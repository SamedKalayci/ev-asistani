import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Alışveriş listesine toplu ürün ekleme işlemlerini yöneten paylaşımlı servis kontratı.
///
/// Modüller arası (ör. `recipes` -> `shopping`) doğrudan import bağımlılıklarını önlemek
/// için bu soyut servis kullanılır.
abstract class ShoppingListService {
  Future<void> addBulkItems(List<String> items);
}

/// Paylaşımlı [ShoppingListService] sağlayıcısı.
///
/// Uygulama kökünde (`main.dart`) `shopping` modülünün implemantasyonu ile override edilir.
final shoppingListServiceProvider = Provider<ShoppingListService>((ref) {
  throw UnimplementedError('shoppingListServiceProvider henüz yapılandırılmadı.');
});
