import os
import time
from uuid import UUID

from celery import Celery

from app.db import get_conn

redis_url = os.getenv("REDIS_URL", "redis://localhost:6379/0")
celery_app = Celery("problem_factory", broker=redis_url, backend=redis_url)
celery_app.conf.task_default_queue = "problem_default"


@celery_app.task(name="problem.generate")
def generate_problem_task(
    job_id: str,
    source_filter: dict,
    category: str | None = None,
    difficulty: str | None = None,
    max_count: int = 10,
):
    # MVP 스텁: 실제 PR 수집/LLM 생성 대신 진행률만 갱신
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE generation_jobs SET status = 'running', updated_at = NOW() WHERE id = %s",
                (UUID(job_id),),
            )
        conn.commit()

    for i in range(1, max_count + 1):
        time.sleep(0.2)
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "UPDATE generation_jobs SET progress_done = %s, updated_at = NOW() WHERE id = %s",
                    (i, UUID(job_id)),
                )
            conn.commit()

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE generation_jobs SET status = 'completed', updated_at = NOW() WHERE id = %s",
                (UUID(job_id),),
            )
        conn.commit()

    return {
        "job_id": job_id,
        "source_filter": source_filter,
        "category": category,
        "difficulty": difficulty,
        "status": "completed",
    }
