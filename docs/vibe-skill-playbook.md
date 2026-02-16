# Project1 바이브코딩 스킬 실행 플레이북

이 문서는 `skills/`에 추가된 스킬을 **실전 작업 순서**로 연결한 운영 가이드다.
목표는 속도와 견고함을 동시에 확보하고, 기술 부채 누적을 조기에 차단하는 것이다.

## 0) 공통 원칙 (항상 적용)

1. 먼저 `vibe-requirements-clarifier`로 요구사항/가정 확정
2. `vibe-success-criteria-planner`로 검증 가능한 완료 기준 작성
3. 구현은 `vibe-tdd-implementation-loop`로 진행
4. 변경 범위는 `vibe-surgical-change-guard`로 최소화
5. 머지 전 `vibe-fullstack-quality-gates`로 최종 게이트 통과

---

## 1) 신규 기능 개발 (기본 플로우)

권장 호출 순서:
1. `vibe-requirements-clarifier`
2. `vibe-success-criteria-planner`
3. (프론트면) `vibe-nextjs-fsd-boundary`
4. (백엔드면) `vibe-go-hexagonal-architecture`
5. `vibe-api-contract-first` (API 연동이 있으면 필수)
6. `vibe-tdd-implementation-loop`
7. `vibe-surgical-change-guard`
8. `vibe-verification-matrix`
9. `vibe-git-pr-safety-flow`

완료 조건:
- 기능 테스트 + 타입/린트 + 빌드 통과
- PR 본문에 검증 명령/결과 기록

---

## 2) 버그 수정

권장 호출 순서:
1. `vibe-requirements-clarifier` (재현 조건 확정)
2. `vibe-success-criteria-planner` (재현 테스트를 성공 기준으로)
3. `vibe-tdd-implementation-loop` (실패 테스트 먼저)
4. `vibe-surgical-change-guard` (핫픽스 범위 제한)
5. `vibe-verification-matrix`
6. `vibe-git-pr-safety-flow`

완료 조건:
- 재현 테스트가 실패→수정 후 통과로 전환
- 무관한 코드 변경 없음

---

## 3) API 스펙 변경/신규 엔드포인트

권장 호출 순서:
1. `vibe-api-contract-first`
2. `vibe-go-hexagonal-architecture`
3. `vibe-nextjs-fsd-boundary`
4. `vibe-tdd-implementation-loop`
5. `vibe-fullstack-quality-gates`

운영 규칙:
- OpenAPI 먼저 수정
- 생성 코드(oapi-codegen/Orval) 동기화
- 프론트/백엔드 컴파일 모두 통과해야 머지

---

## 4) 구조 개선/리팩터링

권장 호출 순서:
1. `vibe-debt-firebreak-architecture`
2. `vibe-success-criteria-planner`
3. `vibe-surgical-change-guard`
4. `vibe-verification-matrix`
5. `vibe-git-pr-safety-flow`

운영 규칙:
- 리팩터링은 기능 변경 PR과 분리
- 전/후 동등성 검증 기준을 먼저 정의

---

## 5) 병렬 개발 (여러 작업 동시 진행)

권장 호출 순서:
1. `vibe-parallel-worktree-orchestrator`
2. `vibe-context-handoff-manager`
3. 작업별로 1~4번 시나리오 적용
4. `vibe-monorepo-turborepo-ops` (모노레포 태스크 최적화)

운영 규칙:
- 작업별 브랜치+worktree+세션 분리
- 세션마다 HANDOFF 문서 유지
- 체인 PR일 경우 병합 순서 명시

실행 명령:
- `make wt-new ISSUE=123 TRACK=fe TYPE=feat SLUG=editor-diff TASK=feature`
- `make wt-list`
- `make wt-sync`
- `make wt-close ISSUE=123 TRACK=fe SLUG=editor-diff`
- `make handoff-check`

스킬 자동 선택:
- `make vibe-plan TASK=api-change TRACKS=fe,be PARALLEL=true`

---

## 6) 운영 안정화/배포 준비

권장 호출 순서:
1. `vibe-backend-lifecycle-di`
2. `vibe-fullstack-quality-gates`
3. `vibe-verification-matrix`
4. `vibe-git-pr-safety-flow`

필수 점검:
- Graceful shutdown 동작 확인
- 환경변수 노출 규칙 준수(`NEXT_PUBLIC_`)
- 롤백 절차가 문서화되어 있는지 확인

---

## 빠른 매핑표

- 요구사항이 모호함 → `vibe-requirements-clarifier`
- 목표가 추상적임("잘 되게") → `vibe-success-criteria-planner`
- 구현 중 과도한 변경 우려 → `vibe-surgical-change-guard`
- Next.js 구조가 뒤엉킴 → `vibe-nextjs-fsd-boundary`
- Go 코드가 Gin/DB에 과결합 → `vibe-go-hexagonal-architecture`
- API 타입 불일치 반복 → `vibe-api-contract-first`
- CI 느림/모노레포 혼란 → `vibe-monorepo-turborepo-ops`
- 종료/기동 안정성 문제 → `vibe-backend-lifecycle-di`
- 머지 품질 불안정 → `vibe-fullstack-quality-gates`
- 기술부채 누적 체감 → `vibe-debt-firebreak-architecture`

---

## 권장 머지 게이트(최소)

- `test`
- `lint`
- `typecheck`
- `build`
- (API 변경 시) 계약 생성물 동기화 검증

이 5개를 통과하지 못하면 기본적으로 머지하지 않는다.
