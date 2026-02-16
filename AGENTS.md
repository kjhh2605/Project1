# Repository Guidelines

## Project Structure & Module Organization
This repository is currently a clean scaffold with no committed source files yet. Use the following layout as you add code:

- `src/` application code grouped by feature or module
- `tests/` automated tests mirroring `src/` structure
- `assets/` static files (images, fixtures, sample data)
- `docs/` design notes and architecture decisions

Example: `src/auth/login.ts` with tests in `tests/auth/test_login.ts`.

## Build, Test, and Development Commands
No build tooling is configured yet. After selecting a stack, standardize commands in a single entry point (`Makefile` or `package.json` scripts) and keep them stable:

- `make setup` installs dependencies
- `make test` runs the full test suite
- `make lint` runs formatting and lint checks
- `make dev` starts a local development server
- `make turbo-ci` runs monorepo quality gates (`lint`, `test`, `build`, `typecheck`) via Turbo
- `make wt-new ...` creates an issue-scoped parallel worktree with handoff/workplan docs
- `make handoff-check` validates required handoff sections

Document any stack-specific alternatives in this file when introduced.

## Coding Style & Naming Conventions
Until language tooling is added, follow consistent defaults:

- Indentation: 2 spaces for JS/TS/YAML, 4 spaces for Python
- Filenames: `kebab-case` for scripts/assets, `snake_case` for Python modules, `PascalCase` for class/type files when idiomatic
- Keep functions small and module boundaries explicit

Adopt automatic formatters and linters early (for example, Prettier/ESLint or Ruff/Black) and run them before commits.

## Testing Guidelines
Add tests with every feature or bug fix. Minimum expectations:

- Place tests under `tests/` using names like `test_<unit>.py` or `<unit>.test.ts`
- Cover core flows, edge cases, and regressions
- Keep test data in `tests/fixtures/` when needed

Run tests locally before opening a pull request.

## Commit & Pull Request Guidelines
There is no existing commit history yet; start with a consistent convention such as Conventional Commits:

- `feat: add user session model`
- `fix: handle empty input in parser`

Pull requests should include:

- Clear summary of what changed and why
- Linked issue (if available)
- Test evidence (`make test` output or equivalent)
- Screenshots for UI changes

## Skills
A skill is a set of local instructions to follow that is stored in a `SKILL.md` file. Below is the list of skills available in this repository.

### Available skills
- `vibe-api-contract-first`: OpenAPI를 SSOT로 두고 백엔드(oapi-codegen)와 프론트엔드(Orval) 코드를 동기 생성하는 스킬. (file: `skills/vibe-api-contract-first/SKILL.md`)
- `vibe-backend-lifecycle-di`: Go 백엔드 DI(Wire/Fx)와 서버 라이프사이클(시작/종료 훅, graceful shutdown)을 표준화하는 스킬. (file: `skills/vibe-backend-lifecycle-di/SKILL.md`)
- `vibe-context-handoff-manager`: 긴 작업/멀티세션에서 컨텍스트 핸드오프 문서를 관리하는 스킬. (file: `skills/vibe-context-handoff-manager/SKILL.md`)
- `vibe-debt-firebreak-architecture`: 초기 단계에서 기술 부채 방화벽(경계, 규칙, 리뷰 게이트)을 설정하는 스킬. (file: `skills/vibe-debt-firebreak-architecture/SKILL.md`)
- `vibe-fullstack-quality-gates`: Next.js+Go 풀스택 품질 게이트(테스트/계약/E2E/보안)를 머지 전 강제하는 스킬. (file: `skills/vibe-fullstack-quality-gates/SKILL.md`)
- `vibe-git-pr-safety-flow`: git/gh 기반 안전한 브랜치·커밋·드래프트 PR 흐름을 적용하는 스킬. (file: `skills/vibe-git-pr-safety-flow/SKILL.md`)
- `vibe-go-hexagonal-architecture`: Go-Gin 백엔드에 Ports & Adapters 경계를 적용하는 스킬. (file: `skills/vibe-go-hexagonal-architecture/SKILL.md`)
- `vibe-monorepo-turborepo-ops`: Turborepo 태스크 그래프/캐시/워크스페이스 의존성을 정리하는 모노레포 운영 스킬. (file: `skills/vibe-monorepo-turborepo-ops/SKILL.md`)
- `vibe-nextjs-fsd-boundary`: Next.js App Router + FSD 계층 의존성 경계를 강제하는 스킬. (file: `skills/vibe-nextjs-fsd-boundary/SKILL.md`)
- `vibe-parallel-worktree-orchestrator`: Git worktree와 병렬 세션 운영으로 다중 작업 충돌을 줄이는 스킬. (file: `skills/vibe-parallel-worktree-orchestrator/SKILL.md`)
- `vibe-requirements-clarifier`: 구현 전 모호한 요구사항의 가정/대안/트레이드오프를 명확화하는 스킬. (file: `skills/vibe-requirements-clarifier/SKILL.md`)
- `vibe-success-criteria-planner`: 요청을 검증 가능한 성공 기준과 단계별 검증 루프로 변환하는 스킬. (file: `skills/vibe-success-criteria-planner/SKILL.md`)
- `vibe-surgical-change-guard`: 요청과 직접 관련된 최소 변경만 수행하도록 범위를 제한하는 스킬. (file: `skills/vibe-surgical-change-guard/SKILL.md`)
- `vibe-tdd-implementation-loop`: write-test-fix 루프로 구현/수정을 진행하는 테스트 우선 스킬. (file: `skills/vibe-tdd-implementation-loop/SKILL.md`)
- `vibe-verification-matrix`: 테스트/정적분석/수동검증/관측성 체크를 매트릭스로 관리하는 스킬. (file: `skills/vibe-verification-matrix/SKILL.md`)

### How to use skills
- Trigger rules: 사용자가 스킬 이름을 명시하거나 작업이 스킬 설명과 명확히 일치하면 해당 스킬을 적용한다.
- Progressive disclosure: 우선 `SKILL.md`를 열어 필요한 만큼만 읽고, 참조 파일은 필요한 것만 추가로 연다.
- Reuse assets/scripts: 스킬 디렉토리에 `scripts/`, `assets/`, 템플릿이 있으면 재작성보다 재사용을 우선한다.
- Coordination: 여러 스킬이 맞으면 최소 조합만 적용하고 적용 순서를 짧게 알린다.
- Fallback: 스킬 파일이 없거나 지시가 불명확하면 문제를 알리고 최선의 대체 방식으로 계속 진행한다.
