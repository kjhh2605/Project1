# 병렬 바이브코딩 상세 운영 매뉴얼

이 문서는 Project1에서 병렬 작업을 실제로 진행할 때, 처음부터 PR 머지까지 따라할 수 있는 실행 매뉴얼이다.
대상은 `apps/fe`, `apps/be`, `apps/problem-factory`를 동시에 개발하는 경우다.

## 1. 이 워크플로우가 해결하는 문제

기존 방식(한 브랜치에 여러 변경 혼합)에서는 아래 문제가 자주 발생한다.
- FE/BE/PF 변경이 한 PR에 섞여 리뷰/롤백이 어려움
- 긴 작업 중 맥락 손실로 재작업 발생
- 병렬 진행 중 브랜치 충돌 증가

현재 워크플로우는 다음 원칙으로 해결한다.
- 트랙 분리: `fe`, `be`, `pf`, `platform`
- 작업 단위 분리: 이슈별 worktree 생성
- 맥락 보존: `HANDOFF.md` + `docs/handoffs/*.md`
- 게이트 강제: branch-name + CI + parallel-governance

## 2. 핵심 개념

- `worktree`: 같은 저장소를 별도 디렉토리로 동시에 체크아웃해서 병렬 작업 가능
- `track`: 변경 주체 앱/영역 (`fe|be|pf|platform`)
- `handoff`: 다음 세션/다른 작업자가 바로 이어받을 수 있는 상태 문서
- `workplan`: 작업 유형 기준으로 추천된 스킬 순서와 검증 명령

## 3. 사전 준비

루트(저장소 최상위)에서 실행:

```bash
make setup
```

선택 확인:

```bash
make wt-list
```

문서 검증 스크립트 확인:

```bash
make handoff-check
```

## 4. 표준 흐름 (한 트랙)

예시: 이슈 `#123`, FE 기능 작업

### 4.1 트랙 생성

루트에서:

```bash
make wt-new ISSUE=123 TRACK=fe TYPE=feat SLUG=editor-diff TASK=feature
```

자동 생성 결과:
- 브랜치: `feat/#123/fe-editor-diff`
- 디렉토리: `worktrees/123-fe-editor-diff`
- 문서: `worktrees/123-fe-editor-diff/HANDOFF.md`
- 문서: `worktrees/123-fe-editor-diff/docs/handoffs/123-fe-editor-diff.md`
- 문서: `worktrees/123-fe-editor-diff/WORKPLAN.md`

### 4.2 작업 디렉토리 이동

```bash
cd worktrees/123-fe-editor-diff
```

### 4.3 스킬 순서 확인

worktree 안에서 루트 Make를 호출하려면:

```bash
make -C ../.. vibe-plan TASK=feature TRACKS=fe PARALLEL=true
```

또는 루트 터미널에서:

```bash
make vibe-plan TASK=feature TRACKS=fe PARALLEL=true
```

### 4.4 구현 중 운영 규칙

- 코드 수정 직후 `HANDOFF.md` 업데이트
- 큰 단계 완료 시 `docs/handoffs/123-fe-editor-diff.md`도 동일 내용 반영
- 무관한 파일 수정 금지 (외과적 변경 원칙)

권장 업데이트 최소 항목:
- `Goal`
- `Status` (done/in-progress/todo)
- `Tried/Result`
- `Next steps`
- `Verification commands`

### 4.5 로컬 검증

루트에서:

```bash
make lint
make test
make handoff-check
make turbo-ci
```

참고:
- `turbo-ci`는 `lint/test/build/typecheck` 통합 실행
- 환경/의존성 부족 시 최소 `lint/test/handoff-check` 우선 통과

### 4.6 PR 생성

PR 본문(`.github/PULL_REQUEST_TEMPLATE.md`)에 반드시 기입:
- `Affected Tracks`
- `Parent PR`
- `Merge Order`
- `Handoff Doc`

예시:
- Affected Tracks: `fe`
- Parent PR: `none`
- Merge Order: `single`
- Handoff Doc: `docs/handoffs/123-fe-editor-diff.md`

