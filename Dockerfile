FROM rust:1.74-slim AS builder

# Cache cargo dependencies
WORKDIR /usr/src/
COPY Cargo.lock Cargo.toml ./
RUN cargo build --release --target=aarch64-unknown-linux-musl

# Create a separate image for the final build
FROM alpine:latest AS runner

# Copy only the compiled binary
COPY --from=builder /usr/src/target/release/todolist-cli /app/todolist-cli

# Define the entrypoint for the container
WORKDIR /app
ENTRYPOINT ["/app/todolist-cli"]
