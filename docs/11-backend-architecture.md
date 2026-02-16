# 백엔드 상세 설계서 (Go + Gin + Hexagonal)

## 1. 목표
- 도메인 로직과 인프라 결합 최소화
- 비동기 파이프라인(실행/분석/AI 평가) 안정 운영
- 확장 가능한 작업 처리 구조 확보

## 2. 계층 구조
- `domain`: 엔티티, 값 객체, 포트 인터페이스
- `application`: 유스케이스/트랜잭션 조율
- `adapter/in`: HTTP, SSE 핸들러
- `adapter/out`: DB, Redis, Judge0, LLM, 정적분석 연동

## 3. 권장 디렉터리
```txt
cmd/api/
internal/domain/
internal/application/
internal/adapter/in/http/
internal/adapter/out/persistence/
internal/adapter/out/judge0/
internal/adapter/out/ai/
api/openapi/
```

## 4. 의존성 규칙
- domain은 Gin/GORM/Redis 패키지를 import하지 않는다.
- application은 포트 인터페이스에만 의존한다.
- adapter가 외부 시스템 구현체를 제공한다.

## 5. API 설계 원칙
- OpenAPI 우선 설계(Contract-First)
- 표준 에러 포맷 및 코드 체계 통일
- 멱등성 필요한 API는 idempotency-key 지원

## 6. Asynq 설계
- 큐: `critical`(AI), `default`(실행), `low`(분석)
- 재시도: 기본 5회 + 지수 백오프
- 작업 payload는 submissionId 중심 최소화
- 동일 submission 중복 처리 방지 키 사용

## 7. SSE 엔드포인트
- 제출 단위 채널로 상태/로그 이벤트 송신
- 이벤트 저장소(Redis Stream 또는 DB)로 재연결 복원 지원

## 8. Graceful Shutdown
- SIGTERM 수신 시 신규 요청 차단
- 진행 중 요청/작업은 타임아웃 내 정리
- DB/Redis/Judge0 클라이언트 순차 종료


## 9. 서비스 분리 반영
- Core API(Go/Gin): 사용자 트래픽 처리 전용
- Problem Factory(Python): 문제 생성/검증/검토 전용
- 관리자 API는 Problem Factory로 분리하고, Core API는 읽기/제출 도메인에 집중
