# 프론트엔드 상세 설계서 (Next.js + FSD)

## 1. 목표
- 기능 중심 구조(FSD)로 프론트 복잡도 관리
- Monaco 기반 디버깅 UX(원본 vs 수정 diff) 제공
- 제출 상태를 실시간으로 사용자에게 전달

## 2. 구조 원칙
- `app/`: 라우팅/레이아웃/전역 provider만 담당
- `src/`: FSD 계층(`shared → entities → features → widgets → pages`) 중심
- 슬라이스 외부 접근은 각 슬라이스 `index.ts`(Public API)만 허용

## 3. 디렉터리 구조
```txt
app/
  (routes)/
  layout.tsx
  providers.tsx
src/
  shared/
    ui/
    lib/
    api/
  entities/
    problem/
    submission/
  features/
    code-submit/
    diff-view/
  widgets/
    editor-panel/
    result-panel/
  pages/
    problem-detail/
```

## 4. 의존성 규칙
- 상위 계층이 하위 계층만 참조
- `pages`는 조립(Composition)만 수행, 비즈니스 로직 금지
- ESLint 경계 규칙으로 계층 위반 차단

## 5. Monaco 전략
- `next/dynamic`으로 클라이언트에서 lazy load
- 일반 편집기 + `DiffEditor` 병행 사용
- 테마(라이트/다크) 및 언어(Java/Python) 동적 로딩

## 6. Zustand 스토어 설계
- `editorSlice`: 코드, 언어, 커서, dirty 상태
- `problemSlice`: 문제 메타/제약/기본 코드
- `diffSlice`: 원본/수정 비교 상태
- `uiSlice`: 패널, 탭, 토스트, 로딩

## 7. SSE 연동
- 엔드포인트: `/api/v1/submissions/{id}/events`
- 이벤트: `queued`, `running`, `analyzing`, `ai_evaluating`, `completed`, `failed`
- 네트워크 단절 시 지수 백오프 재연결

## 8. 품질 게이트
- `npm run lint`
- `npm run typecheck`(추가 필요)
- `npm run test`
- `npm run build`
