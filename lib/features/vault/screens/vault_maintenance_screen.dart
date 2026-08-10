import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/date_picker_field.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../core/services/notification_service.dart';
import '../models/vault_item_model.dart';
import '../providers/vault_provider.dart';

/// 🛠️ Periyodik Bakım Takvimi Detay Ekranı.
class VaultMaintenanceScreen extends ConsumerWidget {
  const VaultMaintenanceScreen({super.key});

  static Future<void> showAddModal(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime? dueDate = DateTime.now().add(const Duration(days: 30));
    final formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.85,
              ),
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.surfaceContainerLowest,
                borderRadius: AppRadius.borderTopXl,
              ),
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.xl + bottomInset,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(ctx).colorScheme.outlineVariant,
                            borderRadius: AppRadius.borderFull,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Center(
                        child: Text(
                          l10n.newMaintenanceTask,
                          style: AppTypography.headlineSmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        label: l10n.maintenanceTitleLabel,
                        hintText: l10n.maintenanceTitleHint,
                        controller: titleController,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Bakım adı zorunludur.' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: l10n.descriptionLabel,
                        hintText: l10n.descriptionHint,
                        controller: descController,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DatePickerField(
                        label: l10n.scheduledDateLabel,
                        selectedDate: dueDate,
                        onDateSelected: (date) => setState(() => dueDate = date),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      PrimaryButton(
                        text: l10n.saveTask,
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          final familyId = ref.read(activeFamilyIdProvider);
                          final user = ref.read(userProvider).valueOrNull;

                          if (familyId.isNotEmpty && user != null) {
                            final newItem = VaultItemModel(
                              id: '',
                              familyId: familyId,
                              category: 'maintenance',
                              title: titleController.text.trim(),
                              description: descController.text.trim(),
                              dueDate: dueDate,
                              createdBy: user.uid,
                            );

                            await ref
                                .read(vaultRepositoryProvider)
                                .addVaultItem(familyId, newItem);

                            if (dueDate != null) {
                              await NotificationService.instance.scheduleMaintenanceNotifications(newItem);
                            }

                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Bakım görevi eklendi! 🛠️')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final vaultItemsAsync = ref.watch(vaultItemsProvider);

    final items = (vaultItemsAsync.valueOrNull ?? [])
        .where((item) => item.category == 'maintenance')
        .toList();

    // Tarihe göre sırala
    items.sort((a, b) {
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(
        title: '🛠️ ${l10n.periodicMaintenance}',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => showAddModal(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddModal(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.build_rounded, color: Colors.white),
        label: Text(
          l10n.addMaintenanceTask,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          child: Column(
            children: [
              if (items.isEmpty)
                EmptyState(
                  icon: Icons.build_circle_outlined,
                  title: l10n.noMaintenanceTasksTitle,
                  description: l10n.noMaintenanceTasksDesc,
                  actionLabel: l10n.addFirstMaintenanceTask,
                  onActionPressed: () => showAddModal(context, ref),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildMaintenanceTile(context, ref, colorScheme, item);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaintenanceTile(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    VaultItemModel item,
  ) {
    final isDone = item.isCompleted;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDone
            ? const Color(0xFFF0FDF4)
            : colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderLg,
        border: Border.all(
          color: isDone
              ? AppColors.primary.withValues(alpha: 0.3)
              : colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isDone,
            activeColor: AppColors.primary,
            onChanged: (_) {
              ref
                  .read(vaultRepositoryProvider)
                  .toggleCompletedStatus(item.familyId, item.id, item.isCompleted);
            },
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (item.description.isNotEmpty)
                      Text(
                        '${item.description} • ',
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    Text(
                      item.remainingDaysText,
                      style: AppTypography.bodySmall.copyWith(
                        color: item.remainingDaysText.contains('Geçti') && !isDone
                            ? AppColors.error
                            : colorScheme.onSurfaceVariant,
                        fontWeight: item.remainingDaysText.contains('Geçti') && !isDone
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () => ref
                .read(vaultRepositoryProvider)
                .deleteVaultItem(item.familyId, item.id),
          ),
        ],
      ),
    );
  }
}