### 4.7 CI 통과 조건

자동 체크:
- branch name 규칙 (`branch-name.yml`)
- 앱별 CI + Turbo (`ci.yml`)
- 병렬 PR 거버넌스 (`parallel-governance.yml`)

app-scoped 브랜치(`fe|be|pf|platform`)에서는 특히 아래가 필수:
- PR 본문 필드 존재
- `docs/handoffs/*.md` 변경 포함

## 5. 표준 흐름 (멀티 트랙 병렬)

예시: 같은 이슈 `#123`에서 FE + BE 동시 진행

루트에서 각각 생성:

```bash
make wt-new ISSUE=123 TRACK=fe TYPE=feat SLUG=editor-diff TASK=feature
make wt-new ISSUE=123 TRACK=be TYPE=feat SLUG=submission-api TASK=api-change
```

권장 운영:
- 터미널/세션 A: `worktrees/123-fe-editor-diff`
- 터미널/세션 B: `worktrees/123-be-submission-api`
- 각 세션은 자신의 HANDOFF만 관리

공통 스킬 추천 확인:

```bash
make vibe-plan TASK=api-change TRACKS=fe,be PARALLEL=true
```

체인 PR 전략(의존 있을 때):
- PR-1: BE contract/API
- PR-2: FE integration (Parent PR: PR-1)
- PR 본문 `Merge Order`에 순서 명시

## 6. 작업 종료 및 정리

머지 후 worktree 정리:

```bash
make wt-close ISSUE=123 TRACK=fe SLUG=editor-diff
```

브랜치까지 제거하려면:

```bash
make wt-close ISSUE=123 TRACK=fe SLUG=editor-diff DELETE_BRANCH=1
```

동기화/잔여 확인:

```bash
make wt-sync
make wt-list
```

## 7. 자주 나는 실패와 해결

### 7.1 `Invalid branch name`
원인:
- 브랜치 패턴 불일치

해결:
- `feat/#<issue>/<track>-<slug>` 형식 재확인
- `track`은 `fe|be|pf|platform` 중 하나만 사용

### 7.2 `docs/handoffs/*.md 변경이 필요합니다`
원인:
- app-scoped PR인데 handoff 문서 변경 누락

해결:
- 해당 트랙 handoff 문서 수정 후 커밋
- `make handoff-check` 재실행

### 7.3 `vibe-plan`이 예상과 다름
원인:
- `TASK`, `TRACKS`, `PARALLEL` 값 오입력

해결:
- 예시 재실행:

```bash
make vibe-plan TASK=api-change TRACKS=fe,be PARALLEL=true
```

### 7.4 `wt-new` 실패 (이미 존재)
원인:
- 동일 key의 worktree가 이미 있음

해결:
- `make wt-list`로 확인
- 필요 시 `make wt-close ...` 후 재생성

## 8. 팀 운영 권장안

- 한 세션은 한 트랙만 담당
- 기능 변경과 리팩터링은 PR 분리
- API 변경은 `TASK=api-change`로 시작해서 contract-first 흐름 강제
- 리뷰어는 코드와 함께 `docs/handoffs/*.md`를 같이 검토

## 9. 빠른 치트시트

### 생성

```bash
make wt-new ISSUE=123 TRACK=fe TYPE=feat SLUG=editor-diff TASK=feature
```

### 스킬 추천

```bash
make vibe-plan TASK=feature TRACKS=fe PARALLEL=true
```

### 검증

```bash
make lint && make test && make handoff-check
```

### 종료

```bash
make wt-close ISSUE=123 TRACK=fe SLUG=editor-diff
```

## 10. 관련 파일

- 실행 가이드(요약): `devops/parallel-workflows.md`
- 스킬 플레이북: `docs/vibe-skill-playbook.md`
- PR 템플릿: `.github/PULL_REQUEST_TEMPLATE.md`
- 병렬 PR 검증: `.github/workflows/parallel-governance.yml`
- Worktree 스크립트: `scripts/worktree/`
- 스킬 선택기: `scripts/vibe/select-skills.sh`
