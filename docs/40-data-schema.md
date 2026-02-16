# 데이터베이스 스키마 설계서

## 1. 도메인 엔티티
- users
- problems
- submissions
- execution_results
- static_analysis_results
- ai_evaluations
- submission_events

## 2. ERD(초안)
- User 1:N Submission
- Problem 1:N Submission
- Submission 1:1 ExecutionResult
- Submission 1:N StaticAnalysisResult
- Submission 1:1 AIEvaluation
- Submission 1:N SubmissionEvent

## 3. 핵심 테이블 정의
### submissions
- `id` (PK)
- `user_id` (FK)
- `problem_id` (FK)
- `language` (java/python)
- `original_code` (text)
- `patched_code` (text)
- `status` (queued/running/analyzing/ai_evaluating/completed/failed)
- `created_at`, `updated_at`

### ai_evaluations
- `submission_id` (PK/FK)
- `model_tier`
- `rubric_version`
- `overall_score`
- `result_json` (jsonb)
- `created_at`

## 4. 인덱스 전략
- `submissions(user_id, created_at desc)`
- `submissions(problem_id, created_at desc)`
- `submissions(status, created_at)`
- `submission_events(submission_id, created_at)`

## 5. 마이그레이션 전략
- expand/contract 원칙 적용
- 파괴적 변경은 2단계 배포(추가 → 전환 → 제거)
- 모든 변경은 롤백 SQL 동반
