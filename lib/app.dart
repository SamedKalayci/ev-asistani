import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/user_provider.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';

class EvAsistaniApp extends ConsumerWidget {
  const EvAsistaniApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Uygulama açılışında anonim auth'u tetikle (sonucu beklemeye gerek yok —
    // bootstrapAuthProvider zaten auth akışını başlatıyor).
    ref.watch(bootstrapAuthProvider);

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Ev Asistanı',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
