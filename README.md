# Project1 Monorepo

Next.js(`apps/fe`) + Go Gin(`apps/be`) 기반 모노레포 스캐폴드.

## Structure

- `apps/fe/` frontend app (Next.js + TypeScript)
- `apps/be/` backend API (Go + Gin)
- `apps/problem-factory/` 문제 생성/검증 서버 (Python FastAPI + Celery)
- `pm/` product specs and roadmap
- `qa/` test strategy and regression checklist
- `design/` UX/UI docs
- `devops/` infra, CI/CD, deployment docs
- `data/` data dictionary and ETL notes
- `ml/` model experiments
- `shared/` shared contracts (OpenAPI)
- `docs/adr/` architecture decision records

## Quick Start

```bash
make setup
make up
```

앱별 단독 실행:

```bash
make fe-dev
make be-dev
make pf-dev
make pf-worker
```

## Quality Gates

```bash
make lint
make test
make ci
```

## Branch Rules (GitFlow)

- long-lived: `main`, `develop`
- feature: `feat/#<issue-number>/<branch-name>`
- hotfix: `hotfix/#<issue-number>/<branch-name>`
- release: `release/<major>.<minor>.<patch>`
