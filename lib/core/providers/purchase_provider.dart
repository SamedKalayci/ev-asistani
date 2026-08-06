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

/// Kullanıcının PRO durumunu dinleyen temel Riverpod provider (`isProUserProvider`).
///
/// 1. RevenueCat 'pro' / 'premium' active entitlement kontrolü
/// 2. Firestore `isPremiumProvider` (Bireysel + Aile PRO) kontrolü
final isProUserProvider = Provider<bool>((ref) {
  final customerInfoAsync = ref.watch(customerInfoProvider);
  final revenueCatPro = customerInfoAsync.valueOrNull != null
      ? PurchaseService.instance.hasActiveEntitlement(customerInfoAsync.valueOrNull)
      : false;

  final firestorePro = ref.watch(isPremiumProvider);

  return revenueCatPro || firestorePro;
});
