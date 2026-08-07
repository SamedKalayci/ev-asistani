import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../router/app_router.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../profile/providers/family_provider.dart';

/// E-posta Doğrulama Bekleme Ekranı (EmailVerificationScreen).
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  bool _isChecking = false;
  bool _isResending = false;

  Future<void> _checkVerificationStatus() async {
    setState(() => _isChecking = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        final updatedUser = FirebaseAuth.instance.currentUser;

        if (updatedUser != null && updatedUser.emailVerified) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('E-posta adresiniz başarıyla doğrulandı! 🎉'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.go(AppRoutes.home);
          }
          return;
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'E-posta henüz doğrulanmamış. Lütfen gelen kutunuzu veya spam klasörünüzü kontrol edin.',
            ),
            backgroundColor: AppColors.tertiary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kontrol sırasında hata oluştu: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() => _isResending = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Doğrulama e-postası tekrar gönderildi! 📧 Gelen kutunuzu kontrol edin.',
              ),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'E-posta gönderilemedi.';
        if (e.code == 'too-many-requests') {
          message = 'Çok fazla istek atıldı. Lütfen biraz bekleyip tekrar deneyin.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  Future<void> _signOutAndReturn() async {
    await ref.read(authRepositoryProvider).signOut();
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontal,
              vertical: AppSpacing.xl,
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon Header
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.md,
                      ),
                      child: Icon(
                        Icons.mark_email_unread_rounded,
                        size: 40,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    'E-posta Adresinizi Doğrulayın',
                    style: AppTypography.displayMedium.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    email.isNotEmpty
                        ? '$email adresine bir doğrulama bağlantısı gönderdik.'
                        : 'Hesabınıza bir doğrulama bağlantısı gönderdik.',
                    style: AppTypography.bodyLarge.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  Text(
                    'Lütfen e-postanızdaki bağlantıya tıklayarak hesabınızı onaylayın.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Button 1: Check verification status
                  PrimaryButton(
                    text: 'Doğruladım / Kontrol Et',
                    icon: Icons.refresh_rounded,
                    isLoading: _isChecking,
                    onPressed: _checkVerificationStatus,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Button 2: Resend email
                  OutlinedButton.icon(
                    onPressed: _isResending ? null : _resendVerificationEmail,
                    icon: _isResending
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          )
                        : const Icon(Icons.send_rounded, size: 20),
                    label: Text(_isResending
                        ? 'Gönderiliyor...'
                        : 'Tekrar Mail Gönder'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Button 3: Sign out and return to login
                  TextButton.icon(
                    onPressed: _signOutAndReturn,
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Farklı Hesap / Giriş Ekranına Dön'),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
