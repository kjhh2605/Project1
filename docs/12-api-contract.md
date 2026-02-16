# API 계약 설계서 (OpenAPI SSOT)

## 1. 원칙
- API 계약은 OpenAPI 문서를 단일 진실 공급원(SSOT)으로 사용한다.
- 서버/클라이언트 코드는 계약에서 생성하고, 수동 중복 정의를 최소화한다.

## 2. 변경 절차
1. OpenAPI 스펙 수정
2. `oapi-codegen`으로 Go 서버 인터페이스/DTO 생성
3. `orval`로 TypeScript 타입/쿼리 훅 생성
4. 구현 코드 보완
5. 계약 테스트 및 통합 테스트 실행

## 3. 버저닝/브레이킹 정책
- 경미한 추가: minor
- 응답 필드 삭제/타입 변경: major
- 브레이킹 변경은 deprecation 기간(최소 2주) 공지

## 4. 표준 에러 스키마
```json
{
  "code": "SUBMISSION_NOT_FOUND",
  "message": "submission not found",
  "details": {
    "submissionId": "sub_123"
  },
  "traceId": "..."
}
```

## 5. 핵심 엔드포인트(MVP)
- `GET /v1/problems`
- `GET /v1/problems/{problemId}`
- `POST /v1/submissions`
- `GET /v1/submissions/{submissionId}`
- `GET /v1/submissions/{submissionId}/events` (SSE)

## 6. 검증 체크
- [ ] 스펙 파일과 생성 코드 동기화
- [ ] 프론트 타입 오류 0
- [ ] 백엔드 컴파일 오류 0
- [ ] 브레이킹 변경 ADR 기록
