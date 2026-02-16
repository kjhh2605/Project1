# HANDOFF 13-be-build-output-path

## Goal
- Turbo CI에서 `project1-be#build` 실패를 유발하는 Go build 출력 경로 충돌을 제거한다.

## Status
- done:
  - `apps/be/package.json` build 스크립트를 `mkdir -p build && go build -o build/api ./cmd/api`로 변경
- in-progress:
  - PR 생성 및 CI 확인
- todo:
  - 통과 후 머지 및 issue #13 종료

## Tried/Result
- command:
  - `gh run view 22068326408 --job 63765978895 --log-failed`
  - result: turbo에서 `go: build output "api" already exists and is a directory` 실패 확인
- command:
  - `make handoff-check`
  - result: 통과

## Failures to avoid
- build 스크립트 변경 외 무관한 BE 로직 수정을 섞지 않기
- app-scoped PR에서 handoff 문서 누락하지 않기

## Next steps
1. PR 생성 (`feat/#13/be-build-output-path` -> `develop`)
2. CI에서 turbo/BE build 성공 확인
3. 통과 시 머지

## Verification commands
- `make handoff-check`

## Open assumptions
- CI 환경에서 `mkdir -p build` 후 `go build -o build/api` 경로가 정상 생성된다.
