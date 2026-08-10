import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/user_model.dart';
import 'quick_add_expense_bottom_sheet.dart';
import '../../profile/providers/family_provider.dart';
import '../models/finance_item_model.dart';
import '../providers/budget_provider.dart';
import '../providers/finance_provider.dart';
import 'budget_plan_bottom_sheet.dart';
import '../../../core/providers/currency_provider.dart';

class HouseholdWalletView extends ConsumerWidget {
  final List<FinanceItemModel> monthItems;

  const HouseholdWalletView({super.key, required this.monthItems});

  String _formatCurrency(double amount, String symbol) {
    final isNegative = amount < 0;
    final absAmount = amount.abs().toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < absAmount.length; i++) {
      if (i > 0 && (absAmount.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(absAmount[i]);
    }
    return '${isNegative ? '-' : ''}$symbol${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    
    final budgetsAsync = ref.watch(budgetsProvider);
    final rawBudgets = budgetsAsync.valueOrNull ?? [];
    final currencySymbol = ref.watch(currencySymbolProvider);

    final Map<FinanceCategory, double> consolidatedBudgets = {};
    for (final b in rawBudgets) {
      consolidatedBudgets[b.category] = (consolidatedBudgets[b.category] ?? 0.0) + b.limitAmount;
    }
    final selectedMonth = ref.watch(selectedMonthProvider);
    final monthlyFreeBudget = ref.watch(monthlyFreeBudgetProvider);

    final walletItems = monthItems.where((i) {
      if (!i.isWalletExpense) return false;
      if (i.dueDate == null) return true;
      return i.dueDate!.year == selectedMonth.year && i.dueDate!.month == selectedMonth.month;
    }).toList();

    final expenses = walletItems.where((i) => i.type == FinanceType.expense).toList();
    final totalWalletExpense = expenses.fold(0.0, (sum, item) => sum + item.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: AppSpacing.xxl + 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Serbest Bütçe Kartı & Planla Butonu ─────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B3D2F), Color(0xFF10281F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.borderXl,
              boxShadow: AppShadows.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.monthlyFreeBudget,
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _formatCurrency(monthlyFreeBudget, currencySymbol),
                  style: AppTypography.displayMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => BudgetPlanBottomSheet.show(context, rawBudgets),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.borderFull,
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                        ),
                      ),
                      icon: const Icon(Icons.track_changes_rounded, size: 20),
                      label: Text(l10n.planBudget, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => QuickAddExpenseBottomSheet.show(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE4E1),
                        foregroundColor: const Color(0xFFD32F2F),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderFull),
                      ),
                      icon: const Icon(Icons.flash_on_rounded, size: 20, color: Colors.orange),
                      label: Text(l10n.quickAddExpense, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xxl),

