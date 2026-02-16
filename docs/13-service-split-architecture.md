# 서비스 분리 아키텍처 (Core API + Problem Factory)

## 1. 목적
유저 트래픽 처리(Core API)와 문제 생성 파이프라인(Problem Factory)을 분리해 성능/안정성/보안을 강화한다.

## 2. 서비스 구성

### 2.1 Core API (Go/Gin)
- 역할: 사용자 문제 조회, 제출 생성/조회, SSE 상태 조회
- 특성: 낮은 지연, 높은 가용성 우선

### 2.2 Problem Factory (Python)
- 역할: GitHub PR 수집, 문제 초안 생성, 자동 검증, 리뷰 워크플로우
- 권장 스택: FastAPI + Celery(또는 RQ) + Redis + PostgreSQL
- 특성: 비동기 배치/백그라운드 작업 중심

### 2.3 Admin Web (Next.js)
- 역할: 문제 검토/승인/게시 UI
- 호출 대상: Problem Factory API

## 3. 데이터/큐 분리 원칙
- DB는 공유 가능하나 스키마 분리 권장
  - `core` (제출/평가)
  - `content` (문제 생성/검수)
- 큐 네임스페이스 분리
  - `submission:*` (Core)
  - `problem:*` (Factory)

## 4. 보안 분리
- GitHub 토큰/LLM 생성 키는 Problem Factory에만 주입
- Core API는 읽기 중심 최소 권한만 유지
- 관리자 권한 검증은 Problem Factory에서 별도 수행

## 5. 배포 전략
- Core API: Cloud Run 또는 GKE(안정 배포)
- Problem Factory: 독립 워커 오토스케일
- 장애 격리: Factory 장애가 Core API SLA에 영향 없도록 네트워크/리소스 분리

## 6. API 경계
- 사용자 API: `/v1/problems`, `/v1/submissions/*` (Core)
- 관리자/생성 API: `/v1/admin/problems/*`, `/v1/admin/generation-jobs/*` (Factory)

## 7. 단계적 전환 계획
1. 관리자 API를 Problem Factory로 이관
2. 문제 생성 Asynq 스펙을 Python 워커 태스크로 매핑
3. Core API는 문제 조회 읽기 모델만 유지
