# 정적 분석 파이프라인 설계서

## 1. 목표
- 제출 코드의 품질/안전/모범사례 위반을 자동으로 탐지한다.
- 언어별 도구 결과를 단일 포맷으로 정규화해 AI 평가 입력으로 활용한다.
- 실행 결과(Judge0)와 정적 분석 결과를 함께 저장해 재현성과 추적성을 보장한다.

## 2. 언어별 도구 및 실행 정책
### Java
- PMD: 코드 스멜/복잡도
- Checkstyle: 스타일/컨벤션
- SpotBugs: 바이트코드 기반 잠재 버그

### Python
- Ruff: 고속 린팅(기본 1차 게이트)
- Pylint: 구조/가독성/잠재 오류
- Bandit: 보안 취약 패턴

### Go (플랫폼 내부 코드 품질)
- golangci-lint: 백엔드 서비스 품질 게이트

## 3. 실행 순서
1. 제출 코드 저장 및 언어 판별
2. Judge0 실행 결과 확보(컴파일/실행 성공 여부)
3. 언어별 정적 분석 도구 실행(컨테이너 내부)
4. 도구별 JSON 결과 파싱
5. 공통 스키마로 정규화
6. severity 가중치 점수 계산
7. AI 평가 입력 컨텍스트에 요약 전달
8. DB 저장 + SSE 이벤트 발행(`analyzing`→`ai_evaluating`)

## 4. 공통 결과 스키마
```json
{
  "tool": "ruff",
  "severity": "warning",
  "rule_id": "F401",
  "message": "module imported but unused",
  "location": {
    "path": "main.py",
    "line": 12,
    "column": 1
  },
  "category": "style",
  "confidence": 0.95
}
```

## 5. 점수화(초안)
- severity 가중치
  - error: 5
  - warning: 3
  - info: 1
- 카테고리 가중치
  - security: x1.5
  - correctness: x1.3
  - performance: x1.2
  - style/readability: x1.0

최종 품질 점수 예시:
- `quality_penalty = Σ(severity_weight × category_weight)`
- AI 루브릭의 best_practices 항목에 penalty 반영

## 6. 재시도/실패 정책
- 재시도 대상
  - 도구 실행 환경 오류(일시 장애)
  - 컨테이너 이미지 pull 실패
- 비재시도 대상
  - 코드 구문 오류로 분석 불가
  - 지원하지 않는 언어

권장 재시도 정책:
- 최대 3회
- 지수 백오프(1s, 4s, 16s)

## 7. 운영 기준
- 분석 워커 타임아웃: 20초
- 제출당 최대 이슈 저장 개수: 500건(초과 시 요약 저장)
- 도구 버전은 월 1회 고정 업데이트(변경 시 ADR 또는 CHANGELOG 기록)

## 8. 체크리스트
- [ ] 도구별 JSON 파서 테스트 완료
- [ ] 공통 스키마 변환 테스트 완료
- [ ] 중복 이슈 제거 규칙 적용
- [ ] SSE 연동 확인
- [ ] DB 저장/조회 성능 확인
