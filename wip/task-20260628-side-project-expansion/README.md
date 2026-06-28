# Task: 사이드 프로젝트 문서 이식 및 컨테이너 분리

## Status: in-progress

## Completion Criteria

- [ ] 선행 폴더 관리 WIP가 종료되어 있다.
- [ ] 사용자가 제공하는 Markdown 원본 2개가 `docs/intake/`에 격리되어 있다.
- [ ] 원본을 복사하지 않고 요구사항·아키텍처·평가 계약으로 분리해 작성했다.
- [ ] M0·M2·M4 평가 조건과 데이터셋, Recall@k, MRR, nDCG, p95, 반복 횟수가 문서화되어 있다.
- [ ] 아키텍처와 모듈 경계, 저장소·캐시·메시지 큐·배포 선택이 ADR로 기록되어 있다.
- [ ] 루트 `README.md`, `PROJECT.md`, `REFERENCE.md`가 실제 사이드 프로젝트에 맞게 재작성되어 있다.
- [ ] 모든 추적 문서가 `WORKFLOW.md`에서 도달 가능하고 깨진 링크가 없다.
- [ ] `app/` 하위 기능 폴더와 컨테이너 배포 단위가 일치한다.
- [ ] 코드 수정 단위는 VS Code 연결과 로컬 디버깅이 가능하며 배포 이미지와 개발 컨테이너가 분리되어 있다.
- [ ] 모든 서비스가 개별 컨테이너로 실행되고 `dev`·`stg`·`prod` 설정이 분리되어 있다.
- [ ] 모든 컨테이너가 non-root, host UID/GID, 공통 timezone과 UTF-8 규칙을 준수한다.
- [ ] 계획과 실제 구현 사이의 미해결 gap이 없다.
- [ ] 전체 검증이 통과하고 변경 사항이 커밋·푸시되어 있다.

## Context

- **Queued**: 2026-06-28
- **Estimated scope**: XL
- **Affected repos**: `/workspaces`
- **Start condition**: 선행 WIP 종료 및 Markdown 원본 2개 업로드 (충족)
- **Started**: 2026-06-28 (선행 폴더 관리 WIP 종료, 원본 2개 업로드로 차단 해제)
- **Anchor**: [사용자 요구사항 원문](anchor.md)
- **Scope**: 문서 이식, 프로젝트 문서 재작성, 기능별 컨테이너 분리
- **이제 범위 내**: 문서 추출, 기술 버전 선정(ADR), 컨테이너 구성·기동

## Source Handling

1. 업로드된 Markdown 원본은 `docs/intake/`에 두고 Git에서 제외합니다.
2. 원본의 문장을 통째로 복사하지 않고 목적별 문서로 분해·재작성합니다.
3. 분석 중간 결과는 `docs/derived/`에, 공개 산출물은 `docs/deliverables/`에 둡니다.
4. 원본 경로 대신 추적 가능한 source ID를 파생 문서 메타데이터에 기록합니다.

## Planned Document Mapping

| 사용자 제안 | 현재 폴더 체계 적용안 | 목적 |
|---|---|---|
| `docs/EVALUATION_CONTRACT.md` | `docs/deliverables/evaluation-contract.md` | M0·M2·M4 평가 계약 |
| `docs/adr/` | `docs/deliverables/adr/` | 아키텍처 결정 기록 |
| 원본 분석 메모 | `docs/derived/` | 요구사항·아키텍처 추출 근거 |
| 업로드 원본 2개 | `docs/intake/` | 미추적 원본 |
| 루트 프로젝트 문서 | `README.md`, `PROJECT.md`, `REFERENCE.md` | 실제 프로젝트 소개·도메인·실행 절차 |

ADR 예상 항목은 `0001-use-opensearch.md`, `0002-select-metadata-db.md` 형식을 따르되 실제 결정과 순번은 원본 분석 후 확정합니다.

## Planned Container Boundary

```text
.devcontainer/                 # Claude/Codex 오케스트레이션 전용
app/
└── <deployment-unit>/         # 기능 폴더 하나가 컨테이너 배포 단위
    ├── .devcontainer/         # 코드 수정 단위에만 사용
    ├── dev/
    │   ├── Dockerfile
    │   └── .env.example
    ├── stg/
    │   ├── Dockerfile
    │   └── .env.example
    └── prod/
        ├── Dockerfile
        └── .env.example
```

정확한 기능 폴더명은 요구사항과 ADR 확정 후 정합니다. Spring, Python, 데이터베이스, 검색 엔진, 모델 실행 단위는 서로 다른 배포 단위로 분리합니다.

## Done

| # | Task | Date | Notes |
|---|---|---|---|
| Q0 | 후속 계획 WIP 등록 | 2026-06-28 | 선행 WIP 종료 전에는 구현하지 않음 |
| B0 | 선행 폴더 관리 WIP 종료 | 2026-06-28 | P5 종료 감사 후 디렉터리 삭제 |
| B1 | Markdown 원본 2개 업로드 | 2026-06-28 | charter·resume-evidence를 intake에 격리 |
| P0 | 원본 격리·분석 및 문서 배치표 확정 | 2026-06-28 | source ID 부여, 저장소 성격 확정, 복사 금지 |

