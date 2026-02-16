# 코드 실행/샌드박스 보안 설계서

## 1. 위협 모델
- 샌드박스 탈출
- 리소스 고갈
- 외부 통신 악용

## 2. 격리 정책
- network=none
- read-only rootfs
- tmpfs 제한
- cgroups v2 제한
- seccomp/AppArmor
- gVisor RuntimeClass

## 3. 언어별 프로파일
### Java
- 메모리:
- 금지 패턴:
### Python
- 메모리:
- 금지 패턴:

## 4. 타임아웃/워치독
- wall-time:
- kill 정책:

## 5. 취약점 대응
- CVE 모니터링
- 패치 SLA
