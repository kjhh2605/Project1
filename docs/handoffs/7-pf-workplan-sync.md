# HANDOFF 7-pf-workplan-sync

## Goal
- `apps/problem-factory` 현재 구현 상태를 기준으로 `WORKPLAN.md`를 실행 가능한 갭 중심 계획으로 재정렬한다.

## Status
- done:
  - `app/api/routes.py`, `app/workers/celery_app.py`, migration 스키마 기준 기능/갭 재분류
  - `WORKPLAN.md`를 현재 구현 반영 버전으로 갱신
- in-progress:
  - 없음
- todo:
  - 이 계획 기준으로 다음 초소형 이슈(#8 예정)부터 코드 구현 시작

## Tried/Result
- command:
  - `python3 -m compileall app` (`apps/problem-factory`)
  - result: 성공(문법 오류 없음)
- command:
  - `rg -n "collect_prs|validate_auto|submit_review|problem.generate" apps/problem-factory/app`
  - result: `problem.generate`만 구현, 나머지 체인 태스크 미구현 확인

## Failures to avoid
- 문서 스펙과 현재 코드 상태를 혼합해 이미 구현된 항목을 다시 계획하지 않기
- app-scoped PR에서 `docs/handoffs/*.md` 변경 누락으로 CI 실패 유발

## Next steps
1. 이슈 #8: `problem.generate`에서 draft 문제 최소 1건 저장 구현
2. 이슈 #9: `source.collect_prs` 태스크 스텁 추가 및 체인 연결
3. 이슈 #10: `problem.validate_auto`/`problem.submit_review` 최소 흐름 구현

## Verification commands
- `cd apps/problem-factory && python3 -m compileall app`
- `make handoff-check`

## Open assumptions
- docs-only 작업이므로 `make lint`, `make test`, `make turbo-ci`는 다음 코드 변경 이슈에서 실행한다.
