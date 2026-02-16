# CI/CD 및 품질 게이트

## 1. 파이프라인 단계
1. build
2. lint/typecheck
3. test
4. security scan
5. deploy
6. post-deploy verify

## 2. 머지 차단 조건
- 테스트 실패
- 보안 임계치 초과
- 계약 생성물 불일치

## 3. 배포 전략
- blue/green 또는 canary
- rollback 절차
