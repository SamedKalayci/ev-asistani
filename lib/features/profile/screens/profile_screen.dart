import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ev_asistani/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/currency_provider.dart';
import '../../../core/providers/theme_provider.dart';
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
import '../../../shared/widgets/user_avatar.dart';
import '../providers/family_provider.dart';
import '../widgets/link_account_bottom_sheet.dart';
import '../widgets/profile_edit_bottom_sheet.dart';
import '../widgets/profile_setting_tile.dart';
import '../../finance/widgets/account_form_bottom_sheet.dart';
import '../../finance/widgets/quick_notes_management_page.dart';
import '../../finance/screens/category_budgets_screen.dart';
import '../../../core/utils/l10n_helper.dart';
import '../../premium/widgets/paywall_bottom_sheet.dart';

/// Profil ve Evim Aile Yönetimi Ekranı (ProfileScreen).
/// Real-time Firestore & Firebase Auth senkronizasyonu ile.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  // ── Ev Adını Düzenle Diyaloğu ──────────────────────────────────────────

  Future<void> _showEditHomeNameDialog(String currentName) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentName);
    final formKey = GlobalKey<FormState>();

    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.editHomeNameTitle),
        content: Form(
          key: formKey,
          child: AppTextField(
            label: l10n.editHomeNameLabel,
            hintText: l10n.editHomeNameHint,
            controller: controller,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.homeNameRequired
                : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(ctx).pop(controller.text.trim());
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && mounted) {
      await ref
          .read(familyNotifierProvider.notifier)
          .updateFamilyName(newName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.homeNameUpdatedToast),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  // ── Tema Seçimi Diyaloğu ─────────────────────────────────────────────

  void _showThemeSelectorDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentThemeMode = ref.read(themeModeProvider);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            l10n.themeSelection,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(ctx, ThemeMode.system, l10n.themeSystem, currentThemeMode == ThemeMode.system),
              const Divider(height: 1),
              _buildThemeOption(ctx, ThemeMode.light, l10n.themeLight, currentThemeMode == ThemeMode.light),
              const Divider(height: 1),
              _buildThemeOption(ctx, ThemeMode.dark, l10n.themeDark, currentThemeMode == ThemeMode.dark),
            ],
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

  Widget _buildThemeOption(
    BuildContext context,
    ThemeMode mode,
    String label,
    bool isSelected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
          : null,
      onTap: () {
        ref.read(themeModeProvider.notifier).setThemeMode(mode);
        Navigator.of(context).pop();
      },
    );
  }

  String _translateRole(BuildContext context, String? rawRole, bool isOwner) {
    final l10n = AppLocalizations.of(context)!;
    if (rawRole == null || rawRole.isEmpty) {
      return isOwner ? l10n.roleHouseOwner : l10n.userRoleLabel;
    }
    String cleanRole = rawRole;
    if (cleanRole.contains(' ')) {
      final parts = cleanRole.split(' ');
      if (parts.length > 1 && !RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ]').hasMatch(parts.first)) {
        cleanRole = parts.sublist(1).join(' ');
      }
    }
    final lower = cleanRole.toLowerCase();
    if (lower.contains('ev sahibi') || lower.contains('house owner') || lower == 'owner') {
      return l10n.roleHouseOwner;
    } else if (lower.contains('anne') || lower.contains('mother')) {
      return l10n.roleMother;
    } else if (lower.contains('baba') || lower.contains('father')) {
      return l10n.roleFather;
    } else if (lower.contains('çocuk') || lower.contains('child')) {
      return l10n.roleChild;
    } else if (lower.contains('arkadaşı') || lower.contains('roommate')) {
      return l10n.roleRoommate;
    } else if (lower.contains('sakini') || lower.contains('other') || lower.contains('diğer')) {
      return l10n.roleOtherResident;
    }
    return cleanRole;
  }

  // ── Hesabımı Sil ──────────────────────────────────────────────────────────

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Text(l10n.deleteAccountConfirmDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.deleteAccountConfirmBtn),
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
              SnackBar(
                content: Text(l10n.deleteAccountReauthNotice),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 5),
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

  // ── Para Birimi Seçimi Diyaloğu ──────────────────────────────────────────────

  void _showCurrencySelectorDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentCurrency = ref.read(currencyProvider);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            l10n.currencySelection,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppCurrency.values.map((currency) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCurrencyOption(
                      ctx,
                      currency,
                      '${currency.name} (${currency.symbol})',
                      currentCurrency == currency,
                    ),
                    if (currency != AppCurrency.values.last) const Divider(height: 1),
                  ],
                );
              }).toList(),
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

  Widget _buildCurrencyOption(
    BuildContext context,
    AppCurrency currency,
    String label,
    bool isSelected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
          : null,
      onTap: () {
        ref.read(currencyProvider.notifier).setCurrency(currency);
        Navigator.of(context).pop();
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
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final roleController = TextEditingController(text: l10n.roleHouseOwner);
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<Map<String, String>?>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.createNewHomeTitle),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.createNewHomeDesc),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l10n.homeNameLabel,
                    hintText: l10n.homeNameHint,
                    controller: controller,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? l10n.homeNameRequired : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Rol Adı — serbest metin girişi + hızlı öneri chip'leri
                  TextFormField(
                    controller: roleController,
                    decoration: InputDecoration(
                      labelText: l10n.roleInHomeLabel,
                      hintText: l10n.roleHouseOwner,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.borderMd,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Hızlı Seçim Chip'leri
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      l10n.roleHouseOwner,
                      l10n.roleMother,
                      l10n.roleFather,
                      l10n.roleChild,
                      l10n.roleRoommate,
                    ].map((role) => ActionChip(
                      label: Text(role, style: AppTypography.labelSmall),
                      onPressed: () => setState(() => roleController.text = role),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    )).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(null),
                child: Text(l10n.cancel),
              ),
              FilledButton.icon(
                icon: const Icon(Icons.add_home_rounded, size: 18),
                label: Text(l10n.createHome),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.of(ctx).pop({'name': controller.text.trim(), 'role': roleController.text.trim().isEmpty ? l10n.roleHouseOwner : roleController.text.trim()});
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
      appBar: AppHeader(title: l10n.appName, showNotificationBell: false),
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

              // ── Kategoriler ve Hesaplar ─────────────────────────────
              _buildSectionHeader(colorScheme, l10n.categoriesAndAccounts),
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.account_balance_wallet_rounded,
                title: l10n.myAccounts,
                subtitle: l10n.myAccountsDesc,
                onTap: () => AccountFormBottomSheet.show(context),
              ),
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.tips_and_updates_rounded,
                title: l10n.recurringExpenses,
                subtitle: l10n.recurringExpensesDescSetting,
                onTap: () => QuickNotesManagementPage.show(context),
              ),
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.track_changes_rounded,
                title: l10n.categoryBudgets,
                subtitle: l10n.categoryBudgetsDesc,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryBudgetsScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              // ── Tercihler ve Ayarlar ──────────────────────────────────────
              _buildSectionHeader(colorScheme, l10n.preferencesAndSettings),
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.palette_outlined,
                title: l10n.themeSelection,
                subtitle: l10n.themeSelectionSubtitle,
                onTap: () => _showThemeSelectorDialog(context),
              ),
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
              const SizedBox(height: AppSpacing.sm),
              ProfileSettingTile(
                icon: Icons.attach_money_rounded,
                title: l10n.currencySelection,
                subtitle: l10n.currencySelectionSubtitle,
                onTap: () => _showCurrencySelectorDialog(context),
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
                          Text(l10n.appName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(l10n.aboutSubtitle),
                          const SizedBox(height: 4),
                          Text(l10n.aboutDeveloper),
                          const SizedBox(height: 8),
                          Text(l10n.aboutDescription),
                          const SizedBox(height: 8),
                          Text(l10n.aboutCopyright, style: const TextStyle(fontSize: 12)),
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
                            ? l10n.signOutAnonymousTitle
                            : l10n.signOut,
                      ),
                      content: Text(
                        isAnonymous
                            ? l10n.signOutAnonymousDesc
                            : l10n.signOutConfirmDesc,
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
                            child: Text(l10n.linkAccountBtn),
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
    final l10n = AppLocalizations.of(context)!;
    final displayName = user?.displayName.isNotEmpty == true
        ? user!.displayName
        : (user?.isAnonymous == true ? l10n.guestUser : l10n.userRoleLabel);
    final email = user?.email.isNotEmpty == true ? user!.email : l10n.anonymousSession;

    final avatarUrl = user?.effectiveAvatarUrl ?? '';
    final avatarType = user?.safeAvatarType ?? AvatarType.presetAvatar;
    final isEmoji = avatarType == AvatarType.emoji && avatarUrl.isNotEmpty;
    final isNetworkImage = avatarUrl.startsWith('http') && !isEmoji;
    final isLocalAsset = avatarUrl.startsWith('assets/') && !isEmoji;

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
                    child: isLocalAsset
                        ? ClipOval(
                            child: Image.asset(
                              avatarUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Text(
                                displayName.isNotEmpty
                                    ? displayName[0].toUpperCase()
                                    : 'K',
                                style: AppTypography.displayMedium.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : isEmoji
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
          gradient: const LinearGradient(
            colors: [Color(0xFF064E3B), Color(0xFF065F46)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadius.borderLg,
          boxShadow: AppShadows.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('⚡', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.adFreeActiveTitle,
                    style: AppTypography.titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    l10n.adFreeActiveDesc,
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: AppRadius.borderSm,
              ),
              child: Text(
                l10n.activeBadge,
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
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
                      l10n.buyAdFreeTitle,
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.buyAdFreeDesc,
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
                  l10n.monthlyYearlyFlexiblePlans,
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
                  label: Text(l10n.inspectAndBuyPlans, style: const TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () => PaywallBottomSheet.show(context),
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



  Future<void> _restoreRemoveAds(BuildContext context) async {
    bool overlayOpen = false;

    void closeOverlay() {
      if (overlayOpen && context.mounted) {
        overlayOpen = false;
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    overlayOpen = true;
    if (context.mounted) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black38,
        builder: (ctx) => const PopScope(
          canPop: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    try {
      final service = ref.read(purchaseServiceProvider);
      final customerInfo = await service.restorePurchases();
      final isEntitled = customerInfo != null &&
          (customerInfo.entitlements.all['remove_ads']?.isActive == true ||
           customerInfo.entitlements.all['pro']?.isActive == true ||
           customerInfo.entitlements.all['premium']?.isActive == true);

      if (isEntitled) {
        await ref.read(isAdFreeProvider.notifier).setAdFreeForFamily();
      }

      closeOverlay();

      if (context.mounted) {
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
      closeOverlay();
      if (context.mounted) {
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
    final l10n = AppLocalizations.of(context)!;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(Icons.home_outlined, color: colorScheme.primary, size: 28),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.notMemberOfFamilyYet,
                      style: AppTypography.titleMedium.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.noHomeSyncDesc,
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
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 340;
              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryButton(
                      text: l10n.createHome,
                      icon: Icons.add_home_rounded,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.md,
                      ),
                      onPressed: _showCreateFamilyDialog,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: _showJoinFamilyDialog,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                          horizontal: AppSpacing.sm,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.borderFull,
                        ),
                      ),
                      icon: const Icon(Icons.qr_code_rounded, size: 18),
                      label: Text(
                        l10n.enterCode,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: l10n.createHome,
                      icon: Icons.add_home_rounded,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: AppSpacing.md,
                      ),
                      onPressed: _showCreateFamilyDialog,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showJoinFamilyDialog,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                          horizontal: AppSpacing.xs,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.borderFull,
                        ),
                      ),
                      icon: const Icon(Icons.qr_code_rounded, size: 18),
                      label: Text(
                        l10n.enterCode,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );
            },
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
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => _showEditHomeNameDialog(family.name),
                    borderRadius: AppRadius.borderFull,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.edit_rounded,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
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

  // ── Aile Üyeleri Listesi & Yönetimi ──────────────────────────────────────

  void _handleManageMembers(
    BuildContext context,
    FamilyModel family,
    List<UserModel> members,
    bool isCurrentOwner,
  ) {
    if (!isCurrentOwner) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Yetki Gerekli 🔐'),
          content: const Text(
            'Aile üyelerini yönetme ve gruptan çıkarma yetkisi sadece ev sahibine (aile kurucusuna) aittir.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Anladım'),
            ),
          ],
        ),
      );
      return;
    }

    _showManageMembersBottomSheet(context, family, members);
  }

  void _showManageMembersBottomSheet(
    BuildContext context,
    FamilyModel family,
    List<UserModel> members,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        final otherMembers = members.where((m) => m.uid != family.createdBy).toList();

        return Consumer(
          builder: (context, ref, child) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLowest,
                borderRadius: AppRadius.borderTopXl,
              ),
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: cs.outlineVariant,
                        borderRadius: AppRadius.borderFull,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Aile Üyelerini Yönet 👥',
                    style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ev grubunuzdan çıkarmak istediğiniz üyenin yanındaki sil butonuna dokunabilirsiniz.',
                    style: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (otherMembers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                      child: Center(
                        child: Text(
                          'Ev grubunuzda henüz başka üye bulunmuyor.',
                          style: AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: otherMembers.length,
                        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final member = otherMembers[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerLow,
                              borderRadius: AppRadius.borderLg,
                              border: Border.all(
                                color: cs.outlineVariant.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                UserAvatar(user: member, radius: 18),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    member.displayName,
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.person_remove_rounded,
                                    color: AppColors.error,
                                    size: 22,
                                  ),
                                  tooltip: 'Aileden Çıkar',
                                  onPressed: () => _confirmRemoveMember(ctx, member),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmRemoveMember(BuildContext modalContext, UserModel member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Üyeyi Aileden Çıkar'),
        content: Text(
          '${member.displayName} kişisini ev grubunuzdan çıkarmak istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Evet, Çıkar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref
            .read(familyNotifierProvider.notifier)
            .removeMember(member.uid);

        if (modalContext.mounted) {
          Navigator.of(modalContext).pop();
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('👋 ${member.displayName} aileden çıkarıldı.'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Üye çıkarılırken hata oluştu: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Widget _buildMembersSection(
    ColorScheme colorScheme,
    FamilyModel family,
    List<UserModel> members,
    UserModel? currentUser,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final isCurrentOwner = family.createdBy == currentUser?.uid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${l10n.familyMembers} (${members.length})',
              style: AppTypography.titleSmall.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () => _handleManageMembers(context, family, members, isCurrentOwner),
              borderRadius: AppRadius.borderFull,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_rounded,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Yönet',
                      style: AppTypography.labelSmall.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

            final displayRole = _translateRole(context, member.familyRole, isOwner);

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
                  UserAvatar(
                    user: member,
                    radius: 16,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      member.displayName,
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
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
                      displayRole,
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
    final l10n = AppLocalizations.of(context)!;
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
                      l10n.linkAccountTitle,
                      style: AppTypography.titleMedium.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.guestModeDesc,
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
                l10n.connectionOptions,
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
