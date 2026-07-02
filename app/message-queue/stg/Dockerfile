# app/message-queue (stg) — RabbitMQ 색인 작업 큐 / prod-like, staging 값
# 공식 이미지 위의 얇은 레이어. 비밀번호 필수, conf 기반 설정, management UI 없음.
# rabbitmq:4 — exact patch version은 M1에서 확정.
FROM rabbitmq:4

# 로케일/타임존 통일
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# TODO(M1): rabbitmq.conf 작성 후 활성화 (기본 계정/vhost/리소스 한계)
#   COPY rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
#   큐·교환기·DLQ 토폴로지는 M3에서 확정(ADR-0004). stg 설정값은 .env.example 참고.

EXPOSE 5672

# 공식 이미지 내장 non-root rabbitmq 사용자로 실행
USER rabbitmq

# stg: M1에서 conf 활성화 시 conf 기반 구동으로 전환
CMD ["rabbitmq-server"]
