import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/l10n_helper.dart';
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
        final l10n = context.l10n;
        String message = l10n.signInFailed;
        if (e.code == 'email-not-verified') {
          message = l10n.verificationEmailSent;
        } else if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
          message = l10n.enterValidEmail;
        } else if (e.code == 'wrong-password') {
          message = l10n.passwordRequired;
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

  // ── Misafir Girişi (Üyeliksiz Devam Et) ─────────────────────────────────

  Future<void> _guestLogin() async {
    setState(() => _isLoading = true);

    try {
      final auth = ref.read(firebaseAuthProvider);
      await auth.signInAnonymously();

      if (mounted) {
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.guestLoginSuccess),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.guestLoginFailed(e.toString())),
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

      if (credential == null) return;

      if (mounted) {
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.googleLoginSuccess),
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
            content: Text(e.message ?? e.code),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final message = e.toString().toLowerCase();
        if (message.contains('cancel') || message.contains('12501')) {
          return;
        }
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
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.appleLoginSuccess),
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
            content: Text(e.message ?? e.code),
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

  // ── Dil Seçimi Diyaloğu & Butonu ──────────────────────────────────────────

  void _showLanguageSelectorDialog(BuildContext context) {
    final l10n = context.l10n;
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
    BuildContext dialogContext,
    String code,
    String label,
    bool isSelected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      dense: true,
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check_rounded, color: colorScheme.primary) : null,
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(code);
        Navigator.of(dialogContext).pop();
      },
    );
  }

  Widget _buildLanguageSelectorButton(ColorScheme colorScheme) {
    final currentLocale = ref.watch(localeProvider);
    final flag = switch (currentLocale.languageCode) {
      'en' => '🇬🇧 EN',
      'de' => '🇩🇪 DE',
      'es' => '🇪🇸 ES',
      'fr' => '🇫🇷 FR',
      'az' => '🇦🇿 AZ',
      'el' => '🇬🇷 EL',
      'pt' => '🇧🇷 PT',
      'tr' => '🇹🇷 TR',
      _ => '🌐 ${currentLocale.languageCode.toUpperCase()}',
    };

    return InkWell(
      onTap: () => _showLanguageSelectorDialog(context),
      borderRadius: AppRadius.borderFull,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: AppRadius.borderFull,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded, size: 16),
            const SizedBox(width: 4),
            Text(
              flag,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Şifremi Unuttum Diyaloğu ─────────────────────────────────────────────

  Future<void> _showForgotPasswordDialog() async {
    final l10n = context.l10n;
    final resetCtrl = TextEditingController(text: _emailController.text.trim());
    final dialogKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.forgotPassword),
        content: Form(
          key: dialogKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.forgotPasswordDesc),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: l10n.emailAddress,
                hintText: l10n.emailHint,
                controller: resetCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.emailRequired;
                  }
                  if (!v.contains('@') || !v.contains('.')) {
                    return l10n.enterValidEmail;
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
            child: Text(l10n.cancel),
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
                      SnackBar(
                        content: Text(l10n.passwordResetSent),
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
            child: Text(l10n.send),
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
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Stack(
          children: [
            // Top Right Language Selector Button
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.pageHorizontal,
              child: _buildLanguageSelectorButton(colorScheme),
            ),
            Center(
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
                        const SizedBox(height: AppSpacing.xl),
                        // ── Logo & Başlık ─────────────────────────────────────
                        Center(
                          child: Image.asset(
                            'assets/icon/app_logo.png',
                            width: 110,
                            height: 110,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          l10n.appName,
                          style: AppTypography.displayMedium.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.smartHomeTagline,
                          style: AppTypography.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppSpacing.xl),

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
                              return l10n.passwordRequired;
                            }
                            if (v.length < 6) {
                              return l10n.passwordMinLength;
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
                              l10n.forgotPassword,
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
                          text: l10n.signInBtn,
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
                          label: Text(l10n.signInWithGoogle),
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
                            text: l10n.signInWithApple,
                            height: 52,
                            borderRadius: const BorderRadius.all(Radius.circular(100)),
                          ),
                        ],

                        const SizedBox(height: AppSpacing.md),
                        _buildConsentText(),
                        const SizedBox(height: AppSpacing.md),

                        // ── Kayıt Ol Bağlantısı ─────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.dontHaveAccount,
                              style: AppTypography.bodyMedium.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go(AppRoutes.register),
                              child: Text(
                                l10n.signUpBtn,
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
                                l10n.orDivider,
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
                          label: Text(l10n.tryAsGuest),
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
          ],
        ),
      ),
    );
  }

  Widget _buildConsentText() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTypography.bodySmall.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
          children: [
            TextSpan(text: l10n.consentByContinuing),
            TextSpan(
              text: l10n.consentTermsAndPrivacy,
              style: TextStyle(
                color: theme.colorScheme.primary,
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
            TextSpan(text: l10n.consentAcceptSuffix),
          ],
        ),
      ),
    );
  }
}
