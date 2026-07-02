# app/message-queue (dev) — RabbitMQ 색인 작업 큐 / 단일 노드, 디버그 친화
# 공식 이미지 위의 얇은 레이어. management UI 포함(관측 편의), 기본 계정은 placeholder.
# rabbitmq:4-management — exact patch version은 M1에서 확정.
FROM rabbitmq:4-management

# 로케일/타임존 통일
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# TODO(M1): rabbitmq.conf 작성 후 활성화
#   COPY rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
#   큐·교환기·DLQ 토폴로지는 M3에서 확정(ADR-0004). dev 설정값은 .env.example 참고.

# AMQP + management UI (dev 전용 관측)
EXPOSE 5672 15672

# 공식 이미지 내장 non-root rabbitmq 사용자로 실행
USER rabbitmq

# dev: 기본 설정으로 단일 노드 구동 (management UI 활성)
CMD ["rabbitmq-server"]
