ARG RUST_VERSION=1.92.0
FROM rust:${RUST_VERSION}-alpine3.23 AS builder

ARG ANKI_VERSION

RUN apk update && apk add --no-cache build-base protobuf && rm -rf /var/cache/apk/*

RUN cargo install --git https://github.com/ankitects/anki.git \
    --tag ${ANKI_VERSION} \
    --root /anki-server \
    --locked \
    anki-sync-server

FROM alpine:3.23

ENV PUID=1000
ENV PGID=1000

COPY --from=builder /anki-server/bin/anki-sync-server /usr/local/bin/anki-sync-server

RUN apk update && apk add --no-cache bash su-exec && rm -rf /var/cache/apk/*

EXPOSE 8080

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME /anki_data

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD anki-sync-server --healthcheck

ENTRYPOINT ["/entrypoint.sh"]
CMD ["anki-sync-server"]