        // ── 2. Kategori Bütçe İlerleme (Progress) ───────────────────────────
        Text(
          l10n.categoryBudgets,
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        if (consolidatedBudgets.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: AppRadius.borderLg,
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.noBudgetsSet,
                    style: AppTypography.bodySmall,
                  ),
                ),
              ],
            ),
          )
        else
          ...consolidatedBudgets.entries.map((entry) {
            final category = entry.key;
            final limitAmount = entry.value;
            if (limitAmount <= 0) return const SizedBox.shrink();
            final spent = expenses
                .where((e) => e.category == category)
                .fold(0.0, (sum, e) => sum + e.amount);
            final percent = (spent / limitAmount).clamp(0.0, 1.0);
            final isOver = spent > limitAmount;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(category.icon, size: 16, color: colorScheme.primary),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            category.getLocalizedLabel(context),
                            style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(
                        '${_formatCurrency(spent, currencySymbol)} / ${_formatCurrency(limitAmount, currencySymbol)}',
                        style: AppTypography.labelSmall.copyWith(
                          color: isOver ? AppColors.error : colorScheme.onSurfaceVariant,
                          fontWeight: isOver ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ClipRRect(
                    borderRadius: AppRadius.borderFull,
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 8,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isOver ? AppColors.error : colorScheme.primary,
                      ),
                    ),
                  ),
                  if (isOver) ...[
                     const SizedBox(height: 2),
                     Align(
                       alignment: Alignment.centerRight,
                       child: Text(
                         l10n.limitExceeded,
                         style: AppTypography.labelSmall.copyWith(color: AppColors.error, fontSize: 10),
                       ),
                     ),
                  ]
                ],
              ),
            );
          }),

        const SizedBox(height: AppSpacing.xl),

        // ── 3. Bireysel Harcamalar ──────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.personalExpenses,
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '${l10n.totalExpense}: ${_formatCurrency(totalWalletExpense, currencySymbol)}',
              style: AppTypography.titleSmall.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (expenses.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: Text(
                l10n.noExpensesPeriod,
                style: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          )
        else
          _buildUserExpenseCards(context, ref, expenses, totalWalletExpense),

        const SizedBox(height: AppSpacing.xxl),

        // ── 4. Kompakt Anlık Harcama Akışı ──────────────────────────────────
        Text(
          l10n.expenseHistory,
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        if (expenses.isEmpty)
          Text(l10n.noRecordsFound, style: AppTypography.bodySmall)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expenses.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return _buildCompactExpenseTile(context, ref, expense, colorScheme);
            },
          ),
        const SizedBox(height: 32),
      ],
    ),
  );
}

  Widget _buildUserExpenseCards(BuildContext context, WidgetRef ref, List<FinanceItemModel> expenses, double totalExpense) {
    final membersAsync = ref.watch(familyMembersProvider);
    final members = membersAsync.valueOrNull ?? [];
    if (members.isEmpty) return const SizedBox.shrink();

    // Üyelere göre harcamaları topla
    final userExpenses = <String, double>{};
    for (var expense in expenses) {
      userExpenses[expense.createdBy] = (userExpenses[expense.createdBy] ?? 0.0) + expense.amount;
    }

    List<Map<String, dynamic>> userData = [];
    userExpenses.forEach((uid, amount) {
      final user = members.firstWhere((m) => m.uid == uid, orElse: () => const UserModel(uid: '', name: 'Bilinmeyen', email: ''));
      final name = user.displayName.isNotEmpty ? user.displayName.split(' ').first : 'Bilinmeyen';
      userData.add({
        'uid': uid,
        'name': name,
        'amount': amount,
        'photoUrl': user.avatarUrl ?? user.photoUrl,
      });
    });

    // Büyükten küçüğe sırala
    userData.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: userData.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final data = userData[index];
          return Container(
            width: 100,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: AppRadius.borderLg,
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: data['photoUrl'] != null && (data['photoUrl'] as String).isNotEmpty
                      ? NetworkImage(data['photoUrl'] as String)
                      : null,
                  child: data['photoUrl'] == null || (data['photoUrl'] as String).isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  data['name'] as String,
                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatCurrency(data['amount'] as double, ref.read(currencySymbolProvider)),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompactExpenseTile(BuildContext context, WidgetRef ref, FinanceItemModel item, ColorScheme colorScheme) {
    final membersAsync = ref.watch(familyMembersProvider);
    final members = membersAsync.valueOrNull ?? [];
    final user = members.firstWhere(
      (m) => m.uid == item.createdBy,
      orElse: () => const UserModel(uid: '', name: 'Bilinmeyen', email: ''),
    );
    final userName = user.displayName.isNotEmpty == true ? user.displayName.split(' ').first : 'Bilinmeyen';

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: AppColors.error,
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 20),
      ),
      onDismissed: (_) {
        ref.read(financeRepositoryProvider).deleteFinanceItem(item.familyId, item.id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.title} silindi.')));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: AppRadius.borderSm,
              ),
              child: Icon(item.category.icon, size: 16, color: AppColors.error),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$userName • ${item.category.getLocalizedLabel(context)}',
                    style: AppTypography.labelSmall.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Text(
              '-${_formatCurrency(item.amount, ref.read(currencySymbolProvider))}',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
