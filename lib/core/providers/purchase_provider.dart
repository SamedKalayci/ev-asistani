import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/purchase_service.dart';
import 'ad_provider.dart';

/// PurchaseService singleton provider.
final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return PurchaseService.instance;
});

/// RevenueCat CustomerInfo yayıncısı.
final customerInfoProvider = FutureProvider<CustomerInfo?>((ref) async {
  final service = ref.watch(purchaseServiceProvider);
  return await service.getCustomerInfo();
});

/// Kullanıcının PRO / Reklamsız durumunu dinleyen temel Riverpod provider (`isProUserProvider`).
final isProUserProvider = Provider<bool>((ref) {
  return ref.watch(isAdFreeProvider);
});
