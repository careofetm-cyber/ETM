# Employee Transport Management System (ETMS)

Enterprise-grade transport management platform built with Flutter and Dart Shelf.

## Architecture

```
├── apps/
│   ├── admin_web/          # Flutter Web Admin Panel
│   ├── employee_app/       # Flutter Employee Mobile App
│   └── driver_app/         # Flutter Driver Mobile App
├── packages/
│   ├── core/               # Shared models, utils, theme, constants
│   ├── networking/         # API client, interceptors
│   ├── maps/               # Google Maps integration
│   ├── auth/               # Authentication logic
│   └── widgets/            # Shared UI widgets
├── backend/                # Dart Shelf REST API
├── docs/                   # Documentation
└── deployment/             # Docker, CI/CD configs
```

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Dart Shelf
- **Database**: PostgreSQL
- **Cache**: Redis
- **State Management**: Riverpod
- **Maps**: Google Maps SDK
- **Notifications**: Firebase Cloud Messaging
- **Auth**: JWT + RBAC

## Getting Started

### Prerequisites

- Flutter SDK >= 3.1.0
- Dart SDK >= 3.1.0
- PostgreSQL 15+
- Redis 7+
- Google Maps API Key
- Firebase Project

### Setup

```bash
# Install dependencies
dart pub get

# Run backend
cd backend && dart run bin/server.dart

# Run admin panel
cd apps/admin_web && flutter run -d chrome

# Run employee app
cd apps/employee_app && flutter run

# Run driver app
cd apps/driver_app && flutter run
```

## Development

```bash
# Run all tests
dart test

# Run backend tests
cd backend && dart test

# Run Flutter tests
cd apps/admin_web && flutter test
```

## Phase 1 (MVP)

- [x] Project structure
- [ ] Authentication (JWT)
- [ ] User management (Admin, Employee, Driver)
- [ ] Vehicle management
- [ ] Route management
- [ ] Trip scheduling
- [ ] Basic live tracking
- [ ] Attendance tracking
- [ ] Push notifications
