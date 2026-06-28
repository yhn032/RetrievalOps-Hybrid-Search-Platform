# app/cache (prod) — Redis 응답 캐시 / 최소 런타임, 보안 활성, 리소스 제한
# 공식 이미지 위의 얇은 레이어. 비밀번호 필수, allkeys-lru, 디버그 도구 없음.
# redis:7 — exact patch version은 M1에서 확정.
FROM redis:7

# 로케일/타임존 통일
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# TODO(M1): redis.conf 작성 후 활성화
#   COPY redis.conf /usr/local/etc/redis/redis.conf
#   prod 필수값: requirepass, maxmemory, maxmemory-policy allkeys-lru.
#   값은 .env.example 참고. 아직 conf 파일 없음.

EXPOSE 6379

# 공식 이미지 내장 non-root redis 사용자로 실행
USER redis

# prod: M1에서 conf 활성화 시 redis-server /usr/local/etc/redis/redis.conf 로 전환
CMD ["redis-server"]
