import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/date_picker_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/payment_schedule_model.dart';
import '../providers/finance_provider.dart';

import '../../../core/theme/app_colors.dart';

class PaymentScheduleBottomSheet extends ConsumerStatefulWidget {
  final PaymentScheduleModel? scheduleToEdit;

  const PaymentScheduleBottomSheet({super.key, this.scheduleToEdit});

  static Future<void> show(BuildContext context, {PaymentScheduleModel? scheduleToEdit}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentScheduleBottomSheet(scheduleToEdit: scheduleToEdit),
    );
  }

  @override
  ConsumerState<PaymentScheduleBottomSheet> createState() => _PaymentScheduleBottomSheetState();
}

class _PaymentScheduleBottomSheetState extends ConsumerState<PaymentScheduleBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _accountNameController;
  
  DateTime? _date;
  bool _isIncome = false; // true: Tahsilat (Gelir), false: Fatura (Gider)
  bool _isPaid = false;
  bool _isRecurring = false;
  int _recurringMonths = 12;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final sched = widget.scheduleToEdit;
    _titleController = TextEditingController(text: sched?.title ?? '');
    _amountController = TextEditingController(text: sched != null ? sched.amount.toStringAsFixed(0) : '');
    _accountNameController = TextEditingController(text: sched?.accountName ?? '');
    _date = sched?.date ?? DateTime.now();

    if (sched != null) {
      _isIncome = sched.isIncome;
      _isPaid = sched.isPaid;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _date == null) return;

    final familyId = ref.read(activeFamilyIdProvider);
    final user = ref.read(userProvider).valueOrNull;

    if (familyId.isEmpty || user == null) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(financeRepositoryProvider);
      final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
      final isEditing = widget.scheduleToEdit != null;

      if (isEditing) {
        final sched = widget.scheduleToEdit!;
        final updateData = {
          'title': _titleController.text.trim(),
          'amount': amount,
          'date': Timestamp.fromDate(_date!),
          'accountName': _accountNameController.text.trim().isNotEmpty ? _accountNameController.text.trim() : null,
          'isIncome': _isIncome,
          'isPaid': _isPaid,
        };

        if (sched.recurringGroupId != null) {
          final choice = await showDialog<String>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Tekrarlayan Ödeme'),
              content: const Text('Bu değişiklik nasıl uygulansın?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, 'single'),
                  child: const Text('Sadece Bu Kaydı'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, 'future'),
                  child: const Text('Gelecek Tüm Tekrarları'),
                ),
              ],
            ),
          );

          if (choice == null) {
            setState(() => _isLoading = false);
            return;
          }

          if (choice == 'future') {
            await repo.updateRecurringPaymentSchedules(
              familyId,
              sched.recurringGroupId!,
              sched.date,
              updateData,
            );
          } else {
            await repo.updatePaymentSchedule(familyId, sched.id, updateData);
          }
        } else {
          await repo.updatePaymentSchedule(familyId, sched.id, updateData);
        }
      } else {
        // Yeni Kayıt
        if (_isRecurring) {
          final groupId = DateTime.now().millisecondsSinceEpoch.toString();
          final List<PaymentScheduleModel> batchSchedules = [];

          for (int i = 0; i < _recurringMonths; i++) {
            // Ay artırma mantığı
            final year = _date!.year + ((_date!.month - 1 + i) ~/ 12);
            final month = ((_date!.month - 1 + i) % 12) + 1;
            // Ayın gün sayısını aşmamak için min gün hesabı
            final daysInMonth = DateTime(year, month + 1, 0).day;
            final day = _date!.day > daysInMonth ? daysInMonth : _date!.day;

            final targetDate = DateTime(year, month, day, _date!.hour, _date!.minute);

            batchSchedules.add(PaymentScheduleModel(
              id: '',
              familyId: familyId,
              title: _titleController.text.trim(),
              amount: amount,
              date: targetDate,
              accountName: _accountNameController.text.trim().isNotEmpty ? _accountNameController.text.trim() : null,
              isIncome: _isIncome,
              isPaid: _isPaid,
              recurringGroupId: groupId,
              createdBy: user.uid,
            ));
          }

          await repo.addPaymentScheduleBatch(familyId, batchSchedules);
        } else {
          final schedule = PaymentScheduleModel(
            id: '',
            familyId: familyId,
            title: _titleController.text.trim(),
            amount: amount,
            date: _date!,
            accountName: _accountNameController.text.trim().isNotEmpty ? _accountNameController.text.trim() : null,
            isIncome: _isIncome,
            isPaid: _isPaid,
            createdBy: user.uid,
          );
          await repo.addPaymentSchedule(familyId, schedule);
        }
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

  Future<void> _deleteSchedule() async {
    final sched = widget.scheduleToEdit;
    if (sched == null) return;

    final familyId = ref.read(activeFamilyIdProvider);
    if (familyId.isEmpty) return;

    String? choice = 'single';
    if (sched.recurringGroupId != null) {
      choice = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Tekrarlayan Kaydı Sil'),
          content: Text('"${sched.title}" ödeme kaydı silinecek. Nasıl uygulamak istersiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'single'),
              child: const Text('Sadece Bu Kaydı'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
              onPressed: () => Navigator.pop(ctx, 'future'),
              child: const Text('Gelecek Tüm Tekrarları Sil'),
            ),
          ],
        ),
      );
      if (choice == null) return;
    } else {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ödeme Kaydını Sil'),
          content: Text('"${sched.title}" kaydını silmek istediğinize emin misiniz?'),
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
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(financeRepositoryProvider);
      if (choice == 'future' && sched.recurringGroupId != null) {
        await repo.deleteRecurringPaymentSchedules(familyId, sched.recurringGroupId!, sched.date);
      } else {
        await repo.deletePaymentSchedule(familyId, sched.id);
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
                widget.scheduleToEdit != null ? 'Ödeme Kaydını Düzenle' : 'Ödeme Takvimine Ekle',
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Gelir/Gider Seçimi
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Fatura / Gider'),
                      value: false,
                      groupValue: _isIncome,
                      onChanged: (v) => setState(() => _isIncome = v!),
                      activeColor: Colors.red,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Tahsilat / Gelir'),
                      value: true,
                      groupValue: _isIncome,
                      onChanged: (v) => setState(() => _isIncome = v!),
                      activeColor: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _titleController,
                label: 'Başlık (örn: Elektrik Faturası, Kira)',
                validator: (val) => val == null || val.isEmpty ? 'Gerekli' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _amountController,
                      label: 'Tutar',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) => val == null || val.isEmpty ? 'Gerekli' : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DatePickerField(
                      label: 'Tarih',
                      selectedDate: _date,
                      onDateSelected: (date) => setState(() => _date = date),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _accountNameController,
                label: 'İlgili Banka / Hesap Adı (Opsiyonel)',
              ),
              const SizedBox(height: AppSpacing.md),

              // Ödendi / Tahsil Edildi durumu
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _isIncome ? 'Tahsil Edildi Olarak İşaretle' : 'Ödendi Olarak İşaretle',
                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                value: _isPaid,
                onChanged: (val) => setState(() => _isPaid = val),
                activeColor: _isIncome ? Colors.green : Colors.blue,
              ),
              const SizedBox(height: AppSpacing.sm),

              // Aylık Tekrarlansın (Sadece yeni eklerken)
              if (widget.scheduleToEdit == null) ...[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Aylık Tekrarlansın',
                    style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    _isRecurring ? 'Seçilen tarihten itibaren her ay otomatik eklenir.' : 'Tek seferlik ödeme.',
                    style: AppTypography.bodySmall,
                  ),
                  value: _isRecurring,
                  onChanged: (val) => setState(() => _isRecurring = val),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                if (_isRecurring) ...[
                  const SizedBox(height: AppSpacing.xs),
                  DropdownButtonFormField<int>(
                    value: _recurringMonths,
                    decoration: const InputDecoration(
                      labelText: 'Kaç Ay Sürecek?',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 2, child: Text('2 Ay')),
                      DropdownMenuItem(value: 3, child: Text('3 Ay')),
                      DropdownMenuItem(value: 6, child: Text('6 Ay')),
                      DropdownMenuItem(value: 12, child: Text('12 Ay (1 Yıl)')),
                      DropdownMenuItem(value: 18, child: Text('18 Ay')),
                      DropdownMenuItem(value: 24, child: Text('24 Ay (2 Yıl - Maks)')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _recurringMonths = val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],

              const SizedBox(height: AppSpacing.lg),

              PrimaryButton(
                onPressed: _isLoading ? () {} : _submit,
                text: widget.scheduleToEdit != null ? 'Kaydı Güncelle' : 'Takvime Ekle',
                isLoading: _isLoading,
              ),
              if (widget.scheduleToEdit != null) ...[
                const SizedBox(height: AppSpacing.md),
                TextButton.icon(
                  onPressed: _isLoading ? null : _deleteSchedule,
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                  label: const Text('Ödeme Kaydını Sil', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
        ),
      ),
    ));
  }
}
