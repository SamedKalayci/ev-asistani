import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../models/finance_item_model.dart';
import '../models/account_model.dart';
import '../models/payment_schedule_model.dart';
import '../repository/finance_repository.dart';

/// [FinanceRepository] sağlayıcısı.
final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return FinanceRepository(firestoreService);
});

/// Aktif ailenin tüm finans kalemlerini sunan ve tarihe göre sıralayan StreamProvider.
final financeItemsProvider = StreamProvider<List<FinanceItemModel>>((ref) {
  final familyId = ref.watch(activeFamilyIdProvider);
  final repo = ref.watch(financeRepositoryProvider);

  return repo.watchFinanceItems(familyId).map((items) {
    final list = List<FinanceItemModel>.from(items);
    list.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return list;
  });
});

/// Sadece Gider kalemlerini döner (Yaklaşan ödeme tarihine göre sıralı).
final expensesProvider = Provider<List<FinanceItemModel>>((ref) {
  final itemsAsync = ref.watch(financeItemsProvider);
  final items = itemsAsync.valueOrNull ?? [];
  return items.where((item) => item.type == FinanceType.expense).toList();
});

/// Sadece Gelir kalemlerini döner (Tarihe göre sıralı).
final incomesProvider = Provider<List<FinanceItemModel>>((ref) {
  final itemsAsync = ref.watch(financeItemsProvider);
  final items = itemsAsync.valueOrNull ?? [];
  return items.where((item) => item.type == FinanceType.income).toList();
});

/// Seçili Ayın Toplam Geliri (Ödeme Takvimi'ndeki isIncome == true kalemler)
final monthlyIncomeProvider = Provider<double>((ref) {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final schedules = ref.watch(paymentSchedulesProvider).valueOrNull ?? [];
  return schedules
      .where((s) => s.isIncome && s.date.year == selectedMonth.year && s.date.month == selectedMonth.month)
      .fold(0.0, (sum, s) => sum + s.amount);
});

/// Seçili Ayın Toplam Gideri (Ödeme Takvimi Giderleri + Ev Cüzdanı Harcamaları)
final monthlyExpenseProvider = Provider<double>((ref) {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final schedules = ref.watch(paymentSchedulesProvider).valueOrNull ?? [];
  final scheduleExpenses = schedules
      .where((s) => !s.isIncome && s.date.year == selectedMonth.year && s.date.month == selectedMonth.month)
      .fold(0.0, (sum, s) => sum + s.amount);

  final walletItems = ref.watch(financeItemsProvider).valueOrNull ?? [];
  final walletExpenses = walletItems
      .where((i) => i.isWalletExpense && i.type == FinanceType.expense && (i.dueDate == null || (i.dueDate!.year == selectedMonth.year && i.dueDate!.month == selectedMonth.month)))
      .fold(0.0, (sum, i) => sum + i.amount);

  return scheduleExpenses + walletExpenses;
});

/// Seçili Ayın Toplam Bireysel Harcaması (Ev Cüzdanı Harcamaları)
final monthlyPersonalExpenseProvider = Provider<double>((ref) {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final walletItems = ref.watch(financeItemsProvider).valueOrNull ?? [];
  return walletItems
      .where((i) =>
          i.isWalletExpense &&
          i.type == FinanceType.expense &&
          (i.dueDate == null ||
              (i.dueDate!.year == selectedMonth.year &&
                  i.dueDate!.month == selectedMonth.month)))
      .fold(0.0, (sum, i) => sum + i.amount);
});

/// Aylık Serbest Bütçe (Kalan Bütçe) provider: (Aylık Gelir - Aylık Gider)
final monthlyFreeBudgetProvider = Provider<double>((ref) {
  final income = ref.watch(monthlyIncomeProvider);
  final expense = ref.watch(monthlyExpenseProvider);
  return income - expense;
});

/// Hesapları dinleyen StreamProvider.
final accountsProvider = StreamProvider<List<AccountModel>>((ref) {
  final familyId = ref.watch(activeFamilyIdProvider);
  final repo = ref.watch(financeRepositoryProvider);
  return repo.watchAccounts(familyId);
});

/// Ödeme takvimini dinleyen StreamProvider.
final paymentSchedulesProvider = StreamProvider<List<PaymentScheduleModel>>((ref) {
  final familyId = ref.watch(activeFamilyIdProvider);
  final repo = ref.watch(financeRepositoryProvider);
  return repo.watchPaymentSchedules(familyId);
});

/// Ödeme Takvimi Ay Seçici için aktif seçili ay provider'ı.
final selectedMonthProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// Seçili ayın net Gelir - Gider dengesini hesaplayan provider.
final totalNetWorthProvider = Provider<double>((ref) {
  final income = ref.watch(monthlyIncomeProvider);
  final expense = ref.watch(monthlyExpenseProvider);
  return income - expense;
});
