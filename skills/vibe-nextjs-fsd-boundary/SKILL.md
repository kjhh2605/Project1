---
name: vibe-nextjs-fsd-boundary
description: Next.js App Router 환경에서 Feature-Sliced Design(FSD) 계층과 의존성 경계를 강제하는 스킬. 페이지 중심 구조를 기능 중심 구조로 정리하거나, 슬라이스 경계 위반을 수정할 때 사용.
---

# Next.js + FSD 경계 강제

## 목표
라우팅 계층과 비즈니스 계층을 분리해 샷건 수술과 순환 의존을 방지한다.

## 구조 원칙
- `app/`는 라우팅, 레이아웃, 전역 프로바이더만 담당한다.
- 실제 기능 코드는 `src/`의 FSD 계층에 둔다.
- 권장 계층: `shared -> entities -> features -> widgets -> pages -> app`
- 상위 계층이 하위 계층만 참조하도록 단방향 의존을 유지한다.

## 필수 규칙
1. 슬라이스 외부 접근은 반드시 Public API(`index.ts`) 경유로만 허용한다.
2. 다른 슬라이스의 내부 파일 직접 import를 금지한다.
3. `entities`는 명사(도메인 모델/표현), `features`는 동사(유즈케이스 액션)로 분리한다.
4. App Router 파일(`app/**/page.tsx`)은 조립(Composition)만 하고 로직을 최소화한다.

## 점검 체크리스트
- [ ] 페이지 파일에서 비즈니스 로직이 과도하게 실행되지 않는가?
- [ ] 슬라이스 간 import가 Public API 경유인가?
- [ ] 계층 역참조(하위 -> 상위)가 없는가?
- [ ] 기능 추가 시 수정 파일이 특정 슬라이스 주변으로 국소화되는가?
