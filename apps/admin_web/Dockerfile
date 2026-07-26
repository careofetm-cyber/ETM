# Build stage
FROM flutter/flutter AS build

WORKDIR /app

# Copy dependency files
COPY pubspec.* ./
RUN flutter pub get

# Copy source code
COPY . .

# Build web app
RUN flutter build web --release --dart-define=ENV=production

# Runtime stage
FROM nginx:alpine

# Copy built files
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
