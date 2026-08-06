import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../models/budget_model.dart';
import '../models/finance_item_model.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository();
});

class BudgetRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _budgetsRef(String familyId) {
    return _firestore.collection('families').doc(familyId).collection('budgets');
  }

  Stream<List<BudgetModel>> watchBudgets(String familyId) {
    return _budgetsRef(familyId).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => BudgetModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<void> setBudget(String familyId, BudgetModel budget) async {
    final querySnapshot = await _budgetsRef(familyId).get();

    final matchingDocs = querySnapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final catStr = data['category'] as String?;
      return FinanceCategory.fromString(catStr) == budget.category;
    }).toList();

    if (matchingDocs.isNotEmpty) {
      // 1. İlk dokümanı yeni varsayılan kategori key'i ve limit miktarı ile güncelle
      final mainDocId = matchingDocs.first.id;
      await _budgetsRef(familyId).doc(mainDocId).update({
        'category': budget.category.name,
        'limitAmount': budget.limitAmount,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 2. Eski/mükerrer kategorilere ait diğer dökümanları temizle
      for (int i = 1; i < matchingDocs.length; i++) {
        await _budgetsRef(familyId).doc(matchingDocs[i].id).delete();
      }
    } else {
      if (budget.limitAmount > 0) {
        // Yeni bütçe ekle
        await _budgetsRef(familyId).add(budget.toMap());
      }
    }
  }
}

final budgetsProvider = StreamProvider<List<BudgetModel>>((ref) {
  final familyId = ref.watch(activeFamilyIdProvider);
  if (familyId.isEmpty) return const Stream.empty();
  return ref.watch(budgetRepositoryProvider).watchBudgets(familyId);
});
