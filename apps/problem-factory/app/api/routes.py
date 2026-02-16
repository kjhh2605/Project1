from uuid import UUID

from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel, Field
from psycopg.types.json import Jsonb

from app.db import get_conn
from app.workers.celery_app import celery_app

router = APIRouter(prefix="/v1/admin", tags=["ProblemFactoryAdmin"])


class GenerationJobRequest(BaseModel):
    sourceFilter: dict
    category: str | None = None
    difficulty: str | None = None
    maxCount: int = Field(default=10, ge=1, le=500)


class ProblemCreateRequest(BaseModel):
    title: str = Field(min_length=1, max_length=200)
    description: str
    problemType: str = Field(pattern="^(bug_finding|performance)$")
    difficulty: str = Field(pattern="^(easy|medium|hard)$")
    category: str
    language: str = Field(pattern="^(java|python)$")
    buggyCode: str
    answerInfo: dict
    hints: list[dict] = Field(default_factory=list)
    tags: list[str] = Field(default_factory=list)
    evaluationRubric: dict


class ReviewDecisionRequest(BaseModel):
    decision: str = Field(pattern="^(approved|rejected|needs_revision)$")
    comments: str | None = None


@router.get('/healthz', include_in_schema=False)
def healthz():
    return {"status": "ok"}


@router.post('/generation-jobs')
def create_generation_job(req: GenerationJobRequest):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO generation_jobs (source_filter, category, difficulty, max_count, status, progress_total, progress_done)
                VALUES (%s, %s, %s, %s, 'queued', %s, 0)
                RETURNING id, status, created_at
                """,
                (
                    Jsonb(req.sourceFilter),
                    req.category,
                    req.difficulty,
                    req.maxCount,
                    req.maxCount,
                ),
            )
            row = cur.fetchone()
        conn.commit()

    job_id = str(row[0])
    celery_app.send_task(
        "problem.generate",
        kwargs={
            "job_id": job_id,
            "source_filter": req.sourceFilter,
            "category": req.category,
            "difficulty": req.difficulty,
            "max_count": req.maxCount,
        },
        queue="problem_default",
    )

    return {
        "jobId": job_id,
        "status": row[1],
        "createdAt": row[2].isoformat(),
    }


@router.get('/generation-jobs/{job_id}')
def get_generation_job(job_id: UUID):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT id, status, progress_total, progress_done, error_message, created_at, updated_at
                FROM generation_jobs
                WHERE id = %s
                """,
                (job_id,),
            )
            row = cur.fetchone()

    if not row:
        raise HTTPException(status_code=404, detail="generation job not found")

    return {
        "jobId": str(row[0]),
        "status": row[1],
        "progressTotal": row[2],
        "progressDone": row[3],
        "errorMessage": row[4],
        "createdAt": row[5].isoformat() if row[5] else None,
        "updatedAt": row[6].isoformat() if row[6] else None,
    }


@router.get('/problems')
def list_problems(
    status: str | None = Query(default=None),
    category: str | None = Query(default=None),
    language: str | None = Query(default=None),
):
    query = """
    SELECT id, title, problem_type, difficulty, category, language, status, created_at
    FROM problems
    WHERE 1=1
    """
    params: list = []

    if status:
        query += " AND status = %s"
        params.append(status)
    if category:
        query += " AND category = %s"
        params.append(category)
    if language:
        query += " AND language = %s"
        params.append(language)

    query += " ORDER BY created_at DESC LIMIT 100"

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(query, params)
            rows = cur.fetchall()

    items = [
        {
            "id": str(r[0]),
            "title": r[1],
            "problemType": r[2],
            "difficulty": r[3],
            "category": r[4],
            "language": r[5],
            "status": r[6],
            "createdAt": r[7].isoformat() if r[7] else None,
        }
        for r in rows
    ]

    return {"items": items, "count": len(items)}


@router.post('/problems')
def create_problem(req: ProblemCreateRequest):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO problems
                (title, description, problem_type, difficulty, category, language, buggy_code,
                 answer_info, hints, tags, evaluation_rubric, status)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 'draft')
                RETURNING id, status, created_at
                """,
                (
                    req.title,
                    req.description,
                    req.problemType,
                    req.difficulty,
                    req.category,
                    req.language,
                    req.buggyCode,
                    Jsonb(req.answerInfo),
                    Jsonb(req.hints),
                    req.tags,
                    Jsonb(req.evaluationRubric),
                ),
            )
            row = cur.fetchone()
        conn.commit()

    return {
        "id": str(row[0]),
        "status": row[1],
        "createdAt": row[2].isoformat(),
    }


@router.post('/problems/{problem_id}/submit-review', status_code=204)
def submit_review(problem_id: UUID):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("UPDATE problems SET status = 'review', updated_at = NOW() WHERE id = %s", (problem_id,))
            updated = cur.rowcount
        conn.commit()

    if updated == 0:
        raise HTTPException(status_code=404, detail="problem not found")


@router.post('/problems/{problem_id}/approve')
def approve_review(problem_id: UUID, req: ReviewDecisionRequest):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id FROM problems WHERE id = %s", (problem_id,))
            exists = cur.fetchone()
            if not exists:
                raise HTTPException(status_code=404, detail="problem not found")

            # reviewer_id는 MVP에서 고정 UUID placeholder 사용
            reviewer_id = "00000000-0000-0000-0000-000000000001"
            cur.execute(
                """
                INSERT INTO problem_reviews
                (problem_id, reviewer_id, is_compilable, is_bug_reproducible, is_fix_valid,
                 is_difficulty_correct, is_category_correct, is_description_clear, comments, decision)
                VALUES (%s, %s, true, true, true, true, true, true, %s, %s)
                """,
                (problem_id, reviewer_id, req.comments, req.decision),
            )

            if req.decision == "approved":
                next_status = "review"
            elif req.decision == "rejected":
                next_status = "archived"
            else:
                next_status = "draft"

            cur.execute("UPDATE problems SET status = %s, updated_at = NOW() WHERE id = %s", (next_status, problem_id))
        conn.commit()

    return {"id": str(problem_id), "status": next_status, "decision": req.decision}


@router.post('/problems/{problem_id}/publish', status_code=204)
def publish_problem(problem_id: UUID):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE problems SET status = 'published', published_at = NOW(), updated_at = NOW() WHERE id = %s",
                (problem_id,),
            )
            updated = cur.rowcount
        conn.commit()

    if updated == 0:
        raise HTTPException(status_code=404, detail="problem not found")
