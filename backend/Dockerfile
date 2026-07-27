# Dockerfile for ETM Backend
# Uses Flutter SDK (needed because etm_core depends on Flutter)

# Stage 1: Build
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy all source
COPY . .

# Get backend dependencies (Flutter SDK provides Dart + Flutter)
RUN cd backend && flutter pub get --no-example

# Build the server binary
RUN cd backend && dart compile exe bin/server.dart -o bin/server

# Stage 2: Runtime (minimal image)
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=build /app/backend/bin/server/bin/server /app/server

EXPOSE 8080
CMD ["/app/server"]
