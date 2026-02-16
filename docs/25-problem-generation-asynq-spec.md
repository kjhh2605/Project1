# 문제 생성 Asynq 작업 스펙

## 1. 목적
오픈소스 PR → 문제 초안 생성 → 자동 검증 → 리뷰 등록 흐름을 비동기 파이프라인으로 표준화한다.

## 2. 작업 타입

### 2.1 `source:collect_prs`
- 큐: `low`
- 설명: GitHub API에서 조건에 맞는 PR 메타데이터/패치 수집
- payload:
```json
{
  "jobId": "job_001",
  "repo": "spring-projects/spring-framework",
  "query": "is:pr is:merged label:bug language:java",
  "from": "2025-01-01",
  "to": "2025-12-31"
}
```

### 2.2 `problem:generate`
- 큐: `default`
- 설명: 수집된 PR 컨텍스트로 LLM 문제 초안 생성
- payload:
```json
{
  "jobId": "job_001",
  "sourceId": "src_001",
  "category": "concurrency",
  "difficulty": "medium"
}
```

### 2.3 `problem:validate_auto`
- 큐: `default`
- 설명: 구문/실행/정답/품질 자동 검증
- payload:
```json
{
  "jobId": "job_001",
  "problemId": "prob_001"
}
```

### 2.4 `problem:submit_review`
- 큐: `low`
- 설명: 검증 통과 문제를 리뷰 대기열로 전환
- payload:
```json
{
  "jobId": "job_001",
  "problemId": "prob_001"
}
```

## 3. 상태 전이
- generation job: `queued -> running -> completed|failed`
- problem: `draft -> review -> published|archived`

## 4. 실패 처리
- 재시도 대상: GitHub API timeout, LLM timeout, Judge0 일시 장애
- 비재시도: 라이선스 미허용, 변환 규칙 위반, 구문 오류 고정 실패
- 실패 사유는 `generation_jobs.error_message`와 문제 검증 리포트에 저장

## 5. 멱등성
- 키: `jobId + sourceId + taskType`
- 동일 source를 같은 job에서 중복 생성하지 않도록 제약

## 6. 운영 지표
- 소스 수집 성공률
- 생성 성공률
- 자동 검증 통과율
- 리뷰 승인율
- 문제 1건당 평균 생성 비용/시간
