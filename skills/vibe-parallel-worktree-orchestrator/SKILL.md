---
name: vibe-parallel-worktree-orchestrator
description: Git worktree와 병렬 세션 운영으로 다중 작업 간 충돌을 줄이는 스킬. 동시에 여러 기능/버그를 진행할 때 사용.
---

# 병렬 작업 오케스트레이션

## 목표
여러 작업을 동시에 진행하면서 브랜치 충돌과 컨텍스트 혼선을 줄인다.

## 실행 절차
1. 작업별 이슈 ID를 부여한다.
2. 작업별 브랜치 + worktree 디렉터리를 분리한다.
3. 각 worktree에 독립 세션을 연결한다.
4. 세션별 HANDOFF.md를 유지한다.
5. 완료 순서대로 PR을 열고 의존 관계를 명시한다.

## 디렉터리 규칙 예시
- worktrees/feat-auth
- worktrees/fix-login-timeout
- worktrees/chore-ci-cache

## 운영 규칙
- 한 세션은 한 목적만 담당시킨다.
- 교차 변경이 필요하면 기준 브랜치를 먼저 정리한다.
- 병합 순서가 중요한 경우 체인 PR 전략을 사용한다.
