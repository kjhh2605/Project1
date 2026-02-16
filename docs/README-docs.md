# Project1 문서 맵

## 우선 작성 순서 (Top 8)
1. 00-prd.md
2. 11-backend-architecture.md
3. 10-frontend-architecture.md
4. 12-api-contract.md
5. 20-code-execution-security.md
6. 30-ai-evaluation-system.md
7. 51-cicd-quality-gates.md
8. 40-data-schema.md

## 추가 핵심 산출물
- 서비스 분리 아키텍처: `13-service-split-architecture.md`
- OpenAPI 초안: `../be/api/openapi/openapi.yaml`
- OpenAPI 관리자 초안: `../be/api/openapi/problem-admin.yaml`
- Asynq 작업 스펙(제출): `22-asynq-task-spec.md`
- Asynq 작업 스펙(문제 생성): `25-problem-generation-asynq-spec.md`
- 문제 생성/관리 준비 문서: `23-problem-generation-management.md`
- 문제 소스 정책: `24-problem-source-policy.md`

## 운영 규칙
- 중요한 기술 선택은 ADR로 기록
- API 변경은 계약 문서와 동시 수정
- 릴리즈 전 품질 게이트 문서 체크
