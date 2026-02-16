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
