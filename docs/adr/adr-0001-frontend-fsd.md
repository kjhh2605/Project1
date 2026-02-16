# ADR-0001 프론트엔드 아키텍처로 FSD 채택

- 상태: accepted
- 작성일: 2026-02-16
- 의사결정자: FE/BE Tech Leads

## 배경/문제
Next.js App Router 기본 구조만으로 기능이 증가하면 페이지 파일에 로직이 집중되고, 슬라이스 경계가 흐려져 유지보수 비용이 급증한다.

## 선택지
1. 기술 계층 중심 구조(components/hooks/utils)
2. Next.js 기본 구조 유지 + 느슨한 컨벤션
3. Feature-Sliced Design(FSD) 도입

## 결정
FSD를 도입하고, `app/`은 라우팅/레이아웃 전용, 비즈니스 코드는 `src/` FSD 계층으로 분리한다.

## 근거
- 기능 중심 응집으로 변경 영향 범위(Blast Radius) 축소
- 슬라이스 Public API로 캡슐화 가능
- 팀 온보딩 및 코드리뷰 기준 명확화

## 결과/영향
- 장점: 구조 일관성, 확장성, 결합도 감소
- 단점: 초기 학습 비용, 경계 규칙 정착 필요
- 후속 작업: ESLint boundaries 규칙 적용, 폴더 템플릿 자동화
