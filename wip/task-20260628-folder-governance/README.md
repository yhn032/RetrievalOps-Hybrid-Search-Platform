# Task: 프로젝트 폴더 관리 체계 이식

## Status: in-progress

## Completion Criteria

- [x] 역할별 문서 폴더와 Git 추적 경계가 적용되어 있다.
- [ ] `WORKFLOW.md`에서 모든 추적 문서에 도달할 수 있다.
- [ ] `MANIFEST.md`에서 생애주기 단계와 상태를 확인할 수 있다.
- [ ] 표준 문서 메타데이터와 기준본 관리 절차가 정의되어 있다.
- [ ] 문서 배치, 출처, 연결성, 기준본 변경을 자동 검사한다.
- [x] 원본 DOCX와 민감 자료가 Git에서 제외되어 있다.
- [ ] 계획과 실제 구현 사이의 미해결 gap이 없다.
- [ ] 전체 검증이 통과하고 변경 사항이 로컬에 커밋되어 있다.

## Context

- **Started**: 2026-06-28
- **Estimated scope**: L
- **Affected repos**: `/workspaces`
- **Scope**: 폴더 및 문서 관리 체계
- **Out of scope**: Spring Boot, JDK, 빌드 도구, 애플리케이션 모듈 설계, 멀티 디자인 시스템

## Done

| # | Task | Date | Notes |
|---|---|---|---|
| 1 | 원본 문서의 폴더 관리 부분 분석 | 2026-06-28 | 멀티 디자인 시스템 제외 |
| 2 | 단계별 이식 계획 수립 | 2026-06-28 | 역할·신뢰 2축과 자동 검사 반영 |
| P0 | Phase 0 기본 구조와 추적 경계 구성 | 2026-06-28 | `app/`, 역할별 `docs/`, WIP 경로 생성 |
| P0.1 | Git 추적 경계 적용 | 2026-06-28 | 원본·내부·미분류 자료는 README만 추적 |
| P0.2 | 원본 DOCX 격리 | 2026-06-28 | `docs/intake/`로 이동하고 ignore 확인 |
| P0.3 | Phase 0 검증 | 2026-06-28 | 집중 검사 통과, 전체 검사 126 PASS / 0 FAIL |

## Remaining

| # | Task | Blocked By | Priority | Notes |
|---|---|---|---|---|
| P1 | `WORKFLOW.md`, `MANIFEST.md`, 단계별 표준 구성 | P0 | HIGH | 생애주기와 상태 정의 |
| P2 | 메타데이터와 기준본 변경 절차 정의 | P1 | HIGH | 출처와 배제 사유 포함 |
| P3 | 문서 gate 및 연결성 검사 구현 | P2 | HIGH | 기존 completion checker에 통합 |
| P4 | 공개 문서 재배치와 루트 정리 | P3 | MEDIUM | 기존 거버넌스 문서는 루트 유지 |
| P5 | 계획–구현 gap 최종 점검 및 WIP 종료 | P4 | HIGH | 모든 완료 조건 검증 |

## Dependencies

```text
P0 → P1 → P2 → P3 → P4 → P5
```

## Decisions

| Date | Decision | Rationale | Alternatives Considered |
|---|---|---|---|
| 2026-06-28 | Spring/JDK 조사를 별도 후속 작업으로 분리 | 현재 요청은 폴더 구조로 한정됨 | Phase 0에서 개발 도구까지 설치 |
| 2026-06-28 | 애플리케이션 경로는 `app/`만 예약 | 문서·거버넌스와 향후 코드를 분리하되 구조를 선결정하지 않음 | 루트 `src/`, 다중 `services/` |
| 2026-06-28 | `inbox/`도 기본 미추적으로 운영 | 분류 전 자료의 민감도를 알 수 없음 | 원안대로 추적 |
| 2026-06-28 | 원본 DOCX는 `intake/`에서 미추적 | 전달받은 원본을 default-deny로 보호 | 원본을 공개 저장소에 커밋 |
| 2026-06-28 | `refs/`를 만들지 않음 | `origin/`과 `derived/`에 역할이 중복됨 | 원안의 `refs/` 유지 |

## Plan–Implementation Gap

| ID | Planned | Actual | Gap | Resolution | Status |
|---|---|---|---|---|---|
| G0 | 역할별 기본 폴더와 추적 경계 | 계획대로 구현 | 없음 | ignore 및 경로 검사 완료 | closed |
| G1 | 생애주기 라우터와 상태 관리 | 미구현 | `WORKFLOW.md`, `MANIFEST.md` 없음 | Phase 1 | open |
| G2 | 메타데이터와 기준본 절차 | 미구현 | 규칙 문서 없음 | Phase 2 | open |
| G3 | 자동 gate | 미구현 | 기존 템플릿 검사만 존재 | Phase 3 | open |
| G4 | 문서 재배치와 루트 정리 | 원본 DOCX 이동 완료 | 공개 문서 재배치 미완료 | Phase 4 | partial |

## Files Modified

| Repo | File | Change Type |
|---|---|---|
| `/workspaces` | `.gitignore` | modified |
| `/workspaces` | `app/README.md` | created |
| `/workspaces` | `docs/**/README.md` | created |
| `/workspaces` | `docs/intake/*.docx` | moved, local-only |
| `/workspaces` | `wip/task-20260628-folder-governance/README.md` | created |
| `/workspaces` | `wip/task-20260628-folder-governance/anchor.md` | created |

## Unpushed Commits

| Repo | Branch | Commit | Description |
|---|---|---|---|
| `/workspaces` | `main` | — | Phase 0 작업 중 |
