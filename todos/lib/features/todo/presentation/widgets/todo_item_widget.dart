import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/todo_entity.dart';

class TodoItemWidget extends StatelessWidget {
  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    this.onTap,
  });

  final TodoEntity todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(todo.id),
      background: _SwipeBackground(
        alignment: Alignment.centerLeft,
        color: AppColors.success,
        icon: todo.isDone ? Icons.undo_rounded : Icons.check_rounded,
        label: todo.isDone ? AppStrings.markPending : AppStrings.markDone,
      ),
      secondaryBackground: const _SwipeBackground(
        alignment: Alignment.centerRight,
        color: AppColors.error,
        icon: Icons.delete_outline_rounded,
        label: AppStrings.delete,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onToggle();
          return false;
        }
        onDelete();
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding,
          vertical: AppSpacing.xs,
        ),
        child: Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: AppColors.borderLight),
                // Left accent stripe for important todos
                gradient: todo.isImportant
                    ? LinearGradient(
                        colors: [
                          AppColors.warning.withAlpha(30),
                          Colors.transparent,
                        ],
                        stops: const [0, 0.08],
                      )
                    : null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left accent bar for important todos
                  if (todo.isImportant)
                    Container(
                      width: 3,
                      height: double.infinity,
                      margin: EdgeInsets.zero,
                      decoration: const BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppSpacing.cardRadius),
                          bottomLeft: Radius.circular(AppSpacing.cardRadius),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TodoCheckbox(isDone: todo.isDone, onTap: onToggle),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        todo.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              decoration: todo.isDone
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                              color: todo.isDone
                                                  ? AppColors.subtleLight
                                                  : null,
                                              fontWeight: todo.isImportant
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    if (todo.isImportant)
                                      const Icon(
                                        Icons.star_rounded,
                                        size: 16,
                                        color: AppColors.warning,
                                      ),
                                  ],
                                ),
                                if (todo.description != null &&
                                    todo.description!.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    todo.description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.subtleLight,
                                          height: 1.4,
                                        ),
                                  ),
                                ],
                                if (todo.deadline != null) ...[
                                  const SizedBox(height: AppSpacing.xs),
                                  _DeadlineBadge(
                                    label: DateFormatter.formatDeadline(
                                      todo.deadline!,
                                    ),
                                    isOverdue: todo.isOverdue,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TodoCheckbox extends StatelessWidget {
  const _TodoCheckbox({required this.isDone, required this.onTap});

  final bool isDone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDone ? AppColors.success : Colors.transparent,
          border: isDone
              ? null
              : Border.all(color: AppColors.borderLight, width: 2),
        ),
        child: isDone
            ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}

class _DeadlineBadge extends StatelessWidget {
  const _DeadlineBadge({required this.label, required this.isOverdue});

  final String label;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isOverdue
            ? AppColors.error.withAlpha(15)
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isOverdue
              ? AppColors.error.withAlpha(60)
              : AppColors.borderLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 11,
            color: isOverdue ? AppColors.error : AppColors.subtleLight,
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isOverdue ? AppColors.error : AppColors.subtleLight,
              fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
  });

  final AlignmentGeometry alignment;
  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePadding,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) ...[
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ] else ...[
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(icon, color: Colors.white, size: 18),
          ],
        ],
      ),
    );
  }
}
