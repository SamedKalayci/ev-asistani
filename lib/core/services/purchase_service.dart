import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../config/env_config.dart';

/// RevenueCat In-App Purchase ve Subscription altyapısını yöneten singleton servis.
class PurchaseService {
  PurchaseService._();
  static final PurchaseService instance = PurchaseService._();

  bool _isInitialized = false;

  /// RevenueCat SDK'sını başlatır (Web ve masaüstü platformlarında güvenle bypass eder).
  Future<void> init({String? userId}) async {
    if (kIsWeb || _isInitialized) return;
    if (!Platform.isAndroid && !Platform.isIOS) return;

    try {
      final apiKey = Platform.isAndroid 
          ? EnvConfig.revenueCatApiKeyAndroid 
          : EnvConfig.revenueCatApiKeyIOS;
      final configuration = PurchasesConfiguration(apiKey);
      if (userId != null && userId.isNotEmpty) {
        configuration.appUserID = userId;
      }
      await Purchases.configure(configuration);
      _isInitialized = true;
    } catch (e) {
      debugPrint('RevenueCat configure uyarısı/hatası: $e');
    }
  }

  /// Mevcut kullanıcı satın alım paketlerini (Offerings) getirir.
  Future<Offerings?> getOfferings() async {
    if (kIsWeb || !_isInitialized) return null;
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('Error getting offerings: $e');
      return null;
    }
  }

  /// Belirli bir paketi satın alır.
  Future<CustomerInfo?> purchasePackage(Package package) async {
    if (kIsWeb || !_isInitialized) return null;
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      return customerInfo;
    } catch (e) {
      debugPrint('Purchase package error: $e');
      rethrow;
    }
  }

  /// Geçmiş satın alımları geri yükler.
  Future<CustomerInfo?> restorePurchases() async {
    if (kIsWeb || !_isInitialized) return null;
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo;
    } catch (e) {
      debugPrint('Restore purchases error: $e');
      rethrow;
    }
  }

  /// Müşteri bilgilerini ve aktif aboneliklerini (CustomerInfo) sorgular.
  Future<CustomerInfo?> getCustomerInfo() async {
    if (kIsWeb || !_isInitialized) return null;
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      debugPrint('Error getting customer info: $e');
      return null;
    }
  }

  /// Müşterinin aktif 'pro' veya 'premium' hakkı (Entitlement) var mı kontrol eder.
  bool hasActiveEntitlement(CustomerInfo? customerInfo) {
    if (customerInfo == null) return false;
    final entitlements = customerInfo.entitlements.all;
    return (entitlements['pro']?.isActive ?? false) ||
        (entitlements['premium']?.isActive ?? false);
  }
}
