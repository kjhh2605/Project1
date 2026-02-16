# CI/CD 및 품질 게이트

## 1. 파이프라인 단계
1. Build
2. Lint/Typecheck
3. Unit/Integration Test
4. Security Scan
5. Deploy (staging)
6. Post-deploy Verify

## 2. 머지 차단 조건
- 프론트/백엔드 테스트 실패
- 타입체크/린트 실패
- OpenAPI 생성물 불일치
- 보안 스캔 임계치 초과(Critical 1개 이상)

## 3. 브랜치 전략
- `main`: 배포 가능한 상태 유지
- 기능 브랜치: 작은 단위 PR 권장
- 핫픽스 브랜치: 사후 ADR/회고 필수

## 4. 배포 전략
- MVP: staging 검증 후 rolling 배포
- 성장 단계: canary 배포 도입
- 실패 시 즉시 롤백 + 원인 분석 티켓 생성

## 5. 품질 리포트
- PR마다 테스트/커버리지/스캔 요약 코멘트 자동 생성
- 주간 품질 리포트: 실패 상위 테스트, flaky 추세, 평균 리드타임
