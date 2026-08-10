import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/purchase_service.dart';

/// PurchaseService singleton provider.
final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return PurchaseService.instance;
});

/// RevenueCat CustomerInfo yayıncısı.
final customerInfoProvider = FutureProvider<CustomerInfo?>((ref) async {
  final service = ref.watch(purchaseServiceProvider);
  return await service.getCustomerInfo();
});

/// Kullanıcının PRO durumunu dinleyen temel Riverpod provider (`isProUserProvider`).
/// Tüm özellik kısıtlamalarını kaldırdığımız için artık her zaman true döner.
final isProUserProvider = Provider<bool>((ref) {
  return true;
});
