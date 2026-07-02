# 애플리케이션 (app)

기능별 컨테이너 배포 단위를 배치합니다. `app/<deployment-unit>/` 하나가 하나의
컨테이너 배포 단위이며, 경계와 근거는
[ADR-0001](../docs/deliverables/adr/0001-architecture-and-module-boundary.md)을 따릅니다.

루트 컨테이너는 claude·codex 오케스트레이션 전용이며 제품 런타임을 직접 실행하지
않습니다. 각 배포 단위는 개별 컨테이너로 기동합니다.

## 배포 단위

| 단위 | 기술 | 성격 |
|---|---|---|
| [web-ui](web-ui/README.md) | 웹 프론트엔드(기술 추후) | 코드 수정 단위 |
| [api-service](api-service/README.md) | Spring Boot | 코드 수정 단위 |
| [retrieval-service](retrieval-service/README.md) | FastAPI | 코드 수정 단위 |
| [model-serving](model-serving/README.md) | FastAPI | 코드 수정 단위 |
| [index-worker](index-worker/README.md) | Java | 코드 수정 단위 |
| [search-store](search-store/README.md) | OpenSearch | 인프라 컨테이너 |
| [metadata-store](metadata-store/README.md) | MariaDB | 인프라 컨테이너 |
| [cache](cache/README.md) | Redis | 인프라 컨테이너 |
| [message-queue](message-queue/README.md) | RabbitMQ | 인프라 컨테이너 |

각 단위의 `dev`·`stg`·`prod` 컨테이너 구성과 환경변수는 각 단위의 `dev/`·`stg/`·
`prod/` 하위 디렉터리에 있습니다. 코드 수정 단위의 실행 명령(CMD)과 실제 앱 코드는
M1 이후 추가합니다.
