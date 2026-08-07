import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../models/finance_item_model.dart';
import '../models/payment_schedule_model.dart';
import '../providers/finance_provider.dart';

class MonthlySummaryBottomSheet extends ConsumerStatefulWidget {
  const MonthlySummaryBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MonthlySummaryBottomSheet(),
    );
  }

  @override
  ConsumerState<MonthlySummaryBottomSheet> createState() => _MonthlySummaryBottomSheetState();
}

class _MonthlySummaryBottomSheetState extends ConsumerState<MonthlySummaryBottomSheet> {
  int _selectedPeriodIndex = 1; // 0: Yıllık, 1: Aylık, 2: Haftalık, 3: Günlük

  String _formatCurrency(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs().toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < absAmount.length; i++) {
      if (i > 0 && (absAmount.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(absAmount[i]);
    }
    return '${isNegative ? '-' : ''}₺${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedMonth = ref.watch(selectedMonthProvider);

    final schedulesAsync = ref.watch(paymentSchedulesProvider);
    final schedules = schedulesAsync.valueOrNull ?? [];

    final financeItemsAsync = ref.watch(financeItemsProvider);
    final walletItems = (financeItemsAsync.valueOrNull ?? []).where((i) => i.isWalletExpense).toList();

    // Dönem Filtrelemesi
    List<PaymentScheduleModel> filteredSchedules = [];
    List<FinanceItemModel> filteredWalletExpenses = [];

    final now = DateTime.now();

    if (_selectedPeriodIndex == 0) {
      // Yıllık
      filteredSchedules = schedules.where((s) => s.date.year == selectedMonth.year).toList();
      filteredWalletExpenses = walletItems
          .where((i) => i.dueDate == null || i.dueDate!.year == selectedMonth.year)
          .toList();
    } else if (_selectedPeriodIndex == 1) {
      // Aylık
      filteredSchedules = schedules
          .where((s) => s.date.year == selectedMonth.year && s.date.month == selectedMonth.month)
          .toList();
      filteredWalletExpenses = walletItems
          .where((i) => i.dueDate == null || (i.dueDate!.year == selectedMonth.year && i.dueDate!.month == selectedMonth.month))
          .toList();
    } else if (_selectedPeriodIndex == 2) {
      // Haftalık (Sadece Bu Hafta: Pazartesi - Pazar)
      final today = DateTime(now.year, now.month, now.day);
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

      filteredSchedules = schedules.where((s) {
        final sDate = DateTime(s.date.year, s.date.month, s.date.day);
        return !sDate.isBefore(startOfWeek) && !sDate.isAfter(endOfWeek);
      }).toList();

      filteredWalletExpenses = walletItems.where((i) {
        if (i.dueDate == null) return false;
        final iDate = DateTime(i.dueDate!.year, i.dueDate!.month, i.dueDate!.day);
        return !iDate.isBefore(startOfWeek) && !iDate.isAfter(endOfWeek);
      }).toList();
    } else {
      // Günlük (Bugün)
      final today = DateTime(now.year, now.month, now.day);
      filteredSchedules = schedules.where((s) {
        final sDate = DateTime(s.date.year, s.date.month, s.date.day);
        return sDate.isAtSameMomentAs(today);
      }).toList();

      filteredWalletExpenses = walletItems.where((i) {
        if (i.dueDate == null) return false;
        final iDate = DateTime(i.dueDate!.year, i.dueDate!.month, i.dueDate!.day);
        return iDate.isAtSameMomentAs(today);
      }).toList();
    }

    final incomeSchedules = filteredSchedules.where((s) => s.isIncome).toList();
    final expenseSchedules = filteredSchedules.where((s) => !s.isIncome).toList();

    final totalIncome = incomeSchedules.fold(0.0, (sum, s) => sum + s.amount);
    final totalScheduleExpense = expenseSchedules.fold(0.0, (sum, s) => sum + s.amount);
    final totalWalletExpense = filteredWalletExpenses.where((i) => i.type == FinanceType.expense).fold(0.0, (sum, i) => sum + i.amount);
    final totalExpense = totalScheduleExpense + totalWalletExpense;

    final netProfit = totalIncome - totalExpense;

    final pendingSchedules = filteredSchedules.where((s) => !s.isPaid).toList();
    // Sort pending schedules by date
    pendingSchedules.sort((a, b) => a.date.compareTo(b.date));

    // Combine realized items for recent transactions feed
    final List<dynamic> recentTransactions = [];
    recentTransactions.addAll(filteredSchedules.where((s) => s.isPaid));
    recentTransactions.addAll(filteredWalletExpenses);
    
    // Sort by date (descending)
    recentTransactions.sort((a, b) {
      final dateA = (a is PaymentScheduleModel) ? a.date : ((a as dynamic).dueDate ?? (a as dynamic).createdAt ?? now);
      final dateB = (b is PaymentScheduleModel) ? b.date : ((b as dynamic).dueDate ?? (b as dynamic).createdAt ?? now);
      return dateB.compareTo(dateA); // newest first
    });

    final limitedTransactions = recentTransactions.take(15).toList();

    String periodTitle = "Net Durum";
    if (_selectedPeriodIndex == 0) periodTitle = "Yıllık Net Durum";
    if (_selectedPeriodIndex == 1) periodTitle = "Aylık Net Durum";
    if (_selectedPeriodIndex == 2) periodTitle = "Haftalık Net Durum";
    if (_selectedPeriodIndex == 3) periodTitle = "Günlük Net Durum";

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.80),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Üst Sürükleme Çubuğu & Kapatma (X) Butonu ──
          Row(
            children: [
              const SizedBox(width: 40), // Kapat butonuna simetri sağlamak için
              Expanded(
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: AppRadius.borderFull,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
                tooltip: 'Kapat',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),

          Text(
            '📊 Finansal Durum',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),

          // ── İçerik Alanı (Kendi içinde kaydırılabilir) ──
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

            // ── Dönem Filtresi (SegmentedButton) ─────────────────────────
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Yıllık')),
                ButtonSegment(value: 1, label: Text('Aylık')),
                ButtonSegment(value: 2, label: Text('Haftalık')),
                ButtonSegment(value: 3, label: Text('Günlük')),
              ],
              selected: {_selectedPeriodIndex},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() => _selectedPeriodIndex = newSelection.first);
              },
              style: SegmentedButton.styleFrom(
                selectedForegroundColor: colorScheme.onPrimary,
                selectedBackgroundColor: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Ana Özet Kartı ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: AppRadius.borderXl,
                boxShadow: AppShadows.md,
                border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(periodTitle.toUpperCase(), style: AppTypography.labelMedium.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _formatCurrency(netProfit),
                    style: AppTypography.displayMedium.copyWith(
                      color: netProfit >= 0 ? const Color(0xFF10B981) : AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.05),
                            borderRadius: AppRadius.borderLg,
                            border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.arrow_upward_rounded, size: 16, color: Colors.blue),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text('Toplam Gelir', style: AppTypography.labelSmall.copyWith(color: Colors.blue, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(_formatCurrency(totalIncome), style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold, color: Colors.blue)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.05),
                            borderRadius: AppRadius.borderLg,
                            border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.arrow_downward_rounded, size: 16, color: AppColors.error),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text('Toplam Gider', style: AppTypography.labelSmall.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(_formatCurrency(totalExpense), style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.error)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // ── Bekleyen İşlemler ──────────────────────────────────────────
            if (pendingSchedules.isNotEmpty) ...[
              Text('Yaklaşan Bekleyen İşlemler', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: pendingSchedules.length,
                  separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = pendingSchedules[index];
                    final isIncome = item.isIncome;
                    return Container(
                      width: 220,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isIncome ? Colors.blue.withValues(alpha: 0.05) : Colors.orange.withValues(alpha: 0.05),
                        borderRadius: AppRadius.borderLg,
                        border: Border.all(color: isIncome ? Colors.blue.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isIncome ? Colors.blue.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                              borderRadius: AppRadius.borderMd,
                            ),
                            child: Icon(
                              isIncome ? Icons.download_rounded : Icons.warning_amber_rounded,
                              size: 20,
                              color: isIncome ? Colors.blue : Colors.orange,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.title,
                                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  isIncome ? "Gelecek Gelir" : "Yaklaşan Ödeme",
                                  style: AppTypography.labelSmall.copyWith(color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatCurrency(item.amount),
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isIncome ? Colors.blue : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],

            // ── Son İşlemler / Harcamalar ──────────────────────────────────────────
            Text('Son İşlemler', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.md),
            if (limitedTransactions.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: Text('Bu dönemde gerçekleşen işlem yok.', style: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant)),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: limitedTransactions.length,
                separatorBuilder: (_, _) => Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                itemBuilder: (context, index) {
                  final item = limitedTransactions[index];
                  if (item is PaymentScheduleModel) {
                    return _buildTransactionTile(
                      context,
                      title: item.title,
                      subtitle: item.accountName ?? "Ödeme Takvimi",
                      amount: item.amount,
                      isIncome: item.isIncome,
                      date: item.date,
                      icon: item.isIncome ? Icons.account_balance_wallet_rounded : Icons.payments_rounded,
                    );
                  } else if (item is FinanceItemModel) {
                    final date = item.dueDate ?? item.createdAt ?? now;
                    return _buildTransactionTile(
                      context,
                      title: item.title,
                      subtitle: item.category.label,
                      amount: item.amount,
                      isIncome: item.type == FinanceType.income,
                      date: date,
                      icon: item.category.icon,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    ),
  ],
),
    );
  }

  Widget _buildTransactionTile(BuildContext context, {
    required String title,
    required String subtitle,
    required double amount,
    required bool isIncome,
    required DateTime date,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = isIncome ? const Color(0xFF10B981) : AppColors.error;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: AppRadius.borderMd,
            ),
            child: Icon(icon, size: 20, color: colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${DateFormat('d MMM', 'tr_TR').format(date)} • $subtitle',
                  style: AppTypography.labelSmall.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            (isIncome ? '+' : '-') + _formatCurrency(amount),
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
