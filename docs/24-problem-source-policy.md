# 문제 소스 정책 (GitHub PR / 벤치마크)

## 1. 수집 소스 정책
### 1.1 GitHub PR
- 기본 조건: `is:pr is:merged label:bug` + 언어 필터
- 저장소 화이트리스트 기반으로만 수집
- 수집 항목: PR 메타, 파일 patch, 코멘트, merge 시각

### 1.2 벤치마크 데이터셋
- Defects4J, BugsInPy 등 라이선스/재배포 정책 검토 후 사용
- 데이터셋 원본 ID를 source_info에 보존

## 2. 제외 규칙
- 보안 취약점 악용 코드(재현 위험 높은 샘플)
- 개인정보/비밀값 포함 커밋
- 변경량 과도(학습 난이도 초과) PR

## 3. 라이선스 규칙
- 허용: MIT, Apache-2.0, BSD-2/3-Clause
- 주의: GPL 계열은 법무 검토 전 퍼블리시 금지
- 모든 문제는 source_info에 라이선스와 attribution 저장

## 4. 변형(Transformation) 규칙
- 원문 구조/아이디어는 유지하되 교육 목적에 맞게 단순화
- 문제 코드 길이 목표: 30~80줄
- 저장소 고유 식별자/민감 문맥 제거

## 5. 추적성(Traceability)
- 문제마다 source fingerprint 저장
  - repo
  - pr_number
  - commit_sha
  - patch_hash
- 이력 변경 시 version 증가
