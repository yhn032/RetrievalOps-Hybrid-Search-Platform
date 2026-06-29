# 아키텍처 결정 기록 (ADR)

RAG Retrieval Platform의 아키텍처·모듈·기술 선택 결정을 기록합니다. 각 문서는
맥락, 결정, 대안, 결과를 담습니다. 결정 근거는
[요구사항](../../derived/side-project-requirements.md)과
[평가 계약](../evaluation-contract.md)을 따릅니다.

## 목록

- [0001 아키텍처와 모듈 경계](0001-architecture-and-module-boundary.md)
- [0002 검색 저장소로 OpenSearch 사용](0002-use-opensearch.md)
- [0003 메타데이터 DB 선택](0003-select-metadata-db.md)
- [0004 메시지 큐 도입 여부](0004-message-queue.md)
- [0005 Kubernetes 적용 시점](0005-kubernetes-deferral.md)
- [0006 색인 워커 구현 언어](0006-index-worker-language.md)
- [0007 모델 서빙 분리](0007-model-serving.md)
