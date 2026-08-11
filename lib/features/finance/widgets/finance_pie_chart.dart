import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/providers/currency_provider.dart';
import '../../../core/utils/l10n_helper.dart';
import '../../../l10n/app_localizations.dart';
import '../models/finance_item_model.dart';
import '../providers/finance_provider.dart';

class PieCategoryData {
  final FinanceCategory category;
  final String? customName;

  const PieCategoryData(this.category, this.customName);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PieCategoryData &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          customName == other.customName;

  @override
  int get hashCode => category.hashCode ^ customName.hashCode;

  String displayName(BuildContext context) {
    if (customName != null && customName!.isNotEmpty) {
      return customName!;
    }
    return category.localizedName(context);
  }

  IconData get icon {
    if (customName != null && customName!.isNotEmpty) {
      return Icons.star_outline_rounded;
    }
    return category.icon;
  }
}

/// Seçili aya ait Kategori Bazlı Harcama Pasta Grafiği + Legend Listesi.
class ExpensePieChartSummary extends ConsumerStatefulWidget {
  const ExpensePieChartSummary({super.key});

  @override
  ConsumerState<ExpensePieChartSummary> createState() =>
      _ExpensePieChartSummaryState();
}

class _ExpensePieChartSummaryState
    extends ConsumerState<ExpensePieChartSummary> {
  int _touchedIndex = -1;

  static const _categoryColors = [
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFFFF9800),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFFFF5722),
  ];

  String _fmt(double amount, String symbol) {
    final abs = amount.abs().toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < abs.length; i++) {
      if (i > 0 && (abs.length - i) % 3 == 0) buf.write('.');
      buf.write(abs[i]);
    }
    return '$symbol${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currencySymbol = ref.watch(currencySymbolProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final allItems = ref.watch(financeItemsProvider).valueOrNull ?? [];

    // Seçili aya ait cüzdan harcamaları
    final monthExpenses = allItems.where((i) {
      if (!i.isWalletExpense || i.type != FinanceType.expense) return false;
      if (i.dueDate == null) return true;
      return i.dueDate!.year == selectedMonth.year &&
          i.dueDate!.month == selectedMonth.month;
    }).toList();

    // Kategoriye göre topla
    final Map<PieCategoryData, double> categoryTotals = {};
    for (final item in monthExpenses) {
      final key = PieCategoryData(item.category, item.customCategoryName);
      categoryTotals[key] = (categoryTotals[key] ?? 0) + item.amount;
    }

    final l10n = AppLocalizations.of(context)!;

    final sorted = categoryTotals.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = sorted.fold(0.0, (s, e) => s + e.value);

    if (total <= 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(
          child: Text(
            l10n.noExpensesPeriod,
            style: AppTypography.bodyMedium
                .copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    // Pie sections
    final sections = sorted.asMap().entries.map((entry) {
      final index = entry.key;
      final amount = entry.value.value;
      final isTouched = index == _touchedIndex;
      final pct = amount / total * 100;

      return PieChartSectionData(
        color: _categoryColors[index % _categoryColors.length],
        value: amount,
        title: '${pct.toStringAsFixed(0)}%',
        radius: isTouched ? 70 : 56,
        titleStyle: AppTypography.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: isTouched ? 13 : 11,
        ),
        badgeWidget: null,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Başlık ──────────────────────────────────────────────────
        Row(
          children: [
            Icon(Icons.pie_chart_rounded,
                size: 18, color: colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              l10n.categoryDistribution,
              style: AppTypography.titleMedium
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // ── Pasta Grafiği ────────────────────────────────────────────
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      _touchedIndex = -1;
                      return;
                    }
                    _touchedIndex =
                        response.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              startDegreeOffset: -90,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Legend Listesi ────────────────────────────────────────────
        ...sorted.asMap().entries.map((entry) {
          final index = entry.key;
          final catData = entry.value.key;
          final amount = entry.value.value;
          final color = _categoryColors[index % _categoryColors.length];
          final pct = amount / total * 100;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                // Renk rozeti
                Container(
                  width: 36,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: AppRadius.borderSm,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${pct.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Kategori ikonu + adı
                Icon(catData.icon, size: 16, color: color),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    catData.displayName(context),
                    style: AppTypography.bodySmall
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                // Tutar
                Text(
                  _fmt(amount, currencySymbol),
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
