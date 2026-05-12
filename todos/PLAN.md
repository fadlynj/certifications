# Flutter Todo App — Enterprise Clean Architecture Plan

## Project Overview

A Flutter Todo application built with strict Clean Architecture, intended for certification.  
Features: Authentication, Todo Management, Home Statistics, Settings.

## Tech Stack

| Layer | Package |
|---|---|
| State | `flutter_bloc` + `bloc_concurrency` |
| Routing | `go_router` + `go_router_builder` |
| DI | `get_it` |
| Database | `drift` + `drift_flutter` |
| FP | `dartz` |
| Security | `flutter_secure_storage` + `crypto` |
| Charts | `syncfusion_flutter_charts` |
| Forms | `formz` |
| Logging | `logger` |
| Equality | `equatable` |
| Notifications | `another_flushbar` |

## Quick Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

> **Note:** Code generation is required for `drift` tables/DAOs and `go_router_builder` typed routes.  
> Default seed account: `admin` / `Admin@123`

---

## Architecture

```
lib/
  core/
    constants/        # App-wide constants and strings
    errors/           # Failure classes and custom exceptions
    extensions/       # Dart/Flutter extensions
    services/         # Logger, etc.
    utils/            # Sanitizer, date formatter
    theme/            # Material 3 theme, colors, spacing
    routes/           # GoRouter + typed route definitions
    security/         # HashService, SecureStorage, SessionManager
    usecases/         # Base UseCase abstract class
  database/
    tables/           # Drift table definitions
    daos/             # Drift Data Access Objects
    app_database.dart # Main database entry point
  features/
    auth/             # Login, session, register
    todo/             # CRUD, home stats, weekly chart
    settings/         # Password reset, clear data, app info
  shared/
    widgets/          # Reusable UI components
  injection/          # get_it registration
  main.dart
```

---

## Progress Tracker

### Configuration
- [x] `PLAN.md` — this file
- [x] `pubspec.yaml` — all dependencies + code gen config
- [x] `analysis_options.yaml` — strict linting
- [x] `flutter_native_splash.yaml`

### Database (Drift)
- [x] `lib/database/app_database.dart`
- [x] `lib/database/tables/users_table.dart`
- [x] `lib/database/tables/todos_table.dart`
- [x] `lib/database/tables/sessions_table.dart`
- [x] `lib/database/daos/users_dao.dart`
- [x] `lib/database/daos/todos_dao.dart`
- [x] `lib/database/daos/sessions_dao.dart`

### Core Layer
- [x] `lib/core/usecases/usecase.dart`
- [x] `lib/core/constants/app_constants.dart`
- [x] `lib/core/constants/app_strings.dart`
- [x] `lib/core/errors/failures.dart`
- [x] `lib/core/errors/exceptions.dart`
- [x] `lib/core/extensions/context_extensions.dart`
- [x] `lib/core/extensions/string_extensions.dart`
- [x] `lib/core/extensions/datetime_extensions.dart`
- [x] `lib/core/services/logger_service.dart`
- [x] `lib/core/utils/input_sanitizer.dart`
- [x] `lib/core/utils/date_formatter.dart`
- [x] `lib/core/theme/app_colors.dart`
- [x] `lib/core/theme/app_text_styles.dart`
- [x] `lib/core/theme/app_spacing.dart`
- [x] `lib/core/theme/app_theme.dart`
- [x] `lib/core/security/hash_service.dart`
- [x] `lib/core/security/secure_storage_service.dart`
- [x] `lib/core/security/session_manager.dart`
- [x] `lib/core/routes/app_router.dart`
- [x] `lib/core/routes/route_names.dart`

### Auth Feature
- [x] `domain/entities/user_entity.dart`
- [x] `domain/entities/session_entity.dart`
- [x] `domain/repositories/auth_repository.dart`
- [x] `domain/usecases/login_usecase.dart`
- [x] `domain/usecases/logout_usecase.dart`
- [x] `domain/usecases/get_current_session_usecase.dart`
- [x] `domain/usecases/register_initial_user_usecase.dart`
- [x] `domain/usecases/reset_password_usecase.dart`
- [x] `data/datasources/auth_local_datasource.dart`
- [x] `data/models/user_model.dart`
- [x] `data/models/session_model.dart`
- [x] `data/mappers/user_mapper.dart`
- [x] `data/mappers/session_mapper.dart`
- [x] `data/repositories/auth_repository_impl.dart`
- [x] `presentation/cubit/auth_state.dart`
- [x] `presentation/cubit/auth_cubit.dart`
- [x] `presentation/pages/login_page.dart`
- [x] `presentation/widgets/login_form.dart`

