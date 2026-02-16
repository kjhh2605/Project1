# Problem Factory (Python)

문제 생성/검증/검토 전용 서비스.

## Stack
- FastAPI
- Celery + Redis
- PostgreSQL

## Run (local)
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8090
```

## Worker (Celery)
```bash
celery -A app.workers.celery_app.celery_app worker -l info
```
