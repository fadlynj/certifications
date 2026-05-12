# Todos — Flutter Clean Architecture

A production-grade Flutter Todo application built for certification purposes, demonstrating enterprise-level Clean Architecture, security best practices, and modern Flutter patterns.

---

## Features

- **Authentication** — Secure login with SHA-256 + PBKDF2-like hashing (10,000 iterations), brute-force lockout (5 attempts → 15-min lockout), UUID session tokens stored in encrypted secure storage.
- **Todo Management** — Create, complete, delete, and filter todos. Soft-delete, deadline tracking, and importance flagging.
- **Statistics** — Weekly bar chart showing completed todos per day (powered by Syncfusion Flutter Charts).
- **Settings** — Reset password, clear all local data, view app version and developer info.
- **Material 3** — Full light/dark theme support.

---

## Architecture

```
lib/
├── core/               # Shared infrastructure
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── routes/
│   ├── security/
│   ├── services/
│   ├── theme/
│   └── usecases/
├── database/           # Drift ORM — tables + DAOs
├── features/
│   ├── auth/           # Login, session, password management
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── todo/           # CRUD, filtering, statistics
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── settings/       # App info, password reset, data clearing
│       ├── data/
│       ├── domain/
│       └── presentation/
├── injection/          # GetIt dependency injection container
└── shared/             # Reusable widgets
```

**Layers**:

| Layer | Role |
|---|---|
| Domain | Entities, abstract repositories, use cases |
| Data | Models, mappers, local data sources, repository implementations |
| Presentation | BLoC/Cubit, pages, widgets |

---

## Tech Stack

| Package | Purpose |
|---|---|
| `flutter_bloc` + `bloc_concurrency` | State management |
| `go_router` | Declarative routing with auth guards |
| `drift` + `drift_flutter` | Type-safe SQLite ORM |
| `get_it` | Service locator / DI |
| `dartz` | Functional programming (`Either`) |
| `formz` | Typed, validated form inputs |
| `flutter_secure_storage` | Encrypted token storage |
| `syncfusion_flutter_charts` | Weekly stats chart |
| `another_flushbar` | In-app notifications |
| `flutter_native_splash` | Native launch screen |

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.8.0`
- Dart SDK `^3.8.0`

### Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate Drift code (required after any table change)
dart run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

### Seed credentials

| Field | Value |
|---|---|
| Username | `admin` |
| Password | `Admin@123` |

The seed user is created automatically on first launch.

---

## Running Tests

```bash
flutter test
```

Tests cover:

- `LoginUseCase` — valid credentials, wrong credentials, locked account
- `AuthCubit` — session check, login flow
- `CreateTodoUseCase` — success and failure paths
- `TodoListCubit` — loading, error, filter states
- `GetWeeklyStatsUseCase` — 7-slot weekly aggregation

---

## Code Generation

This project uses `drift_dev` for database code generation. Whenever you modify a table or DAO, regenerate:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Security Notes

- Passwords are **never** stored in plain text. Each password is hashed with a unique 32-byte salt using 10,000 SHA-256 iterations.
- Session tokens (UUID v4) are stored in `FlutterSecureStorage` (`EncryptedSharedPreferences` on Android, Keychain on iOS).
- Failed login attempts are tracked in secure storage; 5 consecutive failures trigger a 15-minute lockout.
- Sensitive data is **never** logged.

---

## Developer

**Fadly Nugraha Jati (2241720149)** — fadlynugrahaj@gmail.com
