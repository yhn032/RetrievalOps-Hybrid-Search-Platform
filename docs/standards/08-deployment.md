---
document-id: standard-08-deployment
role: standard
stage: "08"
status: drafted
owner: yhn032
updated: 2026-06-29
source: internal
sensitivity: public
---

# 08 배포

## 목적

환경별 설정, 배포 절차, 검증과 복구 방법을 정의한다.

## 적용 기준

- 배포 단위별로 `dev`·`stg`·`prod`를 분리하고 개발 이미지와 배포 이미지를 구분한다
  ([런타임·배포](../deliverables/runtime-and-deployment.md)).
- 로컬 운영형은 Docker Compose로 구성하고, Kubernetes는 이후 선택 적용한다
  ([ADR-0005](../deliverables/adr/0005-kubernetes-deferral.md)).
- 비밀값 없이 배포 구성을 재현할 수 있어야 한다(`.env.example` + 시크릿 주입).
- 모든 이미지는 런타임 규칙(비루트·`TZ=UTC`·UTF-8)을 지킨다.

## 완료 기준

- 비밀정보 없이 배포 구성을 재현할 수 있다.
- 실패 시 이전 정상 상태로 복구할 수 있다.
- 배포 결과를 확인할 명령과 지표가 정의되어 있다.
