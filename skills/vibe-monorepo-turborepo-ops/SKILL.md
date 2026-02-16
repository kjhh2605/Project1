---
name: vibe-monorepo-turborepo-ops
description: Next.js와 Go를 함께 운영하는 모노레포에서 Turborepo 태스크 그래프, 캐시, 워크스페이스 의존성을 정리하는 스킬. 빌드/테스트 시간 단축과 변경 영향 관리가 필요할 때 사용.
---

# 모노레포 운영 규칙(Turborepo)

## 목표
폴리글랏 저장소의 개발 속도와 일관성을 유지한다.

## 구조 원칙
- `apps/`: 실행 가능한 애플리케이션(예: web, api)
- `packages/`: 공유 라이브러리(예: contracts, config, ui)
- 루트에는 공통 도구만 두고 앱 의존성은 각 앱에 둔다.

## Turbo 규칙
1. `build`, `test`, `lint`, `typecheck` 태스크 의존 그래프를 명시한다.
2. 입력/출력 경로를 정의해 캐시 효율을 높인다.
3. 계약 패키지 변경 시 관련 앱 태스크가 자동 연쇄되게 설정한다.
4. CI는 영향 범위 기반 실행(affected only)을 기본으로 한다.

## 체크리스트
- [ ] workspace 참조(`workspace:*`)가 일관적인가?
- [ ] 캐시 누락/과캐시가 없는가?
- [ ] 패키지 경계 위반 import가 없는가?
