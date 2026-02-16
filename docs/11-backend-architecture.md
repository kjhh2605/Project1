# 백엔드 상세 설계서 (Go + Gin + Hexagonal)

## 1. 목표

## 2. 계층 구조
- domain
- application
- adapter(in/out)

## 3. 권장 디렉터리
```txt
cmd/
internal/domain/
internal/application/
internal/adapter/in/http/
internal/adapter/out/
api/
```

## 4. 의존성 규칙
- domain은 프레임워크 의존 금지
- application은 포트 인터페이스 의존

## 5. API 설계 원칙
- OpenAPI first
- 표준 에러 포맷

## 6. Asynq 설계
- queue 구성:
- retry/backoff:
- idempotency:

## 7. SSE 엔드포인트
- 스트림 수명:
- 이벤트 모델:

## 8. Graceful Shutdown
- 시작/종료 훅
- 타임아웃
