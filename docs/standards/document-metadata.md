---
document-id: document-metadata-policy
role: standard
stage: "00"
status: drafted
owner: yhn032
updated: 2026-06-28
source: internal
sensitivity: public
---

# 문서 메타데이터 규격

## 적용 범위

다음 관리 대상 Markdown 문서는 YAML frontmatter를 가져야 합니다.

- 최상위 `WORKFLOW.md`
- `docs/standards/`의 `MANIFEST.md`, 단계 문서, 정책 문서
- `docs/deliverables/`, `docs/derived/`, `docs/research/`에 추가되는 산출물

폴더 안내용 `README.md`, WIP 문서, Git에서 제외되는 원본·내부 자료는 적용 대상이 아닙니다.

## 필수 항목

| 항목 | 형식 | 규칙 |
|---|---|---|
| `document-id` | 소문자 영문·숫자·하이픈 | 저장소 안에서 고유하고 생성 후 변경하지 않음 |
| `role` | `standard`, `deliverable`, `derived`, `research` | 문서가 배치된 역할과 일치 |
| `stage` | `"00"`~`"09"` | 관련 생애주기 단계 |
| `status` | `template`, `drafted`, `approved`, `excluded` | `MANIFEST.md`와 일치 |
| `owner` | Git 사용자 ID | 현재 책임자 |
| `updated` | `YYYY-MM-DD` | 내용 또는 상태를 마지막으로 변경한 날짜 |
| `source` | `internal`, 상대 경로, source ID 또는 URL | 문서의 근거 |
| `sensitivity` | `public`, `internal`, `confidential` | Git 추적 가능 여부 |

## 조건부 항목

- `role: derived`는 원본 상대 경로 또는 추적하지 않는 원본의 source ID를 `source`에 기록합니다.
- `role: research`는 공개 URL을 `source`에 기록합니다.
- `status: excluded`는 `exclusion-reason`을 추가합니다.
- Git으로 추적하는 관리 대상 문서는 `sensitivity: public`이어야 합니다.

## 예시

```yaml
---
document-id: standard-00-common
role: standard
stage: "00"
status: drafted
owner: yhn032
updated: 2026-06-28
source: internal
sensitivity: public
---
```

## 상태 일치 규칙

단계 문서의 `status`와 `MANIFEST.md`의 상태는 항상 같아야 합니다. 상태만 변경하고 본문이나 근거를 갱신하지 않는 변경은 허용하지 않습니다.
