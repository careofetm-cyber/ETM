# Build stage
FROM dart:stable AS build

WORKDIR /app

# Copy dependency files
COPY pubspec.* ./
RUN dart pub get

# Copy source code
COPY . .

# Build the server
RUN dart compile exe bin/server.dart -o bin/server

# Runtime stage
FROM scratch

# Copy built binary
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/server

# Expose port
EXPOSE 8080

# Run the server
CMD ["/app/bin/server"]
