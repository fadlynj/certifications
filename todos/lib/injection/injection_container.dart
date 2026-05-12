import 'package:get_it/get_it.dart';

import '../core/constants/app_constants.dart';
import '../core/security/hash_service.dart';
import '../core/security/secure_storage_service.dart';
import '../core/security/session_manager.dart';
import '../database/app_database.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/get_current_session_usecase.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/register_initial_user_usecase.dart';
import '../features/auth/domain/usecases/reset_password_usecase.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/settings/data/datasources/settings_local_datasource.dart';
import '../features/settings/data/repositories/settings_repository_impl.dart';
import '../features/settings/domain/repositories/settings_repository.dart';
import '../features/settings/domain/usecases/clear_local_data_usecase.dart';
import '../features/settings/domain/usecases/get_app_info_usecase.dart';
import '../features/settings/presentation/cubit/settings_cubit.dart';
import '../features/todo/data/datasources/todo_local_datasource.dart';
import '../features/todo/data/repositories/todo_repository_impl.dart';
import '../features/todo/domain/repositories/todo_repository.dart';
import '../features/todo/domain/usecases/create_todo_usecase.dart';
import '../features/todo/domain/usecases/delete_todo_usecase.dart';
import '../features/todo/domain/usecases/get_todos_usecase.dart';
import '../features/todo/domain/usecases/get_weekly_stats_usecase.dart';
import '../features/todo/domain/usecases/toggle_todo_status_usecase.dart';
import '../features/todo/domain/usecases/update_todo_usecase.dart';
import '../features/todo/presentation/cubit/home_cubit.dart';
import '../features/todo/presentation/cubit/todo_list_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  // ─── Core infrastructure ──────────────────────────────────────────────────
  final db = AppDatabase();
  getIt.registerSingleton<AppDatabase>(db);

  getIt.registerSingleton<HashService>(HashService.instance);

  getIt.registerSingleton<SecureStorageService>(SecureStorageService());

  getIt.registerSingleton<SessionManager>(
    SessionManager(getIt<SecureStorageService>()),
  );

  // ─── Auth ─────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(
      database: db,
      hashService: getIt<HashService>(),
      sessionManager: getIt<SessionManager>(),
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthLocalDataSource>()),
  );

  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => GetCurrentSessionUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => RegisterInitialUserUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => ResetPasswordUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      getCurrentSession: getIt<GetCurrentSessionUseCase>(),
      login: getIt<LoginUseCase>(),
      logout: getIt<LogoutUseCase>(),
    ),
  );

  // ─── Todos ────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSource(database: db),
  );

  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(getIt<TodoLocalDataSource>()),
  );

  getIt.registerLazySingleton(() => CreateTodoUseCase(getIt<TodoRepository>()));
  getIt.registerLazySingleton(() => GetTodosUseCase(getIt<TodoRepository>()));
  getIt.registerLazySingleton(() => UpdateTodoUseCase(getIt<TodoRepository>()));
  getIt.registerLazySingleton(() => DeleteTodoUseCase(getIt<TodoRepository>()));
  getIt.registerLazySingleton(
    () => ToggleTodoStatusUseCase(getIt<TodoRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetWeeklyStatsUseCase(getIt<TodoRepository>()),
  );

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(
      getTodos: getIt<GetTodosUseCase>(),
      getWeeklyStats: getIt<GetWeeklyStatsUseCase>(),
    ),
  );

  getIt.registerFactory<TodoListCubit>(
    () => TodoListCubit(
      getTodos: getIt<GetTodosUseCase>(),
      toggleStatus: getIt<ToggleTodoStatusUseCase>(),
      deleteTodo: getIt<DeleteTodoUseCase>(),
    ),
  );

  // AddTodoCubit is created per-page with userId injected via the page.

  // ─── Settings ─────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSource(
      database: db,
      sessionManager: getIt<SessionManager>(),
    ),
  );

  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt<SettingsLocalDataSource>()),
  );

  getIt.registerLazySingleton(
    () => GetAppInfoUseCase(getIt<SettingsRepository>()),
  );
  getIt.registerLazySingleton(
    () => ClearLocalDataUseCase(getIt<SettingsRepository>()),
  );

  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(
      getAppInfo: getIt<GetAppInfoUseCase>(),
      clearLocalData: getIt<ClearLocalDataUseCase>(),
      resetPassword: getIt<ResetPasswordUseCase>(),
      authCubit: getIt<AuthCubit>(),
    ),
  );

  // ─── Seed initial user ────────────────────────────────────────────────────
  await _seedInitialUser();
}

Future<void> _seedInitialUser() async {
  final hasUser = await getIt<AppDatabase>().usersDao.hasAnyUser();
  if (!hasUser) {
    await getIt<RegisterInitialUserUseCase>().call(
      const RegisterParams(
        username: AppConstants.seedUsername,
        password: AppConstants.seedPassword,
      ),
    );
  }
}
