# 병렬 개발 워크플로우 가이드

## 1. 목적
`apps/fe`, `apps/be`, `apps/problem-factory`를 병렬 트랙으로 나눠 충돌을 최소화하고, 핸드오프/PR 정보를 표준화한다.

## 2. 트랙과 브랜치 규칙
- 트랙: `fe`, `be`, `pf`, `platform`
- 브랜치 패턴:
  - `feat/#<issue>/<track>-<slug>`
  - `hotfix/#<issue>/<track>-<slug>`
  - `chore/#<issue>/<track>-<slug>`

예시:
- `feat/#123/fe-editor-diff`
- `feat/#123/be-submission-api`
- `chore/#456/platform-ci-cache`

## 3. 표준 실행 명령
새 병렬 트랙 생성:

```bash
make wt-new ISSUE=123 TRACK=fe TYPE=feat SLUG=editor-diff TASK=feature
```

상태 확인/동기화/종료:

```bash
make wt-list
make wt-sync
make wt-close ISSUE=123 TRACK=fe SLUG=editor-diff
```

## 4. 생성 산출물
`wt-new` 실행 시 아래 문서가 자동 생성된다.
- `HANDOFF.md`
- `docs/handoffs/<issue>-<track>-<slug>.md`
- `WORKPLAN.md`

핸드오프 검증:

```bash
make handoff-check
```

## 5. 스킬 자동 추천
작업 특성에 맞는 스킬 순서는 아래 명령으로 생성한다.

```bash
make vibe-plan TASK=api-change TRACKS=fe,be PARALLEL=true
```

출력은 `scripts/vibe/select-skills.sh` 규칙에 따라 결정된다.

## 6. PR 거버넌스
app-scoped 브랜치 PR은 다음을 반드시 포함한다.
- `docs/handoffs/*.md` 변경
- PR 본문의 `Affected Tracks`, `Parent PR`, `Merge Order`

관련 자동 검증:
- `.github/workflows/parallel-governance.yml`
- `.github/workflows/branch-name.yml`

## 7. CI 품질 게이트
기존 앱 분기 CI 외에 Turbo 통합 게이트를 사용한다.

```bash
make turbo-ci
```

CI에서도 `npx --yes turbo@2 run lint test build typecheck`를 실행한다.
