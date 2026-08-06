import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/budget_model.dart';
import '../models/finance_item_model.dart';
import '../providers/budget_provider.dart';

class BudgetPlanBottomSheet extends ConsumerStatefulWidget {
  final List<BudgetModel> currentBudgets;

  const BudgetPlanBottomSheet({super.key, required this.currentBudgets});

  static Future<void> show(BuildContext context, List<BudgetModel> currentBudgets) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BudgetPlanBottomSheet(currentBudgets: currentBudgets),
    );
  }

  @override
  ConsumerState<BudgetPlanBottomSheet> createState() => _BudgetPlanBottomSheetState();
}

class _BudgetPlanBottomSheetState extends ConsumerState<BudgetPlanBottomSheet> {
  final Map<FinanceCategory, TextEditingController> _controllers = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final Map<FinanceCategory, double> consolidatedLimits = {};
    for (var b in widget.currentBudgets) {
      consolidatedLimits[b.category] = (consolidatedLimits[b.category] ?? 0.0) + b.limitAmount;
    }

    for (var cat in FinanceCategory.walletCategories) {
      final existingLimit = consolidatedLimits[cat] ?? 0.0;
      _controllers[cat] = TextEditingController(
        text: existingLimit > 0
            ? existingLimit.toStringAsFixed(0)
            : '',
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveBudgets() async {
    final familyId = ref.read(activeFamilyIdProvider);
    final user = ref.read(userProvider).valueOrNull;

    if (familyId.isEmpty || user == null) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(budgetRepositoryProvider);

      for (var cat in FinanceCategory.walletCategories) {
        final text = _controllers[cat]?.text.trim() ?? '';
        final amount = double.tryParse(text) ?? 0.0;
        
        final existing = widget.currentBudgets.where((b) => b.category == cat).firstOrNull;
        
        if (amount > 0 || (existing != null && amount != existing.limitAmount)) {
          final budget = BudgetModel(
            id: '',
            familyId: familyId,
            category: cat,
            limitAmount: amount,
            createdBy: user.uid,
          );
          await repo.setBudget(familyId, budget);
        }
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bütçe hedefleri güncellendi!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.borderTopXl,
        boxShadow: AppShadows.lg,
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xl + bottomInset,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                borderRadius: AppRadius.borderFull,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Bütçeni Planla',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Aylık harcama hedeflerinizi belirleyin. İstemediğiniz kategorileri boş bırakabilirsiniz.',
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: FinanceCategory.walletCategories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                            borderRadius: AppRadius.borderMd,
                          ),
                          child: Icon(cat.icon, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          flex: 3,
                          child: Text(
                            cat.label,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: AppTextField(
                            controller: _controllers[cat],
                            keyboardType: TextInputType.number,
                            hintText: 'Limit (₺)',
                            prefixIcon: const Icon(Icons.currency_lira_rounded, size: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          PrimaryButton(
            text: 'Hedefleri Kaydet',
            onPressed: _isLoading ? null : _saveBudgets,
            isLoading: _isLoading,
            icon: Icons.save_rounded,
          ),
        ],
      ),
    );
  }
}
