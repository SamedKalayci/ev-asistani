import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../router/app_router.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../profile/providers/family_provider.dart';

/// Kayıt Ol Ekranı (RegisterScreen) — Modern Stitch Tasarımı ile.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isLoading = false;
  bool _isAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Kayıt Ol Aksiyonu ───────────────────────────────────────────────────

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.registerConsentError),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.registerUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'E-posta adresinize onay bağlantısı gönderildi. Lütfen e-postanızı onaylayıp giriş yapın.',
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go(AppRoutes.login);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'Kayıt olunamadı.';
        if (e.code == 'email-already-in-use') {
          message = 'Bu e-posta adresi zaten kullanımda.';
        } else if (e.code == 'weak-password') {
          message = 'Şifre çok zayıf. En az 6 karakter kullanın.';
        } else if (e.code == 'invalid-email') {
          message = 'Geçersiz e-posta adresi.';
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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Logo & Başlık ─────────────────────────────────────
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.md,
                        ),
                        child: Icon(
                          Icons.person_add_rounded,
                          size: 36,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Hesap Oluştur',
                      style: AppTypography.displayMedium.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Ev Asistanı dünyasına hoş geldiniz',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // ── Ad Soyad Girdi Alanı ───────────────────────────────
                    AppTextField(
                      label: 'Adınız Soyadınız',
                      hintText: 'Ahmet Yılmaz',
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Adınız Soyadınız zorunludur.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

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
                        final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegex.hasMatch(v.trim())) {
                          return 'Geçerli bir e-posta adresi girin.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ── Şifre Girdi Alanı ──────────────────────────────────
                    AppTextField(
                      label: 'Şifre',
                      hintText: 'En az 6 karakter',
                      controller: _passwordController,
                      obscureText: _isPasswordObscure,
                      textInputAction: TextInputAction.next,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () => setState(
                            () => _isPasswordObscure = !_isPasswordObscure),
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

                    const SizedBox(height: AppSpacing.md),

                    // ── Şifre Tekrar Girdi Alanı ────────────────────────────
                    AppTextField(
                      label: 'Şifre Tekrarı',
                      hintText: 'Şifrenizi doğrulayın',
                      controller: _confirmPasswordController,
                      obscureText: _isConfirmPasswordObscure,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _register(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordObscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () => setState(() =>
                            _isConfirmPasswordObscure =
                                !_isConfirmPasswordObscure),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Şifre tekrarı zorunludur.';
                        }
                        if (v != _passwordController.text) {
                          return 'Şifreler birbiriyle eşleşmiyor.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),
                    _buildConsentCheckboxRow(colorScheme),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Kayıt Ol Butonu ────────────────────────────────────
                    PrimaryButton(
                      text: 'Kayıt Ol',
                      icon: Icons.check_circle_outline_rounded,
                      isLoading: _isLoading,
                      onPressed: _register,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // ── Giriş Yap Bağlantısı ───────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Zaten hesabınız var mı?',
                          style: AppTypography.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.login),
                          child: Text(
                            'Giriş Yapın',
                            style: AppTypography.labelLarge.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildConsentCheckboxRow(ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _isAccepted,
            onChanged: (val) {
              setState(() {
                _isAccepted = val ?? false;
              });
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurface,
                height: 1.4,
              ),
              children: [
                if (l10n.registerConsentPrefix.isNotEmpty)
                  TextSpan(text: l10n.registerConsentPrefix),
                TextSpan(
                  text: l10n.consentTermsAndPrivacy,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final Uri url = Uri.parse('https://samedkalayci.github.io/ev-asistani-privacy/');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                ),
                if (l10n.registerConsentSuffix.isNotEmpty)
                  TextSpan(text: l10n.registerConsentSuffix),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
