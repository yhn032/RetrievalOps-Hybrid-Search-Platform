# api-service (dev) — Spring Boot REST API
# Base: eclipse-temurin 21-jdk (디버깅 도구 포함). 정확한 patch 버전은 M1에서 확정.
FROM eclipse-temurin:21-jdk

# 로케일/타임존 고정
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# 호스트 UID/GID와 일치 → VS Code bind-mount 편집 시 소유권 충돌 방지
ARG HOST_UID=1000
ARG HOST_GID=1000
RUN groupadd -g ${HOST_GID} app \
 && useradd -u ${HOST_UID} -g ${HOST_GID} -m -s /bin/bash app

WORKDIR /app

# TODO(M1): copy built artifact / install app deps (코드는 M1 이후 작성됨)

ENV SERVER_PORT=8080
ENV SPRING_PROFILES_ACTIVE=dev

USER app

# 8080: REST API, 5005: JVM 원격 디버그(dev 전용)
EXPOSE 8080 5005

# dev: 원격 디버그 활성. 산출물 도착 후 아래 CMD 활성화.
# TODO(M1): CMD ["java","-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005","-jar","app.jar"]
