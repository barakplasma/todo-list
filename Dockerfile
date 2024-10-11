FROM rust:1.74-slim as builder

WORKDIR /usr/src/

COPY . .

RUN cargo build --release

ENTRYPOINT ["/usr/src/target/release/todolist-cli"]
