# Project1 MVP 제품/기술 통합 스펙 (KOR)

- 버전: v0.1
- 작성일: 2026-02-16
- 범위: MVP (Java/Python 중심)

---

## 1) 제품 목표

### 1.1 문제 정의
기존 OJ 플랫폼은 "정답 통과"를 중심으로 평가한다. Project1은 **디버깅 과정의 품질**(원인 파악, 수정 전략, 성능 개선 근거)까지 평가한다.

### 1.2 MVP 목표
- 디버깅 문제 풀이/제출/평가의 E2E 흐름 완성
- 실행 검증 + 정적 분석 + AI 루브릭 평가 결합
- 비용 통제 가능한 모델 캐스케이드 운영

### 1.3 비목표
- 대규모 대회 운영 기능
- 실시간 협업 완성형 기능
- 다언어 확장(초기 Java/Python 외)

---

## 2) 시스템 아키텍처

### 2.1 서비스 분리
1. **apps/fe** (Next.js)
   - 문제 풀이 UI, diff 편집, 제출/결과 조회
2. **apps/be** (Go/Gin)
   - 사용자 API, 제출 파이프라인 상태 관리, SSE
3. **apps/problem-factory** (Python/FastAPI + Celery)
   - 문제 생성/검증/검토 워크플로우

### 2.2 데이터/큐
- DB: PostgreSQL (스키마 분리 권장: `core`, `content`)
- 큐/캐시: Redis
- 오브젝트 스토리지: 로그/스냅샷 보관

### 2.3 실행/평가 파이프라인
`제출 -> Judge0 실행 -> 정적분석 -> AI 평가 -> 결과 저장/SSE 전송`

---

## 3) FE 스펙 (apps/fe)

### 3.1 핵심 기능
- 문제 상세 조회
- Monaco 기반 코드 편집
- DiffEditor(원본 vs 수정본)
- 제출 생성/상태 추적(SSE)
- 결과 리포트(실행/분석/AI 피드백)

### 3.2 기술 규칙
- App Router + FSD 계층 구조
- 상태관리: Zustand
- UI: Tailwind + shadcn/ui
- 실시간: EventSource(SSE)

### 3.3 품질 게이트
- lint / typecheck / test / build

---

## 4) BE 스펙 (apps/be)

### 4.1 핵심 API
- `GET /healthz`
- `GET /v1/problems`
- `GET /v1/problems/{problemId}`
- `POST /v1/submissions`
- `GET /v1/submissions/{submissionId}`
- `GET /v1/submissions/{submissionId}/events` (SSE)

### 4.2 아키텍처 원칙
- 헥사고날(Ports/Adapters)
- domain 순수성 유지
- application 계층에서 유스케이스 조율

### 4.3 큐 정책(제출)
- `submission:run` -> `submission:analyze` -> `submission:evaluate_ai`
- 재시도: 지수 백오프, 최대 5회

---

## 5) Problem Factory 스펙 (apps/problem-factory)

### 5.1 핵심 기능
- GitHub PR 수집(화이트리스트 저장소)
- LLM 기반 문제 초안 생성
- 자동 검증(구문/실행/정답/품질)
- 관리자 검토/승인/퍼블리시

### 5.2 관리자 API (초안)
- `POST /v1/admin/generation-jobs`
- `GET /v1/admin/generation-jobs/{jobId}`
- `GET /v1/admin/problems`
- `POST /v1/admin/problems/{problemId}/submit-review`
- `POST /v1/admin/problems/{problemId}/approve`
- `POST /v1/admin/problems/{problemId}/publish`

### 5.3 큐 정책(문제 생성)
- `source:collect_prs`
- `problem:generate`
- `problem:validate_auto`
- `problem:submit_review`

---

## 6) 데이터 스펙

### 6.1 주요 테이블
- `problems`
- `problem_sources`
- `problem_test_cases`
- `problem_reviews`
- `generation_jobs`
- `submissions`
- `ai_evaluations`

### 6.2 상태 모델
- 문제: `draft -> review -> published -> archived`
- 제출: `queued -> running -> analyzing -> ai_evaluating -> completed|failed`

---

## 7) AI 평가 스펙

### 7.1 루브릭
- correctness
- performance
- readability
- best_practices

### 7.2 모델 캐스케이드
- Tier1: 저비용 스크리닝
- Tier2: 표준 평가
- Tier3: 고난도/이의제기

### 7.3 비용 통제
- 프롬프트 캐시
- 시맨틱 캐시
- 배치 처리
- 일/월 예산 알람

---

## 8) 보안 스펙

### 8.1 샌드박스 필수 레이어
- `network=none`
- read-only rootfs + 제한 tmpfs
- cgroups v2 (CPU/MEM/PID 제한)
- seccomp + AppArmor
- gVisor RuntimeClass

### 8.2 인증/인가
- MVP: Clerk
- 관리자 API는 별도 권한 경계 적용

### 8.3 취약점 대응
- 이미지 스캔(Trivy)
- CVE 대응 SLA 운영

---

## 9) 인프라/운영 스펙

### 9.1 배포
- API/FE: Cloud Run 또는 GKE
- 워커: GKE Autopilot/Standard
- DB: Cloud SQL
- 캐시/큐: Redis

### 9.2 관측성
- SLI/SLO: API 지연, 파이프라인 성공률, 평가 지연
- 로그/메트릭/트레이스 통합
- 장애 런북 운영

---

## 10) MVP 완료 기준 (DoD)

### 10.1 제품
- 사용자가 문제를 열고 수정/제출/결과 확인 가능
- 결과 화면에 실행/정적분석/AI 피드백 표시

### 10.2 기술
- 앱별 CI 통과(fe/be/problem-factory)
- OpenAPI 계약 파일 최신 상태 유지
- 보안 최소 정책 적용 완료

### 10.3 운영
- 비용 알람/기본 모니터링 대시보드 운영
- 장애 대응 런북 작성 완료

---

## 11) 우선 구현 순서
1. 제출 E2E(문제조회->제출->상태->결과)
2. Problem Factory 최소 생성 Job 구현
3. 자동 검증 파이프라인 연결
4. 관리자 검토/퍼블리시 UI
5. 비용/품질 모니터링 강화

---

## 12) 참조 문서
- `docs/00-prd.md`
- `docs/11-backend-architecture.md`
- `docs/13-service-split-architecture.md`
- `docs/22-asynq-task-spec.md`
- `docs/25-problem-generation-asynq-spec.md`
- `apps/be/api/openapi/openapi.yaml`
- `apps/be/api/openapi/problem-admin.yaml`
