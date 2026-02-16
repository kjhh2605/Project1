# 프론트엔드 상세 설계서 (Next.js + FSD)

## 1. 목표

## 2. 구조 원칙
- app/는 라우팅/레이아웃만
- src/는 FSD 계층 중심

## 3. 디렉터리 구조
```txt
app/
src/
  shared/
  entities/
  features/
  widgets/
  pages/
```

## 4. 의존성 규칙
- 상위 → 하위 단방향
- 슬라이스 외부 접근은 public API(index.ts)만

## 5. Monaco 전략
- lazy loading:
- DiffEditor 구성:
- 테마/언어 로드:

## 6. Zustand 스토어 설계
- editor slice:
- problem slice:
- diff slice:
- ui slice:

## 7. SSE 연동
- 이벤트 타입:
- 재연결 전략:

## 8. 품질 게이트
- lint/typecheck/test/build
