import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../models/vault_item_model.dart';
import '../repository/vault_repository.dart';

/// [VaultRepository] sağlayıcısı.
final vaultRepositoryProvider = Provider<VaultRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return VaultRepository(firestoreService);
});

/// Aktif ailenin Dijital Ev Kasası (Vault) dökümanlarını sunan StreamProvider.
final vaultItemsProvider = StreamProvider<List<VaultItemModel>>((ref) {
  final familyId = ref.watch(activeFamilyIdProvider);
  final repo = ref.watch(vaultRepositoryProvider);
  return repo.watchVaultItems(familyId);
});
