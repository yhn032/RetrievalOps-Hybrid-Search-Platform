# Task: 사이드 프로젝트 문서 이식 및 컨테이너 분리

## Status: in-progress — 표준 00·01·02 승인 완료. 다음 재개: 03 UI 검토부터 04~09 순차

## Completion Criteria

- [x] 선행 폴더 관리 WIP가 종료되어 있다.
- [x] 사용자가 제공하는 Markdown 원본 2개가 `docs/intake/`에 격리되어 있다.
- [x] 원본을 복사하지 않고 요구사항·아키텍처·평가 계약으로 분리해 작성했다.
- [x] M0·M2·M4 평가 조건과 데이터셋, Recall@k, MRR, nDCG, p95, 반복 횟수가 문서화되어 있다.
- [x] 아키텍처와 모듈 경계, 저장소·캐시·메시지 큐·배포 선택이 ADR로 기록되어 있다.
- [x] 루트 `README.md`, `PROJECT.md`, `REFERENCE.md`가 실제 사이드 프로젝트에 맞게 재작성되어 있다.
- [x] 모든 추적 문서가 `WORKFLOW.md`에서 도달 가능하고 깨진 링크가 없다.
- [ ] `app/` 하위 기능 폴더와 컨테이너 배포 단위가 일치한다. (모델 실행 단위 미분리 — gap)
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
| P1 | 요구사항과 파생 분석 문서 작성 | 2026-06-28 | FR 8개·NFR 9개, 기술 선택은 ADR로 위임 |
| P2 | M0·M2·M4 평가 계약 작성 | 2026-06-28 | 데이터셋·Recall@k·MRR·nDCG·p95·반복 횟수·측정 조건, 완성도 검토 통과 |
| P3 | 아키텍처 및 모듈 경계 ADR 작성 | 2026-06-28 | ADR 6종, 적대적 검토 후 원본 정합성 2건 보정 |
| P4 | 루트 프로젝트 문서 재작성 | 2026-06-28 | README·PROJECT 전면 재작성, REFERENCE 재구성+app 절, 검증 126 PASS |
| P5 | 기능별 컨테이너 배포 단위 확정 | 2026-06-28 | app/ 6개 단위(코드 3·인프라 3) README로 확정 |
| P6 | dev·stg·prod Docker·환경변수 구성 | 2026-06-28 | 36파일(Dockerfile 18·.env.example 18), 비밀 placeholder·.env 미추적 |
| P7 | VS Code 디버깅·배포 분리·runtime 규칙 | 2026-06-28 | 코드 단위 3종 devcontainer, 런타임/배포 문서, 규칙 검사 18 PASS |
| P8 | 링크·검증·계획 gap 최종 점검 | 2026-06-28 | 검증 green(126·gate·link·runtime), 적대적 감사로 미기록 gap 5건 적발·기록 |
| GR1 | 즉시 가능 gap 1차 해소 | 2026-06-29 | P0·G-P8-2·G-P8-4·G-P8-5 해소, runtime 검사 게이트 연동(P7 일부) |
| GR2 | 설계·WBS·협업 워크플로 수립 | 2026-06-29 | system-design·wbs·collaboration-workflow 신설(8단위 반영), 구현·테스트는 사용자 |
| GR3 | 생애주기 표준 00~09 완성 | 2026-06-29 | 단계 표준을 프로젝트 내용으로 작성(template→drafted), 03 UI excluded, MANIFEST 동기화 |
| GR4 | 표준 00·01·02 승인 + 아키텍처 정합화 | 2026-06-29 | 00·01·02 approved+기준본 생성, web-ui 단위·ADR-0008(검색 HA) 추가, ADR 8→9단위 정합, 03 UI 포함(excluded→drafted) |

## Remaining

