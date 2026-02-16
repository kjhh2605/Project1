---
name: vibe-go-hexagonal-architecture
description: Go-Gin 백엔드에서 헥사고날 아키텍처(Ports & Adapters)를 적용해 도메인 순수성, 테스트 용이성, 인프라 교체 가능성을 확보하는 스킬. 비즈니스 로직과 프레임워크 결합을 줄일 때 사용.
---

# Go 헥사고날 아키텍처

## 목표
핵심 도메인이 Gin/DB 드라이버에 오염되지 않도록 분리한다.

## 권장 레이아웃
- `cmd/`: 진입점(main), 의존성 조립
- `internal/domain/`: 엔티티, 값 객체, 포트(인터페이스)
- `internal/application/`: 유스케이스, 트랜잭션 경계
- `internal/adapter/in/http/`: Gin 핸들러(Input Adapter)
- `internal/adapter/out/persistence/`: DB 구현(Output Adapter)
- `api/`: OpenAPI/DTO 계약

## 의존성 규칙
1. `domain`은 어떤 프레임워크 패키지도 import하지 않는다.
2. `application`은 포트 인터페이스에만 의존한다.
3. 어댑터 계층이 포트 구현체를 제공한다.
4. 핸들러는 DTO 변환과 유스케이스 호출만 담당한다.

## 구현 체크
- [ ] 도메인 타입에 DB 태그/HTTP 의존이 없는가?
- [ ] 리포지토리 인터페이스가 domain/application에 선언되어 있는가?
- [ ] 인프라 교체(예: DB 변경) 시 코어 변경이 최소화되는가?