### Todo Feature
- [x] `domain/entities/todo_entity.dart`
- [x] `domain/repositories/todo_repository.dart`
- [x] `domain/usecases/create_todo_usecase.dart`
- [x] `domain/usecases/get_todos_usecase.dart`
- [x] `domain/usecases/update_todo_usecase.dart`
- [x] `domain/usecases/delete_todo_usecase.dart`
- [x] `domain/usecases/toggle_todo_status_usecase.dart`
- [x] `domain/usecases/get_weekly_stats_usecase.dart`
- [x] `data/datasources/todo_local_datasource.dart`
- [x] `data/models/todo_model.dart`
- [x] `data/mappers/todo_mapper.dart`
- [x] `data/repositories/todo_repository_impl.dart`
- [x] `presentation/cubit/home_state.dart`
- [x] `presentation/cubit/home_cubit.dart`
- [x] `presentation/cubit/todo_list_state.dart`
- [x] `presentation/cubit/todo_list_cubit.dart`
- [x] `presentation/cubit/add_todo_state.dart`
- [x] `presentation/cubit/add_todo_cubit.dart`
- [x] `presentation/pages/home_page.dart`
- [x] `presentation/pages/add_todo_page.dart`
- [x] `presentation/pages/todo_list_page.dart`
- [x] `presentation/widgets/todo_item_widget.dart`
- [x] `presentation/widgets/stats_card_widget.dart`
- [x] `presentation/widgets/weekly_chart_widget.dart`
- [x] `presentation/widgets/filter_sort_bar_widget.dart`
- [x] `presentation/widgets/quick_action_button.dart`

### Settings Feature
- [x] `domain/repositories/settings_repository.dart`
- [x] `domain/usecases/get_app_info_usecase.dart`
- [x] `domain/usecases/clear_local_data_usecase.dart`
- [x] `data/datasources/settings_local_datasource.dart`
- [x] `data/repositories/settings_repository_impl.dart`
- [x] `presentation/cubit/settings_state.dart`
- [x] `presentation/cubit/settings_cubit.dart`
- [x] `presentation/pages/settings_page.dart`
- [x] `presentation/widgets/settings_section_widget.dart`

### Shared Widgets
- [x] `lib/shared/widgets/app_button.dart`
- [x] `lib/shared/widgets/app_text_field.dart`
- [x] `lib/shared/widgets/loading_overlay.dart`
- [x] `lib/shared/widgets/empty_state_widget.dart`
- [x] `lib/shared/widgets/confirmation_dialog.dart`
- [x] `lib/shared/widgets/app_flushbar.dart`
- [x] `lib/shared/widgets/skeleton_loader.dart`

### Injection & Entry Point
- [x] `lib/injection/injection_container.dart`
- [x] `lib/main.dart`

### Tests
- [x] `test/features/auth/domain/usecases/login_usecase_test.dart`
- [x] `test/features/auth/presentation/cubit/auth_cubit_test.dart`
- [x] `test/features/todo/domain/usecases/create_todo_usecase_test.dart`
- [x] `test/features/todo/presentation/cubit/todo_list_cubit_test.dart`
- [x] `test/features/todo/domain/usecases/get_weekly_stats_usecase_test.dart`

### Documentation
- [x] `README.md`

---

## Security Architecture

| Concern | Implementation |
|---|---|
| Password storage | SHA-256 + 32-byte random salt, 10,000 iterations |
| Session tokens | UUID v4 stored in `flutter_secure_storage` |
| Session expiry | 7 days, checked on every app start |
| Brute force | 5 attempts → 15-minute lockout (persisted in secure storage) |
| Log sanitization | Sensitive fields never logged |
| Input sanitization | All user input trimmed and sanitized before use |

## Notes for Future Improvement

- Replace SHA-256 iterations with argon2/bcrypt for even stronger hashing
- Add biometric authentication
- Add cloud sync support
- Add recurring todos
- Add todo categories/tags
