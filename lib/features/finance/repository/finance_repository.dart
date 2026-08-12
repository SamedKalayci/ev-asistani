import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firestore_service.dart';
import '../models/finance_item_model.dart';
import '../models/account_model.dart';
import '../models/payment_schedule_model.dart';

/// Finans & Nakit Akışı verilerinin Firestore işlemlerini yöneten repository.
class FinanceRepository {
  final FirestoreService _firestoreService;

  FinanceRepository(this._firestoreService);

  CollectionReference<Map<String, dynamic>> _financeRef(String familyId) =>
      _firestoreService.familiesRef.doc(familyId).collection('financeItems');

  CollectionReference<Map<String, dynamic>> _accountsRef(String familyId) =>
      _firestoreService.familiesRef.doc(familyId).collection('accounts');

  CollectionReference<Map<String, dynamic>> _schedulesRef(String familyId) =>
      _firestoreService.familiesRef.doc(familyId).collection('paymentSchedules');

  /// Aktif ailenin finans kalemlerini gerçek zamanlı dinler.
  Stream<List<FinanceItemModel>> watchFinanceItems(String familyId) {
    if (familyId.isEmpty) return Stream.value([]);

    return _financeRef(familyId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FinanceItemModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Yeni bir finans kalemi (Gelir / Gider) ekler.
  Future<void> addFinanceItem(String familyId, FinanceItemModel item) async {
    await _financeRef(familyId).add(item.toMap());
  }

  /// Mevcut bir finans kalemini günceller.
  Future<void> updateFinanceItem(
      String familyId, String itemId, Map<String, dynamic> data) async {
    await _financeRef(familyId).doc(itemId).update(data);
  }

  /// Bir finans kalemini siler.
  Future<void> deleteFinanceItem(String familyId, String itemId) async {
    await _financeRef(familyId).doc(itemId).delete();
  }

  // --- ACCOUNTS ---

  Stream<List<AccountModel>> watchAccounts(String familyId) {
    if (familyId.isEmpty) return Stream.value([]);
    return _accountsRef(familyId).orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AccountModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<void> addAccount(String familyId, AccountModel account) async {
    await _accountsRef(familyId).add(account.toMap());
  }

  Future<void> updateAccount(String familyId, String accountId, Map<String, dynamic> data) async {
    await _accountsRef(familyId).doc(accountId).update(data);
  }

  Future<void> deleteAccount(String familyId, String accountId) async {
    await _accountsRef(familyId).doc(accountId).delete();
  }

  // --- PAYMENT SCHEDULES ---

  Stream<List<PaymentScheduleModel>> watchPaymentSchedules(String familyId) {
    if (familyId.isEmpty) return Stream.value([]);
    return _schedulesRef(familyId).orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => PaymentScheduleModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<void> addPaymentSchedule(String familyId, PaymentScheduleModel schedule) async {
    await _schedulesRef(familyId).add(schedule.toMap());
  }

  Future<void> updatePaymentSchedule(String familyId, String scheduleId, Map<String, dynamic> data) async {
    await _schedulesRef(familyId).doc(scheduleId).update(data);
  }

  Future<void> deletePaymentSchedule(String familyId, String scheduleId) async {
    await _schedulesRef(familyId).doc(scheduleId).delete();
  }

  Future<void> toggleSchedulePaidStatus(String familyId, String scheduleId, bool currentStatus) async {
    await _schedulesRef(familyId).doc(scheduleId).update({'isPaid': !currentStatus});
  }

  Future<void> addPaymentScheduleBatch(String familyId, List<PaymentScheduleModel> schedules) async {
    final batch = _firestoreService.batch();
    for (var schedule in schedules) {
      final docRef = _schedulesRef(familyId).doc();
      batch.set(docRef, schedule.toMap());
    }
    await batch.commit();
  }

  Future<void> updateRecurringPaymentSchedules(
    String familyId,
    String recurringGroupId,
    DateTime fromDate,
    Map<String, dynamic> data,
  ) async {
    final snapshot = await _schedulesRef(familyId)
        .where('recurringGroupId', isEqualTo: recurringGroupId)
        .get();

    // Gelecekteki kayıtların kendi tarihlerini korumak için updateData'dan 'date' alanını çıkarıyoruz
    final updateData = Map<String, dynamic>.from(data)..remove('date');

    final batch = _firestoreService.batch();
    for (var doc in snapshot.docs) {
      final docDate = (doc.data()['date'] as Timestamp).toDate();
      if (docDate.isAfter(fromDate) || docDate.isAtSameMomentAs(fromDate)) {
        batch.update(doc.reference, updateData);
      }
    }
    await batch.commit();
  }

  Future<void> deleteRecurringPaymentSchedules(
    String familyId,
    String recurringGroupId,
    DateTime fromDate,
  ) async {
    final snapshot = await _schedulesRef(familyId)
        .where('recurringGroupId', isEqualTo: recurringGroupId)
        .get();

    final batch = _firestoreService.batch();
    for (var doc in snapshot.docs) {
      final docDate = (doc.data()['date'] as Timestamp).toDate();
      if (docDate.isAfter(fromDate) || docDate.isAtSameMomentAs(fromDate)) {
        batch.delete(doc.reference);
      }
    }
    await batch.commit();
  }
}
