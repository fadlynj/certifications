import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_flushbar.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/confirmation_dialog.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/settings_section_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsSuccess) {
          AppFlushbar.success(context, state.message);
          context.read<SettingsCubit>().loadSettings();
        }
        if (state is SettingsError) {
          AppFlushbar.error(context, state.message);
          context.read<SettingsCubit>().loadSettings();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.settings)),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return switch (state) {
              SettingsLoading() || SettingsInitial() => const Center(
                child: CircularProgressIndicator(),
              ),
              SettingsResetPasswordForm() => _ResetPasswordForm(state: state),
              _ => _SettingsContent(
                appVersion: state is SettingsLoaded ? state.appVersion : '…',
              ),
            };
          },
        ),
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent({required this.appVersion});

  final String appVersion;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    final userId = auth is AuthAuthenticated ? auth.session.userId : 0;
    final username = auth is AuthAuthenticated ? auth.session.username : '';

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      children: [
        // Account section
        SettingsSectionWidget(
          title: 'Akun',
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 20,
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              title: Text(
                username,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Pengguna #$userId',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.subtleLight,
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: AppColors.subtleLight,
              ),
              title: const Text(AppStrings.resetPassword),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.subtleLight,
                size: 20,
              ),
              onTap: context.read<SettingsCubit>().openResetPasswordForm,
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: 20,
              ),
              title: const Text(
                AppStrings.logout,
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),

        // Data section
        SettingsSectionWidget(
          title: 'Data',
          children: [
            ListTile(
              leading: const Icon(
                Icons.delete_forever_rounded,
                color: AppColors.error,
                size: 20,
              ),
              title: const Text(
                AppStrings.clearData,
                style: TextStyle(color: AppColors.error),
              ),
              subtitle: const Text(
                'Menghapus semua tugas dan keluar dari akun',
                style: TextStyle(fontSize: 12),
              ),
              onTap: () => _confirmClearData(context, userId),
            ),
          ],
        ),

        // About section
        SettingsSectionWidget(
          title: 'Tentang',
          children: [
            ListTile(
              leading: const Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: AppColors.subtleLight,
              ),
              title: const Text(AppStrings.appVersion),
              trailing: Text(
                appVersion,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.subtleLight),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(
                Icons.code_rounded,
                size: 20,
                color: AppColors.subtleLight,
              ),
              title: const Text(AppStrings.developerInfo),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.developerName,
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    AppStrings.developerEmail,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.subtleLight,
                    ),
                  ),
                  Text(
                    AppStrings.developerNik,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.subtleLight,
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: AppStrings.logoutConfirmTitle,
      message: AppStrings.logoutConfirmMessage,
      confirmLabel: AppStrings.logout,
      isDestructive: true,
    );
    if ((confirmed ?? false) && context.mounted) {
      await context.read<SettingsCubit>().logout();
    }
  }

  Future<void> _confirmClearData(BuildContext context, int userId) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: AppStrings.clearDataConfirmTitle,
      message: AppStrings.clearDataConfirmMessage,
      confirmLabel: AppStrings.clearData,
      isDestructive: true,
    );
    if ((confirmed ?? false) && context.mounted) {
      await context.read<SettingsCubit>().clearAllData(userId);
    }
  }
}

class _ResetPasswordForm extends StatelessWidget {
  const _ResetPasswordForm({required this.state});

  final SettingsResetPasswordForm state;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Kata Sandi Saat Ini',
            obscureText: true,
            enabled: !state.isSubmitting,
            onChanged: context.read<SettingsCubit>().currentPasswordChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: AppStrings.newPassword,
            obscureText: true,
            enabled: !state.isSubmitting,
            onChanged: context.read<SettingsCubit>().newPasswordChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: AppStrings.confirmPassword,
            obscureText: true,
            enabled: !state.isSubmitting,
            errorText: state.errorMessage,
            onChanged: context.read<SettingsCubit>().confirmPasswordChanged,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: AppStrings.resetPassword,
            isLoading: state.isSubmitting,
            onPressed: state.isSubmitting
                ? null
                : () {
                    final auth = context.read<AuthCubit>().state;
                    final username = auth is AuthAuthenticated
                        ? auth.session.username
                        : '';
                    context.read<SettingsCubit>().submitResetPassword(username);
                  },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: AppStrings.cancel,
            variant: AppButtonVariant.outlined,
            onPressed: context.read<SettingsCubit>().loadSettings,
          ),
        ],
      ),
    );
  }
}
