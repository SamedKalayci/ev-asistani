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
import '../models/finance_item_model.dart';
import '../providers/finance_provider.dart';

class QuickAddExpenseBottomSheet extends ConsumerStatefulWidget {
  const QuickAddExpenseBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickAddExpenseBottomSheet(),
    );
  }

  @override
  ConsumerState<QuickAddExpenseBottomSheet> createState() => _QuickAddExpenseBottomSheetState();
}

class _QuickAddExpenseBottomSheetState extends ConsumerState<QuickAddExpenseBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  FinanceCategory _selectedCategory = FinanceCategory.kitchenGrocery;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    final familyId = ref.read(activeFamilyIdProvider);
    final user = ref.read(userProvider).valueOrNull;

    if (familyId.isEmpty || user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hata: Aile veya kullanıcı bilgisi bulunamadı.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
      
      final expense = FinanceItemModel(
        id: '', // repo creates id
        familyId: familyId,
        title: _titleController.text.trim(),
        amount: amount,
        type: FinanceType.expense,
        category: _selectedCategory,
        isPaid: true, // Hızlı ekleme anlık harcamadır, ödendi varsayılır
        dueDate: DateTime.now(), // Anlık zaman
        isRecurring: false,
        isWalletExpense: true,
        createdBy: user.uid,
      );

      await ref.read(financeRepositoryProvider).addFinanceItem(familyId, expense);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harcama eklendi!'),
            backgroundColor: AppColors.primary,
          ),
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
      child: Form(
        key: _formKey,
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withValues(alpha: 0.5),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: const Icon(Icons.flash_on_rounded, color: AppColors.error),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Hızlı Harcama Gir',
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: 'Tutar (₺)',
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: const Icon(Icons.currency_lira_rounded, size: 18),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Lütfen tutar girin';
                if (double.tryParse(v.replaceAll(',', '.')) == null) return 'Geçerli bir tutar girin';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Kısa Açıklama',
              controller: _titleController,
              hintText: 'Örn: Kahve, Market vs.',
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Açıklama girin' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<FinanceCategory>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Kategori',
                border: const OutlineInputBorder(borderRadius: AppRadius.borderMd),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              ),
              items: FinanceCategory.walletCategories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Row(
                    children: [
                      Icon(cat.icon, size: 18, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: AppSpacing.sm),
                      Text(cat.getLocalizedLabel(context), style: AppTypography.bodyMedium),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(
              text: 'Kaydet',
              onPressed: _isLoading ? null : _saveExpense,
              isLoading: _isLoading,
              icon: Icons.check_circle_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
