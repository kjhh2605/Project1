from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(prefix="/v1/admin", tags=["ProblemFactoryAdmin"])


class GenerationJobRequest(BaseModel):
    sourceFilter: dict
    category: str | None = None
    difficulty: str | None = None
    maxCount: int = 10


@router.get('/healthz', include_in_schema=False)
def healthz():
    return {"status": "ok"}


@router.post('/generation-jobs')
def create_generation_job(req: GenerationJobRequest):
    # TODO: DB 저장 + Celery enqueue
    return {"jobId": "job_placeholder", "status": "queued", "request": req.model_dump()}
