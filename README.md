# Project1 Monorepo

Next.js(`apps/fe`) + Go Gin(`apps/be`) 기반 모노레포 스캐폴드.

## Structure

- `apps/fe/` frontend app (Next.js + TypeScript)
- `apps/be/` backend API (Go + Gin)
- `apps/problem-factory/` 문제 생성/검증 서버 (Python FastAPI + Celery)
- `devops/` infra, CI/CD, deployment docs
- `data/` data dictionary and migrations
- `shared/` shared contracts (OpenAPI)
- `docs/` architecture/operations documents
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
make turbo-ci
```

## Branch Rules (GitFlow)

- long-lived: `main`, `develop`
- feature: `feat/#<issue-number>/<branch-name>`
- hotfix: `hotfix/#<issue-number>/<branch-name>`
- release: `release/<major>.<minor>.<patch>`

## Parallel Workflow

Create and manage parallel worktrees with issue-scoped tracks:

```bash
make wt-new ISSUE=123 TRACK=fe TYPE=feat SLUG=editor-diff TASK=feature
make wt-list
make wt-sync
make wt-close ISSUE=123 TRACK=fe SLUG=editor-diff
```

Generate skill order for a task:

```bash
make vibe-plan TASK=api-change TRACKS=fe,be PARALLEL=true
```

Validate handoff documents:

```bash
make handoff-check
```
