import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_az.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('az'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'Ev Asistanı'**
  String get appName;

  /// No description provided for @languageSelection.
  ///
  /// In tr, this message translates to:
  /// **'Dil Seçimi'**
  String get languageSelection;

  /// No description provided for @languageSelectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama dilini değiştirin (Türkçe / English)'**
  String get languageSelectionSubtitle;

  /// No description provided for @currencySelection.
  ///
  /// In tr, this message translates to:
  /// **'Para Birimi'**
  String get currencySelection;

  /// No description provided for @currencySelectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Ücret ve bütçe ekranlarında kullanılacak para birimini seçin'**
  String get currencySelectionSubtitle;

  /// No description provided for @preferencesAndSettings.
  ///
  /// In tr, this message translates to:
  /// **'Tercihler ve Ayarlar'**
  String get preferencesAndSettings;

  /// No description provided for @notificationSettings.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Ayarları'**
  String get notificationSettings;

  /// No description provided for @notificationSettingsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Sistem bildirim ayarlarını yönetin'**
  String get notificationSettingsSubtitle;

  /// No description provided for @about.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get about;

  /// No description provided for @aboutSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Ev Asistanı v1.1.0 (Firebase Enabled)'**
  String get aboutSubtitle;

  /// No description provided for @developerLabel.
  ///
  /// In tr, this message translates to:
  /// **'Geliştirici: Samed Kalaycı'**
  String get developerLabel;

  /// No description provided for @aboutDescription.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama: Ev içi düzen ve ortak liste yönetimi uygulaması.'**
  String get aboutDescription;

  /// No description provided for @allRightsReserved.
  ///
  /// In tr, this message translates to:
  /// **'© 2026 Ev Asistanı. Tüm hakları saklıdır.'**
  String get allRightsReserved;

  /// No description provided for @privacyPolicy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası ve Kullanım Koşulları'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Yasal bilgilendirmeleri ve kullanım şartlarını inceleyin'**
  String get privacyPolicySubtitle;

  /// No description provided for @signOut.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get signOut;

  /// No description provided for @signOutSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınızdan güvenli bir şekilde çıkış yapın'**
  String get signOutSubtitle;

  /// No description provided for @deleteAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabımı Sil'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kalıcı olarak hesabınızı ve verilerinizi silin'**
  String get deleteAccountSubtitle;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @confirm.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get confirm;

  /// No description provided for @selectLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil Seçiniz'**
  String get selectLanguage;

  /// No description provided for @turkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @english.
  ///
  /// In tr, this message translates to:
  /// **'İngilizce'**
  String get english;

  /// No description provided for @german.
  ///
  /// In tr, this message translates to:
  /// **'Almanca'**
  String get german;

  /// No description provided for @spanish.
  ///
  /// In tr, this message translates to:
  /// **'İspanyolca'**
  String get spanish;

  /// No description provided for @french.
  ///
  /// In tr, this message translates to:
  /// **'Fransızca'**
  String get french;

  /// No description provided for @azerbaijani.
  ///
  /// In tr, this message translates to:
  /// **'Azerice'**
  String get azerbaijani;

  /// No description provided for @greek.
  ///
  /// In tr, this message translates to:
  /// **'Yunanca'**
  String get greek;

  /// No description provided for @portuguese.
  ///
  /// In tr, this message translates to:
  /// **'Portekizce'**
  String get portuguese;

  /// No description provided for @navHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get navHome;

  /// No description provided for @navInventory.
  ///
  /// In tr, this message translates to:
  /// **'Envanter'**
  String get navInventory;

  /// No description provided for @navShopping.
  ///
  /// In tr, this message translates to:
  /// **'Alışveriş'**
  String get navShopping;

  /// No description provided for @navFinance.
  ///
  /// In tr, this message translates to:
  /// **'Finans'**
  String get navFinance;

  /// No description provided for @navProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @shoppingListTitle.
  ///
  /// In tr, this message translates to:
  /// **'Alışveriş Listesi'**
  String get shoppingListTitle;

  /// No description provided for @toBuyTab.
  ///
  /// In tr, this message translates to:
  /// **'Alınacaklar'**
  String get toBuyTab;

  /// No description provided for @purchasedTab.
  ///
  /// In tr, this message translates to:
  /// **'Alınanlar'**
  String get purchasedTab;

  /// No description provided for @clearCompleted.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get clearCompleted;

  /// No description provided for @newProductHint.
  ///
  /// In tr, this message translates to:
  /// **'Yeni ürün ekle...'**
  String get newProductHint;

  /// No description provided for @itemsCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} Ürün'**
  String itemsCount(int count);

  /// No description provided for @addShoppingItemTitle.
  ///
  /// In tr, this message translates to:
  /// **'Alışveriş Listesine Ürün Ekle'**
  String get addShoppingItemTitle;

  /// No description provided for @productNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ürün Adı'**
  String get productNameLabel;

  /// No description provided for @productNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Süt, Ekmek, Yumurta...'**
  String get productNameHint;

  /// No description provided for @addToListBtn.
  ///
  /// In tr, this message translates to:
  /// **'Listeye Ekle'**
  String get addToListBtn;

  /// No description provided for @itemAddedToast.
  ///
  /// In tr, this message translates to:
  /// **'\"{name}\" alışveriş listesine eklendi! 🛒'**
  String itemAddedToast(String name);

  /// No description provided for @emptyShoppingList.
  ///
  /// In tr, this message translates to:
  /// **'Alışveriş listeniz boş.'**
  String get emptyShoppingList;

  /// No description provided for @financeOverviewTab.
  ///
  /// In tr, this message translates to:
  /// **'Genel Bakış'**
  String get financeOverviewTab;

  /// No description provided for @householdWalletTab.
  ///
  /// In tr, this message translates to:
  /// **'Ev Cüzdanı'**
  String get householdWalletTab;

  /// No description provided for @accountsTab.
  ///
  /// In tr, this message translates to:
  /// **'Hesaplar'**
  String get accountsTab;

  /// No description provided for @viewSummary.
  ///
  /// In tr, this message translates to:
  /// **'Özet Gör'**
  String get viewSummary;

  /// No description provided for @incomeExpenseBalance.
  ///
  /// In tr, this message translates to:
  /// **'Gelir/Gider Dengesi'**
  String get incomeExpenseBalance;

  /// No description provided for @totalIncome.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Gelir'**
  String get totalIncome;

  /// No description provided for @totalExpense.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Gider'**
  String get totalExpense;

  /// No description provided for @personalExpenses.
  ///
  /// In tr, this message translates to:
  /// **'Bireysel Harcamalar'**
  String get personalExpenses;

  /// No description provided for @noAccountYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz hesap eklenmedi.'**
  String get noAccountYet;

  /// No description provided for @paymentSchedule.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Takvimi'**
  String get paymentSchedule;

  /// No description provided for @realizedPayments.
  ///
  /// In tr, this message translates to:
  /// **'Gerçekleşenler'**
  String get realizedPayments;

  /// No description provided for @accountScheduleHeader.
  ///
  /// In tr, this message translates to:
  /// **'Hesap / Takvim'**
  String get accountScheduleHeader;

  /// No description provided for @monthlyFreeBudget.
  ///
  /// In tr, this message translates to:
  /// **'Kalan Serbest Bütçe'**
  String get monthlyFreeBudget;

  /// No description provided for @quickAddExpense.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Gider Ekle'**
  String get quickAddExpense;

  /// No description provided for @greetingUser.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba, {name}'**
  String greetingUser(String name);

  /// No description provided for @quickAdd.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Ekle'**
  String get quickAdd;

  /// No description provided for @expiringSoonTitle.
  ///
  /// In tr, this message translates to:
  /// **'Son Kullanma Tarihleri Yaklaşıyor'**
  String get expiringSoonTitle;

  /// No description provided for @warrantiesExpiringTitle.
  ///
  /// In tr, this message translates to:
  /// **'Garantisi Bitenler & Yaklaşanlar'**
  String get warrantiesExpiringTitle;

  /// No description provided for @shoppingSummaryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Alışveriş Listesi Özet'**
  String get shoppingSummaryTitle;

  /// No description provided for @viewAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Gör'**
  String get viewAll;

  /// No description provided for @urgentExpirationsCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} Acil Ürün'**
  String urgentExpirationsCount(int count);

  /// No description provided for @urgentWarrantiesCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} Acil Garanti'**
  String urgentWarrantiesCount(int count);

  /// No description provided for @inventoryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ev Envanteri'**
  String get inventoryTitle;

  /// No description provided for @expirationTab.
  ///
  /// In tr, this message translates to:
  /// **'Son Kullanma'**
  String get expirationTab;

  /// No description provided for @warrantyTab.
  ///
  /// In tr, this message translates to:
  /// **'Garantiler'**
  String get warrantyTab;

  /// No description provided for @vaultTab.
  ///
  /// In tr, this message translates to:
  /// **'Ev Kasası'**
  String get vaultTab;

  /// No description provided for @addExpirationItem.
  ///
  /// In tr, this message translates to:
  /// **'Ürün Ekle'**
  String get addExpirationItem;

  /// No description provided for @addWarrantyItem.
  ///
  /// In tr, this message translates to:
  /// **'Garanti Ekle'**
  String get addWarrantyItem;

  /// No description provided for @periodicMaintenance.
  ///
  /// In tr, this message translates to:
  /// **'Periyodik Bakım Takvimi'**
  String get periodicMaintenance;

  /// No description provided for @homeGuideWifi.
  ///
  /// In tr, this message translates to:
  /// **'Ev Rehberi & Wi-Fi'**
  String get homeGuideWifi;

  /// No description provided for @digitalVaultSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Evinizle ilgili tüm kritik belgeler, rehberler ve acil durum numaraları şifreli olarak güvenle saklanır.'**
  String get digitalVaultSubtitle;

  /// No description provided for @myHomeAndFamily.
  ///
  /// In tr, this message translates to:
  /// **'Evim & Aile Yönetimi'**
  String get myHomeAndFamily;

  /// No description provided for @inviteCode.
  ///
  /// In tr, this message translates to:
  /// **'Davet Kodu'**
  String get inviteCode;

  /// No description provided for @familyMembers.
  ///
  /// In tr, this message translates to:
  /// **'Aile Üyeleri'**
  String get familyMembers;

  /// No description provided for @proMember.
  ///
  /// In tr, this message translates to:
  /// **'PRO Üye'**
  String get proMember;

  /// No description provided for @proHouseOwner.
  ///
  /// In tr, this message translates to:
  /// **'PRO Ev Sahibi'**
  String get proHouseOwner;

  /// No description provided for @houseOwner.
  ///
  /// In tr, this message translates to:
  /// **'Ev Sahibi'**
  String get houseOwner;

  /// No description provided for @legalSection.
  ///
  /// In tr, this message translates to:
  /// **'Yasal'**
  String get legalSection;

  /// No description provided for @legalAndInfo.
  ///
  /// In tr, this message translates to:
  /// **'Yasal ve Bilgi'**
  String get legalAndInfo;

  /// No description provided for @accountActions.
  ///
  /// In tr, this message translates to:
  /// **'Hesap İşlemleri'**
  String get accountActions;

  /// No description provided for @removeAdsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Reklamları Kaldır (Ad-Free)'**
  String get removeAdsTitle;

  /// No description provided for @memberCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} Üye'**
  String memberCount(int count);

  /// No description provided for @removeAdsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Tek seferlik ödeme ile kalıcı olarak reklamsız kullanın!'**
  String get removeAdsSubtitle;

  /// No description provided for @removeAdsActive.
  ///
  /// In tr, this message translates to:
  /// **'Reklamsız Sürüm Aktif ✅'**
  String get removeAdsActive;

  /// No description provided for @specialPriceOffer.
  ///
  /// In tr, this message translates to:
  /// **'Özel Fiyat! Sadece bir kahve fiyatına.'**
  String get specialPriceOffer;

  /// No description provided for @buyNow.
  ///
  /// In tr, this message translates to:
  /// **'Satın Al'**
  String get buyNow;

  /// No description provided for @restorePurchases.
  ///
  /// In tr, this message translates to:
  /// **'Geri Yükle'**
  String get restorePurchases;

  /// No description provided for @introPopupTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ev Asistanı\'nı Reklamsız Kullanın!'**
  String get introPopupTitle;

  /// No description provided for @introPopupDesc.
  ///
  /// In tr, this message translates to:
  /// **'Çok uygun fiyata tek seferlik ödeme yaparak tüm reklamları kalıcı olarak kaldırabilirsiniz.'**
  String get introPopupDesc;

  /// No description provided for @skipForNow.
  ///
  /// In tr, this message translates to:
  /// **'Şimdilik Geç'**
  String get skipForNow;

  /// No description provided for @shoppingListSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Alınacak ve alınan ürünleri kolayca takip edin.'**
  String get shoppingListSubtitle;

  /// No description provided for @clearCompletedConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Alınanları Temizle'**
  String get clearCompletedConfirmTitle;

  /// No description provided for @clearCompletedConfirmDesc.
  ///
  /// In tr, this message translates to:
  /// **'Alınan tüm ürünler listeden kaldırılacak. Devam et?'**
  String get clearCompletedConfirmDesc;

  /// No description provided for @emptyShoppingListDesc.
  ///
  /// In tr, this message translates to:
  /// **'Ekmek, süt, meyve gibi ihtiyacınız olan ürünleri yukarıdaki alandan ekleyebilirsiniz.'**
  String get emptyShoppingListDesc;

  /// No description provided for @allPurchasedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Tüm ürünler alındı! 🎉'**
  String get allPurchasedMessage;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @accountTypeCash.
  ///
  /// In tr, this message translates to:
  /// **'Nakit'**
  String get accountTypeCash;

  /// No description provided for @accountTypeBank.
  ///
  /// In tr, this message translates to:
  /// **'Banka'**
  String get accountTypeBank;

  /// No description provided for @accountTypeCreditCard.
  ///
  /// In tr, this message translates to:
  /// **'Kredi Kartı'**
  String get accountTypeCreditCard;

  /// No description provided for @accountTypeDebtCredit.
  ///
  /// In tr, this message translates to:
  /// **'Cari (Borç/Alacak)'**
  String get accountTypeDebtCredit;

  /// No description provided for @statementCutoff.
  ///
  /// In tr, this message translates to:
  /// **'Fatura kesim: {day}'**
  String statementCutoff(String day);

  /// No description provided for @planBudget.
  ///
  /// In tr, this message translates to:
  /// **'Bütçeni Planla'**
  String get planBudget;

  /// No description provided for @categoryBudgets.
  ///
  /// In tr, this message translates to:
  /// **'Kategori Bütçeleri'**
  String get categoryBudgets;

  /// No description provided for @noBudgetsSet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bir bütçe hedefi belirlemediniz. \"Bütçeni Planla\" butonuna tıklayarak başlayın.'**
  String get noBudgetsSet;

  /// No description provided for @limitExceeded.
  ///
  /// In tr, this message translates to:
  /// **'Limit aşıldı!'**
  String get limitExceeded;

  /// No description provided for @noExpensesPeriod.
  ///
  /// In tr, this message translates to:
  /// **'Bu dönem hiç harcama yok.'**
  String get noExpensesPeriod;

  /// No description provided for @expenseHistory.
  ///
  /// In tr, this message translates to:
  /// **'Harcama Geçmişi'**
  String get expenseHistory;

  /// No description provided for @noRecordsFound.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt bulunmuyor.'**
  String get noRecordsFound;

  /// No description provided for @financeManagementPro.
  ///
  /// In tr, this message translates to:
  /// **'Finans Yönetimi PRO'**
  String get financeManagementPro;

  /// No description provided for @financeProDesc.
  ///
  /// In tr, this message translates to:
  /// **'Ailenizin tüm gelir, gider, banka hesapları, ödeme takvimi ve nakit akışını kontrol etmek için PRO üyeliğe yükseltin.'**
  String get financeProDesc;

  /// No description provided for @expirationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Son Kullanma Tarihleri'**
  String get expirationTitle;

  /// No description provided for @freshnessSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Envanterinizdeki ürünlerin tazelik durumunu takip edin.'**
  String get freshnessSubtitle;

  /// No description provided for @searchProductLocationHint.
  ///
  /// In tr, this message translates to:
  /// **'Ürün adı veya konum ara...'**
  String get searchProductLocationHint;

  /// No description provided for @clearExpired.
  ///
  /// In tr, this message translates to:
  /// **'Süresi Dolanları Temizle'**
  String get clearExpired;

  /// No description provided for @noProductsYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz Ürün Yok'**
  String get noProductsYet;

  /// No description provided for @noProductsFound.
  ///
  /// In tr, this message translates to:
  /// **'Ürün Bulunamadı'**
  String get noProductsFound;

  /// No description provided for @addFirstProductDesc.
  ///
  /// In tr, this message translates to:
  /// **'İlk ürününüzü eklemek için \"Ürün Ekle\" butonuna basın.'**
  String get addFirstProductDesc;

  /// No description provided for @noMatchingProductsDesc.
  ///
  /// In tr, this message translates to:
  /// **'Arama veya filtreleme kriterlerinize uygun ürün bulunmuyor.'**
  String get noMatchingProductsDesc;

  /// No description provided for @clearFilters.
  ///
  /// In tr, this message translates to:
  /// **'Filtreleri Temizle'**
  String get clearFilters;

  /// No description provided for @expirationDateLabel.
  ///
  /// In tr, this message translates to:
  /// **'Son Kullanma'**
  String get expirationDateLabel;

  /// No description provided for @trashAndShopping.
  ///
  /// In tr, this message translates to:
  /// **'Çöpe At & Alışverişe Ekle'**
  String get trashAndShopping;

  /// No description provided for @warrantyTrackingTitle.
  ///
  /// In tr, this message translates to:
  /// **'Garanti Takibi'**
  String get warrantyTrackingTitle;

  /// No description provided for @warrantySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Cihazlarınızın ve eşyalarınızın garanti sürelerini takip edin.'**
  String get warrantySubtitle;

  /// No description provided for @searchDeviceBrandHint.
  ///
  /// In tr, this message translates to:
  /// **'Cihaz, marka veya mağaza ara...'**
  String get searchDeviceBrandHint;

  /// No description provided for @noWarrantyRecordsYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz Garanti Kaydı Yok'**
  String get noWarrantyRecordsYet;

  /// No description provided for @noWarrantyRecordsFound.
  ///
  /// In tr, this message translates to:
  /// **'Garanti Kaydı Bulunamadı'**
  String get noWarrantyRecordsFound;

  /// No description provided for @addFirstWarrantyDesc.
  ///
  /// In tr, this message translates to:
  /// **'İlk garanti kaydınızı eklemek için \"Garanti Ekle\" butonuna basın.'**
  String get addFirstWarrantyDesc;

  /// No description provided for @noMatchingWarrantiesDesc.
  ///
  /// In tr, this message translates to:
  /// **'Arama veya filtreleme kriterlerinize uygun kayıt bulunmuyor.'**
  String get noMatchingWarrantiesDesc;

  /// No description provided for @documentsAndWarranties.
  ///
  /// In tr, this message translates to:
  /// **'Belgeler & Garantiler'**
  String get documentsAndWarranties;

  /// No description provided for @serviceAndEmergencyNumbers.
  ///
  /// In tr, this message translates to:
  /// **'Servis & Acil Numaralar'**
  String get serviceAndEmergencyNumbers;

  /// No description provided for @uploadDocument.
  ///
  /// In tr, this message translates to:
  /// **'Belge Yükle'**
  String get uploadDocument;

  /// No description provided for @noDocumentsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Belge Bulunmuyor'**
  String get noDocumentsTitle;

  /// No description provided for @noDocumentsDesc.
  ///
  /// In tr, this message translates to:
  /// **'Tapu, sigorta poliçesi veya önemli evraklarınızı Dijital Ev Kasası\'na güvenle kaydedin.'**
  String get noDocumentsDesc;

  /// No description provided for @uploadFirstDocument.
  ///
  /// In tr, this message translates to:
  /// **'İlk Belgeyi Yükle'**
  String get uploadFirstDocument;

  /// No description provided for @addNumber.
  ///
  /// In tr, this message translates to:
  /// **'Numara Ekle'**
  String get addNumber;

  /// No description provided for @noEmergencyContactsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı Numara Bulunmuyor'**
  String get noEmergencyContactsTitle;

  /// No description provided for @noEmergencyContactsDesc.
  ///
  /// In tr, this message translates to:
  /// **'Elektrikçi, tesisatçı veya acil durum kişilerini ekleyerek tek tıkla arama yapın.'**
  String get noEmergencyContactsDesc;

  /// No description provided for @addFirstNumber.
  ///
  /// In tr, this message translates to:
  /// **'İlk Numarayı Ekle'**
  String get addFirstNumber;

  /// No description provided for @call.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get call;

  /// No description provided for @copy.
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get copy;

  /// No description provided for @newMaintenanceTask.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Periyodik Bakım Görevi'**
  String get newMaintenanceTask;

  /// No description provided for @maintenanceTitleLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bakım Adı'**
  String get maintenanceTitleLabel;

  /// No description provided for @maintenanceTitleHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Kombi Yıllık Bakım, Klima Filtre Temizliği'**
  String get maintenanceTitleHint;

  /// No description provided for @descriptionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama / Detaylar'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Filtreler yıkanacak, servis çağrılacak.'**
  String get descriptionHint;

  /// No description provided for @scheduledDateLabel.
  ///
  /// In tr, this message translates to:
  /// **'Planlanan Bakım Tarihi'**
  String get scheduledDateLabel;

  /// No description provided for @saveTask.
  ///
  /// In tr, this message translates to:
  /// **'Görevi Kaydet'**
  String get saveTask;

  /// No description provided for @addHomeInfo.
  ///
  /// In tr, this message translates to:
  /// **'+ Ev Bilgisi Ekle'**
  String get addHomeInfo;

  /// No description provided for @noGuideTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rehber Bilgisi Bulunmuyor'**
  String get noGuideTitle;

  /// No description provided for @noGuideDesc.
  ///
  /// In tr, this message translates to:
  /// **'Wi-Fi şifresi, abonelik numaraları veya vanaların yerini ekleyerek ev halkı ile anlık paylaşın.'**
  String get noGuideDesc;

  /// No description provided for @deleteItem.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get deleteItem;

  /// No description provided for @deleteConfirmDesc.
  ///
  /// In tr, this message translates to:
  /// **'adlı kayıt kalıcı olarak silinecek.'**
  String get deleteConfirmDesc;

  /// No description provided for @addWarranty.
  ///
  /// In tr, this message translates to:
  /// **'Garanti Ekle'**
  String get addWarranty;

  /// No description provided for @addMaintenanceTask.
  ///
  /// In tr, this message translates to:
  /// **'Bakım Ekle'**
  String get addMaintenanceTask;

  /// No description provided for @noMaintenanceTasksTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bakım Görevi Bulunmuyor'**
  String get noMaintenanceTasksTitle;

  /// No description provided for @noMaintenanceTasksDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kombi bakımı, baca temizliği veya filtre değişimlerini ekleyerek zamanı gelince hatırlatma alın.'**
  String get noMaintenanceTasksDesc;

  /// No description provided for @addFirstMaintenanceTask.
  ///
  /// In tr, this message translates to:
  /// **'İlk Bakım Görevini Ekle'**
  String get addFirstMaintenanceTask;

  /// No description provided for @consentByContinuing.
  ///
  /// In tr, this message translates to:
  /// **'Devam ederek '**
  String get consentByContinuing;

  /// No description provided for @consentTermsAndPrivacy.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Koşulları ve Gizlilik Politikası'**
  String get consentTermsAndPrivacy;

  /// No description provided for @consentAcceptSuffix.
  ///
  /// In tr, this message translates to:
  /// **'\'nı kabul etmiş olursunuz.'**
  String get consentAcceptSuffix;

  /// No description provided for @registerConsentPrefix.
  ///
  /// In tr, this message translates to:
  /// **''**
  String get registerConsentPrefix;

  /// No description provided for @registerConsentSuffix.
  ///
  /// In tr, this message translates to:
  /// **'\'nı okudum, kabul ediyorum.'**
  String get registerConsentSuffix;

  /// No description provided for @registerConsentError.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için şartları kabul etmelisiniz.'**
  String get registerConsentError;

  /// No description provided for @addProduct.
  ///
  /// In tr, this message translates to:
  /// **'Ürün Ekle'**
  String get addProduct;

  /// No description provided for @perMonthSuffix.
  ///
  /// In tr, this message translates to:
  /// **'/ bu ay'**
  String get perMonthSuffix;

  /// No description provided for @freeBudgetDescription.
  ///
  /// In tr, this message translates to:
  /// **'Aylık net gelirden sabit giderler düşüldükten sonra kalan tutar.'**
  String get freeBudgetDescription;

  /// No description provided for @viewDetails.
  ///
  /// In tr, this message translates to:
  /// **'İncele'**
  String get viewDetails;

  /// No description provided for @everythingLooksGood.
  ///
  /// In tr, this message translates to:
  /// **'Evindeki her şey yolunda görünüyor.'**
  String get everythingLooksGood;

  /// No description provided for @statusAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get statusAll;

  /// No description provided for @statusExpiredChip.
  ///
  /// In tr, this message translates to:
  /// **'Süresi Dolanlar'**
  String get statusExpiredChip;

  /// No description provided for @statusCriticalChip.
  ///
  /// In tr, this message translates to:
  /// **'Kritik'**
  String get statusCriticalChip;

  /// No description provided for @statusUpcomingChip.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşanlar'**
  String get statusUpcomingChip;

  /// No description provided for @statusSafeChip.
  ///
  /// In tr, this message translates to:
  /// **'Güvenli'**
  String get statusSafeChip;

  /// No description provided for @statusExpired.
  ///
  /// In tr, this message translates to:
  /// **'Tarihi Geçti'**
  String get statusExpired;

  /// No description provided for @statusToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün Son'**
  String get statusToday;

  /// No description provided for @daysLeft.
  ///
  /// In tr, this message translates to:
  /// **'{count} Gün Kaldı'**
  String daysLeft(int count);

  /// No description provided for @budgetPlanDescription.
  ///
  /// In tr, this message translates to:
  /// **'Aylık harcama hedeflerinizi belirleyin. İstemediğiniz kategorileri boş bırakabilirsiniz.'**
  String get budgetPlanDescription;

  /// No description provided for @categoryDiningOut.
  ///
  /// In tr, this message translates to:
  /// **'Yeme / İçme'**
  String get categoryDiningOut;

  /// No description provided for @categoryKitchenGrocery.
  ///
  /// In tr, this message translates to:
  /// **'Mutfak & Market'**
  String get categoryKitchenGrocery;

  /// No description provided for @categoryHomeBills.
  ///
  /// In tr, this message translates to:
  /// **'Ev & Faturalar'**
  String get categoryHomeBills;

  /// No description provided for @categoryShoppingPersonal.
  ///
  /// In tr, this message translates to:
  /// **'Alışveriş & Kişisel'**
  String get categoryShoppingPersonal;

  /// No description provided for @categoryTransport.
  ///
  /// In tr, this message translates to:
  /// **'Ulaşım'**
  String get categoryTransport;

  /// No description provided for @categoryEntertainmentSubscriptions.
  ///
  /// In tr, this message translates to:
  /// **'Eğlence & Abonelikler'**
  String get categoryEntertainmentSubscriptions;

  /// No description provided for @categoryOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get categoryOther;

  /// No description provided for @saveBudgets.
  ///
  /// In tr, this message translates to:
  /// **'Hedefleri Kaydet'**
  String get saveBudgets;

  /// No description provided for @limitAmountHint.
  ///
  /// In tr, this message translates to:
  /// **'Limit (₺)'**
  String get limitAmountHint;

  /// No description provided for @financialStatus.
  ///
  /// In tr, this message translates to:
  /// **'Finansal Durum'**
  String get financialStatus;

  /// No description provided for @periodYearly.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık'**
  String get periodYearly;

  /// No description provided for @periodMonthly.
  ///
  /// In tr, this message translates to:
  /// **'Aylık'**
  String get periodMonthly;

  /// No description provided for @periodWeekly.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık'**
  String get periodWeekly;

  /// No description provided for @periodDaily.
  ///
  /// In tr, this message translates to:
  /// **'Günlük'**
  String get periodDaily;

  /// No description provided for @netStatus.
  ///
  /// In tr, this message translates to:
  /// **'Net Durum'**
  String get netStatus;

  /// No description provided for @yearlyNetStatus.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık Net Durum'**
  String get yearlyNetStatus;

  /// No description provided for @monthlyNetStatus.
  ///
  /// In tr, this message translates to:
  /// **'Aylık Net Durum'**
  String get monthlyNetStatus;

  /// No description provided for @weeklyNetStatus.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Net Durum'**
  String get weeklyNetStatus;

  /// No description provided for @dailyNetStatus.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Net Durum'**
  String get dailyNetStatus;

  /// No description provided for @upcomingPendingTransactions.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşan Bekleyen İşlemler'**
  String get upcomingPendingTransactions;

  /// No description provided for @recentTransactions.
  ///
  /// In tr, this message translates to:
  /// **'Son İşlemler'**
  String get recentTransactions;

  /// No description provided for @futureIncome.
  ///
  /// In tr, this message translates to:
  /// **'Gelecek Gelir'**
  String get futureIncome;

  /// No description provided for @upcomingPayment.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşan Ödeme'**
  String get upcomingPayment;

  /// No description provided for @noTransactionsPeriod.
  ///
  /// In tr, this message translates to:
  /// **'Bu dönemde gerçekleşen işlem yok.'**
  String get noTransactionsPeriod;

  /// No description provided for @budgetPlanUpdated.
  ///
  /// In tr, this message translates to:
  /// **'Bütçe hedefleri güncellendi!'**
  String get budgetPlanUpdated;

  /// No description provided for @linkAccountTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınızı Bağlayın'**
  String get linkAccountTitle;

  /// No description provided for @guestModeDesc.
  ///
  /// In tr, this message translates to:
  /// **'Misafir modundasınız. Verilerinizi kaybetmeden hesabınızı kalıcı yapın.'**
  String get guestModeDesc;

  /// No description provided for @guestModeBottomSheetDesc.
  ///
  /// In tr, this message translates to:
  /// **'Misafir modundasınız. Verilerinizi kaybetmemek için bir giriş yöntemi seçerek kalıcı bir hesap oluşturun.'**
  String get guestModeBottomSheetDesc;

  /// No description provided for @connectionOptions.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı Seçenekleri'**
  String get connectionOptions;

  /// No description provided for @userRoleLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı'**
  String get userRoleLabel;

  /// No description provided for @anonymousSession.
  ///
  /// In tr, this message translates to:
  /// **'Anonim Oturum'**
  String get anonymousSession;

  /// No description provided for @notMemberOfFamilyYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz Bir Aileye Bağlı Değilsiniz'**
  String get notMemberOfFamilyYet;

  /// No description provided for @notMemberOfHomeYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz Bir Eve Dahil Değilsiniz'**
  String get notMemberOfHomeYet;

  /// No description provided for @noHomeSyncDesc.
  ///
  /// In tr, this message translates to:
  /// **'Ortak ürün ve alışveriş listesi senkronizasyonu için bir ev oluşturun veya var olan bir eve davet kodu ile katılın.'**
  String get noHomeSyncDesc;

  /// No description provided for @createHome.
  ///
  /// In tr, this message translates to:
  /// **'Ev Oluştur'**
  String get createHome;

  /// No description provided for @enterCode.
  ///
  /// In tr, this message translates to:
  /// **'Kodu Gir'**
  String get enterCode;

  /// No description provided for @createOrJoinHome.
  ///
  /// In tr, this message translates to:
  /// **'Ev Oluştur veya Katıl'**
  String get createOrJoinHome;

  /// No description provided for @createNewHomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Ev / Aile Oluştur'**
  String get createNewHomeTitle;

  /// No description provided for @createNewHomeDesc.
  ///
  /// In tr, this message translates to:
  /// **'Evinize bir isim verin. 1 kısa reklam izleyerek evinizi ücretsiz oluşturabilirsiniz.'**
  String get createNewHomeDesc;

  /// No description provided for @homeNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ev / Aile Adı'**
  String get homeNameLabel;

  /// No description provided for @homeNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Yılmaz Ailesi'**
  String get homeNameHint;

  /// No description provided for @homeNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Ev adı zorunludur.'**
  String get homeNameRequired;

  /// No description provided for @roleInHomeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Evdeki Rolünüz'**
  String get roleInHomeLabel;

  /// No description provided for @roleHouseOwner.
  ///
  /// In tr, this message translates to:
  /// **'👑 Ev Sahibi'**
  String get roleHouseOwner;

  /// No description provided for @roleMother.
  ///
  /// In tr, this message translates to:
  /// **'👨‍👩‍👧 Anne'**
  String get roleMother;

  /// No description provided for @roleFather.
  ///
  /// In tr, this message translates to:
  /// **'👨‍👩‍👦 Baba'**
  String get roleFather;

  /// No description provided for @roleChild.
  ///
  /// In tr, this message translates to:
  /// **'👶 Çocuk'**
  String get roleChild;

  /// No description provided for @roleRoommate.
  ///
  /// In tr, this message translates to:
  /// **'🏠 Ev Arkadaşı'**
  String get roleRoommate;

  /// No description provided for @roleOtherResident.
  ///
  /// In tr, this message translates to:
  /// **'🐾 Diğer/Ev Sakini'**
  String get roleOtherResident;

  /// No description provided for @noUpcomingExpirationsMessage.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşan son kullanma tarihi bulunan ürün yok. 👍'**
  String get noUpcomingExpirationsMessage;

  /// No description provided for @expirationProductItem.
  ///
  /// In tr, this message translates to:
  /// **'Son Kullanma Tarihli Ürün'**
  String get expirationProductItem;

  /// No description provided for @expirationProductSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Buzdolabı veya kilerdeki gıda/ilaç takibi'**
  String get expirationProductSubtitle;

  /// No description provided for @warrantyDocumentItem.
  ///
  /// In tr, this message translates to:
  /// **'Garanti Belgesi / Evrak Ekle'**
  String get warrantyDocumentItem;

  /// No description provided for @warrantyDocumentSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Ürün garanti belgeleri ve cihaz evrakları'**
  String get warrantyDocumentSubtitle;

  /// No description provided for @enterQuickExpense.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Harcama Gir'**
  String get enterQuickExpense;

  /// No description provided for @amountLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tutar'**
  String get amountLabel;

  /// No description provided for @amountRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen tutar girin'**
  String get amountRequired;

  /// No description provided for @validAmountRequired.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir tutar girin'**
  String get validAmountRequired;

  /// No description provided for @shortDescriptionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kısa Açıklama'**
  String get shortDescriptionLabel;

  /// No description provided for @shortDescriptionHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Kahve, Market vs.'**
  String get shortDescriptionHint;

  /// No description provided for @descriptionRequired.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama girin'**
  String get descriptionRequired;

  /// No description provided for @categoryLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kategori'**
  String get categoryLabel;

  /// No description provided for @addToPaymentSchedule.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Takvimine Ekle'**
  String get addToPaymentSchedule;

  /// No description provided for @editPaymentSchedule.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Takvimini Düzenle'**
  String get editPaymentSchedule;

  /// No description provided for @billExpenseOption.
  ///
  /// In tr, this message translates to:
  /// **'Fatura / Gider'**
  String get billExpenseOption;

  /// No description provided for @incomeCollectionOption.
  ///
  /// In tr, this message translates to:
  /// **'Tahsilat / Gelir'**
  String get incomeCollectionOption;

  /// No description provided for @scheduleTitleLabel.
  ///
  /// In tr, this message translates to:
  /// **'Başlık (örn: Elektrik Faturası, Kira)'**
  String get scheduleTitleLabel;

  /// No description provided for @titleRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen başlık girin'**
  String get titleRequired;

  /// No description provided for @dateLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get dateLabel;

  /// No description provided for @bankAccountNameOptional.
  ///
  /// In tr, this message translates to:
  /// **'İlgili Banka / Hesap Adı (Opsiyonel)'**
  String get bankAccountNameOptional;

  /// No description provided for @markAsPaid.
  ///
  /// In tr, this message translates to:
  /// **'Ödendi Olarak İşaretle'**
  String get markAsPaid;

  /// No description provided for @repeatMonthly.
  ///
  /// In tr, this message translates to:
  /// **'Aylık Tekrarlansın'**
  String get repeatMonthly;

  /// No description provided for @oneTimePaymentNotice.
  ///
  /// In tr, this message translates to:
  /// **'Tek seferlik ödeme.'**
  String get oneTimePaymentNotice;

  /// No description provided for @addToScheduleBtn.
  ///
  /// In tr, this message translates to:
  /// **'Takvime Ekle'**
  String get addToScheduleBtn;

  /// No description provided for @addNewDocumentTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Belge / Evrak Ekle'**
  String get addNewDocumentTitle;

  /// No description provided for @editDocumentTitle.
  ///
  /// In tr, this message translates to:
  /// **'Belgeyi Düzenle'**
  String get editDocumentTitle;

  /// No description provided for @documentTitleLabel.
  ///
  /// In tr, this message translates to:
  /// **'Belge Başlığı'**
  String get documentTitleLabel;

  /// No description provided for @documentTitleHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Tapu Senedi, Kira Sözleşmesi'**
  String get documentTitleHint;

  /// No description provided for @notesDescriptionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama / Notlar'**
  String get notesDescriptionLabel;

  /// No description provided for @notesDescriptionHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Dosya dolabında 2. gözde saklanıyor.'**
  String get notesDescriptionHint;

  /// No description provided for @addFileImage.
  ///
  /// In tr, this message translates to:
  /// **'Dosya / Görsel Ekle'**
  String get addFileImage;

  /// No description provided for @selectPhotoDocument.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf / Belge Seç'**
  String get selectPhotoDocument;

  /// No description provided for @saveDocumentBtn.
  ///
  /// In tr, this message translates to:
  /// **'Belgeyi Kaydet'**
  String get saveDocumentBtn;

  /// No description provided for @addNewContactTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni İletişim / Servis Numarası Ekle'**
  String get addNewContactTitle;

  /// No description provided for @editContactTitle.
  ///
  /// In tr, this message translates to:
  /// **'Numarayı Düzenle'**
  String get editContactTitle;

  /// No description provided for @namePersonLabel.
  ///
  /// In tr, this message translates to:
  /// **'İsim / Kişi Adı'**
  String get namePersonLabel;

  /// No description provided for @namePersonHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Tesisatçı Ahmet Usta, Site Yönetimi'**
  String get namePersonHint;

  /// No description provided for @titleCategoryLabel.
  ///
  /// In tr, this message translates to:
  /// **'Unvan / Kategori'**
  String get titleCategoryLabel;

  /// No description provided for @titleCategoryHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Su Tesisatı, Elektrik, Çilingir, Yönetim'**
  String get titleCategoryHint;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In tr, this message translates to:
  /// **'Telefon Numarası'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: 0555 123 45 67'**
  String get phoneNumberHint;

  /// No description provided for @saveNumberBtn.
  ///
  /// In tr, this message translates to:
  /// **'Numarayı Kaydet'**
  String get saveNumberBtn;

  /// No description provided for @summary.
  ///
  /// In tr, this message translates to:
  /// **'Özet'**
  String get summary;

  /// No description provided for @creditCardExpenses.
  ///
  /// In tr, this message translates to:
  /// **'Kart Harcamaları'**
  String get creditCardExpenses;

  /// No description provided for @cashExpenses.
  ///
  /// In tr, this message translates to:
  /// **'Nakit Harcamaları'**
  String get cashExpenses;

  /// No description provided for @quickExpenses.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Harcamalar'**
  String get quickExpenses;

  /// No description provided for @pleaseSelectDocumentOrPhoto.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bir belge veya fotoğraf seçin.'**
  String get pleaseSelectDocumentOrPhoto;

  /// No description provided for @editWarranty.
  ///
  /// In tr, this message translates to:
  /// **'Garanti Kaydını Düzenle'**
  String get editWarranty;

  /// No description provided for @productDeviceName.
  ///
  /// In tr, this message translates to:
  /// **'Ürün / Cihaz Adı'**
  String get productDeviceName;

  /// No description provided for @productDeviceNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Buzdolabı, Laptop...'**
  String get productDeviceNameHint;

  /// No description provided for @brand.
  ///
  /// In tr, this message translates to:
  /// **'Marka'**
  String get brand;

  /// No description provided for @brandHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Samsung, Apple...'**
  String get brandHint;

  /// No description provided for @store.
  ///
  /// In tr, this message translates to:
  /// **'Satın Alınan Mağaza'**
  String get store;

  /// No description provided for @storeHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: MediaMarkt, Trendyol...'**
  String get storeHint;

  /// No description provided for @purchaseDate.
  ///
  /// In tr, this message translates to:
  /// **'Alış Tarihi'**
  String get purchaseDate;

  /// No description provided for @warrantyEndDate.
  ///
  /// In tr, this message translates to:
  /// **'Garanti Bitiş Tarihi'**
  String get warrantyEndDate;

  /// No description provided for @hasInvoice.
  ///
  /// In tr, this message translates to:
  /// **'Fatura / Belge Mevcut'**
  String get hasInvoice;

  /// No description provided for @icon.
  ///
  /// In tr, this message translates to:
  /// **'İkon'**
  String get icon;

  /// No description provided for @optionalNotes.
  ///
  /// In tr, this message translates to:
  /// **'Notlar (İsteğe Bağlı)'**
  String get optionalNotes;

  /// No description provided for @optionalNotesHint.
  ///
  /// In tr, this message translates to:
  /// **'Ek bilgi...'**
  String get optionalNotesHint;

  /// No description provided for @invoiceNumberOptional.
  ///
  /// In tr, this message translates to:
  /// **'Fatura Numarası (İsteğe Bağlı)'**
  String get invoiceNumberOptional;

  /// No description provided for @invoiceNumberHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: AMZ-2024-12345'**
  String get invoiceNumberHint;

  /// No description provided for @changeInvoiceFile.
  ///
  /// In tr, this message translates to:
  /// **'Fatura Dosyasını Değiştir'**
  String get changeInvoiceFile;

  /// No description provided for @uploadInvoiceFile.
  ///
  /// In tr, this message translates to:
  /// **'📸 Fatura Görseli / PDF Yükle'**
  String get uploadInvoiceFile;

  /// No description provided for @saveChanges.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklikleri Kaydet'**
  String get saveChanges;

  /// No description provided for @productNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Ürün adı zorunludur.'**
  String get productNameRequired;

  /// No description provided for @brandRequired.
  ///
  /// In tr, this message translates to:
  /// **'Marka zorunludur.'**
  String get brandRequired;

  /// No description provided for @storeRequired.
  ///
  /// In tr, this message translates to:
  /// **'Mağaza adı zorunludur.'**
  String get storeRequired;

  /// No description provided for @selectPurchaseDateWarning.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen alış tarihini seçin.'**
  String get selectPurchaseDateWarning;

  /// No description provided for @selectWarrantyEndDateWarning.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen garanti bitiş tarihini seçin.'**
  String get selectWarrantyEndDateWarning;

  /// No description provided for @selectDateHint.
  ///
  /// In tr, this message translates to:
  /// **'Tarih Seçiniz'**
  String get selectDateHint;

  /// No description provided for @addNewHomeInfo.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Ev Bilgisi Ekle'**
  String get addNewHomeInfo;

  /// No description provided for @editHomeInfo.
  ///
  /// In tr, this message translates to:
  /// **'Ev Bilgisini Düzenle'**
  String get editHomeInfo;

  /// No description provided for @categorySelection.
  ///
  /// In tr, this message translates to:
  /// **'Kategori Seçimi'**
  String get categorySelection;

  /// No description provided for @guideTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rehber Başlığı'**
  String get guideTitle;

  /// No description provided for @guideTitleHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Doğalgaz Aboneliği, Su Vanası, Wi-Fi Şifresi'**
  String get guideTitleHint;

  /// No description provided for @importantValueLabel.
  ///
  /// In tr, this message translates to:
  /// **'Önemli Bilgi / Değer (Tek Tıkla Kopyalanabilir)'**
  String get importantValueLabel;

  /// No description provided for @importantValueHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Abone No: 123456, Şifre: xyz123, Mavi Vana'**
  String get importantValueHint;

  /// No description provided for @detailedNotesLabel.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama / Detaylı Not'**
  String get detailedNotesLabel;

  /// No description provided for @detailedNotesHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Sayaç balkondaki dolabın sağ iç kısmındadır.'**
  String get detailedNotesHint;

  /// No description provided for @updateInfoBtn.
  ///
  /// In tr, this message translates to:
  /// **'Bilgiyi Güncelle'**
  String get updateInfoBtn;

  /// No description provided for @categoryWifi.
  ///
  /// In tr, this message translates to:
  /// **'📶 Wi-Fi & Ağ'**
  String get categoryWifi;

  /// No description provided for @categoryInstallation.
  ///
  /// In tr, this message translates to:
  /// **'⚡ Tesisat & Abonelik'**
  String get categoryInstallation;

  /// No description provided for @categoryPasswords.
  ///
  /// In tr, this message translates to:
  /// **'🔑 Şifre & Kodlar'**
  String get categoryPasswords;

  /// No description provided for @categoryGeneralHome.
  ///
  /// In tr, this message translates to:
  /// **'ℹ️ Genel Ev Bilgisi'**
  String get categoryGeneralHome;

  /// No description provided for @themeSelection.
  ///
  /// In tr, this message translates to:
  /// **'Tema Seçimi'**
  String get themeSelection;

  /// No description provided for @themeSelectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama görünümünü seçin (Sistem / Açık / Koyu)'**
  String get themeSelectionSubtitle;

  /// No description provided for @themeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem (Varsayılan)'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık Tema'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu Tema'**
  String get themeDark;

  /// No description provided for @editHomeNameTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ev Adını Düzenle'**
  String get editHomeNameTitle;

  /// No description provided for @editHomeNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ev Adı'**
  String get editHomeNameLabel;

  /// No description provided for @editHomeNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Kalaycı Home, Güneş Apt. No:4'**
  String get editHomeNameHint;

  /// No description provided for @homeNameUpdatedToast.
  ///
  /// In tr, this message translates to:
  /// **'Ev adı başarıyla güncellendi! 🏠'**
  String get homeNameUpdatedToast;

  /// No description provided for @customRoleOption.
  ///
  /// In tr, this message translates to:
  /// **'✏️ Özel Rol...'**
  String get customRoleOption;

  /// No description provided for @customRoleHint.
  ///
  /// In tr, this message translates to:
  /// **'Rol adını yazın (örn. Amca, Misafir)...'**
  String get customRoleHint;

  /// No description provided for @aboutDeveloper.
  ///
  /// In tr, this message translates to:
  /// **'Geliştirici: Samed Kalaycı'**
  String get aboutDeveloper;

  /// No description provided for @aboutCopyright.
  ///
  /// In tr, this message translates to:
  /// **'© 2026 Ev Asistanı. Tüm hakları saklıdır.'**
  String get aboutCopyright;

  /// No description provided for @addShoppingItemSub.
  ///
  /// In tr, this message translates to:
  /// **'Eksilen gıda, temizlik ve ev ihtiyaçları'**
  String get addShoppingItemSub;

  /// No description provided for @guestLoginSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Misafir oturumu ile giriş yapıldı. 👋'**
  String get guestLoginSuccess;

  /// No description provided for @guestLoginFailed.
  ///
  /// In tr, this message translates to:
  /// **'Misafir girişi başarısız: {error}'**
  String guestLoginFailed(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'az',
    'de',
    'el',
    'en',
    'es',
    'fr',
    'pt',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'az':
      return AppLocalizationsAz();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
