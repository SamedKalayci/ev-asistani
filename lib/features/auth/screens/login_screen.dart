import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../router/app_router.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../profile/providers/family_provider.dart';

/// Giriş Ekranı (LoginScreen) — E-posta/Parola ve Misafir Girişi seçenekleri ile.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── E-posta ile Giriş Yap ───────────────────────────────────────────────

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        context.go(AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'Giriş yapılamadı.';
        if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
          message = 'E-posta veya şifre hatalı.';
        } else if (e.code == 'wrong-password') {
          message = 'Şifre hatalı.';
        } else if (e.code == 'invalid-email') {
          message = 'Geçersiz e-posta adresi.';
        } else if (e.code == 'user-disabled') {
          message = 'Bu hesap dondurulmuş.';
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
        setState(() => _isLoading = false);
      }
    }
  }

  // ── Misafir Girişi (Üyeliksiz Devam Et) ─────────────────────────────────

  Future<void> _guestLogin() async {
    setState(() => _isLoading = true);

    try {
      final auth = ref.read(firebaseAuthProvider);
      await auth.signInAnonymously();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Misafir oturumu ile giriş yapıldı. 👋'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Misafir girişi başarısız: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ── Google ile Giriş Yap ──────────────────────────────────────────────────

  Future<void> _googleLogin() async {
    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final credential = await authRepo.signInWithGoogle();

      if (credential != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google hesabınızla giriş yapıldı. 👋'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go(AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google girişi başarısız: ${e.message ?? e.code}'),
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
        setState(() => _isLoading = false);
      }
    }
  }

  // ── Apple ile Giriş Yap ───────────────────────────────────────────────────

  Future<void> _appleLogin() async {
    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final credential = await authRepo.signInWithApple();

      if (credential != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Apple hesabınızla giriş yapıldı. 👋'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go(AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Apple girişi başarısız: ${e.message ?? e.code}'),
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
        setState(() => _isLoading = false);
      }
    }
  }

  // ── Şifremi Unuttum Diyaloğu ─────────────────────────────────────────────

  Future<void> _showForgotPasswordDialog() async {
    final resetCtrl = TextEditingController(text: _emailController.text.trim());
    final dialogKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Şifremi Unuttum'),
        content: Form(
          key: dialogKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Hesabınıza ait e-posta adresini girin. Size bir şifre sıfırlama bağlantısı göndereceğiz.',
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'E-posta Adresi',
                hintText: 'ornek@email.com',
                controller: resetCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'E-posta adresi girmelisiniz.';
                  }
                  if (!v.contains('@') || !v.contains('.')) {
                    return 'Geçerli bir e-posta girin.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () async {
              if (dialogKey.currentState!.validate()) {
                final email = resetCtrl.text.trim();
                Navigator.of(ctx).pop();
                try {
                  await ref
                      .read(authRepositoryProvider)
                      .sendPasswordResetEmail(email);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Şifre sıfırlama bağlantısı e-postanıza gönderildi! 📧',
                        ),
                        backgroundColor: AppColors.primary,
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
                }
              }
            },
            child: const Text('Gönder'),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontal,
              vertical: AppSpacing.xl,
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Logo & Başlık ─────────────────────────────────────
                    Center(
                      child: Image.asset(
                        'assets/icon/app_logo.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Ev Asistanı',
                      style: AppTypography.displayMedium.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Evindeki her şeyi akıllıca yönet',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    // ── E-posta Girdi Alanı ────────────────────────────────
                    AppTextField(
                      label: 'E-posta Adresi',
                      hintText: 'ornek@email.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'E-posta adresi zorunludur.';
                        }
                        if (!v.contains('@') || !v.contains('.')) {
                          return 'Lütfen geçerli bir e-posta girin.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ── Şifre Girdi Alanı ──────────────────────────────────
                    AppTextField(
                      label: 'Şifre',
                      hintText: '••••••••',
                      controller: _passwordController,
                      obscureText: _isObscure,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _login(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () =>
                            setState(() => _isObscure = !_isObscure),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Şifre zorunludur.';
                        }
                        if (v.length < 6) {
                          return 'Şifre en az 6 karakter olmalıdır.';
                        }
                        return null;
                      },
                    ),

                    // ── Şifremi Unuttum Bağlantısı ─────────────────────────
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: Text(
                          'Şifremi Unuttum',
                          style: AppTypography.labelMedium.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Giriş Yap Butonu ───────────────────────────────────
                    PrimaryButton(
                      text: 'Giriş Yap',
                      icon: Icons.login_rounded,
                      isLoading: _isLoading,
                      onPressed: _login,
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // ── Google ile Giriş Yap Butonu ─────────────────────────
                    OutlinedButton.icon(
                      onPressed: _isLoading ? null : _googleLogin,
                      icon: const Icon(
                        Icons.g_mobiledata_rounded,
                        size: 28,
                        color: AppColors.primary,
                      ),
                      label: const Text('Google ile Giriş Yap'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.borderFull,
                        ),
                      ),
                    ),

                    if (!kIsWeb && Platform.isIOS) ...[
                      const SizedBox(height: AppSpacing.sm),
                      SignInWithAppleButton(
                        onPressed: _isLoading ? () {} : _appleLogin,
                        text: 'Apple ile Giriş Yap',
                        height: 52,
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.md),

                    // ── Kayıt Ol Bağlantısı ─────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hesabınız yok mu?',
                          style: AppTypography.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.register),
                          child: Text(
                            'Kayıt Olun',
                            style: AppTypography.labelLarge.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // ── Seperatör ─────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: colorScheme.outlineVariant
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm),
                          child: Text(
                            'veya',
                            style: AppTypography.bodySmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: colorScheme.outlineVariant
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ── Misafir Girişi Butonu ──────────────────────────────
                    OutlinedButton.icon(
                      onPressed: _isLoading ? null : _guestLogin,
                      icon: const Icon(Icons.person_outline_rounded),
                      label: const Text('Misafir Olarak Deneyin (Üyeliksiz)'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.borderFull,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
