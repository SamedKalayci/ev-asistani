import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'core/services/notification_service.dart';
import 'core/services/purchase_service.dart';
import 'features/shopping/providers/shopping_provider.dart';
import 'firebase_options.dart';
import 'shared/services/shopping_list_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Çevre değişkenlerini yükle
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('dotenv yüklenemedi (muhtemelen test ortamı veya dosya yok): $e');
  }
  
  // intl tarih verilerini tüm desteklenen diller için başlat
  try {
    for (final lang in ['tr', 'en', 'de', 'es', 'fr', 'az', 'el', 'pt']) {
      await initializeDateFormatting(lang, null);
    }
  } catch (e) {
    debugPrint('initializeDateFormatting hatası: $e');
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase.initializeApp uyarısı: $e');
  }

  // Yerel bildirim servisini başlat ve bildirim izinlerini iste
  try {
    final notificationService = NotificationService.instance;
    await notificationService.init();
    await notificationService.requestPermissions();
  } catch (e) {
    debugPrint('NotificationService başlatılırken hata: $e');
  }

  // RevenueCat In-App Purchase servisini başlat
  try {
    await PurchaseService.instance.init();
  } catch (e) {
    debugPrint('PurchaseService başlatılırken hata: $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        shoppingListServiceProvider.overrideWith(
          (ref) => ShoppingListServiceImpl(ref),
        ),
      ],
      child: const EvAsistaniApp(),
    ),
  );
}

