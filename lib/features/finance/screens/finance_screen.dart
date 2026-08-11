import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/purchase_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/no_family_empty_state.dart';
import '../../../shared/widgets/pro_blur_overlay.dart';
import '../providers/finance_provider.dart';
import '../widgets/account_form_bottom_sheet.dart';
import '../widgets/accounts_overview_view.dart';
import '../widgets/household_wallet_view.dart';
import '../widgets/monthly_summary_bottom_sheet.dart';
import '../widgets/payment_schedule_bottom_sheet.dart';
import '../widgets/quick_add_expense_bottom_sheet.dart';

class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});

  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final hasFamily = ref.watch(hasRealFamilyProvider);
    final isPremium = ref.watch(isProUserProvider);
    final financeItemsAsync = ref.watch(financeItemsProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);

    if (!hasFamily) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppHeader(title: l10n.appName),
        body: const SafeArea(child: NoFamilyEmptyState()),
      );
    }

    final localeCode = Localizations.localeOf(context).toString();
    final formattedMonthYear = DateFormat.yMMMM(localeCode).format(selectedMonth);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(title: l10n.appName),
      floatingActionButton: isPremium
          ? FloatingActionButton.extended(
              onPressed: () {
                final selectedMainTab = ref.read(financeTabProvider);
                if (selectedMainTab == 0) {
                  // Hesap / Takvim menüsü
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.account_balance_wallet),
                            title: Text(l10n.accountsTab),
                            onTap: () {
                              Navigator.pop(ctx);
                              AccountFormBottomSheet.show(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.calendar_month),
                            title: Text(l10n.paymentSchedule),
                            onTap: () {
                              Navigator.pop(ctx);
                              PaymentScheduleBottomSheet.show(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Ev Cüzdanı -> Harcama Gir
                  QuickAddExpenseBottomSheet.show(context);
                }
              },
              icon: const Icon(Icons.add_rounded),
              label: Text(ref.watch(financeTabProvider) == 0 ? l10n.accountScheduleHeader : l10n.quickAddExpense),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            )
          : null,
      body: ProBlurOverlay(
        isLocked: !isPremium,
        title: l10n.financeManagementPro,
        subtitle: l10n.financeProDesc,
        child: Column(
          children: [
            // ── Üst Menü (SegmentedControl) ──
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SegmentedButton<int>(
                      segments: [
                        ButtonSegment(
                          value: 0,
                          label: Text(l10n.financeOverviewTab),
                        ),
                        ButtonSegment(
                          value: 1,
                          label: Text(l10n.householdWalletTab),
                        ),
                      ],
                      selected: {ref.watch(financeTabProvider)},
                      onSelectionChanged: (Set<int> newSelection) {
                        ref.read(financeTabProvider.notifier).state = newSelection.first;
                      },
                      style: SegmentedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        selectedForegroundColor: colorScheme.onPrimary,
                        selectedBackgroundColor: colorScheme.primary,
                        side: BorderSide(
                          color: colorScheme.primary.withValues(alpha: 0.5),
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.borderLg,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Genel Ay Seçici & "Özet Gör" Butonu Barı ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
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
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            formattedMonthYear,
                            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: AppSpacing.xs),
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
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  ActionChip(
                    avatar: const Icon(Icons.bar_chart_rounded, size: 18, color: Colors.indigo),
                    label: Text(l10n.summary, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                    backgroundColor: Colors.indigo.withValues(alpha: 0.1),
                    side: BorderSide(color: Colors.indigo.withValues(alpha: 0.3)),
                    shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderFull),
                    onPressed: () => MonthlySummaryBottomSheet.show(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),

            // ── İçerik Alanı ──
            Expanded(
              child: ref.watch(financeTabProvider) == 0
                  ? const AccountsOverviewView()
                  : HouseholdWalletView(
                      monthItems: financeItemsAsync.valueOrNull ?? []),
            ),
          ],
        ),
      ),
    );
  }
}
