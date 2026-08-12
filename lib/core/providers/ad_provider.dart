import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/ad_service.dart';
import 'purchase_provider.dart';
import 'user_provider.dart';
import '../../features/profile/providers/family_provider.dart';

/// Aile bazlı reklamsız mod durumunu dinleyen provider.
///
/// Öncelik sırası:
///  1. Kullanıcının bağlı olduğu aile Firestore dokümanındaki `isAdFree == true`
///  2. RevenueCat entitlement aktifse (ağ erişimi olduğunda)
///  3. Aile yoksa, anonim/yeni kullanıcıysa → false (reklamlar gösterilir)
///
/// SharedPreferences tamamen kaldırıldı; durum artık cihaza değil aileye bağlı.
final isAdFreeProvider = StateNotifierProvider<_AdFreeNotifier, bool>((ref) {
  return _AdFreeNotifier(ref);
});

class _AdFreeNotifier extends StateNotifier<bool> {
  _AdFreeNotifier(this._ref) : super(false) {
    _init();
  }

  final Ref _ref;

  void _init() {
    // Aktif ailenin Firestore verisini gerçek zamanlı dinle
    _ref.listen<AsyncValue<dynamic>>(currentFamilyProvider, (_, next) {
      final family = next.valueOrNull;
      if (family == null) {
        // Aile yok (anonim veya yeni kullanıcı) → reklamlar gösterilir
        _update(false);
        return;
      }
      _update((family.isAdFree as bool?) ?? false);
    }, fireImmediately: true);

    // RevenueCat müşteri bilgilerini de dinle (entitlement yenileme için)
    _ref.listen<AsyncValue<CustomerInfo?>>(customerInfoProvider, (_, next) {
      final customerInfo = next.value;
      if (customerInfo != null) {
        final activeEntitlements = customerInfo.entitlements.all;
        final hasEntitlement =
            (activeEntitlements['remove_ads']?.isActive ?? false) ||
            (activeEntitlements['pro']?.isActive ?? false) ||
            (activeEntitlements['premium']?.isActive ?? false);
        if (hasEntitlement && !state) {
          // RC entitlement aktifse Firestore'a da yaz
          setAdFreeForFamily();
        }
      }
    });
  }

  void _update(bool value) {
    if (state != value) {
      state = value;
      AdService.instance.setPremium(value);
    }
  }

  /// Satın alma sonrası çağrılır: Firestore'daki aile dokümanına isAdFree=true yazar.
  /// Bu sayede tüm aile üyeleri anlık olarak reklamsız moda geçer.
  Future<void> setAdFreeForFamily() async {
    try {
      final familyId = _ref.read(activeFamilyIdProvider);
      if (familyId.isEmpty) {
        // Aile yoksa hiçbir şey yapma (anonim kullanıcı)
        return;
      }
      final firestoreService = _ref.read(firestoreServiceProvider);
      await firestoreService.updateFamily(familyId, {'isAdFree': true});
      // Firestore stream otomatik güncelleyecek; elle _update gerekmez
    } catch (e) {
      // Firestore yazma hatası; state güncellenmez, kullanıcı tekrar deneyebilir
    }
  }
}

/// Aile Boyu PRO / Reklamsız Üyelik sağlayıcısı.
/// isAdFreeProvider durumunu dinler (Abonelik varsa true, yoksa false döner).
final isPremiumProvider = Provider<bool>((ref) {
  return ref.watch(isAdFreeProvider);
});

/// [AdService] singleton'ını sunan provider.
final adServiceProvider = Provider<AdService>((ref) {
  return AdService.instance;
});
