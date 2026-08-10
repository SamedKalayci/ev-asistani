import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/vault_item_model.dart';
import '../providers/vault_provider.dart';

/// 📞 Servis & Acil Numaralar Detay Ekranı.
class VaultContactsScreen extends ConsumerWidget {
  const VaultContactsScreen({super.key});

  /// Ekleme veya Düzenleme (Edit) modalı.
  static Future<void> showContactModal(
    BuildContext context,
    WidgetRef ref, {
    VaultItemModel? item,
  }) {
    final isEditing = item != null;
    final titleController = TextEditingController(text: item?.title ?? '');
    final roleController = TextEditingController(text: item?.description ?? '');
    final phoneController = TextEditingController(text: item?.phoneNumber ?? '');
    final formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.surfaceContainerLowest,
            borderRadius: AppRadius.borderTopXl,
          ),
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xl + bottomInset,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(ctx).colorScheme.outlineVariant,
                        borderRadius: AppRadius.borderFull,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Center(
                    child: Text(
                      isEditing
                          ? 'İletişim / Servis Numarasını Düzenle'
                          : 'Yeni İletişim / Servis Numarası Ekle',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: 'İsim / Kişi Adı',
                    hintText: 'Örn: Tesisatçı Ahmet Usta, Site Yönetimi',
                    controller: titleController,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'İsim zorunludur.' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Unvan / Kategori',
                    hintText: 'Örn: Su Tesisatı, Elektrik, Çilingir, Yönetim',
                    controller: roleController,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Telefon Numarası',
                    hintText: 'Örn: 0555 123 45 67',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Telefon zorunludur.' : null,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(
                    text: isEditing ? 'Numarayı Güncelle' : 'Numarayı Kaydet',
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final familyId = ref.read(activeFamilyIdProvider);
                      final user = ref.read(userProvider).valueOrNull;

                      if (familyId.isNotEmpty && user != null) {
                        final repo = ref.read(vaultRepositoryProvider);
                        if (isEditing) {
                          await repo.updateVaultItem(familyId, item.id, {
                            'title': titleController.text.trim(),
                            'description': roleController.text.trim(),
                            'phoneNumber': phoneController.text.trim(),
                          });
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Numara güncellendi! ✅')),
                            );
                          }
                        } else {
                          final newItem = VaultItemModel(
                            id: '',
                            familyId: familyId,
                            category: 'emergency',
                            title: titleController.text.trim(),
                            description: roleController.text.trim(),
                            phoneNumber: phoneController.text.trim(),
                            createdBy: user.uid,
                          );
                          await repo.addVaultItem(familyId, newItem);
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Yeni numara eklendi! ✅')),
                            );
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Telefon Arama İşlevi (Native Phone Call with Fallback)
  Future<void> _makeCall(BuildContext context, String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: cleanPhone,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        if (context.mounted) {
          Clipboard.setData(ClipboardData(text: phone));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Arama başlatılamadı, telefon kopyalandı! 📋 ($phone)'),
            ),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        Clipboard.setData(ClipboardData(text: phone));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Telefon kopyalandı: $phone'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final vaultItemsAsync = ref.watch(vaultItemsProvider);

    final items = (vaultItemsAsync.valueOrNull ?? [])
        .where((item) => item.category == 'emergency')
        .toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(
        title: '📞 ${l10n.serviceAndEmergencyNumbers}',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => showContactModal(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showContactModal(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
        label: Text(
          l10n.addNumber,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          child: Column(
            children: [
              if (items.isEmpty)
                EmptyState(
                  icon: Icons.phone_in_talk_rounded,
                  title: l10n.noEmergencyContactsTitle,
                  description: l10n.noEmergencyContactsDesc,
                  actionLabel: l10n.addFirstNumber,
                  onActionPressed: () => showContactModal(context, ref),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildContactTile(context, ref, colorScheme, item);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    VaultItemModel item,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final phone = item.phoneNumber ?? '';

    return InkWell(
      onTap: () => showContactModal(context, ref, item: item),
      borderRadius: AppRadius.borderLg,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: AppRadius.borderLg,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.call_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.description.isNotEmpty
                        ? '${item.description} • $phone'
                        : phone,
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Kopyala Butonu
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 18),
              tooltip: l10n.copy,
              color: colorScheme.primary,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: phone));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Numara kopyalandı! 📋 ($phone)')),
                );
              },
            ),

            // Ara Butonu (Native Phone Dialing)
            ElevatedButton.icon(
              onPressed: () => _makeCall(context, phone),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
              icon: const Icon(Icons.phone, size: 14),
              label: Text(l10n.call, style: const TextStyle(fontSize: 12)),
            ),

            // Sil Butonu
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error, size: 20),
              tooltip: 'Sil',
              onPressed: () => ref
                  .read(vaultRepositoryProvider)
                  .deleteVaultItem(item.familyId, item.id),
            ),
          ],
        ),
      ),
    );
  }
}
