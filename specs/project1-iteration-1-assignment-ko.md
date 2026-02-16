# Project1 Iteration 1 역할 배정안 (1~2주)

- 기준: `specs/project1-mvp-role-task-list-ko.md`
- 기간: 1~2주
- 목표: **Problem Factory 최소 생성 파이프라인 + Frontend UI 설계/골격** 완성

## 1) 이번 Iteration 범위

### 포함 (P0)
- PF-1, PF-2
- FE-1(문제 상세/편집 UI), FE-3(결과 리포트 UI 설계)
- PLATFORM-1 (개발/CI 기반 안정화)
- DATA-3 (generation job/review 스키마)

### 포함 (P1)
- PF-3 (자동 검증 -> 리뷰 제출 최소 경로)
- FE 제출 상태 UX 목업/상태 머신 정리

### 제외 (다음 Iteration)
- 제출 E2E 완성(실제 Judge0/AI 평가 연동)
- BE 제출 API 전체(1202/1203 성격)
- AI 캐스케이드 본구현

## 2) 역할별 배정안

## FE(UI) 담당
- Task A: 문제 상세/편집 화면 IA + 컴포넌트 설계
- Task B: 결과 리포트 화면(실행/분석/AI 피드백) UI 설계
- Task C: 제출 상태 UX(queued/running/analyzing...) 화면 상태 정의
- 완료조건:
  - 주요 화면 3종(문제풀이/결과리포트/상태뷰) 라우트 골격 구현
  - FSD 경계 준수(`app` 조립, `src` 기능 레이어 분리)
  - 디자인 토큰/컴포넌트 재사용 규칙 문서화
- 의존성:
  - Problem 데이터 mock 또는 BE-1 최소 조회 API
- 시작 명령:
  - `make wt-new ISSUE=2101 TRACK=fe TYPE=feat SLUG=ui-ia-layout TASK=feature`
  - `make wt-new ISSUE=2102 TRACK=fe TYPE=feat SLUG=result-report-ui TASK=feature`

## Problem Factory 담당
- Task A: PF-1 generation job 생성/조회 API
- Task B: PF-2 PR 수집 + 문제 초안 생성 워커 체인
- Task C: PF-3 자동 검증 -> 리뷰 제출 최소 흐름(가능 범위)
- 완료조건:
  - generation job 생성 후 상태 조회 가능
  - `source:collect_prs -> problem:generate` 1회 성공 로그 확보
  - 검증 단계 성공 시 review 상태 전이 확인(최소 1케이스)
- 의존성:
  - DATA-3, PLATFORM-1
- 시작 명령:
  - `make wt-new ISSUE=2201 TRACK=pf TYPE=feat SLUG=generation-job-api TASK=feature`
  - `make wt-new ISSUE=2202 TRACK=pf TYPE=feat SLUG=collect-generate-worker TASK=feature`
  - `make wt-new ISSUE=2203 TRACK=pf TYPE=feat SLUG=validate-review-flow TASK=feature`

## Data 담당
- Task A: DATA-3 generation_jobs/problem_reviews 스키마 우선 구축
- Task B: 문제 초안 메타(소스 PR, 검증결과) 저장 컬럼 보강
- 완료조건:
  - migration up/down 검증
  - PF API/워커에서 필요한 상태 컬럼 모두 조회 가능
- 의존성:
  - 없음
- 시작 명령:
  - `make wt-new ISSUE=2301 TRACK=platform TYPE=feat SLUG=pf-job-review-schema TASK=feature`

## Platform 담당
- Task A: PLATFORM-1 로컬/CI 실행 안정화
- Task B: PF 워커 실행/로그 수집 기본 운영 스크립트 정리
- 완료조건:
  - `make setup`, `make ci`, `make turbo-ci` 동작 확인
  - PF API + worker 동시 실행 가이드/명령 정리
  - 병렬 PR 규칙 위반 시 CI 실패 확인
- 의존성:
  - 없음
- 시작 명령:
  - `make wt-new ISSUE=2401 TRACK=platform TYPE=chore SLUG=pf-dev-ci-stabilize TASK=ops`

## QA/Release 담당
- Task A: PF 생성 파이프라인 시나리오 점검표 작성
- Task B: FE UI 흐름 스모크 체크리스트 작성
- 완료조건:
  - PF: job 생성->생성->검증(가능 범위) 증거 1세트
  - FE: 3개 핵심 화면 진입/상태전환 체크리스트 완료
- 의존성:
  - FE/UI, PF 핵심 작업
- 시작 명령:
  - `make wt-new ISSUE=2501 TRACK=platform TYPE=feat SLUG=pf-ui-smoke-check TASK=feature`

## 3) 병렬 진행 순서 (권장)

1. Data: `#2301` 시작
2. Platform: `#2401` 시작
3. PF: `#2201` -> `#2202` 병행
4. FE(UI): `#2101` -> `#2102` 진행
5. PF: `#2203` (PF-3 최소 흐름)
6. QA: `#2501`로 통합 점검

## 4) PR 병합 순서 (체인)

1. `#2301` PF 스키마
2. `#2401` PF 개발/CI 안정화
3. `#2201` generation job API
4. `#2202` collect/generate 워커
5. `#2101` FE UI IA/레이아웃
6. `#2102` FE 결과 리포트 UI
7. `#2203` validate/review 최소 흐름
8. `#2501` 통합 스모크 점검 리포트

## 5) 일일 운영 체크리스트

- 작업 시작 전:
  - `make wt-list`
  - `make vibe-plan TASK=<...> TRACKS=<...> PARALLEL=true`
- 작업 중:
  - `HANDOFF.md` 업데이트
  - `docs/handoffs/<issue-track-slug>.md` 업데이트
- PR 전:
  - `make lint`
  - `make test`
  - `make handoff-check`
- PR 본문 필수:
  - Affected Tracks
  - Parent PR
  - Merge Order
  - Handoff Doc

## 6) 담당자 입력란

- FE(UI) 담당:
- PF 담당:
- Data 담당:
- Platform 담당:
- QA/Release 담당:

## 7) 종료 기준 (Iteration 1 Done)

- PF에서 generation job 생성/조회 + collect/generate 체인 최소 1회 성공
- FE에서 문제풀이/결과리포트/상태뷰 UI 골격 확인 가능
- 핵심 PR이 모두 CI 통과
- handoff 문서 누락 0건