| # | Task | Blocked By | Priority | Notes |
|---|---|---|---|---|
| R0 | 표준 검토·승인 이어가기 | GR4 | HIGH | ★ 재개 지점: **03 UI(drafted)** 검토·승인부터 04~09 순차. 선행 단계 approved 후 다음 진입 |
| R1 | WBS를 간트차트로 전환 | — | MED | `docs/deliverables/wbs.md`를 markdown 표가 아닌 간트차트(예: Mermaid `gantt`)로 재작성 |
| GR | 잔여 gap 해소 + app 스캐폴드 구현 | P8 | — | 결정 필요 잔여 없음(반영 완료)·M1 의존(P2·P3·P7 빌드), web-ui·model-serving·message-queue 스캐폴드와 Java 워커 전환은 구현 대기 |

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
| 2026-06-29 | 문서 배치표는 분리하지 않고 원본 분석 문서에 둔다 | 배치표는 분석 맥락이라 derived 문서가 적절하고 분리 실익이 없음 | 별도 deliverable로 분리 |
| 2026-06-29 | 호스트 UID/GID 정합은 코드 수정 단위에만 적용 | 인프라는 바인드 마운트 없이 named volume를 써서 정합이 불필요 | 모든 컨테이너에 강제 |
| 2026-06-29 | 모델 서빙(임베딩·Reranker)을 별도 컨테이너로 분리 | anchor의 "모델도 별도 컨테이너" 충실, vLLM/GPU 모델 서빙을 포트폴리오로 노출 | retrieval-service in-process 유지 |
| 2026-06-29 | MariaDB는 공식 entrypoint의 표준 권한 드롭을 수용하고 검사를 보강 | MariaDB 표준 패턴 존중, initdb chown 깨짐 회피 | USER mysql 강제 + 사전 소유권 |
| 2026-06-29 | 메시지 큐 RabbitMQ 채택, 색인 워커를 Java로 전환 | 이력서의 RabbitMQ·Spring 비동기 역량 노출, 모델 분리로 워커의 임베딩 의존 감소 | DB 작업 테이블·Python 워커 유지 |
| 2026-06-29 | 검색 UI·색인 대시보드(web-ui) 추가, 03 UI 포함 | 클라이언트 검색 호출과 색인 상태 관측 화면이 필요 | UI 없이 API 소비자만 |
| 2026-06-29 | 검색 경로 가용성은 큐가 아니라 복제·캐시·서킷브레이커로 확보(ADR-0008) | 동기·멱등 검색에 큐 버퍼링은 지연 증가·유실 방지 무의미 | 검색 요청을 메시지 큐로 버퍼링 |

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
| P0 | 원본 격리·분석, 문서 배치표 확정 | derived 분석 문서에 배치표 통합, 저장소 성격 확정 절 추가 | 배치표를 독립 산출물로 분리하지 않음 | 해소(분리 불요 결정 기록) |
| P1 | 요구사항·파생 분석 문서 작성 | FR·NFR 표 작성, 정량 목표값은 평가계약으로 위임 | 요구사항에 목표 수치(목표 Recall@k·p95 임계) 미포함 | open |
| P2 | M0·M2·M4 평가 계약 작성 | 필수 지표·측정 조건 전부 포함, 완성도 검토 통과 | 데이터셋 최종 선정·목표 수치·질의셋 열거를 M0 실행·ADR로 위임 | open |
| P3 | 아키텍처·모듈·기술 ADR 6종 | ADR 6종 작성·적대적 검토, 원본 정합성 오류 2건 보정 | MQ·색인 워커 언어 결정 잠정(포트폴리오 강조점 따라 재검토), Java 비동기 시연 미반영, 데이터셋 선정 ADR은 M0 실행 시로 위임, MariaDB 실무 근거 미확정 | 결정: RabbitMQ 채택·워커 Java (구현 대기) |
| P4 | 루트 README·PROJECT·REFERENCE 재작성 | README·PROJECT 전면 재작성, REFERENCE는 운영 명령 보존 위해 재구성+app 절 | REFERENCE에 폴리에이전트 인프라 설명 잔존, CLAUDE/AGENTS는 템플릿 거버넌스 서술 유지(저장소 이중 정체성) | open |
| P5 | 기능별 컨테이너 배포 단위 확정 | app/ 6개 단위 디렉터리+README 생성, 책임·기술·성격 명시 | 실제 Dockerfile·환경변수·실행 미생성(P6~P7로 분리) | open |
| P6 | dev·stg·prod Docker·환경변수 | 36파일 생성, non-root·TZ·UTF-8·HOST_UID/GID 규약 적용 | 앱 코드가 M1 이후라 코드 유닛 빌드/COPY/CMD가 TODO(M1) 자리표시자, infra config 파일도 미생성, 런타임 규칙을 P7 대신 P6 Dockerfile에 선반영 | open |
| P7 | VS Code 디버깅·배포 분리·runtime 규칙 | devcontainer 3종·배포 분리 문서·runtime-rules-check.sh(18 PASS) | 검사 스크립트 게이트 연동은 해소; devcontainer/dev 이미지 실제 빌드·기동 미검증(앱 코드 M1 이후)과 HOST_UID/GID 1000 고정은 잔여 | 일부 해소 |
| P8 | 링크·검증·gap 최종 점검 | 검증 green·하드에러 0, 5-lens 적대적 감사 + evaluator 외부 교차검증 | 미기록 gap 5건 적발(아래 'P8 점검 발견 gap') | open |

