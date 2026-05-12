import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/todo_list_state.dart';

class FilterSortBarWidget extends StatelessWidget {
  const FilterSortBarWidget({
    super.key,
    required this.activeFilter,
    required this.activeSort,
    required this.onFilterChanged,
    required this.onSortChanged,
  });

  final TodoFilter activeFilter;
  final TodoSort activeSort;
  final ValueChanged<TodoFilter> onFilterChanged;
  final ValueChanged<TodoSort> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding,
          ),
          child: Row(
            children: TodoFilter.values
                .map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: FilterChip(
                      label: Text(_filterLabel(f)),
                      selected: activeFilter == f,
                      onSelected: (_) => onFilterChanged(f),
                      selectedColor: AppColors.primary.withAlpha(20),
                      labelStyle: TextStyle(
                        color: activeFilter == f
                            ? AppColors.primary
                            : AppColors.subtleLight,
                        fontWeight: activeFilter == f
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 13,
                      ),
                      side: activeFilter == f
                          ? const BorderSide(color: AppColors.primary)
                          : const BorderSide(color: AppColors.borderLight),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // Sort selector
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding,
          ),
          child: Row(
            children: [
              Text(
                'Urutkan',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.subtleLight,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              ...TodoSort.values.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: ChoiceChip(
                    label: Text(_sortLabel(s)),
                    selected: activeSort == s,
                    onSelected: (_) => onSortChanged(s),
                    selectedColor: AppColors.primary.withAlpha(20),
                    labelStyle: TextStyle(
                      color: activeSort == s
                          ? AppColors.primary
                          : AppColors.subtleLight,
                      fontWeight: activeSort == s
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 12,
                    ),
                    side: activeSort == s
                        ? const BorderSide(color: AppColors.primary)
                        : const BorderSide(color: AppColors.borderLight),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _filterLabel(TodoFilter f) => switch (f) {
    TodoFilter.all => AppStrings.filterAll,
    TodoFilter.done => AppStrings.filterDone,
    TodoFilter.pending => AppStrings.filterPending,
    TodoFilter.important => AppStrings.filterImportant,
  };

  String _sortLabel(TodoSort s) => switch (s) {
    TodoSort.createdDate => AppStrings.sortCreated,
    TodoSort.deadline => AppStrings.sortDeadline,
    TodoSort.importance => AppStrings.sortImportance,
  };
}
