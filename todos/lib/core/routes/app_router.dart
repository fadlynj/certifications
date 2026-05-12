// ⚠️ This file uses go_router_builder code generation.
// Run: dart run build_runner build --delete-conflicting-outputs
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/todo/domain/usecases/create_todo_usecase.dart';
import '../../features/todo/presentation/cubit/add_todo_cubit.dart';
import '../../features/todo/presentation/pages/add_todo_page.dart';
import '../../features/todo/presentation/pages/home_page.dart';
import '../../features/todo/presentation/pages/todo_list_page.dart';
import '../../injection/injection_container.dart' as di;
import 'route_names.dart';

/// A [ChangeNotifier] that re-triggers the GoRouter redirect whenever the
/// [AuthCubit] emits a new state (e.g. after login / logout).
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(AuthCubit cubit) {
    cubit.stream.listen((_) => notifyListeners());
  }
}

class AppRouter {
  AppRouter._();

  /// Creates and returns the [GoRouter] wired to [authCubit].
  static GoRouter createRouter(AuthCubit authCubit) {
    final notifier = _AuthStateNotifier(authCubit);

    return GoRouter(
      initialLocation: RouteNames.login,
      refreshListenable: notifier,
      redirect: (BuildContext context, GoRouterState state) {
        final isAuthenticated = authCubit.state is AuthAuthenticated;
        final isOnLogin = state.matchedLocation == RouteNames.login;

        if (!isAuthenticated && !isOnLogin) return RouteNames.login;
        if (isAuthenticated && isOnLogin) return RouteNames.home;
        return null;
      },
      routes: [
        GoRoute(
          path: RouteNames.login,
          name: 'login',
          builder: (_, _) => const LoginPage(),
        ),
        GoRoute(
          path: RouteNames.home,
          name: 'home',
          builder: (_, _) => const HomePage(),
          routes: [
            GoRoute(
              path: 'add-todo',
              name: 'addTodo',
              builder: (ctx, state) {
                final isImportant = state.extra as bool? ?? false;
                final auth = ctx.read<AuthCubit>().state;
                final userId = auth is AuthAuthenticated
                    ? auth.session.userId
                    : 0;
                return BlocProvider(
                  create: (_) => AddTodoCubit(
                    createTodo: di.getIt<CreateTodoUseCase>(),
                    userId: userId,
                    isImportantDefault: isImportant,
                  ),
                  child: AddTodoPage(isImportantDefault: isImportant),
                );
              },
            ),
            GoRoute(
              path: 'todos',
              name: 'todos',
              builder: (_, _) => const TodoListPage(),
            ),
            GoRoute(
              path: 'settings',
              name: 'settings',
              builder: (_, _) => const SettingsPage(),
            ),
          ],
        ),
      ],
      errorBuilder: (_, state) =>
          Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
    );
  }
}
