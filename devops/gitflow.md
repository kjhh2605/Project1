# GitFlow Rules

## Long-Lived Branches

- `main`: production-ready only
- `develop`: integration branch for upcoming release

## Branch Naming

- Feature: `feat/#<issue-number>/<branch-name>`
- Hotfix: `hotfix/#<issue-number>/<branch-name>`
- Release: `release/<major>.<minor>.<patch>`

Examples:
- `feat/#123/login-api`
- `hotfix/#452/payment-timeout`
- `release/1.2.0`

## Merge Policy

- No direct push to `main` or `develop`
- Merge only through pull requests
- Required checks: branch-name, ci
- Release and hotfix must be back-merged into `develop`
