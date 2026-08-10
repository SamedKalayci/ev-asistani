// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Ev Asistanı';

  @override
  String get languageSelection => 'Dil Seçimi';

  @override
  String get languageSelectionSubtitle =>
      'Uygulama dilini değiştirin (Türkçe / English)';

  @override
  String get currencySelection => 'Para Birimi';

  @override
  String get currencySelectionSubtitle =>
      'Ücret ve bütçe ekranlarında kullanılacak para birimini seçin';

  @override
  String get preferencesAndSettings => 'Tercihler ve Ayarlar';

  @override
  String get notificationSettings => 'Bildirim Ayarları';

  @override
  String get notificationSettingsSubtitle =>
      'Sistem bildirim ayarlarını yönetin';

  @override
  String get about => 'Hakkında';

  @override
  String get aboutSubtitle => 'Ev Asistanı v1.1.0 (Firebase Enabled)';

  @override
  String get developerLabel => 'Geliştirici: Samed Kalaycı';

  @override
  String get aboutDescription =>
      'Açıklama: Ev içi düzen ve ortak liste yönetimi uygulaması.';

  @override
  String get allRightsReserved => '© 2026 Ev Asistanı. Tüm hakları saklıdır.';

  @override
  String get privacyPolicy => 'Gizlilik Politikası ve Kullanım Koşulları';

  @override
  String get privacyPolicySubtitle =>
      'Yasal bilgilendirmeleri ve kullanım şartlarını inceleyin';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get signOutSubtitle => 'Hesabınızdan güvenli bir şekilde çıkış yapın';

  @override
  String get deleteAccount => 'Hesabımı Sil';

  @override
  String get deleteAccountSubtitle =>
      'Kalıcı olarak hesabınızı ve verilerinizi silin';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get confirm => 'Onayla';

  @override
  String get selectLanguage => 'Dil Seçiniz';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'İngilizce';

  @override
  String get german => 'Almanca';

  @override
  String get spanish => 'İspanyolca';

  @override
  String get french => 'Fransızca';

  @override
  String get azerbaijani => 'Azerice';

  @override
  String get greek => 'Yunanca';

  @override
  String get portuguese => 'Portekizce';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navInventory => 'Envanter';

  @override
  String get navShopping => 'Alışveriş';

  @override
  String get navFinance => 'Finans';

  @override
  String get navProfile => 'Profil';

  @override
  String get shoppingListTitle => 'Alışveriş Listesi';

  @override
  String get toBuyTab => 'Alınacaklar';

  @override
  String get purchasedTab => 'Alınanlar';

  @override
  String get clearCompleted => 'Temizle';

  @override
  String get newProductHint => 'Yeni ürün ekle...';

  @override
  String itemsCount(int count) {
    return '$count Ürün';
  }

  @override
  String get addShoppingItemTitle => 'Alışveriş Listesine Ürün Ekle';

  @override
  String get productNameLabel => 'Ürün Adı';

  @override
  String get productNameHint => 'Örn: Süt, Ekmek, Yumurta...';

  @override
  String get addToListBtn => 'Listeye Ekle';

  @override
  String itemAddedToast(String name) {
    return '\"$name\" alışveriş listesine eklendi! 🛒';
  }

  @override
  String get emptyShoppingList => 'Alışveriş listeniz boş.';

  @override
  String get financeOverviewTab => 'Genel Bakış';

  @override
  String get householdWalletTab => 'Ev Cüzdanı';

  @override
  String get accountsTab => 'Hesaplar';

  @override
  String get viewSummary => 'Özet Gör';

  @override
  String get incomeExpenseBalance => 'Gelir/Gider Dengesi';

  @override
  String get totalIncome => 'Toplam Gelir';

  @override
  String get totalExpense => 'Toplam Gider';

  @override
  String get personalExpenses => 'Bireysel Harcamalar';

  @override
  String get noAccountYet => 'Henüz hesap eklenmedi.';

  @override
  String get paymentSchedule => 'Ödeme Takvimi';

  @override
  String get realizedPayments => 'Gerçekleşenler';

  @override
  String get accountScheduleHeader => 'Hesap / Takvim';

  @override
  String get monthlyFreeBudget => 'Kalan Serbest Bütçe';

  @override
  String get quickAddExpense => 'Hızlı Gider Ekle';

  @override
  String greetingUser(String name) {
    return 'Merhaba, $name';
  }

  @override
  String get quickAdd => 'Hızlı Ekle';

  @override
  String get expiringSoonTitle => 'Son Kullanma Tarihleri Yaklaşıyor';

  @override
  String get warrantiesExpiringTitle => 'Garantisi Bitenler & Yaklaşanlar';

  @override
  String get shoppingSummaryTitle => 'Alışveriş Listesi Özet';

  @override
  String get viewAll => 'Tümünü Gör';

  @override
  String urgentExpirationsCount(int count) {
    return '$count Acil Ürün';
  }

  @override
  String urgentWarrantiesCount(int count) {
    return '$count Acil Garanti';
  }

  @override
  String get inventoryTitle => 'Ev Envanteri';

  @override
  String get expirationTab => 'Son Kullanma';

  @override
  String get warrantyTab => 'Garantiler';

  @override
  String get vaultTab => 'Ev Kasası';

  @override
  String get addExpirationItem => 'Ürün Ekle';

  @override
  String get addWarrantyItem => 'Garanti Ekle';

  @override
  String get periodicMaintenance => 'Periyodik Bakım Takvimi';

  @override
  String get homeGuideWifi => 'Ev Rehberi & Wi-Fi';

  @override
  String get digitalVaultSubtitle =>
      'Evinizle ilgili tüm kritik belgeler, rehberler ve acil durum numaraları şifreli olarak güvenle saklanır.';

  @override
  String get myHomeAndFamily => 'Evim & Aile Yönetimi';

  @override
  String get inviteCode => 'Davet Kodu';

  @override
  String get familyMembers => 'Aile Üyeleri';

  @override
  String get proMember => 'PRO Üye';

  @override
  String get proHouseOwner => 'PRO Ev Sahibi';

  @override
  String get houseOwner => 'Ev Sahibi';

  @override
  String get legalSection => 'Yasal';

  @override
  String get legalAndInfo => 'Yasal ve Bilgi';

  @override
  String get accountActions => 'Hesap İşlemleri';

  @override
  String get removeAdsTitle => 'Reklamları Kaldır (Ad-Free)';

  @override
  String memberCount(int count) {
    return '$count Üye';
  }

  @override
  String get removeAdsSubtitle =>
      'Tek seferlik ödeme ile kalıcı olarak reklamsız kullanın!';

  @override
  String get removeAdsActive => 'Reklamsız Sürüm Aktif ✅';

  @override
  String get specialPriceOffer => 'Özel Fiyat! Sadece bir kahve fiyatına.';

  @override
  String get buyNow => 'Satın Al';

  @override
  String get restorePurchases => 'Geri Yükle';

  @override
  String get introPopupTitle => 'Ev Asistanı\'nı Reklamsız Kullanın!';

  @override
  String get introPopupDesc =>
      'Çok uygun fiyata tek seferlik ödeme yaparak tüm reklamları kalıcı olarak kaldırabilirsiniz.';

  @override
  String get skipForNow => 'Şimdilik Geç';

  @override
  String get shoppingListSubtitle =>
      'Alınacak ve alınan ürünleri kolayca takip edin.';

  @override
  String get clearCompletedConfirmTitle => 'Alınanları Temizle';

  @override
  String get clearCompletedConfirmDesc =>
      'Alınan tüm ürünler listeden kaldırılacak. Devam et?';

  @override
  String get emptyShoppingListDesc =>
      'Ekmek, süt, meyve gibi ihtiyacınız olan ürünleri yukarıdaki alandan ekleyebilirsiniz.';

  @override
  String get allPurchasedMessage => 'Tüm ürünler alındı! 🎉';

  @override
  String get delete => 'Sil';

  @override
  String get accountTypeCash => 'Nakit';

  @override
  String get accountTypeBank => 'Banka';

  @override
  String get accountTypeCreditCard => 'Kredi Kartı';

  @override
  String get accountTypeDebtCredit => 'Cari (Borç/Alacak)';

  @override
  String statementCutoff(String day) {
    return 'Fatura kesim: $day';
  }

  @override
  String get planBudget => 'Bütçeni Planla';

  @override
  String get categoryBudgets => 'Kategori Bütçeleri';

  @override
  String get noBudgetsSet =>
      'Henüz bir bütçe hedefi belirlemediniz. \"Bütçeni Planla\" butonuna tıklayarak başlayın.';

  @override
  String get limitExceeded => 'Limit aşıldı!';

  @override
  String get noExpensesPeriod => 'Bu dönem hiç harcama yok.';

  @override
  String get expenseHistory => 'Harcama Geçmişi';

  @override
  String get noRecordsFound => 'Kayıt bulunmuyor.';

  @override
  String get financeManagementPro => 'Finans Yönetimi PRO';

  @override
  String get financeProDesc =>
      'Ailenizin tüm gelir, gider, banka hesapları, ödeme takvimi ve nakit akışını kontrol etmek için PRO üyeliğe yükseltin.';

  @override
  String get expirationTitle => 'Son Kullanma Tarihleri';

  @override
  String get freshnessSubtitle =>
      'Envanterinizdeki ürünlerin tazelik durumunu takip edin.';

  @override
  String get searchProductLocationHint => 'Ürün adı veya konum ara...';

  @override
  String get clearExpired => 'Süresi Dolanları Temizle';

  @override
  String get noProductsYet => 'Henüz Ürün Yok';

  @override
  String get noProductsFound => 'Ürün Bulunamadı';

  @override
  String get addFirstProductDesc =>
      'İlk ürününüzü eklemek için \"Ürün Ekle\" butonuna basın.';

  @override
  String get noMatchingProductsDesc =>
      'Arama veya filtreleme kriterlerinize uygun ürün bulunmuyor.';

  @override
  String get clearFilters => 'Filtreleri Temizle';

  @override
  String get expirationDateLabel => 'Son Kullanma';

  @override
  String get trashAndShopping => 'Çöpe At & Alışverişe Ekle';

  @override
  String get warrantyTrackingTitle => 'Garanti Takibi';

  @override
  String get warrantySubtitle =>
      'Cihazlarınızın ve eşyalarınızın garanti sürelerini takip edin.';

  @override
  String get searchDeviceBrandHint => 'Cihaz, marka veya mağaza ara...';

  @override
  String get noWarrantyRecordsYet => 'Henüz Garanti Kaydı Yok';

  @override
  String get noWarrantyRecordsFound => 'Garanti Kaydı Bulunamadı';

  @override
  String get addFirstWarrantyDesc =>
      'İlk garanti kaydınızı eklemek için \"Garanti Ekle\" butonuna basın.';

  @override
  String get noMatchingWarrantiesDesc =>
      'Arama veya filtreleme kriterlerinize uygun kayıt bulunmuyor.';

  @override
  String get documentsAndWarranties => 'Belgeler & Garantiler';

  @override
  String get serviceAndEmergencyNumbers => 'Servis & Acil Numaralar';

  @override
  String get uploadDocument => 'Belge Yükle';

  @override
  String get noDocumentsTitle => 'Belge Bulunmuyor';

  @override
  String get noDocumentsDesc =>
      'Tapu, sigorta poliçesi veya önemli evraklarınızı Dijital Ev Kasası\'na güvenle kaydedin.';

  @override
  String get uploadFirstDocument => 'İlk Belgeyi Yükle';

  @override
  String get addNumber => 'Numara Ekle';

  @override
  String get noEmergencyContactsTitle => 'Kayıtlı Numara Bulunmuyor';

  @override
  String get noEmergencyContactsDesc =>
      'Elektrikçi, tesisatçı veya acil durum kişilerini ekleyerek tek tıkla arama yapın.';

  @override
  String get addFirstNumber => 'İlk Numarayı Ekle';

  @override
  String get call => 'Ara';

  @override
  String get copy => 'Kopyala';

  @override
  String get newMaintenanceTask => 'Yeni Periyodik Bakım Görevi';

  @override
  String get maintenanceTitleLabel => 'Bakım Adı';

  @override
  String get maintenanceTitleHint =>
      'Örn: Kombi Yıllık Bakım, Klima Filtre Temizliği';

  @override
  String get descriptionLabel => 'Açıklama / Detaylar';

  @override
  String get descriptionHint => 'Örn: Filtreler yıkanacak, servis çağrılacak.';

  @override
  String get scheduledDateLabel => 'Planlanan Bakım Tarihi';

  @override
  String get saveTask => 'Görevi Kaydet';

  @override
  String get addHomeInfo => '+ Ev Bilgisi Ekle';

  @override
  String get noGuideTitle => 'Rehber Bilgisi Bulunmuyor';

  @override
  String get noGuideDesc =>
      'Wi-Fi şifresi, abonelik numaraları veya vanaların yerini ekleyerek ev halkı ile anlık paylaşın.';

  @override
  String get deleteItem => 'Sil';

  @override
  String get deleteConfirmDesc => 'adlı kayıt kalıcı olarak silinecek.';

  @override
  String get addWarranty => 'Garanti Ekle';

  @override
  String get addMaintenanceTask => 'Bakım Ekle';

  @override
  String get noMaintenanceTasksTitle => 'Bakım Görevi Bulunmuyor';

  @override
  String get noMaintenanceTasksDesc =>
      'Kombi bakımı, baca temizliği veya filtre değişimlerini ekleyerek zamanı gelince hatırlatma alın.';

  @override
  String get addFirstMaintenanceTask => 'İlk Bakım Görevini Ekle';

  @override
  String get consentByContinuing => 'Devam ederek ';

  @override
  String get consentTermsAndPrivacy =>
      'Kullanım Koşulları ve Gizlilik Politikası';

  @override
  String get consentAcceptSuffix => '\'nı kabul etmiş olursunuz.';

  @override
  String get registerConsentPrefix => '';

  @override
  String get registerConsentSuffix => '\'nı okudum, kabul ediyorum.';

  @override
  String get registerConsentError =>
      'Devam etmek için şartları kabul etmelisiniz.';

  @override
  String get addProduct => 'Ürün Ekle';

  @override
  String get perMonthSuffix => '/ bu ay';

  @override
  String get freeBudgetDescription =>
      'Aylık net gelirden sabit giderler düşüldükten sonra kalan tutar.';

  @override
  String get viewDetails => 'İncele';

  @override
  String get everythingLooksGood => 'Evindeki her şey yolunda görünüyor.';

  @override
  String get statusAll => 'Tümü';

  @override
  String get statusExpiredChip => 'Süresi Dolanlar';

  @override
  String get statusCriticalChip => 'Kritik';

  @override
  String get statusUpcomingChip => 'Yaklaşanlar';

  @override
  String get statusSafeChip => 'Güvenli';

  @override
  String get statusExpired => 'Tarihi Geçti';

  @override
  String get statusToday => 'Bugün Son';

  @override
  String daysLeft(int count) {
    return '$count Gün Kaldı';
  }

  @override
  String get budgetPlanDescription =>
      'Aylık harcama hedeflerinizi belirleyin. İstemediğiniz kategorileri boş bırakabilirsiniz.';

  @override
  String get categoryDiningOut => 'Yeme / İçme';

  @override
  String get categoryKitchenGrocery => 'Mutfak & Market';

  @override
  String get categoryHomeBills => 'Ev & Faturalar';

  @override
  String get categoryShoppingPersonal => 'Alışveriş & Kişisel';

  @override
  String get categoryTransport => 'Ulaşım';

  @override
  String get categoryEntertainmentSubscriptions => 'Eğlence & Abonelikler';

  @override
  String get categoryOther => 'Diğer';

  @override
  String get saveBudgets => 'Hedefleri Kaydet';

  @override
  String get limitAmountHint => 'Limit (₺)';

  @override
  String get financialStatus => 'Finansal Durum';

  @override
  String get periodYearly => 'Yıllık';

  @override
  String get periodMonthly => 'Aylık';

  @override
  String get periodWeekly => 'Haftalık';

  @override
  String get periodDaily => 'Günlük';

  @override
  String get netStatus => 'Net Durum';

  @override
  String get yearlyNetStatus => 'Yıllık Net Durum';

  @override
  String get monthlyNetStatus => 'Aylık Net Durum';

  @override
  String get weeklyNetStatus => 'Haftalık Net Durum';

  @override
  String get dailyNetStatus => 'Günlük Net Durum';

  @override
  String get upcomingPendingTransactions => 'Yaklaşan Bekleyen İşlemler';

  @override
  String get recentTransactions => 'Son İşlemler';

  @override
  String get futureIncome => 'Gelecek Gelir';

  @override
  String get upcomingPayment => 'Yaklaşan Ödeme';

  @override
  String get noTransactionsPeriod => 'Bu dönemde gerçekleşen işlem yok.';

  @override
  String get budgetPlanUpdated => 'Bütçe hedefleri güncellendi!';

  @override
  String get linkAccountTitle => 'Hesabınızı Bağlayın';

  @override
  String get guestModeDesc =>
      'Misafir modundasınız. Verilerinizi kaybetmeden hesabınızı kalıcı yapın.';

  @override
  String get guestModeBottomSheetDesc =>
      'Misafir modundasınız. Verilerinizi kaybetmemek için bir giriş yöntemi seçerek kalıcı bir hesap oluşturun.';

  @override
  String get connectionOptions => 'Bağlantı Seçenekleri';

  @override
  String get userRoleLabel => 'Kullanıcı';

  @override
  String get anonymousSession => 'Anonim Oturum';

  @override
  String get notMemberOfFamilyYet => 'Henüz Bir Aileye Bağlı Değilsiniz';

  @override
  String get notMemberOfHomeYet => 'Henüz Bir Eve Dahil Değilsiniz';

  @override
  String get noHomeSyncDesc =>
      'Ortak ürün ve alışveriş listesi senkronizasyonu için bir ev oluşturun veya var olan bir eve davet kodu ile katılın.';

  @override
  String get createHome => 'Ev Oluştur';

  @override
  String get enterCode => 'Kodu Gir';

  @override
  String get createOrJoinHome => 'Ev Oluştur veya Katıl';

  @override
  String get createNewHomeTitle => 'Yeni Ev / Aile Oluştur';

  @override
  String get createNewHomeDesc =>
      'Evinize bir isim verin. 1 kısa reklam izleyerek evinizi ücretsiz oluşturabilirsiniz.';

  @override
  String get homeNameLabel => 'Ev / Aile Adı';

  @override
  String get homeNameHint => 'Örn: Yılmaz Ailesi';

  @override
  String get homeNameRequired => 'Ev adı zorunludur.';

  @override
  String get roleInHomeLabel => 'Evdeki Rolünüz';

  @override
  String get roleHouseOwner => '👑 Ev Sahibi';

  @override
  String get roleMother => '👨‍👩‍👧 Anne';

  @override
  String get roleFather => '👨‍👩‍👦 Baba';

  @override
  String get roleChild => '👶 Çocuk';

  @override
  String get roleRoommate => '🏠 Ev Arkadaşı';

  @override
  String get roleOtherResident => '🐾 Diğer/Ev Sakini';

  @override
  String get noUpcomingExpirationsMessage =>
      'Yaklaşan son kullanma tarihi bulunan ürün yok. 👍';

  @override
  String get expirationProductItem => 'Son Kullanma Tarihli Ürün';

  @override
  String get expirationProductSubtitle =>
      'Buzdolabı veya kilerdeki gıda/ilaç takibi';

  @override
  String get warrantyDocumentItem => 'Garanti Belgesi / Evrak Ekle';

  @override
  String get warrantyDocumentSubtitle =>
      'Ürün garanti belgeleri ve cihaz evrakları';

  @override
  String get enterQuickExpense => 'Hızlı Harcama Gir';

  @override
  String get amountLabel => 'Tutar';

  @override
  String get amountRequired => 'Lütfen tutar girin';

  @override
  String get validAmountRequired => 'Geçerli bir tutar girin';

  @override
  String get shortDescriptionLabel => 'Kısa Açıklama';

  @override
  String get shortDescriptionHint => 'Örn: Kahve, Market vs.';

  @override
  String get descriptionRequired => 'Açıklama girin';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get addToPaymentSchedule => 'Ödeme Takvimine Ekle';

  @override
  String get editPaymentSchedule => 'Ödeme Takvimini Düzenle';

  @override
  String get billExpenseOption => 'Fatura / Gider';

  @override
  String get incomeCollectionOption => 'Tahsilat / Gelir';

  @override
  String get scheduleTitleLabel => 'Başlık (örn: Elektrik Faturası, Kira)';

  @override
  String get titleRequired => 'Lütfen başlık girin';

  @override
  String get dateLabel => 'Tarih';

  @override
  String get bankAccountNameOptional => 'İlgili Banka / Hesap Adı (Opsiyonel)';

  @override
  String get markAsPaid => 'Ödendi Olarak İşaretle';

  @override
  String get repeatMonthly => 'Aylık Tekrarlansın';

  @override
  String get oneTimePaymentNotice => 'Tek seferlik ödeme.';

  @override
  String get addToScheduleBtn => 'Takvime Ekle';

  @override
  String get addNewDocumentTitle => 'Yeni Belge / Evrak Ekle';

  @override
  String get editDocumentTitle => 'Belgeyi Düzenle';

  @override
  String get documentTitleLabel => 'Belge Başlığı';

  @override
  String get documentTitleHint => 'Örn: Tapu Senedi, Kira Sözleşmesi';

  @override
  String get notesDescriptionLabel => 'Açıklama / Notlar';

  @override
  String get notesDescriptionHint =>
      'Örn: Dosya dolabında 2. gözde saklanıyor.';

  @override
  String get addFileImage => 'Dosya / Görsel Ekle';

  @override
  String get selectPhotoDocument => 'Fotoğraf / Belge Seç';

  @override
  String get saveDocumentBtn => 'Belgeyi Kaydet';

  @override
  String get addNewContactTitle => 'Yeni İletişim / Servis Numarası Ekle';

  @override
  String get editContactTitle => 'Numarayı Düzenle';

  @override
  String get namePersonLabel => 'İsim / Kişi Adı';

  @override
  String get namePersonHint => 'Örn: Tesisatçı Ahmet Usta, Site Yönetimi';

  @override
  String get titleCategoryLabel => 'Unvan / Kategori';

  @override
  String get titleCategoryHint =>
      'Örn: Su Tesisatı, Elektrik, Çilingir, Yönetim';

  @override
  String get phoneNumberLabel => 'Telefon Numarası';

  @override
  String get phoneNumberHint => 'Örn: 0555 123 45 67';

  @override
  String get saveNumberBtn => 'Numarayı Kaydet';
}