### P8 점검에서 발견한 미기록 gap (추후 해소)

P8 최종 감사(5-lens + evaluator)가 적발한, 기존 페이즈 기록에 빠져 있던 gap이다.
하드 에러는 아니며(검증 green) 사용자 지시에 따라 기록만 한다.

| # | gap | 심각도 | 관련 | 상태 |
|---|---|---|---|---|
| G-P8-1 | 모델 실행 별도 컨테이너 부재 — anchor와 WIP 계획은 "모델도 별도 컨테이너 기동"을 요구하나 임베딩·Reranker가 retrieval-service에 in-process로 접힘. ADR·gap 기록 없음 | 높음 | P3·P5 | 결정: 분리 (구현 대기) |
| G-P8-2 | host UID/GID 정합이 "모든 컨테이너"에서 코드 단위로 축소(인프라 3종 미적용). runtime 문서엔 설계로 기술되나 anchor 문구 이탈은 미기록 | 중간 | P6·P7 | 해소(결정 명문화: runtime 문서·Decisions) |
| G-P8-3 | metadata-store(MariaDB) 3개 Dockerfile에 명시 USER 없음(entrypoint가 root로 시작 후 mysql로 drop). runtime-rules-check가 인프라 USER를 미검사하는 사각 포함 | 중간 | P6·P7 | 결정: 표준 drop 수용+검사 보강 (구현 대기) |
| G-P8-4 | intake 문장 일부 근접 인용(평가계약 측정조건 bullet, 모듈 책임 셀, 파이프라인 문자열) — 단어 단위 추출이나 "복사 금지" 관점에서 미기록 | 낮음 | P2·P3 | 해소(재서술) |
| G-P8-5 | REFERENCE.md 푸터 "Last updated: 2026-06-25"가 2026-06-28 재작성과 불일치(표기 오류) | 낮음 | P4 | 해소(날짜 갱신) |

## Files Modified

| Repo | File | Change Type |
|---|---|---|
| `/workspaces` | `wip/task-20260628-side-project-expansion/README.md` | created |
| `/workspaces` | `wip/task-20260628-side-project-expansion/anchor.md` | created |
| `/workspaces` | `docs/derived/side-project-source-analysis.md` | created (P0) |
| `/workspaces` | `docs/derived/side-project-requirements.md` | created (P1) |
| `/workspaces` | `docs/deliverables/evaluation-contract.md` | created (P2) |
| `/workspaces` | `docs/deliverables/README.md` | modified (P2·P3 링크) |
| `/workspaces` | `docs/deliverables/adr/` | created (P3, ADR 6종+인덱스) |
| `/workspaces` | `README.md` | rewritten (P4) |
| `/workspaces` | `PROJECT.md` | rewritten (P4) |
| `/workspaces` | `REFERENCE.md` | reframed+app 절 (P4) |
| `/workspaces` | `app/README.md` 및 `app/<unit>/README.md` 6종 | created (P5) |
| `/workspaces` | `app/<unit>/{dev,stg,prod}/Dockerfile`·`.env.example` 36종 | created (P6) |
| `/workspaces` | `app/<code-unit>/.devcontainer/devcontainer.json` 3종 | created (P7) |
| `/workspaces` | `docs/deliverables/runtime-and-deployment.md` | created (P7) |
| `/workspaces` | `scripts/meta/runtime-rules-check.sh` | created (P7) |
| `/workspaces` | `scripts/meta/completion-checker.sh` | modified (GR1: runtime 검사 게이트 연동) |
| `/workspaces` | `docs/deliverables/evaluation-contract.md`, `adr/0001-*.md`, `runtime-and-deployment.md`, `README.md`, `REFERENCE.md` | modified (GR1: gap 해소) |

## Unpushed Commits

| Repo | Branch | Commit | Description |
|---|---|---|---|
| — | — | — | 없음 |
