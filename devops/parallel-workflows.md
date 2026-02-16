# 병렬 개발 워크플로우 가이드 (apps 분리 기준)

## 1. 목적
`apps/fe`, `apps/be`, `apps/problem-factory`를 서로 독립적으로 개발/배포할 수 있게 표준 작업 흐름을 정의한다.

## 2. 브랜치 전략 (권장)
- FE 작업: `feat/<issue>-fe-...`
- BE 작업: `feat/<issue>-be-...`
- PF 작업: `feat/<issue>-pf-...`
- 공통 변경(문서/인프라): `chore/<issue>-platform-...`

## 3. 로컬 실행 패턴
- 전체 스택: `make up`
- FE만: `make fe-dev`
- BE만: `make be-dev`
- PF API만: `make pf-dev`
- PF Worker만: `make pf-worker`

## 4. 병렬 작업 권장 방식
1. 작업 단위를 앱 경계에 맞춰 쪼갠다.
2. PR도 앱 경계 기준으로 분리한다(혼합 PR 지양).
3. API 계약 변경은 OpenAPI 파일을 먼저 수정한다.
4. 계약 변경 시 FE/BE/PF 영향 범위를 PR 본문에 명시한다.

## 5. 리뷰 체크리스트
- [ ] 변경이 단일 앱에 국한되는가?
- [ ] 다중 앱 변경이면 이유가 명확한가?
- [ ] OpenAPI 변경 시 생성/검증 절차가 포함되었는가?
- [ ] 문서(`docs/`)가 함께 갱신되었는가?
