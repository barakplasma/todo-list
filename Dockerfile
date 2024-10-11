FROM rust:1.74 as planner
RUN cargo install cargo-chef

WORKDIR /app
# Copy the whole project
COPY . .
# Prepare a build plan ("recipe")
RUN cargo chef prepare --recipe-path recipe.json

FROM rust:1.74 AS builder
workdir /usr/src/
RUN cargo install cargo-chef

# Copy the build plan from the previous Docker stage
COPY --from=planner /app/recipe.json recipe.json

# Build dependencies - this layer is cached as long as `recipe.json`
# doesn't change.
RUN cargo chef cook --recipe-path recipe.json

# Build the whole project
COPY . .
RUN cargo build --release

FROM gcr.io/distroless/cc-debian12
WORKDIR /app

# Copy only the compiled binary
COPY --from=builder /usr/src/target/release/todolist-cli todolist-cli

# Define the entrypoint for the container
ENTRYPOINT ["/app/todolist-cli", "start"]
