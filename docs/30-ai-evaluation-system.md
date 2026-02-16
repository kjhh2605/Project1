# AI 평가 시스템 설계서

## 1. 목표
- 정답 여부를 넘어 수정의 품질(정확성/성능/가독성)을 정량·정성 평가
- 비용 폭증 없이 안정적인 피드백 제공

## 2. 3단계 캐스케이드
- Tier 1: 저비용 모델(빠른 스크리닝)
- Tier 2: 표준 평가 모델(대부분 케이스)
- Tier 3: 고품질 모델(경계/이의제기/프리미엄)

승급 조건 예시:
- Tier1 신뢰도 낮음
- 정적 분석과 평가 결과 불일치
- 상위 난이도 문제 또는 프리미엄 사용자

## 3. 루브릭 설계
- correctness (0~5)
- performance (0~5)
- readability (0~5)
- best_practices (0~5)
- overall_score = 합계(20점)

## 4. 프롬프트 관리
- 문제별 루브릭 템플릿 버전 관리(`rubricVersion`)
- 시스템 프롬프트와 문제별 프롬프트 분리
- 변경 시 A/B 검증 후 승격

## 5. 캐시 전략
- 프롬프트 캐시: 동일 문제/루브릭 템플릿 재사용
- 시맨틱 캐시: 유사 제출 임베딩 기반 히트
- 캐시 히트 시 결과 신뢰도 플래그 명시

## 6. 응답 스키마(JSON)
```json
{
  "correctness": {"score": 4, "reasoning": "..."},
  "performance": {"score": 3, "reasoning": "..."},
  "readability": {"score": 5, "reasoning": "..."},
  "best_practices": {"score": 4, "reasoning": "..."},
  "overall_score": 16,
  "feedback": "...",
  "model_tier": 2,
  "rubric_version": "r1.0"
}
```

## 7. 품질 모니터링
- 인간 검수 샘플과 모델 점수 일치율
- 문제별 편향/드리프트 감시
- 평가 지연 시간과 비용 추세 대시보드화
