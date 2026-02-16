from celery import Celery
import os

redis_url = os.getenv("REDIS_URL", "redis://localhost:6379/0")
celery_app = Celery("problem_factory", broker=redis_url, backend=redis_url)
celery_app.conf.task_default_queue = "problem_default"


@celery_app.task(name="problem.generate")
def generate_problem_task(source_id: str, category: str | None = None, difficulty: str | None = None):
    # TODO: PR 컨텍스트 추출 -> LLM 생성 -> 자동검증
    return {
        "source_id": source_id,
        "category": category,
        "difficulty": difficulty,
        "status": "stub_done",
    }
