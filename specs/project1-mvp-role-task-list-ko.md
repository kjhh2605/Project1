# Project1 MVP 역할별 태스크 목록 (KOR)

- 기준 스펙: `specs/project1-mvp-spec-ko.md`
- 버전: v0.1
- 작성일: 2026-02-16
- 목적: MVP 구현 착수 시 역할별 책임/우선순위/의존성 명확화

---

## 0) 공통 운영 규칙

- 브랜치: `feat/#<issue>/<track>-<slug>`
- 트랙: `fe | be | pf | platform`
- 병렬 작업 시작 명령:
  - `make wt-new ISSUE=<id> TRACK=<track> TYPE=feat SLUG=<slug> TASK=<feature|api-change|ops|refactor>`
- 공통 검증:
  - `make lint`
  - `make test`
  - `make handoff-check`
  - `make turbo-ci`

---

## 1) FE 역할 (apps/fe)

### FE-1 (P0) 문제 상세 + 편집 UI 기본 플로우
- 내용: 문제 조회, Monaco 편집, DiffEditor 기본 화면 구성
- 완료조건:
  - 문제 상세 진입 -> 원본/수정본 편집 가능
  - 페이지/위젯 구조가 FSD 경계 위반 없이 동작
- 의존성: `BE-1`(문제 조회 API)
- 권장 트랙: `fe`
- 권장 시작 명령:
  - `make wt-new ISSUE=101 TRACK=fe TYPE=feat SLUG=problem-editor TASK=feature`

### FE-2 (P0) 제출 생성 + 상태 추적(SSE)
- 내용: 제출 버튼, 제출 ID 기반 상태 폴링/스트림 구독(EventSource)
- 완료조건:
  - 제출 이후 상태 변화(`queued -> running -> ...`) UI 반영
  - 연결 끊김/재연결 처리(최소 1회)
- 의존성: `BE-2`, `BE-3`
- 권장 트랙: `fe`

### FE-3 (P1) 결과 리포트 화면
- 내용: 실행 결과 + 정적 분석 + AI 피드백 섹션 렌더링
- 완료조건:
  - completed 제출에 대해 3개 섹션 노출
  - 실패 상태(failed) 시 오류/재시도 안내 표시
- 의존성: `BE-4`, `AI-1`
- 권장 트랙: `fe`

---

## 2) BE 역할 (apps/be)

### BE-1 (P0) 문제 조회 API
- 내용: `GET /v1/problems`, `GET /v1/problems/{problemId}`
- 완료조건:
  - OpenAPI 계약과 응답 스키마 일치
  - 기본 페이징/조회 실패 케이스 처리
- 의존성: `DATA-1`
- 권장 트랙: `be`
- 권장 시작 명령:
  - `make wt-new ISSUE=201 TRACK=be TYPE=feat SLUG=problems-api TASK=api-change`

### BE-2 (P0) 제출 생성 API
- 내용: `POST /v1/submissions` 구현 + queue enqueue
- 완료조건:
  - 제출 생성 후 `queued` 상태 저장
  - 파이프라인 첫 큐(`submission:run`) 정상 발행
- 의존성: `DATA-2`, `PLATFORM-2`
- 권장 트랙: `be`

### BE-3 (P0) 제출 조회 + SSE 이벤트 API
- 내용: `GET /v1/submissions/{submissionId}`, `GET /v1/submissions/{submissionId}/events`
- 완료조건:
  - 상태 전이 이벤트 SSE 송신
  - 클라이언트 재접속 시 최신 상태 복구 가능
- 의존성: `BE-2`
- 권장 트랙: `be`

### BE-4 (P1) 실행/분석/AI 결과 집계 응답
- 내용: 최종 결과 스냅샷 모델 정리 및 조회 응답 확장
- 완료조건:
  - FE 결과 리포트가 별도 가공 없이 렌더 가능
  - 누락 필드 없이 OpenAPI 업데이트 완료
- 의존성: `AI-1`, `PLATFORM-3`
- 권장 트랙: `be`

---

## 3) Problem Factory 역할 (apps/problem-factory)

### PF-1 (P0) generation job 생성/조회 API
- 내용: `POST /v1/admin/generation-jobs`, `GET /v1/admin/generation-jobs/{jobId}`
- 완료조건:
  - job 생성 -> 상태 조회 가능
  - job 상태 최소 `queued|running|completed|failed`
- 의존성: `DATA-3`
- 권장 트랙: `pf`
- 권장 시작 명령:
  - `make wt-new ISSUE=301 TRACK=pf TYPE=feat SLUG=generation-job-api TASK=feature`

### PF-2 (P0) PR 수집 + 문제 초안 생성 워커
- 내용: `source:collect_prs`, `problem:generate` 큐 체인 구현
- 완료조건:
  - 화이트리스트 저장소 PR 최소 1건 수집
  - draft 문제 레코드 생성 확인
- 의존성: `PF-1`, `PLATFORM-2`
- 권장 트랙: `pf`

### PF-3 (P1) 자동 검증 + 리뷰 제출 단계
- 내용: `problem:validate_auto`, `problem:submit_review` 구현
- 완료조건:
  - 검증 성공 시 review 상태로 전이
  - 실패 케이스 로그/에러코드 저장
- 의존성: `PF-2`, `DATA-4`
- 권장 트랙: `pf`

---

## 4) Data 역할 (schema/migrations)

