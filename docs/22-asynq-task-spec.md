# Asynq 작업 스펙 문서 (MVP)

## 1. 목적
제출 파이프라인(실행 → 정적분석 → AI평가)을 Asynq 기반으로 표준화하고, 재시도/관측/장애복구 규칙을 명확히 한다.

## 2. 큐 토폴로지
- `critical` (weight 6): AI 평가
- `default` (weight 3): 코드 실행(Judge0)
- `low` (weight 1): 정적 분석/후처리

초기 워커 설정 예시:
- concurrency: 10
- strict priority: true

## 3. 작업 타입 정의

### 3.1 `submission:run`
- 큐: `default`
- 역할: Judge0 실행 요청 및 실행 결과 저장
- 입력 payload:
```json
{
  "submissionId": "sub_001",
  "problemId": "prob_001",
  "language": "python",
  "attempt": 1
}
```
- 성공 시 후속 작업: `submission:analyze` enqueue

### 3.2 `submission:analyze`
- 큐: `low`
- 역할: 언어별 정적 분석 실행 및 결과 정규화
- 입력 payload:
```json
{
  "submissionId": "sub_001",
  "language": "python",
  "attempt": 1
}
```
- 성공 시 후속 작업: `submission:evaluate_ai` enqueue

### 3.3 `submission:evaluate_ai`
- 큐: `critical`
- 역할: AI 캐스케이드 평가 수행 후 점수/피드백 저장
- 입력 payload:
```json
{
  "submissionId": "sub_001",
  "problemId": "prob_001",
  "rubricVersion": "r1.0",
  "preferredTier": 1,
  "attempt": 1
}
```
- 완료 시: submission 상태 `completed`로 전이

### 3.4 `submission:finalize` (선택)
- 큐: `low`
- 역할: 집계/알림/캐시 갱신 등 후처리

## 4. 상태 전이
- `queued` → `running` → `analyzing` → `ai_evaluating` → `completed`
- 실패 시: `failed`
- 각 전이 시 SSE 이벤트 발행 필수

## 5. 재시도 정책
- 기본 재시도: 최대 5회
- 백오프: 지수 백오프(+ jitter)
- 영구 실패 조건:
  - 사용자 코드 컴파일 실패(재시도 불필요)
  - 입력 데이터 무결성 오류
- 일시 실패 조건:
  - Judge0 일시 장애
  - LLM API timeout/5xx

## 6. 멱등성(idempotency)
- 키: `submissionId + taskType`
- 동일 키 작업이 동시 처리되지 않도록 작업 생성 시 중복 방지
- 워커는 저장 전에 현재 상태를 확인해 중복 write를 방지

## 7. 타임아웃 정책
- `submission:run`: 30초
- `submission:analyze`: 20초
- `submission:evaluate_ai`: 45초
- 타임아웃 초과 시 retry 대상 여부 판정 후 처리

## 8. 장애/운영 규칙
- Dead Letter Queue(DLQ) 운영
- DLQ 재처리 명령은 관리자만 수행
- 큐 적체 임계치 알람:
  - `critical` > 100
  - `default` > 300
  - `low` > 500

## 9. 관측성 필드 표준
각 작업 로그/메트릭에 아래 필드 포함:
- `traceId`
- `submissionId`
- `taskType`
- `queue`
- `attempt`
- `latencyMs`
- `result`(success/fail/retry)

## 10. 구현 체크리스트
- [ ] 작업 타입 상수 정의
- [ ] payload schema 검증
- [ ] 상태 전이 함수 단일화
- [ ] SSE 이벤트 발행 훅 연결
- [ ] retry/backoff/timeout 테스트
- [ ] DLQ 모니터링 대시보드 구성
