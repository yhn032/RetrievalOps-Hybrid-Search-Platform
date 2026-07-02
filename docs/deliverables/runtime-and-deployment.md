---
document-id: deliverable-runtime-and-deployment
role: deliverable
stage: "08"
status: drafted
owner: yhn032
updated: 2026-07-02
source: intake-side-project-charter
sensitivity: public
---

# 런타임 규칙과 배포 분리

배포 단위 컨테이너의 런타임 규칙과 개발·배포 이미지 분리 원칙을 정의한다. 배포
단위 경계는 [ADR-0001](adr/0001-architecture-and-module-boundary.md)을 따른다.

## 런타임 규칙

모든 배포 단위 컨테이너는 다음을 지킨다. `scripts/meta/runtime-rules-check.sh`로
검사한다.

| 규칙 | 적용 |
|---|---|
| 타임존 | 모든 이미지 `TZ=UTC` |
| 인코딩 | `LANG=C.UTF-8`, `LC_ALL=C.UTF-8` |
| 비루트 실행 | 코드 단위는 `USER app`, 인프라 단위는 명시 `USER` 또는 공식 entrypoint의 권한 드롭(주석으로 명기 — metadata-store) |
| 호스트 권한 | 코드 단위 Dockerfile은 `HOST_UID`/`HOST_GID` 인자로 호스트와 동일 권한 유지 |

인프라 단위(search-store·metadata-store·cache·message-queue)는 소스를 바인드
마운트하지 않고 named volume를 사용하므로 호스트 UID/GID 정합이 필요하지 않다.
따라서 호스트 권한 정합은 코드 수정 단위 5종에만 적용하며, 이는 anchor의 "모든
컨테이너" 문구를 코드 단위로 좁힌 의도적 결정이다. 인프라 단위는 공식 이미지의
고정 비루트 사용자로 기동하며, metadata-store(MariaDB)만 공식 entrypoint의 표준
권한 드롭(root 시작 → mysql 유저)을 수용하고 Dockerfile 주석으로 명기한다 —
검사(`runtime-rules-check.sh`)는 인프라 단위에서 명시 `USER` 또는 권한 드롭
주석을 요구한다.

## 개발·배포 이미지 분리

- 개발: 코드 수정 단위 5종(web-ui·api-service·retrieval-service·model-serving·
  index-worker)은 `dev/` 이미지와 `.devcontainer/`로 VS Code에 연결해 로컬에서
  실행·디버깅한다. 소스는 바인드 마운트하고 비루트 사용자가 호스트 UID/GID로
  편집한다.
- 배포: 실제 앱은 `stg/`·`prod/` 이미지로 빌드해 컨테이너로 배포한다. 배포
  이미지는 디버그 도구를 포함하지 않으며 개발 컨테이너와 분리된다.
- 인프라 단위 4종(search-store·metadata-store·cache·message-queue)은 공식 이미지
  기반으로 모든 환경에서 컨테이너로만 기동한다.

배포 단위는 총 9개다([ADR-0001](adr/0001-architecture-and-module-boundary.md)).

## VS Code 로컬 디버깅

| 코드 단위 | devcontainer | 비고 |
|---|---|---|
| web-ui | `app/web-ui/.devcontainer/` | 프론트엔드 기술 확정 전 placeholder, 포트 3000 |
| api-service | `app/api-service/.devcontainer/` | Spring Boot, 디버그 포트 5005 |
| retrieval-service | `app/retrieval-service/.devcontainer/` | FastAPI reload |
| model-serving | `app/model-serving/.devcontainer/` | FastAPI reload, 포트 8001 |
| index-worker | `app/index-worker/.devcontainer/` | 워커 프로세스(Java) |

각 devcontainer는 해당 단위의 `dev/Dockerfile`을 빌드하고 `HOST_UID`/`HOST_GID`로
비루트 사용자를 호스트와 맞춘다. 실제 앱 코드는 M1 이후 추가한다.
