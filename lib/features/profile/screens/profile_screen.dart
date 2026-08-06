import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/providers/ad_provider.dart';
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
import '../../premium/widgets/paywall_bottom_sheet.dart';
import '../providers/family_provider.dart';
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
  bool _isLinkingGoogle = false;

  // ── Google Hesap Bağlama Akışı ───────────────────────────────────────────

  Future<void> _handleGoogleLink() async {
    setState(() => _isLinkingGoogle = true);
    try {
      await ref.read(familyNotifierProvider.notifier).linkWithGoogle();
      final state = ref.read(familyNotifierProvider);

      if (state.hasError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bağlama hatası: ${state.error}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Hesabınız başarıyla Google ile bağlandı!'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bağlama sırasında hata: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLinkingGoogle = false);
      }
    }
  }

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
          final firestoreService = ref.read(firestoreServiceProvider);
          // Remove from family if exists
          final currentFamily = ref.read(currentFamilyProvider).valueOrNull;
          if (currentFamily != null) {
            await firestoreService.updateFamily(currentFamily.id, {
              'memberUids': FieldValue.arrayRemove([user.uid]),
            });
          }
          
          // Delete users/userId document
          await firestoreService.usersRef.doc(user.uid).delete();
          
          // Delete Firebase Auth User
          await user.delete();
          
          // Sign out state clear
          await ref.read(authRepositoryProvider).signOut();
        }
      } catch (e) {
        if (e.toString().contains('requires-recent-login')) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Güvenlik nedeniyle hesabınızı silmek için lütfen çıkış yapıp tekrar giriş yapın.'),
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
                icon: const Icon(Icons.ondemand_video_rounded, size: 18),
                label: const Text('1 Reklam İzle & Aile Oluştur'),
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

      // Ödüllü Reklam İzletme Akışı
      await ref.read(adServiceProvider).showRewardedAd(
        onRewardEarned: () async {
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
          }
        },
        onAdFailed: () async {
          // Reklam yüklenemese dahi kullanıcıyı mağdur etmemek için işlemi tamamla
          if (!mounted) return;
          await ref
              .read(familyNotifierProvider.notifier)
              .createFamily(familyName);
              
          // Rolü güncelle
          final user = ref.read(userProvider).valueOrNull;
          if (user != null) {
            await ref.read(firestoreServiceProvider).updateUserProfile(user.uid, {'familyRole': familyRole});
          }
        },
      );
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
      appBar: const AppHeader(title: 'Ev Asistanı'),
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

              // ── PRO Üyelik Banner'ı (isPremium == false ise) ──────────────
              if (!ref.watch(isPremiumProvider)) ...[
                _buildProUpgradeBanner(colorScheme),
                const SizedBox(height: AppSpacing.lg),
              ],

              // ── Kullanıcı Bilgi Kartı ─────────────────────────────────────
              _buildUserProfileCard(colorScheme, currentUser),

              const SizedBox(height: AppSpacing.sectionGap),

              // ── Ev & Aile Yönetimi Bölümü ─────────────────────────────────
              _buildSectionHeader(colorScheme, 'Evim & Aile Yönetimi'),
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
              _buildSectionHeader(colorScheme, 'Tercihler ve Ayarlar'),
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.notifications_active_rounded,
                title: 'Bildirim Ayarları',
                subtitle: 'Sistem bildirim ayarlarını yönetin',
                onTap: () async {
                  await openAppSettings();
                },
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              // ── Yasal ve Bilgi ────────────────────────────────────────────
              _buildSectionHeader(colorScheme, 'Yasal ve Bilgi'),
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.info_outline_rounded,
                title: 'Hakkında',
                subtitle: 'Ev Asistanı v1.0.0 (Firebase Enabled)',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Hakkında'),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Uygulama Adı: Ev Asistanı', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Sürüm: v1.0.0 (Firebase Enabled)'),
                          SizedBox(height: 4),
                          Text('Geliştirici: Samed Kalaycı'),
                          SizedBox(height: 8),
                          Text('Açıklama: Ev içi düzen ve ortak liste yönetimi uygulaması.'),
                          SizedBox(height: 8),
                          Text('© 2026 Ev Asistanı. Tüm hakları saklıdır.', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Kapat'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.gavel_outlined,
                title: 'Gizlilik Politikası ve Kullanım Koşulları',
                subtitle: 'Yasal bilgilendirmeleri ve kullanım şartlarını inceleyin',
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
              _buildSectionHeader(colorScheme, 'Hesap İşlemleri'),
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.logout_rounded,
                title: 'Çıkış Yap',
                subtitle: 'Hesabınızdan güvenli bir şekilde çıkış yapın',
                iconColor: AppColors.error,
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Çıkış Yap'),
                      content: const Text(
                        'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
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
                          child: const Text('Çıkış Yap'),
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
                title: 'Hesabımı Sil',
                subtitle: 'Kalıcı olarak hesabınızı ve verilerinizi silin',
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
    final roleLabel = user?.role.label ?? 'Üye';

    final avatarUrl = user?.effectiveAvatarUrl;
    final avatarType = user?.safeAvatarType ?? AvatarType.presetAvatar;
    final isEmoji = avatarType == AvatarType.emoji &&
        avatarUrl != null &&
        avatarUrl.isNotEmpty;
    final isNetworkImage =
        avatarUrl != null && avatarUrl.startsWith('http') && !isEmoji;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding * 1.25),
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
                    radius: 44,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage:
                        isNetworkImage ? NetworkImage(avatarUrl) : null,
                    child: isEmoji
                        ? Text(
                            avatarUrl,
                            style: const TextStyle(fontSize: 42),
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
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.surface, width: 2),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 14,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

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

          const SizedBox(height: AppSpacing.md),

          // Rol ve PRO Rozetleri — Sadece biri gösterilir
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (ref.watch(isPremiumProvider))
                // ── PRO Üye Rozeti (mavi gradient) ──────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                    ),
                    borderRadius: AppRadius.borderFull,
                    boxShadow: AppShadows.xs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('👑', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        'PRO Üye',
                        style: AppTypography.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                // ── Üye Rozeti (yeşil, sadece PRO DEĞİLSE) ─────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: AppRadius.borderFull,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        roleLabel,
                        style: AppTypography.labelMedium.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── PRO Yükseltme Banner'ı ────────────────────────────────────────────────

  Widget _buildProUpgradeBanner(ColorScheme colorScheme) {
    return InkWell(
      onTap: () => PaywallBottomSheet.show(context),
      borderRadius: AppRadius.borderLg,
      child: Container(
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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF38BDF8),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('👑', style: TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ev Asistanı PRO\'ya Yükseltin',
                    style: AppTypography.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Dijital Ev Kasası, Nakit Akışı & Sınırsız Ev Paylaşımı',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
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
                  // —— PRO Aile Rozeti ———————————————————————
                  if (ref.watch(isPremiumProvider)) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                        ),
                        borderRadius: AppRadius.borderFull,
                        boxShadow: AppShadows.xs,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('👑',
                              style: TextStyle(fontSize: 10, height: 1.2)),
                          SizedBox(width: 3),
                          Text(
                            'PRO Aile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  '${family.memberCount} Üye',
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
                  'Davet Kodu:',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aile Üyeleri (${members.length})',
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
                  // —— Üye Rozeti (Ücretsiz / PRO durumuna göre) ——————————
                  if (ref.watch(isPremiumProvider))
                    // PRO Aile rozetleri
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                        ),
                        borderRadius: AppRadius.borderSm,
                        boxShadow: AppShadows.xs,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('👑',
                              style: TextStyle(fontSize: 9, height: 1.2)),
                          const SizedBox(width: 3),
                          Text(
                            'PRO $roleName',
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    // Standart rozet
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
                  Icons.g_mobiledata_rounded,
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
                      'Hesabınızı Google ile Bağlayın',
                      style: AppTypography.titleMedium.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Misafir modundasınız. Verilerinizi kaybetmeden Google hesabınızla kalıcı yapın.',
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
              icon: _isLinkingGoogle
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.account_circle_rounded, size: 20),
              label: Text(
                _isLinkingGoogle ? 'Bağlanıyor...' : 'Google ile Bağla',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
              onPressed: _isLinkingGoogle ? null : _handleGoogleLink,
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
