import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../core/providers/currency_provider.dart';
import '../../../core/utils/l10n_helper.dart';
import '../../../l10n/app_localizations.dart';
import '../models/finance_item_model.dart';
import '../providers/finance_provider.dart';
import '../providers/quick_notes_provider.dart';
import 'quick_notes_autocomplete.dart';
import '../providers/budget_provider.dart';

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
  final _accountController = TextEditingController();
  String _selectedCategoryKey = FinanceCategory.kitchenGrocery.name;
  String _paymentType = 'Nakit';
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _accountController.dispose();
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
      
      final systemCat = FinanceCategory.values.where((c) => c.name == _selectedCategoryKey).firstOrNull;
      final category = systemCat ?? FinanceCategory.other;
      final customCategoryName = systemCat == null ? _selectedCategoryKey : null;

      final expense = FinanceItemModel(
        id: '', // repo creates id
        familyId: familyId,
        title: _titleController.text.trim(),
        amount: amount,
        type: FinanceType.expense,
        category: category,
        customCategoryName: customCategoryName,
        accountName: _accountController.text.trim().isEmpty 
            ? _paymentType 
            : _accountController.text.trim(),
        isPaid: true,
        dueDate: DateTime.now(),
        isRecurring: false,
        isWalletExpense: true,
        createdBy: user.uid,
      );

      await ref.read(financeRepositoryProvider).addFinanceItem(familyId, expense);

      // Açıklamayı hazır şablonlara kaydet (boş değilse)
      final note = _titleController.text.trim();
      if (note.isNotEmpty) {
        addQuickNote(familyId, note, category).ignore();
      }

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
    final currencySymbol = ref.watch(currencySymbolProvider);
    final l10n = AppLocalizations.of(context)!;

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
                  l10n.enterQuickExpense,
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: '${l10n.amountLabel} ($currencySymbol)',
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Center(
                widthFactor: 1.0,
                child: Text(
                  currencySymbol,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l10n.amountRequired;
                if (double.tryParse(v.replaceAll(',', '.')) == null) return l10n.validAmountRequired;
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            QuickNotesAutocomplete(
              controller: _titleController,
              label: l10n.shortDescriptionLabel,
              hintText: l10n.shortDescriptionHint,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.descriptionRequired : null,
              onNoteSelected: (note) {
                setState(() {
                  _selectedCategoryKey = note.category.name;
                });
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Consumer(
              builder: (context, ref, child) {
                final budgetsAsync = ref.watch(budgetsProvider);
                final currentBudgets = budgetsAsync.valueOrNull ?? [];
                final customCategoryNames = currentBudgets
                    .where((b) => b.customName != null && b.customName!.isNotEmpty)
                    .map((b) => b.customName!)
                    .toSet()
                    .toList();

                final allOptions = [
                  ...FinanceCategory.walletCategories.map((c) => c.name),
                  ...customCategoryNames,
                ];
                final value = allOptions.contains(_selectedCategoryKey)
                    ? _selectedCategoryKey
                    : FinanceCategory.kitchenGrocery.name;

                return DropdownButtonFormField<String>(
                  value: value,
                  decoration: InputDecoration(
                    labelText: l10n.categoryLabel,
                    border: const OutlineInputBorder(borderRadius: AppRadius.borderMd),
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  ),
                  items: [
                    ...FinanceCategory.walletCategories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat.name,
                        child: Row(
                          children: [
                            Icon(cat.icon, size: 18, color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: AppSpacing.sm),
                            Text(cat.localizedName(context), style: AppTypography.bodyMedium),
                          ],
                        ),
                      );
                    }),
                    ...customCategoryNames.map((name) {
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Row(
                          children: [
                            Icon(Icons.star_outline_rounded, size: 18, color: colorScheme.secondary),
                            const SizedBox(width: AppSpacing.sm),
                            Text(name, style: AppTypography.bodyMedium),
                          ],
                        ),
                      );
                    }),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCategoryKey = val;
                      });
                    }
                  },
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Ödeme Türü Seçici
            Text(
              '${l10n.paymentType} *',
              style: AppTypography.labelMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            FormField<String>(
              initialValue: _paymentType,
              validator: (val) =>
                  (val == null || val.isEmpty) ? l10n.paymentTypeRequired : null,
              builder: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<String>(
                      segments: [
                        ButtonSegment<String>(
                          value: 'Nakit',
                          icon: const Icon(Icons.payments_outlined, size: 16),
                          label: Text(l10n.cash),
                        ),
                        ButtonSegment<String>(
                          value: 'Kredi Kartı',
                          icon: const Icon(Icons.credit_card_rounded, size: 16),
                          label: Text(l10n.creditCard),
                        ),
                      ],
                      selected: {state.value ?? 'Nakit'},
                      onSelectionChanged: (val) {
                        state.didChange(val.first);
                        setState(() {
                          _paymentType = val.first;
                        });
                      },
                      style: SegmentedButton.styleFrom(
                        selectedForegroundColor: colorScheme.onPrimary,
                        selectedBackgroundColor: colorScheme.primary,
                      ),
                    ),
                    if (state.hasError) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        state.errorText!,
                        style: TextStyle(color: colorScheme.error, fontSize: 12),
                      ),
                    ]
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // Hesap / Kredi Kartı Serbest Metin Alanı
            AppTextField(
              label: l10n.accountCreditCard,
              controller: _accountController,
              hintText: l10n.accountCreditCardHint,
            ),
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(
              text: l10n.save,
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
