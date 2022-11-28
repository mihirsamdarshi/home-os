FROM alpine:latest as compiler

RUN apk update && apk add --no-cache wget

WORKDIR /data

RUN wget -O airupnp https://github.com/philippe44/AirConnect/blob/master/bin/airupnp-linux-aarch64-static

FROM alpine:latest as runner

COPY --from=compiler /data/airupnp /usr/bin/airupnp
RUN chmod +x /usr/bin/airupnp

ENTRYPOINT

