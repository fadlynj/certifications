import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

abstract final class AppFlushbar {
  static Future<void> error(BuildContext context, String message) async {
    await _show(
      context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
    );
  }

  static Future<void> success(BuildContext context, String message) async {
    await _show(
      context,
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static Future<void> info(BuildContext context, String message) async {
    await _show(
      context,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_outline_rounded,
    );
  }

  static Future<void> _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) async {
    await Flushbar<void>(
      message: message,
      icon: Icon(icon, color: Colors.white, size: 24),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: backgroundColor,
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}
