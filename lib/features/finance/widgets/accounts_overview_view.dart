import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/currency_provider.dart';
import '../models/account_model.dart';
import '../models/payment_schedule_model.dart';
import '../providers/finance_provider.dart';
import 'account_form_bottom_sheet.dart';
import 'payment_schedule_bottom_sheet.dart';

class AccountsOverviewView extends ConsumerWidget {
  const AccountsOverviewView({super.key});

  static String _formatCurrency(double amount, String symbol) {
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
    final netWorth = ref.watch(totalNetWorthProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final monthlyIncome = ref.watch(monthlyIncomeProvider);
    final monthlyExpense = ref.watch(monthlyExpenseProvider);
    final monthlyPersonalExpense = ref.watch(monthlyPersonalExpenseProvider);
    final accountsAsync = ref.watch(accountsProvider);
    final schedulesAsync = ref.watch(paymentSchedulesProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Net Varlık / Gelir-Gider Dengesi Kartı
          _buildNetWorthCard(
            context,
            netWorth,
            accountsAsync.valueOrNull ?? [],
            selectedMonth,
            monthlyIncome,
            monthlyExpense,
            monthlyPersonalExpense,
            currencySymbol,
          ),
          const SizedBox(height: AppSpacing.xxl),

          // 2. Hesaplar (Gruplandırılmış)
          ..._buildAccountsList(context, accountsAsync.valueOrNull ?? [], currencySymbol),
          const SizedBox(height: AppSpacing.xxl),

          // 3. Ödeme Takvimi
          _buildPaymentSchedules(context, ref, schedulesAsync.valueOrNull ?? [], currencySymbol),
          const SizedBox(height: 100), // Alt boşluk
        ],
      ),
    );
  }

  Widget _buildNetWorthCard(
    BuildContext context,
    double netWorth,
    List<AccountModel> accounts,
    DateTime selectedMonth,
    double monthlyIncome,
    double monthlyExpense,
    double monthlyPersonalExpense,
    String currencySymbol,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).toString();

    final formattedTitle = '${DateFormat.yMMMM(localeCode).format(selectedMonth)} ${l10n.incomeExpenseBalance}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formattedTitle, style: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          _formatCurrency(netWorth, currencySymbol),
          style: AppTypography.displayMedium.copyWith(
            color: netWorth >= 0 ? AppColors.success : AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Toplam Gelir / Toplam Gider Özet Satırları
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.arrow_upward_rounded, size: 16, color: AppColors.success),
                const SizedBox(width: 4.0),
                Text(
                  '${l10n.totalIncome}: +${_formatCurrency(monthlyIncome, currencySymbol)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.arrow_downward_rounded, size: 16, color: AppColors.error),
                const SizedBox(width: 4.0),
                Text(
                  '${l10n.totalExpense}: -${_formatCurrency(monthlyExpense, currencySymbol)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${l10n.personalExpenses}: -${_formatCurrency(monthlyPersonalExpense, currencySymbol)}',
              style: AppTypography.labelSmall.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildAccountsList(BuildContext context, List<AccountModel> accounts, String currencySymbol) {
    final l10n = AppLocalizations.of(context)!;
    if (accounts.isEmpty) {
      final colorScheme = Theme.of(context).colorScheme;
      return [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: AppRadius.borderLg,
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.noAccountYet,
                style: AppTypography.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ];
    }

    final groups = <AccountType, List<AccountModel>>{};
    for (var acc in accounts) {
      groups.putIfAbsent(acc.type, () => []).add(acc);
    }

    final widgets = <Widget>[];
    for (var type in AccountType.values) {
      if (groups.containsKey(type) && groups[type]!.isNotEmpty) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            type.getLocalizedLabel(l10n).toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ));
        
        final list = groups[type]!;
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderLg,
              side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3)),
            itemBuilder: (context, index) {
              final acc = list[index];
              return ListTile(
                onTap: () => AccountFormBottomSheet.show(context, accountToEdit: acc),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    _getIconForType(acc.type),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(acc.title, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                subtitle: acc.type == AccountType.creditCard && acc.cutoffDay != null
                    ? Text(l10n.statementCutoff(acc.cutoffDay!), style: AppTypography.bodySmall)
                    : null,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatCurrency(acc.balance, currencySymbol),
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: acc.type == AccountType.debtCredit && acc.personType == 'debt' ? Colors.red : null,
                      ),
                    ),
                    if (acc.limit != null && acc.type == AccountType.creditCard)
                      Text('/ ${_formatCurrency(acc.limit!, currencySymbol)}', style: AppTypography.labelSmall),
                  ],
                ),
              );
            },
          ),
        )));
      }
    }
    return widgets;
  }

  IconData _getIconForType(AccountType type) {
    switch (type) {
      case AccountType.cash: return Icons.account_balance_wallet_outlined;
      case AccountType.bank: return Icons.account_balance_outlined;
      case AccountType.creditCard: return Icons.credit_card_outlined;
      case AccountType.debtCredit: return Icons.person_outline;
    }
  }

  Widget _buildPaymentSchedules(BuildContext context, WidgetRef ref, List<PaymentScheduleModel> schedules, String currencySymbol) {
    final l10n = AppLocalizations.of(context)!;
    final selectedMonth = ref.watch(selectedMonthProvider);
    final localeCode = Localizations.localeOf(context).toString();
    final formattedMonthYear = DateFormat.yMMMM(localeCode).format(selectedMonth);
    final now = DateTime.now();
    final isCurrentMonth = selectedMonth.year == now.year && selectedMonth.month == now.month;

    // Seçili aya ait veya (mevcut ay seçiliyse) gecikmiş ödenmemiş kayıtlar
    final filteredSchedules = schedules.where((s) {
      final isThisSelectedMonth = s.date.year == selectedMonth.year && s.date.month == selectedMonth.month;
      final isOverdueAndUnpaid = isCurrentMonth && !s.isPaid && s.date.isBefore(DateTime(now.year, now.month, now.day));
      return isThisSelectedMonth || isOverdueAndUnpaid;
    }).toList();

    final pendingSchedules = filteredSchedules.where((s) => !s.isPaid).toList();
    final realizedSchedules = filteredSchedules.where((s) => s.isPaid).toList();

    return Material(
      color: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderXl,
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Ödeme Takvimi
          Text(l10n.paymentSchedule, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.xs),

          // Ay Seçeneği (Ödeme Takvimi Altında)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedMonthYear,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      ref.read(selectedMonthProvider.notifier).state =
                          DateTime(selectedMonth.year, selectedMonth.month - 1);
                    },
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      ref.read(selectedMonthProvider.notifier).state =
                          DateTime(selectedMonth.year, selectedMonth.month + 1);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          if (filteredSchedules.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Center(
                child: Text(
                  l10n.paymentSchedule,
                  style: AppTypography.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            )
          else ...[
            if (pendingSchedules.isNotEmpty) ...[
              Text(l10n.paymentSchedule, style: AppTypography.labelLarge.copyWith(color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: AppSpacing.sm),
              _buildScheduleList(context, ref, pendingSchedules, currencySymbol),
              if (realizedSchedules.isNotEmpty) const SizedBox(height: AppSpacing.lg),
            ],
            if (realizedSchedules.isNotEmpty) ...[
              Text(l10n.realizedPayments, style: AppTypography.labelLarge.copyWith(color: Colors.grey, decoration: TextDecoration.lineThrough)),
              const SizedBox(height: AppSpacing.sm),
              _buildScheduleList(context, ref, realizedSchedules, currencySymbol),
            ],
          ],
        ],
      ),
    ));
  }

  Widget _buildScheduleList(BuildContext context, WidgetRef ref, List<PaymentScheduleModel> schedulesList, String currencySymbol) {
    final now = DateTime.now();
    final localeCode = Localizations.localeOf(context).toString();
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: schedulesList.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (context, index) {
        final s = schedulesList[index];
        final isOverdue = !s.isPaid && s.date.isBefore(DateTime(now.year, now.month, now.day));
        final color = s.isPaid
            ? Colors.grey
            : (isOverdue ? AppColors.error : (s.isIncome ? AppColors.success : AppColors.error));

        final formattedDate = DateFormat.MMMd(localeCode).format(s.date);

        return InkWell(
          onTap: () => PaymentScheduleBottomSheet.show(context, scheduleToEdit: s),
          borderRadius: AppRadius.borderMd,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: Checkbox(
                    value: s.isPaid,
                    onChanged: (val) {
                      if (val != null) {
                        final repo = ref.read(financeRepositoryProvider);
                        final familyId = ref.read(activeFamilyIdProvider);
                        repo.updatePaymentSchedule(familyId, s.id, {'isPaid': val});
                      }
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 3.5,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: AppRadius.borderFull,
                  ),
                ),
                const SizedBox(width: 8),

                // Başlık & Tarih / Hesap Adı Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              s.title,
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: s.isPaid ? TextDecoration.lineThrough : null,
                                color: s.isPaid ? colorScheme.onSurfaceVariant : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (s.recurringGroupId != null) ...[
                            const SizedBox(width: 4),
                            const Text('🔄', style: TextStyle(fontSize: 10)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        s.accountName != null && s.accountName!.isNotEmpty
                            ? '$formattedDate • ${s.accountName}'
                            : formattedDate,
                        style: AppTypography.labelSmall.copyWith(
                          color: isOverdue && !s.isPaid
                              ? AppColors.error
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isOverdue && !s.isPaid ? FontWeight.bold : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Tutar
                Text(
                  (s.isIncome ? '+' : '-') + _formatCurrency(s.amount, currencySymbol),
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: s.isPaid ? TextDecoration.lineThrough : null,
                    color: s.isPaid
                        ? colorScheme.onSurfaceVariant
                        : (s.isIncome ? AppColors.success : AppColors.error),
                  ),
                ),
                const SizedBox(width: 4),

                IconButton(
                  icon: Icon(Icons.close_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _handleDeleteSchedule(context, ref, s),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleDeleteSchedule(BuildContext context, WidgetRef ref, PaymentScheduleModel s) async {
    final repo = ref.read(financeRepositoryProvider);
    final familyId = ref.read(activeFamilyIdProvider);
    final l10n = AppLocalizations.of(context)!;

    if (s.recurringGroupId == null) {
      await repo.deletePaymentSchedule(familyId, s.id);
      return;
    }

    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.paymentSchedule),
        content: const Text('...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'single'),
            child: Text(l10n.confirm),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, 'future'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (choice == 'single') {
      await repo.deletePaymentSchedule(familyId, s.id);
    } else if (choice == 'future') {
      await repo.deleteRecurringPaymentSchedules(familyId, s.recurringGroupId!, s.date);
    }
  }
}
