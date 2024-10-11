FROM rust:1.74-slim AS builder

# Cache cargo dependencies
WORKDIR /usr/src/

COPY Cargo.lock Cargo.toml ./
COPY migration/Cargo.toml ./migration/

RUN cargo build --release

# Create a separate image for the final build
FROM alpine:latest AS runner

# Copy only the compiled binary
COPY --from=builder /usr/src/target/release/todolist-cli /app/todolist-cli

# Define the entrypoint for the container
WORKDIR /app
ENTRYPOINT ["/app/todolist-cli start"]
