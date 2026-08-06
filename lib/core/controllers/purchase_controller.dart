import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../providers/purchase_provider.dart';
import '../providers/user_provider.dart';
import '../services/ad_service.dart';

final purchaseControllerProvider = StateNotifierProvider<PurchaseController, bool>((ref) {
  return PurchaseController(ref);
});

/// RevenueCat satın alma ve geri yükleme işlemlerini yöneten Controller.
class PurchaseController extends StateNotifier<bool> {
  final Ref _ref;

  PurchaseController(this._ref) : super(false);

  /// Seçili paketi satın alır ve PRO statüsünü günceller.
  Future<bool> purchasePackage(Package package) async {
    state = true;
    try {
      final service = _ref.read(purchaseServiceProvider);
      final customerInfo = await service.purchasePackage(package);
      final isEntitled = service.hasActiveEntitlement(customerInfo);

      if (isEntitled) {
        await _applyProSuccess();
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    } finally {
      state = false;
    }
  }

  /// Geçmiş satın alımları geri yükler (Restore Purchases).
  Future<bool> restorePurchases() async {
    state = true;
    try {
      final service = _ref.read(purchaseServiceProvider);
      final customerInfo = await service.restorePurchases();
      final isEntitled = service.hasActiveEntitlement(customerInfo);

      if (isEntitled) {
        await _applyProSuccess();
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    } finally {
      state = false;
    }
  }

  /// Satın alma başarılı olduğunda local flag ve Firestore profillerini günceller.
  Future<void> _applyProSuccess() async {
    AdService.instance.setPremium(true);
    final user = _ref.read(userProvider).valueOrNull;
    if (user != null) {
      final firestoreService = _ref.read(firestoreServiceProvider);
      final familyId = _ref.read(activeFamilyIdProvider);

      await firestoreService.updateUserProfile(user.uid, {
        'isPremium': true,
        'premiumPurchasedAt': DateTime.now().toIso8601String(),
      });

      if (familyId.isNotEmpty) {
        await firestoreService.updateFamily(familyId, {
          'isPremium': true,
        });
      }
    }
    _ref.invalidate(customerInfoProvider);
  }
}
