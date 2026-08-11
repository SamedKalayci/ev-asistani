import 'finance_item_model.dart';

class QuickNoteModel {
  final String id;
  final String title;
  final FinanceCategory category;

  const QuickNoteModel({
    required this.id,
    required this.title,
    required this.category,
  });

  factory QuickNoteModel.fromMap(Map<String, dynamic> map, String id) {
    return QuickNoteModel(
      id: id,
      title: map['title'] as String? ?? map['text'] as String? ?? '', // text is for backwards compatibility
      category: FinanceCategory.fromString(map['category'] as String?),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category.name,
    };
  }
}
