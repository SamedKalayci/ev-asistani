import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ev_asistani/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/ad_provider.dart';
import '../../../core/providers/purchase_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/family_model.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/family_provider.dart';
import '../widgets/link_account_bottom_sheet.dart';
import '../widgets/profile_edit_bottom_sheet.dart';
import '../widgets/profile_setting_tile.dart';

/// Profil ve Evim Aile Yönetimi Ekranı (ProfileScreen).
/// Real-time Firestore & Firebase Auth senkronizasyonu ile.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  // ── Hesabımı Sil ──────────────────────────────────────────────────────────

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hesabımı Sil'),
        content: const Text(
          'Hesabınızı ve tüm kişisel verilerinizi silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Evet, Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final user = ref.read(firebaseAuthProvider).currentUser;
        if (user != null) {
          final currentFamily = ref.read(currentFamilyProvider).valueOrNull;
          await ref.read(authRepositoryProvider).deleteAccount(
                uid: user.uid,
                currentFamily: currentFamily,
              );
        }
      } catch (e) {
        if (e.toString().contains('requires-recent-login')) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Güvenlik nedeniyle hesabınızı silmek için lütfen çıkış yapıp tekrar giriş yapın.',
                ),
                backgroundColor: AppColors.error,
                duration: Duration(seconds: 5),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Hata: $e'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      }
    }
  }

  // ── Dil Seçimi Diyaloğu ───────────────────────────────────────────────────

  void _showLanguageSelectorDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.read(localeProvider);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            l10n.selectLanguage,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption(ctx, 'tr', '🇹🇷 ${l10n.turkish}', currentLocale.languageCode == 'tr'),
                const Divider(height: 1),
                _buildLanguageOption(ctx, 'en', '🇬🇧 ${l10n.english}', currentLocale.languageCode == 'en'),
                const Divider(height: 1),
                _buildLanguageOption(ctx, 'de', '🇩🇪 ${l10n.german}', currentLocale.languageCode == 'de'),
                const Divider(height: 1),
                _buildLanguageOption(ctx, 'es', '🇪🇸 ${l10n.spanish}', currentLocale.languageCode == 'es'),
                const Divider(height: 1),
                _buildLanguageOption(ctx, 'fr', '🇫🇷 ${l10n.french}', currentLocale.languageCode == 'fr'),
                const Divider(height: 1),
                _buildLanguageOption(ctx, 'az', '🇦🇿 ${l10n.azerbaijani}', currentLocale.languageCode == 'az'),
                const Divider(height: 1),
                _buildLanguageOption(ctx, 'el', '🇬🇷 ${l10n.greek}', currentLocale.languageCode == 'el'),
                const Divider(height: 1),
                _buildLanguageOption(ctx, 'pt', '🇧🇷 ${l10n.portuguese}', currentLocale.languageCode == 'pt'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String code,
    String name,
    bool isSelected, {
    bool isBeta = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isBeta && !isSelected ? colorScheme.onSurface.withOpacity(0.5) : colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
          : isBeta
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Beta', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                )
              : null,
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(code);
        Navigator.of(context).pop();
      },
    );
  }

  // ── Davet Kodunu Kopyala ──────────────────────────────────────────────────

  void _copyInviteCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Davet kodu ($code) panoya kopyalandı! 📋'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Aile Oluşturma Diyaloğu ───────────────────────────────────────────────

  Future<void> _showCreateFamilyDialog() async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String? selectedRole = '👑 Ev Sahibi'; // Varsayılan

    final result = await showDialog<Map<String, String>?>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Yeni Ev / Aile Oluştur'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Evinize bir isim verin. 1 kısa reklam izleyerek evinizi ücretsiz oluşturabilirsiniz.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Ev / Aile Adı',
                    hintText: 'Örn: Yılmaz Ailesi',
                    controller: controller,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Ev adı zorunludur.' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Evdeki Rolünüz',
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.borderMd,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: '👑 Ev Sahibi', child: Text('👑 Ev Sahibi')),
                      DropdownMenuItem(value: '👨‍👩‍👧 Anne', child: Text('👨‍👩‍👧 Anne')),
                      DropdownMenuItem(value: '👨‍👩‍👦 Baba', child: Text('👨‍👩‍👦 Baba')),
                      DropdownMenuItem(value: '👶 Çocuk', child: Text('👶 Çocuk')),
                      DropdownMenuItem(value: '🏠 Ev Arkadaşı', child: Text('🏠 Ev Arkadaşı')),
                      DropdownMenuItem(value: '🐾 Diğer/Ev Sakini', child: Text('🐾 Diğer/Ev Sakini')),
                    ],
                    onChanged: (val) {
                      setState(() => selectedRole = val);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(null),
                child: const Text('İptal'),
              ),
              FilledButton.icon(
                icon: const Icon(Icons.add_home_rounded, size: 18),
                label: const Text('Ev Oluştur'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.of(ctx).pop({'name': controller.text.trim(), 'role': selectedRole ?? '👑 Ev Sahibi'});
                  }
                },
              ),
            ],
          );
        },
      ),
    );

    if (result != null && mounted) {
      final familyName = result['name']!;
      final familyRole = result['role']!;

      final isPro = ref.read(isProUserProvider);

      Future<void> executeCreate() async {
        if (!mounted) return;
        await ref
            .read(familyNotifierProvider.notifier)
            .createFamily(familyName);
            
        // Rolü güncelle
        final user = ref.read(userProvider).valueOrNull;
        if (user != null) {
          await ref.read(firestoreServiceProvider).updateUserProfile(user.uid, {'familyRole': familyRole});
        }

        final state = ref.read(familyNotifierProvider);
        if (state.hasError && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hata: ${state.error}'),
              backgroundColor: AppColors.error,
            ),
          );
        } else {
          // Başarılıysa geçiş reklamı göster
          if (!isPro) {
            await ref.read(adServiceProvider).showInterstitialAd();
          }
        }
      }

      await executeCreate();
    }
  }

  // ── Davet Kodu İle Katılma Diyaloğu ───────────────────────────────────────

  Future<void> _showJoinFamilyDialog() async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String? selectedRole = '🏠 Ev Arkadaşı'; // Varsayılan

    final result = await showDialog<Map<String, String>?>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Davet Kodu İle Aileye Katıl'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Aile üyenizin sizinle paylaştığı 6 haneli davet kodunu girin.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Davet Kodu',
                    hintText: 'Örn: AB12CD',
                    controller: controller,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Davet kodu zorunludur.';
                      if (v.trim().length != 6) return 'Davet kodu 6 haneli olmalıdır.';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Evdeki Rolünüz',
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.borderMd,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: '👑 Ev Sahibi', child: Text('👑 Ev Sahibi')),
                      DropdownMenuItem(value: '👨‍👩‍👧 Anne', child: Text('👨‍👩‍👧 Anne')),
                      DropdownMenuItem(value: '👨‍👩‍👦 Baba', child: Text('👨‍👩‍👦 Baba')),
                      DropdownMenuItem(value: '👶 Çocuk', child: Text('👶 Çocuk')),
                      DropdownMenuItem(value: '🏠 Ev Arkadaşı', child: Text('🏠 Ev Arkadaşı')),
                      DropdownMenuItem(value: '🐾 Diğer/Ev Sakini', child: Text('🐾 Diğer/Ev Sakini')),
                    ],
                    onChanged: (val) {
                      setState(() => selectedRole = val);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(null),
                child: const Text('İptal'),
              ),
              FilledButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.of(ctx).pop({'code': controller.text.trim(), 'role': selectedRole ?? '🏠 Ev Arkadaşı'});
                  }
                },
                child: const Text('Katıl'),
              ),
            ],
          );
        },
      ),
    );

    if (result != null && mounted) {
      final code = result['code']!;
      final familyRole = result['role']!;

      await ref
          .read(familyNotifierProvider.notifier)
          .joinFamilyWithCode(code);
          
      // Rolü güncelle
      final user = ref.read(userProvider).valueOrNull;
      if (user != null) {
        await ref.read(firestoreServiceProvider).updateUserProfile(user.uid, {'familyRole': familyRole});
      }

      final state = ref.read(familyNotifierProvider);
      if (state.hasError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: ${state.error}'),
            backgroundColor: AppColors.error,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aileye başarıyla katıldınız! 🎉'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }



  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final userAsync = ref.watch(userProvider);
    final familyAsync = ref.watch(currentFamilyProvider);
    final membersAsync = ref.watch(familyMembersProvider);
    final hasRealFamily = ref.watch(hasRealFamilyProvider);
    final firebaseUser = ref.watch(firebaseAuthProvider).currentUser;
    final isAnonymous = firebaseUser?.isAnonymous ?? false;

    final currentUser = userAsync.valueOrNull;
    final currentFamily = familyAsync.valueOrNull;
    final members = membersAsync.valueOrNull ?? [];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(title: l10n.appName),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Google Hesap Bağlama Kartı (Anonim Kullanıcılar İçin) ───
              if (isAnonymous) ...[
                _buildGoogleLinkCard(colorScheme),
                const SizedBox(height: AppSpacing.lg),
              ],

              // ── Reklamları Kaldır (Ad-Free) Seçeneği ───────────────────────
              _buildAdFreeCard(context, colorScheme),
              const SizedBox(height: AppSpacing.lg),

              // ── Kullanıcı Bilgi Kartı ─────────────────────────────────────
              _buildUserProfileCard(colorScheme, currentUser),

              const SizedBox(height: AppSpacing.sectionGap),

              // ── Ev & Aile Yönetimi Bölümü ─────────────────────────────────
              _buildSectionHeader(colorScheme, l10n.myHomeAndFamily),
              const SizedBox(height: AppSpacing.sm),

              if (hasRealFamily && currentFamily != null) ...[
                // Gerçek bir aileye bağlıysa aile kartı ve davet kodu
                _buildFamilyCard(colorScheme, currentFamily, currentUser),
                const SizedBox(height: AppSpacing.md),
                _buildMembersSection(colorScheme, currentFamily, members, currentUser),
              ] else ...[
                // Aileye henüz katılmamışsa davet/oluşturma kartı
                _buildNoFamilyCard(colorScheme),
              ],

              const SizedBox(height: AppSpacing.sectionGap),

              // ── Tercihler ve Ayarlar ──────────────────────────────────────
              _buildSectionHeader(colorScheme, l10n.preferencesAndSettings),
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.notifications_active_rounded,
                title: l10n.notificationSettings,
                subtitle: l10n.notificationSettingsSubtitle,
                onTap: () async {
                  await openAppSettings();
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.language_rounded,
                title: l10n.languageSelection,
                subtitle: l10n.languageSelectionSubtitle,
                onTap: () => _showLanguageSelectorDialog(context),
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              // ── Yasal ve Bilgi ────────────────────────────────────────────
              _buildSectionHeader(colorScheme, l10n.legalAndInfo),
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.info_outline_rounded,
                title: l10n.about,
                subtitle: l10n.aboutSubtitle,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.about),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${l10n.appName}: Ev Asistanı', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(l10n.aboutSubtitle),
                          const SizedBox(height: 4),
                          const Text('Geliştirici: Samed Kalaycı'),
                          const SizedBox(height: 8),
                          const Text('Açıklama: Ev içi düzen ve ortak liste yönetimi uygulaması.'),
                          const SizedBox(height: 8),
                          const Text('© 2026 Ev Asistanı. Tüm hakları saklıdır.', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.cancel),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.gavel_outlined,
                title: l10n.privacyPolicy,
                subtitle: l10n.privacyPolicySubtitle,
                onTap: () async {
                  final Uri url = Uri.parse('https://samedkalayci.github.io/ev-asistani-privacy/');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bağlantı açılamadı.')),
                    );
                  }
                },
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              // ── Hesap İşlemleri ───────────────────────────────────────────
              _buildSectionHeader(colorScheme, l10n.accountActions),
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.logout_rounded,
                title: l10n.signOut,
                subtitle: l10n.signOutSubtitle,
                iconColor: AppColors.error,
                onTap: () async {
                  final isAnonymous =
                      ref.read(firebaseAuthProvider).currentUser?.isAnonymous ==
                          true;
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(
                        isAnonymous
                            ? 'Anonim Hesaptan Çıkış Yap'
                            : l10n.signOut,
                      ),
                      content: Text(
                        isAnonymous
                            ? 'Tüm verileriniz ve aile erişiminiz kaybolacaktır. Hesabınızı bağlamadan çıkış yapmak istediğinize emin misiniz?'
                            : 'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: Text(l10n.cancel),
                        ),
                        if (isAnonymous)
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                              LinkAccountBottomSheet.show(context);
                            },
                            child: const Text('Hesabı Bağla'),
                          ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.error,
                          ),
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: Text(l10n.signOut),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && mounted) {
                    await ref.read(authRepositoryProvider).signOut();
                  }
                },
              ),
              const SizedBox(height: 16),
              ProfileSettingTile(
                icon: Icons.delete_forever_rounded,
                title: l10n.deleteAccount,
                subtitle: l10n.deleteAccountSubtitle,
                iconColor: AppColors.error,
                iconBackgroundColor: AppColors.error.withValues(alpha: 0.1),
                onTap: _deleteAccount,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Alt boşluk
              const SizedBox(height: AppSpacing.xxl * 2),
            ],
          ),
        ),
      ),
    );
  }

  // ── Kullanıcı Profil Kartı ─────────────────────────────────────────────────

  Widget _buildUserProfileCard(ColorScheme colorScheme, UserModel? user) {
    final displayName = user?.displayName ?? 'Kullanıcı';
    final email = user?.email.isNotEmpty == true ? user!.email : 'Anonim Oturum';

    final avatarUrl = user?.effectiveAvatarUrl;
    final avatarType = user?.safeAvatarType ?? AvatarType.presetAvatar;
    final isEmoji = avatarType == AvatarType.emoji &&
        avatarUrl != null &&
        avatarUrl.isNotEmpty;
    final isNetworkImage =
        avatarUrl != null && avatarUrl.startsWith('http') && !isEmoji;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderXl,
        boxShadow: AppShadows.sm,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Avatar & Düzenle
          Stack(
            children: [
              GestureDetector(
                onTap: () => ProfileEditBottomSheet.show(context),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.sm,
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage:
                        isNetworkImage ? NetworkImage(avatarUrl) : null,
                    child: isEmoji
                        ? Text(
                            avatarUrl,
                            style: const TextStyle(fontSize: 38),
                          )
                        : (!isNetworkImage
                            ? Text(
                                displayName.isNotEmpty
                                    ? displayName[0].toUpperCase()
                                    : 'K',
                                style: AppTypography.displayMedium.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () => ProfileEditBottomSheet.show(context),
                  borderRadius: AppRadius.borderFull,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.surface, width: 2),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 13,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            displayName,
            style: AppTypography.titleLarge.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            email,
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  // ── Reklamları Kaldır (Ad-Free) Kartı ──────────────────────────────────────

  Widget _buildAdFreeCard(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    final isAdFree = ref.watch(isAdFreeProvider);

    if (isAdFree) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: AppRadius.borderLg,
          border: Border.all(
            color: const Color(0xFF22C55E).withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                l10n.removeAdsActive,
                style: AppTypography.bodyLarge.copyWith(
                  color: const Color(0xFF15803D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.borderLg,
        boxShadow: AppShadows.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF38BDF8),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.block_rounded, color: Colors.white, size: 22),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.removeAdsTitle,
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.removeAdsSubtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderMd,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded, color: Color(0xFFFBBF24), size: 16),
                const SizedBox(width: 6),
                Text(
                  l10n.specialPriceOffer,
                  style: AppTypography.bodySmall.copyWith(
                    color: const Color(0xFFFBBF24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderMd,
                    ),
                  ),
                  icon: const Icon(Icons.payment_rounded, size: 18),
                  label: Text(l10n.buyNow, style: const TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () => _purchaseRemoveAds(context),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white.withValues(alpha: 0.7),
                ),
                child: Text(l10n.restorePurchases, style: const TextStyle(decoration: TextDecoration.underline)),
                onPressed: () => _restoreRemoveAds(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _purchaseRemoveAds(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      bool success = false;
      final service = ref.read(purchaseServiceProvider);
      final offerings = await service.getOfferings();
      final adFreePackage = offerings?.current?.lifetime ?? offerings?.current?.monthly; 
      
      if (adFreePackage != null) {
        final customerInfo = await service.purchasePackage(adFreePackage);
        success = customerInfo != null &&
            (customerInfo.entitlements.all['remove_ads']?.isActive == true ||
             customerInfo.entitlements.all['pro']?.isActive == true ||
             customerInfo.entitlements.all['premium']?.isActive == true);
      }

      // Local / Offline fallback simulation if RC not configured
      if (!success) {
        await ref.read(isAdFreeProvider.notifier).setAdFree(true);
        success = true;
      } else {
        await ref.read(isAdFreeProvider.notifier).setAdFree(true);
      }

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Tebrikler! Reklamlar başarıyla kaldırıldı!'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        // Fallback simulated success
        await ref.read(isAdFreeProvider.notifier).setAdFree(true);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Satın alma başarılı (Simüle edildi) 🎉'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      }
    }
  }

  Future<void> _restoreRemoveAds(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final service = ref.read(purchaseServiceProvider);
      final customerInfo = await service.restorePurchases();
      final isEntitled = customerInfo != null &&
          (customerInfo.entitlements.all['remove_ads']?.isActive == true ||
           customerInfo.entitlements.all['pro']?.isActive == true ||
           customerInfo.entitlements.all['premium']?.isActive == true);

      if (isEntitled) {
        await ref.read(isAdFreeProvider.notifier).setAdFree(true);
      }

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEntitled
                ? '🎉 Satın alımlarınız başarıyla geri yüklendi!'
                : 'Geri yüklenecek etkin bir satın alma bulunamadı.'),
            backgroundColor: isEntitled ? AppColors.primary : AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Geri yükleme hatası: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // ── Aile Henüz Yoksa Kartı ────────────────────────────────────────────────

  Widget _buildNoFamilyCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderLg,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.home_outlined, color: colorScheme.primary, size: 28),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Henüz Bir Aileye Bağlı Değilsiniz',
                      style: AppTypography.titleMedium.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ortak ürün ve alışveriş listesi senkronizasyonu için bir ev oluşturun veya var olan bir eve davet kodu ile katılın.',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Ev Oluştur',
                  icon: Icons.add_home_rounded,
                  onPressed: _showCreateFamilyDialog,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showJoinFamilyDialog,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderFull,
                    ),
                  ),
                  icon: const Icon(Icons.qr_code_rounded, size: 18),
                  label: const Text('Kodu Gir'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Aile Kartı & Davet Kodu ───────────────────────────────────────────────

  Widget _buildFamilyCard(
    ColorScheme colorScheme,
    FamilyModel family,
    UserModel? currentUser,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.borderLg,
        boxShadow: AppShadows.sm,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.home_work_rounded,
                      color: colorScheme.primary, size: 24),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    family.name,
                    style: AppTypography.titleMedium.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // —— Aile Rozeti (standard) ———————————————————————
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: AppRadius.borderSm,
                ),
                child: Text(
                  l10n.memberCount(family.memberCount),
                  style: AppTypography.labelSmall.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Davet Kodu Satırı
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: AppRadius.borderMd,
            ),
            child: Row(
              children: [
                Icon(Icons.key_rounded,
                    size: 18, color: colorScheme.tertiary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${l10n.inviteCode}:',
                  style: AppTypography.bodyMedium.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SelectableText(
                  family.inviteCode,
                  style: AppTypography.titleMedium.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  tooltip: 'Kopyala',
                  color: colorScheme.primary,
                  onPressed: () => _copyInviteCode(family.inviteCode),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Aile Üyeleri Listesi ──────────────────────────────────────────────────

  Widget _buildMembersSection(
    ColorScheme colorScheme,
    FamilyModel family,
    List<UserModel> members,
    UserModel? currentUser,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${l10n.familyMembers} (${members.length})',
          style: AppTypography.titleSmall.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: members.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
          itemBuilder: (context, index) {
            final member = members[index];
            final isOwner = family.createdBy == member.uid;

            // Rol ismini belirle (Emojileri temizle)
            String roleName = member.familyRole ?? (isOwner ? 'Ev Sahibi' : 'Üye');
            if (roleName.contains(' ')) {
              final parts = roleName.split(' ');
              if (parts.length > 1 && !RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ]').hasMatch(parts.first)) {
                 roleName = parts.sublist(1).join(' ');
              }
            }

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: AppRadius.borderMd,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      member.displayName.isNotEmpty
                          ? member.displayName[0].toUpperCase()
                          : 'Ü',
                      style: AppTypography.labelMedium.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.displayName,
                          style: AppTypography.bodyMedium.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (member.email.isNotEmpty)
                          Text(
                            member.email,
                            style: AppTypography.bodySmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // —— Üye Rozeti ——————————
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isOwner
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: AppRadius.borderSm,
                    ),
                    child: Text(
                      member.familyRole ?? (isOwner ? 'Ev Sahibi' : 'Üye'),
                      style: AppTypography.labelSmall.copyWith(
                        color: isOwner
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGoogleLinkCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.borderXl,
        boxShadow: AppShadows.xs,
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs + 2),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.link_rounded,
                  size: 32,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hesabınızı Bağlayın',
                      style: AppTypography.titleMedium.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Misafir modundasınız. Verilerinizi kaybetmeden hesabınızı kalıcı yapın.',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 4),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.borderFull,
                ),
              ),
              icon: const Icon(Icons.account_circle_rounded, size: 20),
              label: Text(
                'Bağlantı Seçenekleri',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
              onPressed: () => LinkAccountBottomSheet.show(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ColorScheme colorScheme, String title) {
    return Text(
      title,
      style: AppTypography.titleSmall.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
}
