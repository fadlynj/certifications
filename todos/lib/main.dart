import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/todo/presentation/cubit/home_cubit.dart';
import 'features/todo/presentation/cubit/todo_list_cubit.dart';
import 'injection/injection_container.dart' as di;

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await di.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final authCubit = di.getIt<AuthCubit>();
  await authCubit.checkCurrentSession();

  FlutterNativeSplash.remove();

  runApp(TodoApp(authCubit: authCubit));
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key, required this.authCubit});
  final AuthCubit authCubit;

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  late final _router = AppRouter.createRouter(widget.authCubit);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: widget.authCubit),
        BlocProvider<HomeCubit>(create: (_) => di.getIt<HomeCubit>()),
        BlocProvider<TodoListCubit>(create: (_) => di.getIt<TodoListCubit>()),
        BlocProvider<SettingsCubit>(create: (_) => di.getIt<SettingsCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Todos',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: _router,
      ),
    );
  }
}
