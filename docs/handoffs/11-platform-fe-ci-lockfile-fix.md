# HANDOFF 11-platform-fe-ci-lockfile-fix

## Goal
- FE CI의 `npm ci`가 workspace root lockfile을 요구하며 실패하는 문제를 최소 수정으로 해결한다.

## Status
- done:
  - FE job install 명령을 `npm ci --workspaces=false`로 변경
- in-progress:
  - PR 생성 및 CI 결과 확인
- todo:
  - 통과 후 머지하고 issue #11 종료

## Tried/Result
- command:
  - `gh run view 22068326408 --job 63765978907 --log-failed`
  - result: `npm ci`가 lockfile 부재(EUSAGE)로 실패함을 확인
- command:
  - `make handoff-check`
  - result: 통과

## Failures to avoid
- FE job 수정과 무관한 앱 코드 변경을 함께 포함하지 않기
- app-scoped PR에서 handoff 문서 누락하지 않기

## Next steps
1. PR 생성 (`feat/#11/platform-fe-ci-lockfile-fix` -> `develop`)
2. CI의 FE 잡 성공 여부 확인
3. 통과 시 머지

## Verification commands
- `make handoff-check`

## Open assumptions
- npm 10에서 `--workspaces=false` 옵션이 workspace 탐지 경로를 끊어 `apps/fe/package-lock.json` 기반 설치를 허용한다.
