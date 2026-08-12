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
import '../../../core/utils/l10n_helper.dart';
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
          content: Text(context.l10n.registerConsentError),
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
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.verificationEmailSent),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go(AppRoutes.login);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        final l10n = context.l10n;
        String message = l10n.signUpBtn;
        if (e.code == 'email-already-in-use') {
          message = l10n.emailAlreadyInUse;
        } else if (e.code == 'weak-password') {
          message = l10n.passwordMinLength;
        } else if (e.code == 'invalid-email') {
          message = l10n.enterValidEmail;
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
    final l10n = context.l10n;

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
                      l10n.createAccount,
                      style: AppTypography.displayMedium.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.welcomeToApp,
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // ── Ad Soyad Girdi Alanı ───────────────────────────────
                    AppTextField(
                      label: l10n.fullNameLabel,
                      hintText: 'Ahmet Yılmaz',
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.fullNameRequired;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ── E-posta Girdi Alanı ────────────────────────────────
                    AppTextField(
                      label: l10n.emailAddress,
                      hintText: l10n.emailHint,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.emailRequired;
                        }
                        final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegex.hasMatch(v.trim())) {
                          return l10n.enterValidEmail;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ── Şifre Girdi Alanı ──────────────────────────────────
                    AppTextField(
                      label: l10n.passwordLabel,
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
                          return l10n.passwordRequired;
                        }
                        if (v.length < 6) {
                          return l10n.passwordMinLength;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ── Şifre Tekrar Girdi Alanı ────────────────────────────
                    AppTextField(
                      label: l10n.confirmPasswordLabel,
                      hintText: l10n.confirmPasswordHint,
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
                          return l10n.confirmPasswordRequired;
                        }
                        if (v != _passwordController.text) {
                          return l10n.passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),
                    _buildConsentCheckboxRow(colorScheme),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Kayıt Ol Butonu ────────────────────────────────────
                    PrimaryButton(
                      text: l10n.signUpBtn,
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
                          l10n.alreadyHaveAccount,
                          style: AppTypography.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.login),
                          child: Text(
                            l10n.signInBtn,
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
