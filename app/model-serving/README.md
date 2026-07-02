# model-serving

임베딩·Reranker 모델 추론을 담당하는 FastAPI 배포 단위.

- 기술: Python · FastAPI
- 책임: 임베딩 추론(`POST /embed`), Reranker 점수 산출(`POST /rerank`)
- 성격: 코드 수정 단위 — VS Code 로컬 디버깅 지원
- 연동: retrieval-service·index-worker가 REST로 호출(인바운드), GPU/모델 런타임(아웃바운드)
- 근거: [ADR-0001](../../docs/deliverables/adr/0001-architecture-and-module-boundary.md),
  [ADR-0007](../../docs/deliverables/adr/0007-model-serving.md)

모델·런타임(GPU·vLLM 등) 선택은 M2에서 확정하며, 실제 앱 코드는 M1 이후 추가한다.
