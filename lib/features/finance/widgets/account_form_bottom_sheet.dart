import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/account_model.dart';
import '../providers/finance_provider.dart';

class AccountFormBottomSheet extends ConsumerStatefulWidget {
  final AccountModel? accountToEdit;

  const AccountFormBottomSheet({super.key, this.accountToEdit});

  static Future<void> show(BuildContext context, {AccountModel? accountToEdit}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AccountFormBottomSheet(accountToEdit: accountToEdit),
    );
  }

  @override
  ConsumerState<AccountFormBottomSheet> createState() => _AccountFormBottomSheetState();
}

class _AccountFormBottomSheetState extends ConsumerState<AccountFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _balanceController;
  late TextEditingController _bankNameController;
  late TextEditingController _cutoffDayController;
  late TextEditingController _limitController;

  AccountType _selectedType = AccountType.cash;
  String? _personType; // 'credit' or 'debt' for debtCredit
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final acc = widget.accountToEdit;
    _titleController = TextEditingController(text: acc?.title ?? '');
    _balanceController = TextEditingController(text: acc != null ? acc.balance.toStringAsFixed(0) : '');
    _bankNameController = TextEditingController(text: acc?.bankName ?? '');
    _cutoffDayController = TextEditingController(text: acc?.cutoffDay ?? '');
    _limitController = TextEditingController(text: acc?.limit != null ? acc!.limit!.toStringAsFixed(0) : '');

    if (acc != null) {
      _selectedType = acc.type;
      _personType = acc.personType;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _balanceController.dispose();
    _bankNameController.dispose();
    _cutoffDayController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == AccountType.debtCredit && _personType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen Alacak veya Borç durumunu seçin.')),
      );
      return;
    }

    final familyId = ref.read(activeFamilyIdProvider);
    final user = ref.read(userProvider).valueOrNull;

    if (familyId.isEmpty || user == null) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(financeRepositoryProvider);
      final balance = double.tryParse(_balanceController.text.replaceAll(',', '.')) ?? 0;
      final limit = _limitController.text.isNotEmpty ? double.tryParse(_limitController.text.replaceAll(',', '.')) : null;

      final isEditing = widget.accountToEdit != null;

      if (isEditing) {
        await repo.updateAccount(familyId, widget.accountToEdit!.id, {
          'title': _titleController.text.trim(),
          'type': _selectedType.name,
          'balance': balance,
          'bankName': _selectedType == AccountType.bank || _selectedType == AccountType.creditCard ? _bankNameController.text.trim() : null,
          'cutoffDay': _selectedType == AccountType.creditCard ? _cutoffDayController.text.trim() : null,
          'limit': limit,
          'personType': _selectedType == AccountType.debtCredit ? _personType : null,
        });
      } else {
        final account = AccountModel(
          id: '',
          familyId: familyId,
          title: _titleController.text.trim(),
          type: _selectedType,
          balance: balance,
          bankName: _selectedType == AccountType.bank || _selectedType == AccountType.creditCard ? _bankNameController.text.trim() : null,
          cutoffDay: _selectedType == AccountType.creditCard ? _cutoffDayController.text.trim() : null,
          limit: limit,
          personType: _selectedType == AccountType.debtCredit ? _personType : null,
          createdBy: user.uid,
        );
        await repo.addAccount(familyId, account);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hesabı Sil'),
        content: Text('"${widget.accountToEdit?.title}" hesabını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final familyId = ref.read(activeFamilyIdProvider);
    if (familyId.isEmpty || widget.accountToEdit == null) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(financeRepositoryProvider).deleteAccount(familyId, widget.accountToEdit!.id);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.xl,
          bottom: bottomInset > 0 ? bottomInset + AppSpacing.md : AppSpacing.xxl,
        ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: AppRadius.borderFull,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                widget.accountToEdit != null ? 'Hesabı Düzenle' : 'Yeni Hesap Ekle',
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Tür Seçimi
              Text('Hesap Türü', style: AppTypography.labelMedium),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                children: AccountType.values.map((type) {
                  final isSelected = _selectedType == type;
                  return ChoiceChip(
                    label: Text(type.label),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedType = type);
                    },
                    selectedColor: Theme.of(context).colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),

              AppTextField(
                controller: _titleController,
                label: 'Hesap Adı (örn: Cüzdan, Ahmet Amca)',
                validator: (val) => val == null || val.isEmpty ? 'Gerekli' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              
              AppTextField(
                controller: _balanceController,
                label: 'Bakiye / Tutar',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) => val == null || val.isEmpty ? 'Gerekli' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              if (_selectedType == AccountType.bank || _selectedType == AccountType.creditCard) ...[
                AppTextField(
                  controller: _bankNameController,
                  label: 'Banka Adı (Opsiyonel)',
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              if (_selectedType == AccountType.creditCard) ...[
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _limitController,
                        label: 'Limit',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        controller: _cutoffDayController,
                        label: 'Kesim Günü (örn: 29)',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              if (_selectedType == AccountType.debtCredit) ...[
                Text('Kişi Türü', style: AppTypography.labelMedium),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Alacaklıyım'),
                        value: 'credit',
                        groupValue: _personType,
                        onChanged: (v) => setState(() => _personType = v),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Borçluyum'),
                        value: 'debt',
                        groupValue: _personType,
                        onChanged: (v) => setState(() => _personType = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                onPressed: _isLoading ? () {} : _submit,
                text: widget.accountToEdit != null ? 'Hesabı Güncelle' : 'Hesabı Kaydet',
                isLoading: _isLoading,
              ),
              if (widget.accountToEdit != null) ...[
                const SizedBox(height: AppSpacing.md),
                TextButton.icon(
                  onPressed: _isLoading ? null : _deleteAccount,
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                  label: const Text('Hesabı Sil', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
        ),
      ),
    ));
  }
}
