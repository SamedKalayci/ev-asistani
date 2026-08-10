import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../providers/family_provider.dart';

class LinkAccountBottomSheet extends ConsumerStatefulWidget {
  const LinkAccountBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LinkAccountBottomSheet(),
    );
  }

  @override
  ConsumerState<LinkAccountBottomSheet> createState() =>
      _LinkAccountBottomSheetState();
}

class _LinkAccountBottomSheetState
    extends ConsumerState<LinkAccountBottomSheet> {
  bool _isLinkingGoogle = false;
  bool _isLinkingApple = false;

  Future<void> _handleGoogleLink() async {
    setState(() => _isLinkingGoogle = true);
    try {
      final repository = ref.read(authRepositoryProvider);
      final credential = await repository.linkWithGoogle();

      if (mounted) {
        if (credential != null) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Hesabınız başarıyla Google ile bağlandı!'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bağlama hatası: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLinkingGoogle = false);
    }
  }

  Future<void> _handleAppleLink() async {
    setState(() => _isLinkingApple = true);
    try {
      final repository = ref.read(authRepositoryProvider);
      final credential = await repository.linkWithApple();

      if (mounted) {
        if (credential != null) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Hesabınız başarıyla Apple ile bağlandı!'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bağlama hatası: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLinkingApple = false);
    }
  }

  Future<void> _showEmailLinkDialog() async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLinking = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('E-posta ile Bağla'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    label: 'E-posta Adresi',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Gerekli';
                      if (!v.contains('@')) return 'Geçersiz e-posta';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Parola (En az 6 karakter)',
                    controller: passwordController,
                    obscureText: true,
                    validator: (v) {
                      if (v == null || v.trim().length < 6) return 'En az 6 karakter';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              if (!isLinking)
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('İptal'),
                ),
              FilledButton(
                onPressed: isLinking
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        setDialogState(() => isLinking = true);
                        try {
                          Navigator.of(ctx).pop({'email': emailController.text.trim(), 'password': passwordController.text});
                        } finally {
                          setDialogState(() => isLinking = false);
                        }
                      },
                child: isLinking
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Bağla'),
              ),
            ],
          );
        },
      ),
    ).then((result) async {
      if (result != null && result is Map) {
         try {
           final repository = ref.read(authRepositoryProvider);
           final credential = await repository.linkWithEmailAndPassword(
             email: result['email'],
             password: result['password'],
           );
           
           if (mounted && credential != null) {
             Navigator.of(context).pop();
             showDialog(
               context: context,
               builder: (ctx) => AlertDialog(
                 title: const Text('E-posta Doğrulama'),
                 content: const Text(
                   'E-posta adresinize onay linki gönderildi. Bağlantıya tıklayıp e-postanızı onayladıktan sonra e-posta ile giriş yapabilirsiniz.',
                 ),
                 actions: [
                   TextButton(
                     onPressed: () => Navigator.of(ctx).pop(),
                     child: const Text('Tamam'),
                   ),
                 ],
               ),
             );
           }
         } catch (e) {
           if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('Hata: $e'), backgroundColor: AppColors.error),
             );
           }
         }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isBusy = _isLinkingGoogle || _isLinkingApple;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.linkAccountTitle,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.guestModeBottomSheetDesc,
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Google Button
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.borderFull,
              ),
            ),
            icon: _isLinkingGoogle
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : const Icon(Icons.g_mobiledata_rounded, size: 28),
            label: Text(
              _isLinkingGoogle ? 'Bağlanıyor...' : 'Google ile Bağla',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
            onPressed: isBusy ? null : _handleGoogleLink,
          ),
          const SizedBox(height: AppSpacing.md),

          // Apple Button
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.onSurface,
              foregroundColor: colorScheme.surface,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.borderFull,
              ),
            ),
            icon: _isLinkingApple
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.surface,
                    ),
                  )
                : const Icon(Icons.apple_rounded, size: 24),
            label: Text(
              _isLinkingApple ? 'Bağlanıyor...' : 'Apple ile Bağla',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.surface,
              ),
            ),
            onPressed: isBusy ? null : _handleAppleLink,
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // E-posta Button
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.borderFull,
              ),
            ),
            icon: const Icon(Icons.email_rounded, size: 20),
            label: Text(
              'E-posta ile Bağla',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: isBusy ? null : _showEmailLinkDialog,
          ),

          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
