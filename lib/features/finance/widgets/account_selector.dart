import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../models/account_model.dart';
import '../providers/finance_provider.dart';

/// Hesap / Ödeme Yöntemi seçici Dropdown.
/// Seçilen hesap [AccountModel] döner; "Belirtilmemiş" seçilirse null döner.
class AccountSelector extends ConsumerWidget {
  final AccountModel? selectedAccount;
  final ValueChanged<AccountModel?> onChanged;

  const AccountSelector({
    super.key,
    required this.selectedAccount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final accounts = accountsAsync.valueOrNull ?? [];
    final colorScheme = Theme.of(context).colorScheme;

    return DropdownButtonFormField<AccountModel?>(
      value: selectedAccount,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Hesap / Ödeme Yöntemi',
        labelStyle: AppTypography.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
        border: const OutlineInputBorder(borderRadius: AppRadius.borderMd),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        prefixIcon: Icon(
          Icons.account_balance_wallet_outlined,
          size: 18,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      items: [
        // "Belirtilmemiş" seçeneği
        DropdownMenuItem<AccountModel?>(
          value: null,
          child: Row(
            children: [
              Icon(Icons.remove_circle_outline_rounded,
                  size: 16, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Belirtilmemiş',
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        // Mevcut hesaplar
        ...accounts.map((account) {
          final icon = _iconForType(account.type);
          return DropdownMenuItem<AccountModel?>(
            value: account,
            child: Row(
              children: [
                Icon(icon, size: 16, color: colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    account.title,
                    style: AppTypography.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  account.type.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
      onChanged: onChanged,
    );
  }

  IconData _iconForType(AccountType type) {
    switch (type) {
      case AccountType.cash:
        return Icons.payments_outlined;
      case AccountType.bank:
        return Icons.account_balance_outlined;
      case AccountType.creditCard:
        return Icons.credit_card_rounded;
      case AccountType.debtCredit:
        return Icons.swap_horiz_rounded;
    }
  }
}
