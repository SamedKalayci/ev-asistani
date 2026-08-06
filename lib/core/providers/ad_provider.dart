import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ad_service.dart';
import 'user_provider.dart';
import '../../features/profile/providers/family_provider.dart';

/// [AdService] singleton'ını sunan provider.
final adServiceProvider = Provider<AdService>((ref) {
  return AdService.instance;
});

/// Aile Boyu PRO Üyelik sağlayıcısı.
///
/// Kullanıcının bireysel `isPremium` bayrağı VEYA
/// ailedeki herhangi bir üyenin `isPremium` bayrağı `true` ise `true` döner.
///
/// Bu provider Firestore'u gerçek zamanlı dinler; PRO satın alma anında
/// ve uygulama açılışında otomatik olarak doğru değeri yansıtır.
final isPremiumProvider = Provider<bool>((ref) {
  // 1. Bireysel PRO kontrolü
  final userAsync = ref.watch(userProvider);
  final userIsPremium = userAsync.whenOrNull(data: (u) => u?.isPremium) ?? false;

  // 2. Aile PRO kontrolü — families/{id}.isPremium alanı
  final familyAsync = ref.watch(currentFamilyProvider);
  final familyIsPremium =
      familyAsync.whenOrNull(data: (f) => f?.isPremium) ?? false;

  // 3. Aile üyelerinden herhangi biri PRO mu?
  final membersAsync = ref.watch(familyMembersProvider);
  final memberIsPremium = membersAsync.whenOrNull(
        data: (members) => members.any((m) => m.isPremium),
      ) ??
      false;

  final effective = userIsPremium || familyIsPremium || memberIsPremium;

  // AdService'in local flag'ini de senkronize et
  AdService.instance.setPremium(effective);

  return effective;
});