## Remaining

| # | Task | Blocked By | Priority | Notes |
|---|---|---|---|---|
| P1 | 요구사항과 파생 분석 문서 작성 | P0 | HIGH | 현재 메타데이터·출처 규칙 적용 |
| P2 | M0·M2·M4 평가 계약 작성 | P1 | HIGH | 평가 데이터와 측정 조건 포함 |
| P3 | 아키텍처 및 모듈 경계 ADR 작성 | P1 | HIGH | 선택 근거와 대안 기록 |
| P4 | 루트 프로젝트 문서 재작성 | P2, P3 | HIGH | README·PROJECT·REFERENCE |
| P5 | 기능별 컨테이너 배포 단위 확정 | P3 | HIGH | 정확한 app 하위 폴더 결정 |
| P6 | dev·stg·prod Docker·환경변수 구성 | P5 | HIGH | 비밀정보는 추적하지 않음 |
| P7 | VS Code 디버깅·배포 분리와 runtime 규칙 적용 | P6 | HIGH | non-root·UID/GID·timezone·UTF-8 |
| P8 | 링크·검증·계획 gap 최종 점검 | P4, P7 | HIGH | WIP 종료 조건 확인 |

## Dependencies

```text
B0 + B1 → P0 → P1 ─┬→ P2 ─┐
                    └→ P3 ─┼→ P4 ─┐
                           └→ P5 → P6 → P7 ─┼→ P8
```

## Decisions

| Date | Decision | Rationale | Alternatives Considered |
|---|---|---|---|
| 2026-06-28 | 이 워크스페이스를 분리된 사이드 프로젝트 본체로 확정 | 차터의 "별도 저장소"는 이력서 프로젝트에서 사이드 프로젝트를 분리한다는 뜻이며 이 저장소가 그 분리본 | 별도 저장소 신규 생성 |
| 2026-06-28 | 현재 WIP 종료 후 이 WIP를 시작 | 폴더 규칙이 확정돼야 후속 문서 위치가 안정됨 | 두 WIP 병행 |
| 2026-06-28 | 업로드 원본은 `intake/`에서 미추적 | 사용자 제공 원본은 default-deny 원칙 적용 | 원본 Markdown 직접 커밋 |
| 2026-06-28 | 평가 계약과 ADR은 `deliverables/`에 배치 | 현재 역할 기반 폴더 체계를 유지 | 사용자 예시 경로를 그대로 생성 |
| 2026-06-28 | root 오케스트레이션 컨테이너에서 앱을 실행하지 않음 | Claude/Codex 조율 계층과 제품 runtime을 분리 | 단일 컨테이너에 통합 |
| 2026-06-28 | `app/<deployment-unit>/`를 배포 경계로 사용 | 기능 소유권과 컨테이너 단위를 일치 | 언어별 단일 거대 폴더 |
| 2026-06-28 | 개발 컨테이너와 배포 이미지를 분리 | 로컬 디버깅 도구가 운영 이미지에 포함되는 것을 방지 | 동일 Dockerfile 공용 |
| 2026-06-28 | 실제 서비스명과 기술 버전은 문서 분석 후 확정 | 입력과 ADR 없이 구조를 선결정하지 않음 | Spring·DB 구조 즉시 생성 |

## Plan–Implementation Gap

| ID | Planned | Actual | Gap | Resolution | Status |
|---|---|---|---|---|---|
| N0 | 선행 WIP 종료 후 시작 | 선행 WIP 종료됨 | 없음 | 차단 해제 | closed |
| N1 | 원본 Markdown 2개 분석 | 2개 업로드·격리, source ID 부여 | 없음 | P0에서 분석 | closed |
| N2 | 평가 계약과 ADR | 미구현 | 산출물 없음 | P2·P3 | open |
| N3 | 프로젝트 맞춤 루트 문서 | 현재 거버넌스 템플릿 내용 | 프로젝트 내용 미반영 | P4 | open |
| N4 | 기능별 배포 단위 | `app/README.md`만 존재 | 기능 경계 미확정 | P5 | open |
| N5 | 환경별 컨테이너 구성 | 미구현 | dev·stg·prod 없음 | P6 | open |
| N6 | 디버깅·배포·권한 규칙 | 미구현 | 실행 검증 없음 | P7 | open |

### 페이즈별 구현 gap (기록만, P8 이후 일괄 해소)

| 페이즈 | 계획 | 실제 구현 | gap | 상태 |
|---|---|---|---|---|
| P0 | 원본 격리·분석, 문서 배치표 확정 | derived 분석 문서에 배치표 통합, 저장소 성격 확정 절 추가 | 배치표를 독립 산출물로 분리하지 않음 | open |

## Files Modified

| Repo | File | Change Type |
|---|---|---|
| `/workspaces` | `wip/task-20260628-side-project-expansion/README.md` | created |
| `/workspaces` | `wip/task-20260628-side-project-expansion/anchor.md` | created |
| `/workspaces` | `docs/derived/side-project-source-analysis.md` | created (P0) |

## Unpushed Commits

| Repo | Branch | Commit | Description |
|---|---|---|---|
| — | — | — | 없음 |
