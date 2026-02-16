# 코드 실행/샌드박스 보안 설계서

## 1. 위협 모델
- 샌드박스 탈출 통한 호스트 침투
- 포크 폭탄/무한루프로 자원 고갈
- 외부 네트워크 악용(스캔, 데이터 유출)

## 2. 필수 격리 정책
- 네트워크: `--network=none`
- 파일시스템: read-only rootfs + 제한 tmpfs(최대 100MB)
- cgroups v2: CPU 1 core, PID 64, 메모리(Java 512MB/Python 256MB)
- seccomp: `mount`, `setns`, `unshare`, `ptrace` 등 차단
- AppArmor: 파일 접근/권한 최소화
- gVisor RuntimeClass: 커널 공격면 축소

## 3. 언어별 프로파일
### Java
- 실행 옵션: `-Xmx256m`(문제 난이도에 따라 상향)
- 위험 API(`Runtime.exec`, `ProcessBuilder`) 사용 시 경고 신호 생성

### Python
- 실행 시간 제한 강화(기본 2~3초)
- 위험 패턴(`subprocess`, `eval/exec`) 탐지 결과를 피드백에 반영
- 단, 탐지는 보안 보조수단이며 격리 대체 수단 아님

## 4. 타임아웃/워치독
- 컴파일 타임아웃, 실행 타임아웃, wall-time 워치독 분리
- 타임아웃 초과 시 즉시 kill + 정리 로그 기록

## 5. 취약점 대응
- Judge0 버전 최소 기준: v1.13.1+
- 주간 이미지 취약점 스캔(Trivy)
- 치명 CVE 발견 시 24시간 내 패치 계획 수립
