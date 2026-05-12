import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_flushbar.dart';
import '../../../../shared/widgets/confirmation_dialog.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/todo_list_cubit.dart';
import '../cubit/todo_list_state.dart';
import '../widgets/filter_sort_bar_widget.dart';
import '../widgets/todo_item_widget.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadTodos() {
    final auth = context.read<AuthCubit>().state;
    if (auth is AuthAuthenticated) {
      context.read<TodoListCubit>().loadTodos(auth.session.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.todoList),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilledButton.icon(
              onPressed: () async {
                final ctx = context;
                final added = await ctx.push<bool>(
                  RouteNames.addTodo,
                  extra: false,
                );
                if ((added ?? false) && ctx.mounted) {
                  unawaited(AppFlushbar.success(ctx, AppStrings.todoCreated));
                }
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Baru'),
              style: FilledButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pagePadding,
              AppSpacing.sm,
              AppSpacing.pagePadding,
              AppSpacing.xs,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: context.read<TodoListCubit>().search,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: AppColors.subtleLight,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          context.read<TodoListCubit>().search('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Filter / Sort bar
          BlocBuilder<TodoListCubit, TodoListState>(
            buildWhen: (prev, curr) =>
                curr is TodoListLoaded &&
                prev is TodoListLoaded &&
                (curr.filter != prev.filter || curr.sort != prev.sort),
            builder: (context, state) {
              if (state is! TodoListLoaded) return const SizedBox.shrink();
              return FilterSortBarWidget(
                activeFilter: state.filter,
                activeSort: state.sort,
                onFilterChanged: context.read<TodoListCubit>().setFilter,
                onSortChanged: context.read<TodoListCubit>().setSort,
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),

          // List
          Expanded(
            child: BlocBuilder<TodoListCubit, TodoListState>(
              builder: (context, state) {
                return switch (state) {
                  TodoListInitial() || TodoListLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  TodoListError(:final message) => Center(child: Text(message)),
                  TodoListLoaded() => _buildList(context, state),
                };
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () async {
          final ctx = context;
          final added = await ctx.push<bool>(RouteNames.addTodo, extra: false);
          if ((added ?? false) && mounted) {
            unawaited(
              // ignore: use_build_context_synchronously
              AppFlushbar.success(ctx, AppStrings.todoCreated),
            );
          }
        },
        tooltip: AppStrings.addTodo,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildList(BuildContext context, TodoListLoaded state) {
    final todos = state.displayedTodos;

    if (todos.isEmpty) {
      return EmptyStateWidget(
        icon: state.searchQuery.isNotEmpty || state.filter != TodoFilter.all
            ? Icons.search_off_rounded
            : Icons.checklist_rounded,
        message: state.searchQuery.isNotEmpty || state.filter != TodoFilter.all
            ? AppStrings.emptyFilterResult
            : AppStrings.emptyTodoList,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItemWidget(
          todo: todo,
          onToggle: () => context.read<TodoListCubit>().toggleTodo(todo.id),
          onDelete: () => _confirmDelete(context, todo.id, todo.title),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    int todoId,
    String title,
  ) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: AppStrings.deleteConfirmTitle,
      message: AppStrings.deleteConfirmMessage,
      confirmLabel: AppStrings.delete,
      isDestructive: true,
    );
    if ((confirmed ?? false) && context.mounted) {
      await context.read<TodoListCubit>().deleteTodo(todoId);
      if (context.mounted) {
        await AppFlushbar.info(context, AppStrings.todoDeleted);
      }
    }
  }
}
