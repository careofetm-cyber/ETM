# Dockerfile for ETM Backend (Dart Shelf API)
# Multi-stage build for smaller final image

# Stage 1: Build
FROM dart:3.5-sdk AS build

WORKDIR /app

# Copy dependency files first for better caching
COPY pubspec.yaml pubspec.lock* ./
COPY packages/core/pubspec.yaml packages/core/
COPY packages/networking/pubspec.yaml packages/networking/
COPY packages/maps/pubspec.yaml packages/maps/

# Copy backend pubspec
COPY backend/pubspec.yaml backend/

# Get dependencies
RUN cd backend && dart pub get

# Copy source code
COPY packages/ packages/
COPY backend/ backend/

# Build
RUN cd backend && dart compile exe bin/server.dart -o bin/server

# Stage 2: Runtime
FROM scratch

# Copy built binary and runtime dependencies
COPY --from=build /runtime/lib/ /lib/
COPY --from=build /app/backend/bin/server/bin/server /app/server

# Expose port
EXPOSE 8080

# Run
CMD ["/app/server"]
