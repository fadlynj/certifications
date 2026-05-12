import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/usecases/get_weekly_stats_usecase.dart';

class WeeklyChartWidget extends StatelessWidget {
  const WeeklyChartWidget({super.key, required this.stats});

  final List<DayStats> stats;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.subtleDark : AppColors.subtleLight;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.weeklyProgress,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  '7 hari terakhir',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.subtleLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 180,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                margin: EdgeInsets.zero,
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(fontSize: 11, color: labelColor),
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  interval: 1,
                  labelStyle: TextStyle(fontSize: 10, color: labelColor),
                  majorGridLines: const MajorGridLines(
                    width: 0.5,
                    dashArray: <double>[4, 4],
                    color: AppColors.borderLight,
                  ),
                  axisLine: const AxisLine(width: 0),
                ),
                series: <CartesianSeries<DayStats, String>>[
                  ColumnSeries<DayStats, String>(
                    dataSource: stats,
                    xValueMapper: (ds, _) => ds.day.weekdayShort,
                    yValueMapper: (ds, _) => ds.count,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                    color: AppColors.primary,
                    width: 0.5,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  format: 'point.x: point.y selesai',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
