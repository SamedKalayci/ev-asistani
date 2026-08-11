import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../models/finance_item_model.dart';
import '../models/quick_note_model.dart';

/// Firestore `families/{familyId}/quickNotes` koleksiyonunu izler.
/// Her döküman: { title: String, category: String, createdAt: Timestamp }
final quickNotesProvider = StreamProvider<List<QuickNoteModel>>((ref) {
  final familyId = ref.watch(activeFamilyIdProvider);
  if (familyId.isEmpty) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('families')
      .doc(familyId)
      .collection('quickNotes')
      .orderBy('createdAt', descending: false)
      .snapshots()
      .map((snap) => snap.docs
          .map((d) => QuickNoteModel.fromMap(d.data(), d.id))
          .where((n) => n.title.isNotEmpty)
          .toList());
});

/// Yeni bir hazır not/şablon ekler.
Future<void> addQuickNote(String familyId, String title, FinanceCategory category) async {
  final trimmedTitle = title.trim();
  if (familyId.isEmpty || trimmedTitle.isEmpty) return;

  final query = await FirebaseFirestore.instance
      .collection('families')
      .doc(familyId)
      .collection('quickNotes')
      .get();

  // Büyük/küçük harf duyarsız başlık kontrolü yap
  final existingDoc = query.docs.where((doc) {
    final docTitle = (doc.data()['title'] as String? ?? doc.data()['text'] as String? ?? '').trim();
    return docTitle.toLowerCase() == trimmedTitle.toLowerCase();
  }).firstOrNull;

  if (existingDoc != null) {
    // Varsa kategoriyi güncelle ve zaman damgasını yenile
    await existingDoc.reference.update({
      'category': category.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  } else {
    // Yoksa yeni oluştur
    await FirebaseFirestore.instance
        .collection('families')
        .doc(familyId)
        .collection('quickNotes')
        .add({
      'title': trimmedTitle,
      'category': category.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

/// Id'si eşleşen hazır notu/şablonu siler.
Future<void> deleteQuickNote(String familyId, String noteId) async {
  if (familyId.isEmpty || noteId.isEmpty) return;
  await FirebaseFirestore.instance
      .collection('families')
      .doc(familyId)
      .collection('quickNotes')
      .doc(noteId)
      .delete();
}
