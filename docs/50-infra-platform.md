# 인프라 구축 가이드 (GCP)

## 1. 목표
- MVP는 저비용/저복잡도로 시작한다.
- 성장 단계에서 무중단 확장 가능한 구조로 전환한다.
- 코드 실행 샌드박스 보안을 기본 전제로 한다.

## 2. 환경 단계
### 2.1 MVP (<100 DAU)
- API: Cloud Run
- DB: Cloud SQL(PostgreSQL)
- 큐/캐시: Redis(Managed)
- 샌드박스/워커: 단일 GKE Autopilot 노드풀 또는 VM

### 2.2 초기 성장 (100~1K DAU)
- API: Cloud Run + 최소 인스턴스 설정
- 워커: GKE Autopilot(Asynq Worker/Judge0)
- 모니터링: Grafana Cloud + OpenTelemetry

### 2.3 성장 (1K+ DAU)
- API/워커 모두 GKE Standard 검토
- DB read replica + 연결 풀 최적화
- 큐 분리 및 워커 오토스케일(HPA)

## 3. 핵심 구성
- Cloud Run/GKE: 서비스 컴퓨트
- Cloud SQL(PostgreSQL): 트랜잭션 데이터
- Redis: Asynq 백엔드 + 캐시
- Cloud Storage: 로그/스냅샷 보관
- Cloudflare: CDN/WAF/DDoS 보호

## 4. Kubernetes 표준
- 네임스페이스: `project1-api`, `project1-worker`, `project1-sandbox`
- 리소스 요청/제한 필수 선언
- 샌드박스 워크로드는 `RuntimeClass: gvisor` 강제
- PodDisruptionBudget 설정(핵심 워커)

## 5. 네트워크/보안
- 기본 원칙: 최소 권한, 기본 거부
- Ingress: API만 공개, 관리자/내부 서비스는 제한
- Egress: 워커별 목적지 allowlist
- Secret: Secret Manager + K8s Secret 동기화
- 이미지: private registry + 서명 검증(가능 시)

## 6. CI/CD 권장 구조
1. PR: lint/typecheck/test/security scan
2. main merge: build/push/deploy(staging)
3. smoke test 통과 시 production 배포
4. 실패 시 자동 롤백

## 7. 비용 관리
- 월 예산 알림: 50%/80%/100%
- 라벨 기반 비용 추적: `env`, `service`, `team`
- 비핵심 배치 워크로드는 스팟/저우선 자원 사용
- 장기 미사용 리소스 주간 정리

## 8. 초기 실행 체크리스트
- [ ] GCP 프로젝트/권한/IAM 구성
- [ ] Cloud SQL/Redis 생성 및 접근 제어
- [ ] GKE Autopilot + gVisor runtime 구성
- [ ] 도메인/SSL/Cloudflare 연결
- [ ] 비용 알림/대시보드 설정
