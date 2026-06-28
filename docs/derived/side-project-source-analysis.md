---
document-id: derived-side-project-source-analysis
role: derived
stage: "01"
status: drafted
owner: yhn032
updated: 2026-06-28
source: intake-side-project-charter
sensitivity: public
---

# 사이드 프로젝트 원본 분석과 문서 배치표

## 분석 범위

`docs/intake/`에 격리된 사용자 제공 원본 2건에서 사이드 프로젝트 관련 내용을
추출했습니다. 원본은 Git에서 추적하지 않으며, 이 문서는 공개 가능한 분석 결과와
배치 계획만 기록합니다. 원본 문장을 통째로 인용하지 않고 목적별로 재작성합니다.

| 원본 파일 | source ID | 성격 |
|---|---|---|
| `SIDE_PROJECT_CHARTER.md` | `intake-side-project-charter` | Production RAG Retrieval Platform 프로젝트 차터 |
| `SIDE_PROJECT_RESUME_EVIDENCE.md` | `intake-side-project-resume-evidence` | 이력서 고도화·포지셔닝 방향 |

## 저장소 성격 확정

이 워크스페이스가 차터에서 말하는 "별도 저장소"이며, 이력서 고도화 프로젝트에서
분리된 사이드 프로젝트 본체입니다. 코드와 컨테이너 배포 단위를 모두 이 저장소에서
구현하고, claude·codex 오케스트레이션 계층이 `app/` 하위 배포 단위들을 조율합니다.
추가 저장소는 만들지 않습니다.

## 추출 대상 요약

### 차터에서 추출

- 플래그십: Production RAG Retrieval Platform (재직 데이터·코드를 쓰지 않고 공개
  데이터로 신규 구현)
- 모듈 경계 6종: `api-service`, `retrieval-service`, `index-worker`,
  `search-store`, `metadata-store`, `cache`
- 마일스톤 M0~M5와 각 완료 기준
- 이력서 반영 게이트 6개 조건

### 이력서 방향 문서에서 추출 (제한적)

- 포지셔닝: 검색(IR) 경험을 RAG로 확장한 백엔드
- 스킬 전략 힌트(예: 실무 스킬에서 PostgreSQL 제외, MariaDB 근거 확인) →
  metadata DB 선택 ADR의 입력으로만 사용
- 실제 경력 정량 지표와 역할 경계는 민감 자료이므로 추적 문서로 옮기지 않고
  원본에만 둠

## 문서 배치표

| 추출 내용 | 대상 경로 | 페이즈 |
|---|---|---|
| 요구사항(기능·비기능) | `docs/derived/side-project-requirements.md` | P1 |
| 평가 계약(M0·M2·M4) | `docs/deliverables/evaluation-contract.md` | P2 |
| 아키텍처·모듈·기술 선택 ADR | `docs/deliverables/adr/` | P3 |
| 프로젝트 소개·도메인·실행 절차 | 루트 `README.md`·`PROJECT.md`·`REFERENCE.md` | P4 |
| 기능별 컨테이너 배포 단위 | `app/<deployment-unit>/` | P5~P7 |

배치표의 대상 경로는 후속 페이즈에서 실제 생성되며, 생성 시 각 역할 README에서
링크로 연결합니다.

## 민감 자료 처리

`SIDE_PROJECT_RESUME_EVIDENCE.md`에는 실제 재직 프로젝트의 정량 지표와 역할 경계가
포함됩니다. 이 수치는 공개 산출물로 옮기지 않으며, 사이드 프로젝트의 포지셔닝과
이력서 반영 게이트 설계에만 근거로 활용합니다.
