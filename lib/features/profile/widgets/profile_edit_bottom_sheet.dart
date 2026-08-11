import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/family_provider.dart';

/// Profil Görseli, Kullanıcı Adı, Ev Adı & Rol Düzenleme Modalı.
class ProfileEditBottomSheet extends ConsumerStatefulWidget {
  const ProfileEditBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProfileEditBottomSheet(),
    );
  }

  @override
  ConsumerState<ProfileEditBottomSheet> createState() =>
      _ProfileEditBottomSheetState();
}

class _ProfileEditBottomSheetState
    extends ConsumerState<ProfileEditBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _homeNameController;
  String? _selectedAvatarUrl;
  bool _isLoading = false;

  // Hızlı Seçim Rol Önerileri
  static const List<String> _roleSuggestions = [
    '👑 Ev Sahibi',
    '👨‍👩‍👧 Anne',
    '👨‍👩‍👦 Baba',
    '👶 Çocuk',
    '🏠 Ev Arkadaşı',
    '🐾 Ev Sakini',
  ];

  // Yerel Assets PNG Avatar Listesi
  static const List<String> _presetAvatars = [
    'assets/avatars/critters-1786448610540.png',
    'assets/avatars/critters-1786448624909.png',
    'assets/avatars/critters-1786448628488.png',
    'assets/avatars/critters-1786448632066.png',
    'assets/avatars/critters-1786448635139.png',
    'assets/avatars/critters-1786448638050.png',
    'assets/avatars/critters-1786448641398.png',
    'assets/avatars/critters-1786448645288.png',
    'assets/avatars/critters-1786449230352.png',
    'assets/avatars/critters-1786449238167.png',
    'assets/avatars/critters-1786449241376.png',
    'assets/avatars/critters-1786449246792.png',
    'assets/avatars/critters-1786449254090.png',
    'assets/avatars/dylan-1786448716806.png',
    'assets/avatars/dylan-1786448728280.png',
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider).valueOrNull;
    final family = ref.read(currentFamilyProvider).valueOrNull;

    _nameController = TextEditingController(text: user?.displayName ?? '');
    _roleController = TextEditingController(text: user?.familyRole ?? '');
    _homeNameController = TextEditingController(text: family?.name ?? '');
    _selectedAvatarUrl = user?.effectiveAvatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _homeNameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final user = ref.read(userProvider).valueOrNull;
    if (user == null) return;

    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen geçerli bir isim girin.')),
      );
      return;
    }

    final newRole = _roleController.text.trim();
    final newHomeName = _homeNameController.text.trim();

    setState(() => _isLoading = true);

    try {
      final firestoreService = ref.read(firestoreServiceProvider);

      // Kullanıcı profilini güncelle
      await firestoreService.updateUserProfile(user.uid, {
        'name': newName,
        'displayName': newName,
        'avatarUrl': _selectedAvatarUrl,
        'avatarType': AvatarType.presetAvatar.name,
        'photoUrl': _selectedAvatarUrl,
        'familyRole': newRole,
      });

      // Ev adını da güncelle (varsa)
      final hasFamily = ref.read(hasRealFamilyProvider);
      if (hasFamily && newHomeName.isNotEmpty) {
        await ref
            .read(familyNotifierProvider.notifier)
            .updateFamilyName(newHomeName);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil bilgileriniz güncellendi!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata oluştu: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildAvatarImage(String? url, {required double size}) {
    if (url == null || url.isEmpty) {
      return Icon(Icons.person_rounded, size: size * 0.6, color: AppColors.primary);
    }

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return ClipOval(
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.person_rounded,
            size: size * 0.55,
            color: AppColors.primary,
          ),
        ),
      );
    }

    return ClipOval(
      child: Image.asset(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.person_rounded,
          size: size * 0.55,
          color: AppColors.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final hasFamily = ref.watch(hasRealFamilyProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.borderTopXl,
        boxShadow: AppShadows.lg,
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xl + bottomInset,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sürükleme Çubuğu
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: AppRadius.borderFull,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Başlık
            Center(
              child: Text(
                'Profil ve Ev Bilgilerini Düzenle',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Üst Avatar Önizlemesi ─────────────────────────────────────────
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surfaceContainerLow,
                  boxShadow: AppShadows.md,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 3,
                  ),
                ),
                child: _buildAvatarImage(
                  _selectedAvatarUrl ?? _presetAvatars.first,
                  size: 90,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── 1. KULLANICI & EV BİLGİLERİ ─────────────────────────────────
            _buildSectionTitle(colorScheme, 'KULLANICI VE EV BİLGİLERİ'),
            const SizedBox(height: AppSpacing.md),

            // İsim Girişi
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Adınız / Takma Adınız',
                hintText: 'Örn: Ahmet Yılmaz',
                prefixIcon: const Icon(Icons.person_outline_rounded),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.borderLg,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Ev Adı Girişi (Aileye bağlıysa göster)
            if (hasFamily) ...[
              TextFormField(
                controller: _homeNameController,
                decoration: InputDecoration(
                  labelText: l10n.editHomeNameLabel,
                  hintText: l10n.editHomeNameHint,
                  prefixIcon: const Icon(Icons.home_work_outlined),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.borderLg,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Aile İçi Rol Girişi (TextFormField)
            TextFormField(
              controller: _roleController,
              decoration: InputDecoration(
                labelText: 'Aile İçi Rolünüz',
                hintText: 'Örn: Ev Sahibi, Anne, Baba, Ağabey...',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.borderLg,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs + 2),

            // Hızlı Seçim Rol Çipleri
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _roleSuggestions.map((role) {
                  final isSelected = _roleController.text.trim() == role;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(
                        role,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: colorScheme.primaryContainer,
                      backgroundColor: colorScheme.surfaceContainerLow,
                      onSelected: (_) {
                        setState(() {
                          _roleController.text = role;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── 2. YEREL AVATAR SEÇENEKLERİ (YATAY KAYDIRMA) ────────────────
            _buildSectionTitle(colorScheme, 'AVATAR SEÇENEKLERİ'),
            const SizedBox(height: AppSpacing.md),

            SizedBox(
              height: 76,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _presetAvatars.length,
                itemBuilder: (context, index) {
                  final url = _presetAvatars[index];
                  final isSelected = _selectedAvatarUrl == url;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatarUrl = url;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.surfaceContainerLow,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : colorScheme.outlineVariant.withValues(alpha: 0.3),
                            width: isSelected ? 3 : 1.5,
                          ),
                          boxShadow: isSelected ? AppShadows.sm : null,
                        ),
                        child: Center(
                          child: _buildAvatarImage(url, size: 66),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Kaydet Butonu ────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Profil Bilgilerini Kaydet',
                isLoading: _isLoading,
                onPressed: _saveProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ColorScheme colorScheme, String title) {
    return Text(
      title,
      style: AppTypography.labelMedium.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
    );
  }
}
