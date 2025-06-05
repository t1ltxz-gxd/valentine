ARG APP_NAME=valentine

FROM rust:slim-bullseye AS builder
ARG APP_NAME

WORKDIR /app
COPY . .

RUN apt-get update && apt-get install -y musl-tools && \
    rustup target add x86_64-unknown-linux-musl && \
    cargo build --release --target x86_64-unknown-linux-musl --bin ${APP_NAME}

FROM gcr.io/distroless/cc
ARG APP_NAME

COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/${APP_NAME} /usr/local/bin/app

ENTRYPOINT ["/usr/local/bin/app"]
