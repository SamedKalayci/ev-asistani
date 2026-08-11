import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/budget_model.dart';
import '../models/finance_item_model.dart';
import '../providers/budget_provider.dart';
import '../../../core/providers/currency_provider.dart';
import '../../../core/utils/l10n_helper.dart';

class CategoryBudgetsScreen extends ConsumerStatefulWidget {
  const CategoryBudgetsScreen({super.key});

  @override
  ConsumerState<CategoryBudgetsScreen> createState() => _CategoryBudgetsScreenState();
}

class _CategoryBudgetsScreenState extends ConsumerState<CategoryBudgetsScreen> {
  final Map<FinanceCategory, TextEditingController> _systemControllers = {};
  final Map<String, TextEditingController> _customControllers = {};
  bool _isLoading = false;

  @override
  void dispose() {
    for (var c in _systemControllers.values) {
      c.dispose();
    }
    for (var c in _customControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncControllers(List<BudgetModel> currentBudgets) {
    // 1. Sync system controllers (always populated for all walletCategories)
    for (var cat in FinanceCategory.walletCategories) {
      final existing = currentBudgets.where((b) => b.category == cat && (b.customName == null || b.customName!.isEmpty)).firstOrNull;
      final currentLimit = existing?.limitAmount ?? 0.0;
      if (!_systemControllers.containsKey(cat)) {
        _systemControllers[cat] = TextEditingController(
          text: currentLimit > 0 ? currentLimit.toStringAsFixed(0) : '',
        );
      }
    }

    // 2. Sync custom controllers
    final activeCustomNames = <String>{};
    for (var b in currentBudgets) {
      if (b.customName != null && b.customName!.isNotEmpty) {
        activeCustomNames.add(b.customName!);
        if (!_customControllers.containsKey(b.customName!)) {
          _customControllers[b.customName!] = TextEditingController(
            text: b.limitAmount > 0 ? b.limitAmount.toStringAsFixed(0) : '',
          );
        }
      }
    }

    // Remove old unused custom controllers
    _customControllers.removeWhere((name, _) => !activeCustomNames.contains(name));
  }

  Future<void> _saveBudgets(List<BudgetModel> currentBudgets) async {
    final familyId = ref.read(activeFamilyIdProvider);
    final user = ref.read(userProvider).valueOrNull;

    if (familyId.isEmpty || user == null) return;

    setState(() => _isLoading = true);
    try {
      final colRef = FirebaseFirestore.instance.collection('families').doc(familyId).collection('budgets');
      final querySnapshot = await colRef.get();

      // 1. Save system budgets (walletCategories)
      for (var cat in FinanceCategory.walletCategories) {
        final text = _systemControllers[cat]?.text.trim() ?? '';
        final amount = double.tryParse(text) ?? 0.0;

        final matchingDocs = querySnapshot.docs.where((doc) {
          final data = doc.data();
          final catStr = data['category'] as String?;
          final customNameStr = data['customName'] as String?;
          return FinanceCategory.fromString(catStr) == cat && (customNameStr == null || customNameStr.isEmpty);
        }).toList();

        if (matchingDocs.isNotEmpty) {
          final mainDocId = matchingDocs.first.id;
          await colRef.doc(mainDocId).update({
            'limitAmount': amount,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          for (int i = 1; i < matchingDocs.length; i++) {
            await colRef.doc(matchingDocs[i].id).delete();
          }
        } else if (amount > 0) {
          final budget = BudgetModel(
            id: '',
            familyId: familyId,
            category: cat,
            limitAmount: amount,
            createdBy: user.uid,
          );
          await colRef.add(budget.toMap());
        }
      }

      // 2. Save custom budgets
      for (var budget in currentBudgets) {
        if (budget.customName != null && budget.customName!.isNotEmpty) {
          final controller = _customControllers[budget.customName!];
          if (controller != null) {
            final text = controller.text.trim();
            final amount = double.tryParse(text) ?? 0.0;
            if (amount != budget.limitAmount) {
              await colRef.doc(budget.id).update({
                'limitAmount': amount,
                'updatedAt': FieldValue.serverTimestamp(),
              });
            }
          }
        }
      }

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.budgetPlanUpdated)),
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

  Future<void> _showAddBudgetDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final currencySymbol = ref.read(currencySymbolProvider);
    final familyId = ref.read(activeFamilyIdProvider);
    final user = ref.read(userProvider).valueOrNull;

    if (familyId.isEmpty || user == null) return;

    final nameController = TextEditingController();
    final limitController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addBudget),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: nameController,
                label: l10n.budgetCategoryName,
                hintText: 'Örn: Tatil Fonu, Araç Bakımı...',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return l10n.pleaseEnterBudgetName;
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: limitController,
                label: l10n.limitAmountLabel,
                keyboardType: TextInputType.number,
                hintText: 'Limit ($currencySymbol)',
                prefixIcon: Center(
                  widthFactor: 1.0,
                  child: Text(
                    currencySymbol,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return l10n.pleaseEnterValidLimit;
                  final amt = double.tryParse(val.trim());
                  if (amt == null || amt <= 0) return l10n.pleaseEnterValidLimit;
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final name = nameController.text.trim();
                final amt = double.parse(limitController.text.trim());
                
                final budget = BudgetModel(
                  id: '',
                  familyId: familyId,
                  category: FinanceCategory.other,
                  limitAmount: amt,
                  createdBy: user.uid,
                  customName: name,
                );
                
                final colRef = FirebaseFirestore.instance.collection('families').doc(familyId).collection('budgets');
                await colRef.add(budget.toMap());
                
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.budgetAdded)),
                  );
                }
              }
            },
            child: Text(l10n.addLabel),
          ),
        ],
      ),
    );
  }

  Future<bool> _deleteBudget(BuildContext context, String customName) async {
    final l10n = AppLocalizations.of(context)!;
    final familyId = ref.read(activeFamilyIdProvider);
    if (familyId.isEmpty) return false;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(customName),
        content: Text(l10n.deleteBudgetConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('families')
            .doc(familyId)
            .collection('budgets')
            .get();
        final matchingDocs = querySnapshot.docs.where((doc) {
          final data = doc.data();
          final customNameStr = data['customName'] as String?;
          return customNameStr == customName;
        }).toList();
        for (var doc in matchingDocs) {
          await doc.reference.delete();
        }
        _customControllers.remove(customName);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.budgetDeleted)),
          );
        }
        return true;
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: $e')),
          );
        }
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final currencySymbol = ref.watch(currencySymbolProvider);

    final budgetsAsync = ref.watch(budgetsProvider);
    final currentBudgets = budgetsAsync.valueOrNull ?? [];

    _syncControllers(currentBudgets);

    // Get only the user-defined budgets (where customName is present)
    final customBudgets = currentBudgets.where((b) => b.customName != null && b.customName!.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.categoryBudgets),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 26),
            tooltip: l10n.addBudget,
            onPressed: () => _showAddBudgetDialog(context),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.budgetPlanDescription,
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: ListView(
                  children: [
                    // A. System categories section (statically populated)
                    ...FinanceCategory.walletCategories.map((cat) {
                      final controller = _systemControllers[cat];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                                borderRadius: AppRadius.borderSm,
                              ),
                              child: Icon(cat.icon, color: AppColors.primary, size: 16),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                cat.localizedName(context),
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            SizedBox(
                              width: 120,
                              child: TextFormField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: AppTypography.bodyMedium.copyWith(
                                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                  ),
                                  filled: true,
                                  fillColor: colorScheme.surfaceContainerLow,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                                    child: Center(
                                      widthFactor: 1.0,
                                      child: Text(
                                        currencySymbol,
                                        style: AppTypography.titleSmall.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xs,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: AppRadius.borderMd,
                                    borderSide: BorderSide(color: colorScheme.outline),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: AppRadius.borderMd,
                                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: AppRadius.borderMd,
                                    borderSide: BorderSide(color: colorScheme.primary, width: 2),
                                  ),
                                ),
                              ),
                            ),
                            // System categories have no red drag handle,
                            // we put matching SizedBox width so everything aligns to the right!
                            const SizedBox(width: 15),
                          ],
                        ),
                      );
                    }),

                    // B. Custom budgets section
                    if (customBudgets.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      const Divider(),
                      const SizedBox(height: AppSpacing.md),
                      ...customBudgets.map((budget) {
                        final name = budget.customName!;
                        final controller = _customControllers[name];
                        return Dismissible(
                          key: Key(budget.id.isNotEmpty ? budget.id : name),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) => _deleteBudget(context, name),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: AppRadius.borderMd,
                            ),
                            child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                                    borderRadius: AppRadius.borderSm,
                                  ),
                                  child: Icon(Icons.star_outline_rounded, color: colorScheme.secondary, size: 16),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                SizedBox(
                                  width: 120,
                                  child: TextFormField(
                                    controller: controller,
                                    keyboardType: TextInputType.number,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '0',
                                      hintStyle: AppTypography.bodyMedium.copyWith(
                                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                      ),
                                      filled: true,
                                      fillColor: colorScheme.surfaceContainerLow,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                                        child: Center(
                                          widthFactor: 1.0,
                                          child: Text(
                                            currencySymbol,
                                            style: AppTypography.titleSmall.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.sm,
                                        vertical: AppSpacing.xs,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: AppRadius.borderMd,
                                        borderSide: BorderSide(color: colorScheme.outline),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: AppRadius.borderMd,
                                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: AppRadius.borderMd,
                                        borderSide: BorderSide(color: colorScheme.primary, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Container(
                                  width: 3,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: colorScheme.error.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(1.5),
                                  ),
                                ),
                                const SizedBox(width: 4),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                text: l10n.saveBudgets,
                onPressed: _isLoading ? null : () => _saveBudgets(currentBudgets),
                isLoading: _isLoading,
                icon: Icons.save_rounded,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
