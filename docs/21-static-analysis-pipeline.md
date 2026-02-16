# 정적 분석 파이프라인 설계서

## 1. 목표

## 2. 언어별 도구
- Java: PMD, Checkstyle, SpotBugs
- Python: Ruff, Pylint, Bandit
- Go: golangci-lint

## 3. 실행 순서
1. 코드 실행 결과 확보
2. 언어별 분석
3. JSON 파싱/정규화
4. 통합 점수 산출

## 4. 결과 스키마
- severity:
- rule_id:
- location:
- message:

## 5. 재시도/실패 정책
- 
