import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/primary_button.dart';

/// Profil Görseli & Kullanıcı Adı Düzenleme Modalı (`image_e88bc4.png` tasarımına tam uyumlu).
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
  String? _selectedAvatarUrl;
  AvatarType _selectedAvatarType = AvatarType.presetAvatar;
  String? _selectedFamilyRole;
  bool _isLoading = false;

  // Aile içi rol seçenekleri
  static const List<String> _familyRoles = [
    '👑 Ev Sahibi',
    '👨‍👩‍👧 Anne',
    '👨‍👩‍👦 Baba',
    '👶 Çocuk',
    '🏠 Ev Arkadaşı',
    '🐾 Diğer/Ev Sakini',
  ];

  // Tasarımdaki Hazır 3D / Vektör Avatar Örnekleri
  static const List<String> _presetAvatars = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150',
  ];

  // Tasarımdaki Eğlenceli Emojiler
  static const List<String> _emojis = [
    '😊',
    '😎',
    '🥳',
    '🚀',
    '⭐',
    '👑',
    '🦊',
    '🏡',
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider).valueOrNull;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _selectedAvatarUrl = user?.effectiveAvatarUrl;
    _selectedAvatarType = user?.safeAvatarType ?? AvatarType.presetAvatar;
    _selectedFamilyRole = user?.familyRole;
  }

  @override
  void dispose() {
    _nameController.dispose();
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

    setState(() => _isLoading = true);

    try {
      final firestoreService = ref.read(firestoreServiceProvider);

      await firestoreService.updateUserProfile(user.uid, {
        'name': newName,
        'displayName': newName,
        'avatarUrl': _selectedAvatarUrl,
        'avatarType': _selectedAvatarType.name,
        'photoUrl': _selectedAvatarUrl,
        if (_selectedFamilyRole != null) 'familyRole': _selectedFamilyRole,
      });

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
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
                'Profil Düzenle',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Üst Avatar Önizlemesi ─────────────────────────────────────────
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryContainer,
                      boxShadow: AppShadows.md,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: _selectedAvatarType == AvatarType.emoji
                          ? Text(
                              _selectedAvatarUrl ?? '😊',
                              style: const TextStyle(fontSize: 48),
                            )
                          : CircleAvatar(
                              radius: 46,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                _selectedAvatarUrl ?? _presetAvatars.first,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── 1. KULLANICI BİLGİLERİ ───────────────────────────────────────
            _buildSectionTitle(colorScheme, 'KULLANICI BİLGİLERİ'),
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

            // Aile İçi Rol Seçimi
            DropdownButtonFormField<String>(
              value: _selectedFamilyRole,
              decoration: InputDecoration(
                labelText: 'Aile İçi Rolünüz',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.borderLg,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
              ),
              items: _familyRoles.map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => _selectedFamilyRole = val);
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── 2. HAZIR AVATARLAR ───────────────────────────────────────────
            _buildSectionTitle(colorScheme, 'HAZIR AVATARLAR'),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _presetAvatars.map((url) {
                final isSelected = _selectedAvatarType == AvatarType.presetAvatar &&
                    _selectedAvatarUrl == url;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatarUrl = url;
                      _selectedAvatarType = AvatarType.presetAvatar;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: isSelected ? AppShadows.xs : null,
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: colorScheme.surfaceContainerLow,
                      backgroundImage: NetworkImage(url),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── 3. EMOJİLER ──────────────────────────────────────────────────
            _buildSectionTitle(colorScheme, 'EMOJİLER'),
            const SizedBox(height: AppSpacing.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _emojis.map((emoji) {
                  final isSelected = _selectedAvatarType == AvatarType.emoji &&
                      _selectedAvatarUrl == emoji;

                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatarUrl = emoji;
                          _selectedAvatarType = AvatarType.emoji;
                        });
                      },
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryContainer
                              : colorScheme.surfaceContainerLow,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
