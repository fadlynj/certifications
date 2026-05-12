import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_flushbar.dart';
import '../../../../shared/widgets/skeleton_loader.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/stats_card_widget.dart';
import '../widgets/weekly_chart_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final auth = context.read<AuthCubit>().state;
    if (auth is AuthAuthenticated) {
      context.read<HomeCubit>().loadHome(auth.session.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: AppStrings.settings,
            onPressed: () => context.push(RouteNames.settings),
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeInitial() || HomeLoading() => const _HomeSkeleton(),
            HomeError(:final message) => Center(child: Text(message)),
            HomeLoaded() => _HomeContent(state: state),
          };
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<HomeCubit>().refreshStats(),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          _Greeting(),
          const SizedBox(height: AppSpacing.lg),

          // Stats â€” single card with 3 columns
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    StatsCardWidget(
                      label: AppStrings.totalTodos,
                      count: state.totalCount,
                      color: AppColors.primary,
                    ),
                    const _VerticalDivider(),
                    StatsCardWidget(
                      label: AppStrings.doneTodos,
                      count: state.doneCount,
                      color: AppColors.success,
                    ),
                    const _VerticalDivider(),
                    StatsCardWidget(
                      label: AppStrings.pendingTodos,
                      count: state.pendingCount,
                      color: AppColors.warning,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Weekly chart
          WeeklyChartWidget(stats: state.weeklyStats),
          const SizedBox(height: AppSpacing.lg),

          // Quick actions label
          Text(
            'Aksi Cepat',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.subtleLight,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Quick actions grid â€” 2Ã—2 with enough height
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              QuickActionButton(
                icon: Icons.add_rounded,
                label: AppStrings.addTodo,
                color: AppColors.primary,
                onTap: () async {
                  final added = await context.push<bool>(
                    RouteNames.addTodo,
                    extra: false,
                  );
                  if ((added ?? false) && context.mounted) {
                    unawaited(
                      AppFlushbar.success(context, AppStrings.todoCreated),
                    );
                  }
                },
              ),
              QuickActionButton(
                icon: Icons.star_rounded,
                label: 'Penting',
                color: AppColors.warning,
                onTap: () async {
                  final added = await context.push<bool>(
                    RouteNames.addTodo,
                    extra: true,
                  );
                  if ((added ?? false) && context.mounted) {
                    unawaited(
                      AppFlushbar.success(context, AppStrings.todoCreated),
                    );
                  }
                },
              ),
              QuickActionButton(
                icon: Icons.list_alt_rounded,
                label: AppStrings.todoList,
                color: AppColors.info,
                onTap: () => context.push(RouteNames.todos),
              ),
              QuickActionButton(
                icon: Icons.settings_outlined,
                label: AppStrings.settings,
                color: AppColors.subtleLight,
                onTap: () => context.push(RouteNames.settings),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      color: AppColors.borderLight,
    );
  }
}

class _Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    final username = auth is AuthAuthenticated ? auth.session.username : 'kamu';

    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Selamat pagi'
        : hour < 17
        ? 'Selamat siang'
        : 'Selamat malam';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $username',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Ini ringkasan tugas Anda.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.subtleLight),
        ),
      ],
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: const [
        SkeletonLoader(height: 52, width: double.infinity),
        SizedBox(height: AppSpacing.lg),
        SkeletonLoader(height: 80, width: double.infinity),
        SizedBox(height: AppSpacing.lg),
        SkeletonLoader(height: 240, width: double.infinity),
      ],
    );
  }
}