### DATA-1 (P0) 문제 도메인 스키마
- 내용: `problems`, `problem_test_cases`, `problem_sources`
- 완료조건:
  - FE/BE 조회 시나리오에서 필요한 인덱스 포함
  - 마이그레이션 up/down 검증 완료
- 의존성: 없음
- 권장 트랙: `platform` 또는 `be`

### DATA-2 (P0) 제출/평가 스키마
- 내용: `submissions`, `ai_evaluations`
- 완료조건:
  - 상태 전이/결과 조회에 필요한 컬럼 반영
  - 제출ID 기준 조회 성능 인덱스 포함
- 의존성: 없음
- 권장 트랙: `platform` 또는 `be`

### DATA-3 (P0) generation job 스키마
- 내용: `generation_jobs`, `problem_reviews`
- 완료조건:
  - PF job 파이프라인 상태 저장 가능
  - 리뷰 상태 모델(`draft->review->published`) 반영
- 의존성: 없음
- 권장 트랙: `platform` 또는 `pf`

### DATA-4 (P1) 상태 전이/감사 로그 보강
- 내용: 상태 변경 이력 또는 최소 감사 필드(created_by, updated_by 등)
- 완료조건:
  - 장애 분석 가능한 수준의 이력 확보
- 의존성: `DATA-2`, `DATA-3`
- 권장 트랙: `platform`

---

## 5) Platform/DevOps 역할

### PLATFORM-1 (P0) 로컬/CI 실행 환경 안정화
- 내용: FE/BE/PF 개발 실행 및 기본 CI 안정화
- 완료조건:
  - `make setup`, `make ci`, `make turbo-ci` 재현 가능
  - docs-only 변경 시 경량 CI 스킵 정상 동작
- 의존성: 없음
- 권장 트랙: `platform`

### PLATFORM-2 (P0) Redis 기반 큐/워커 운영 연결
- 내용: 제출/생성 파이프라인 큐 구성, 재시도 정책(최대 5회) 반영
- 완료조건:
  - 실패 재시도 지수 백오프 동작
  - dead-letter/실패 로깅 최소 정책 적용
- 의존성: 없음
- 권장 트랙: `platform`

### PLATFORM-3 (P1) 관측성 최소 세트
- 내용: API 지연/파이프라인 성공률/평가 지연 지표 수집
- 완료조건:
  - 대시보드 또는 로그 기반 기본 모니터링 가능
  - 런북 링크 제공
- 의존성: `BE-2`, `PF-2`
- 권장 트랙: `platform`

### PLATFORM-4 (P1) 보안 최소 정책
- 내용: 실행 샌드박스 최소 레이어, 취약점 스캔 파이프라인
- 완료조건:
  - `network=none` 등 필수 정책 체크리스트 문서화
  - Trivy 스캔 루틴 실행 가능
- 의존성: `PLATFORM-1`
- 권장 트랙: `platform`

---

## 6) AI 역할

### AI-1 (P0) 평가 루브릭 파이프라인
- 내용: correctness/performance/readability/best_practices 점수화
- 완료조건:
  - 제출 1건 기준 AI 평가 JSON 산출
  - BE 결과 조회 API에 매핑 가능
- 의존성: `BE-2`, `DATA-2`
- 권장 트랙: `be` 또는 `pf`

### AI-2 (P1) 모델 캐스케이드 제어
- 내용: Tier1/2/3 분기 로직 + 예산 제어
- 완료조건:
  - 비용 임계치 초과 시 상위 Tier 제한 또는 fallback 동작
  - 일/월 예산 알람 기초 구현
- 의존성: `AI-1`, `PLATFORM-3`
- 권장 트랙: `platform`

---

## 7) QA/Release 역할

### QA-1 (P0) 제출 E2E 시나리오 검증
- 내용: 문제 조회 -> 수정 -> 제출 -> 결과 확인 전체 검증
- 완료조건:
  - happy-path 1개 + 실패-path 1개 자동/수동 증거 확보
- 의존성: `FE-2`, `BE-3`, `BE-4`
- 권장 트랙: `fe` 또는 `platform`

### QA-2 (P1) Problem Factory 운영 시나리오 검증
- 내용: PR 수집 -> 생성 -> 검증 -> 리뷰 제출 흐름 점검
- 완료조건:
  - generation job end-to-end 1회 성공
- 의존성: `PF-3`
- 권장 트랙: `pf`

### QA-3 (P1) 릴리즈 게이트 체크리스트
- 내용: 스펙 DoD(제품/기술/운영) 기준 출고 승인 체크
- 완료조건:
  - 모든 P0 완료 + P1 잔여 리스크 문서화
- 의존성: 전 역할
- 권장 트랙: `platform`

---

## 8) MVP 우선순위 실행 순서 (권장)

1. `DATA-1`, `DATA-2`, `PLATFORM-1`
2. `BE-1`, `BE-2`, `BE-3`
3. `FE-1`, `FE-2`
4. `AI-1`, `BE-4`, `FE-3`
5. `PF-1`, `PF-2`, `PF-3`
6. `QA-1`, `QA-2`, `QA-3`
7. `PLATFORM-3`, `PLATFORM-4`, `AI-2`

---

## 9) 역할 배정 템플릿

### 담당자 입력용
- FE 담당:
- BE 담당:
- PF 담당:
- Platform 담당:
- AI 담당:
- QA/Release 담당:

### 이번 이터레이션 목표 (최대 2주)
- 필수(P0):
- 선택(P1):
- 제외(이번 범위 아님):
