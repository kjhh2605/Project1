# Problem Factory 작업계획 (현재 구현 반영 재수립)

## 현재 구현 기능 (코드 확인 기준)
- [x] FastAPI 앱 기동 및 `/v1/admin/healthz` 헬스체크 (`apps/problem-factory/app/main.py`, `apps/problem-factory/app/api/routes.py`)
- [x] generation job 생성/단건 조회 API (`POST/GET /v1/admin/generation-jobs...`)
- [x] 문제 수동 생성/목록 조회/리뷰 제출/승인/퍼블리시 API
- [x] Celery `problem.generate` 워커 스텁(진행률 갱신 후 completed)
- [x] DB 스키마(`problems`, `problem_reviews`, `generation_jobs`, `problem_sources`) 정의

## 미구현 또는 갭
- [ ] 비동기 체인 분리 미구현: `source:collect_prs`, `problem:validate_auto`, `problem:submit_review` 태스크 없음
- [ ] `problem.generate`가 draft 문제 레코드를 실제 생성하지 않음(현재는 job progress만 갱신)
- [ ] 실패 사유 코드 체계/재시도 정책/멱등키(`jobId+sourceId+taskType`) 미구현
- [ ] API/worker 자동 테스트 부재
- [ ] 승인 상태 모델이 문서와 다를 여지: `approved` 결정 후 상태가 `review`로 유지됨

## 재정의된 완료 기준
- [ ] generation job 1건 실행 시 최소 1개의 draft 문제가 생성된다.
- [ ] Celery 체인이 `collect_prs -> generate -> validate_auto -> submit_review` 순서로 동작한다.
- [ ] 검증 성공은 `review`, 실패는 `draft + error_message`로 저장된다.
- [ ] 태스크 재시도/비재시도 기준이 코드로 분리되고 로그에 원인 코드가 남는다.
- [ ] API/worker 핵심 경로 테스트가 추가되어 로컬에서 재현 가능하다.

## 작업 단계 (우선순위)
1. 상태/계약 정합성 고정 (P0)
   - 작업: 문서 기준 상태 전이 확정, `approve` 후 상태 정의 명문화, API 응답 스키마 고정
   - verify: `rg -n "approve|publish|status|review|published" /Users/gnar/Desktop/Project1/apps/problem-factory/app/api/routes.py /Users/gnar/Desktop/Project1/docs`
   - 대안: 상태를 늘리지 않고 `review`를 "승인대기/승인완료"로 내부 필드 분리

2. PF-2 실제 생성 경로 구현 (P0)
   - 작업: `problem.generate`에서 source 입력 기반 draft 문제 레코드 저장(최소 1건)
   - verify: job 실행 후 `GET /v1/admin/problems?status=draft` 결과 증가 확인
   - 대안: 외부 수집 전 fixture source를 DB에 저장하고 생성 로직만 먼저 연결

3. 태스크 체인 확장 (P0-P1)
   - 작업: `source.collect_prs`, `problem.validate_auto`, `problem.submit_review` 추가 및 체인 구성
   - verify: worker 로그에서 4개 태스크 순차 실행 확인
   - 대안: 실제 외부 API 대신 더미 collector + 규칙 기반 validator로 first pass 구현

4. 실패/멱등/재시도 정책 반영 (P1)
   - 작업: 태스크별 에러코드 표준화, `generation_jobs.error_message` 및 검증 리포트 저장, 멱등키 적용
   - verify: 동일 입력 재실행 시 중복 생성 방지 및 실패 로그 확인
   - 대안: DB unique 제약 + upsert로 1차 멱등성 확보

5. 검증 자동화/운영 기준선 추가 (P1)
   - 작업: API smoke test + worker unit test 추가, 실행 문서 갱신
   - verify: `cd /Users/gnar/Desktop/Project1/apps/problem-factory && python3 -m compileall app`
   - verify: `cd /Users/gnar/Desktop/Project1 && make handoff-check`
   - 대안: 테스트 프레임워크 도입 전에는 curl + SQL 체크 스크립트로 임시 검증

## 리스크와 완화
- 외부 수집 의존성: GitHub API 연동을 뒤로 미루고 fixture 기반 파이프라인 선검증
- 품질 검증 난이도: rule-based validator로 인터페이스 먼저 고정 후 Judge0 연동
- 운영 혼선: 상태 전이 표를 코드/문서 동시 관리(불일치시 CI 실패 규칙 추가)
