// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appName => 'Ev köməkçisi';

  @override
  String get languageSelection => 'Dil seçimi';

  @override
  String get languageSelectionSubtitle => 'Tətbiq dilini dəyişin';

  @override
  String get currencySelection => 'Valyuta';

  @override
  String get currencySelectionSubtitle =>
      'Büdcə və maliyyə ekranları üçün valyuta seçin';

  @override
  String get preferencesAndSettings => 'Üstünlüklər və Tənzimləmələr';

  @override
  String get notificationSettings => 'Bildiriş Tənzimləmələri';

  @override
  String get notificationSettingsSubtitle => 'Sistem bildirişlərini idarə edin';

  @override
  String get about => 'Haqqında';

  @override
  String get aboutSubtitle => 'Ev köməkçisi v1.1.0 (Firebase Aktiv)';

  @override
  String get developerLabel => 'İnkişafçı: Samed Kalaycı';

  @override
  String get aboutDescription => 'Təsvir: Ağıllı ev təşkilatı.';

  @override
  String get allRightsReserved =>
      '© 2026 Ev Köməkçisi. Bütün hüquqlar qorunur.';

  @override
  String get privacyPolicy => 'Məxfilik Siyasəti və Şərtlər';

  @override
  String get privacyPolicySubtitle => 'Hüquqi məlumatları nəzərdən keçirin';

  @override
  String get signOut => 'Çıxış et';

  @override
  String get signOutSubtitle => 'Hesabınızdan təhlükəsiz çıxış edin';

  @override
  String get deleteAccount => 'Hesabı sil';

  @override
  String get deleteAccountSubtitle =>
      'Hesabınızı və məlumatlarınızı həmişəlik silin';

  @override
  String get cancel => 'Ləğv et';

  @override
  String get save => 'Yadda saxla';

  @override
  String get confirm => 'Təsdiqlə';

  @override
  String get selectLanguage => 'Dili seçin';

  @override
  String get turkish => 'Türkcə';

  @override
  String get english => 'İngiliscə';

  @override
  String get german => 'Almanca';

  @override
  String get spanish => 'İspanca';

  @override
  String get french => 'Fransızca';

  @override
  String get azerbaijani => 'Azərbaycan dili';

  @override
  String get greek => 'Yunan dili';

  @override
  String get portuguese => 'Portuqal dili';

  @override
  String get navHome => 'Ana Səhifə';

  @override
  String get navInventory => 'İnventar';

  @override
  String get navShopping => 'Alış-veriş';

  @override
  String get navFinance => 'Maliyyə';

  @override
  String get navProfile => 'Profil';

  @override
  String get shoppingListTitle => 'Alış-veriş Siyahısı';

  @override
  String get toBuyTab => 'Alınacaqlar';

  @override
  String get purchasedTab => 'Alınanlar';

  @override
  String get clearCompleted => 'Təmizlə';

  @override
  String get newProductHint => 'Yeni məhsul əlavə et...';

  @override
  String itemsCount(int count) {
    return '$count Məhsul';
  }

  @override
  String get addShoppingItemTitle => 'Siyahıya Məhsul Əlavə Et';

  @override
  String get productNameLabel => 'Məhsulun Adı';

  @override
  String get productNameHint => 'Məsələn: Süd, Çörək, Yumurta...';

  @override
  String get addToListBtn => 'Siyahıya Əlavə Et';

  @override
  String itemAddedToast(String name) {
    return '\"$name\" alış-veriş siyahısına əlavə olundu! 🛒';
  }

  @override
  String get emptyShoppingList => 'Alış-veriş siyahınız boşdur.';

  @override
  String get financeOverviewTab => 'Ümumi Baxış';

  @override
  String get householdWalletTab => 'Ev Pulqabısı';

  @override
  String get accountsTab => 'Hesablar';

  @override
  String get viewSummary => 'Xülasəyə Bax';

  @override
  String get incomeExpenseBalance => 'Gəlir/Xərc Balansı';

  @override
  String get totalIncome => 'Ümumi Gəlir';

  @override
  String get totalExpense => 'Ümumi Xərc';

  @override
  String get personalExpenses => 'Fərdi Xərclər';

  @override
  String get noAccountYet => 'Hələ ki hesab əlavə edilməyib.';

  @override
  String get paymentSchedule => 'Ödəniş Təqvimi';

  @override
  String get realizedPayments => 'Həyata Keçirilənlər';

  @override
  String get accountScheduleHeader => 'Hesab / Təqvim';

  @override
  String get monthlyFreeBudget => 'Qalan Sərbəst Büdcə';

  @override
  String get quickAddExpense => 'Tez Xərc Əlavə Et';

  @override
  String greetingUser(String name) {
    return 'Salam, $name';
  }

  @override
  String get quickAdd => 'Tez Əlavə Et';

  @override
  String get expiringSoonTitle => 'Yararlılıq Müddəti Bitənlər';

  @override
  String get warrantiesExpiringTitle => 'Zəmanəti Bitənlər';

  @override
  String get shoppingSummaryTitle => 'Alış-veriş Siyahısı Xülasəsi';

  @override
  String get viewAll => 'Hamısına Bax';

  @override
  String urgentExpirationsCount(int count) {
    return '$count Təcili Məhsul';
  }

  @override
  String urgentWarrantiesCount(int count) {
    return '$count Təcili Zəmanət';
  }

  @override
  String get inventoryTitle => 'Ev İnventarı';

  @override
  String get expirationTab => 'Yararlılıq';

  @override
  String get warrantyTab => 'Zəmanət';

  @override
  String get vaultTab => 'Seyf';

  @override
  String get addExpirationItem => 'Məhsul Əlavə Et';

  @override
  String get addWarrantyItem => 'Zəmanət Əlavə Et';

  @override
  String get periodicMaintenance => 'Dövri Xidmət Təqvimi';

  @override
  String get homeGuideWifi => 'Ev Bələdçisi və Wi-Fi';

  @override
  String get digitalVaultSubtitle =>
      'Evlə bağlı vacib sənədlər və təcili nömrələr şifrələnərək qorunur.';

  @override
  String get myHomeAndFamily => 'Evim və Ailə İdarəetməsi';

  @override
  String get inviteCode => 'Dəvət Kodu';

  @override
  String get familyMembers => 'Ailə Üvləri';

  @override
  String get proMember => 'PRO Üvü';

  @override
  String get proHouseOwner => 'PRO Ev Sahibi';

  @override
  String get houseOwner => 'Ev Sahibi';

  @override
  String get legalSection => 'Hüquqi';

  @override
  String get legalAndInfo => 'Hüquqi & Məlumat';

  @override
  String get accountActions => 'Hesab Əməliyyatları';

  @override
  String get removeAdsTitle => 'Reklamları Sil (Ad-Free)';

  @override
  String memberCount(int count) {
    return '$count Üzv';
  }

  @override
  String get removeAdsSubtitle =>
      'Birdəfəlik ödənişlə həmişəlik reklamsız istifadə edin!';

  @override
  String get removeAdsActive => 'Reklamsız Versiya Aktivdir ✅';

  @override
  String get specialPriceOffer => 'Xüsusi Qiymət! Sadece bir kofe qiymətinə.';

  @override
  String get buyNow => 'İndi Al';

  @override
  String get restorePurchases => 'Bərpa Et';

  @override
  String get introPopupTitle => 'Proqramı Reklamsız İşlədin!';

  @override
  String get introPopupDesc =>
      'Birdəfəlik kiçik ödənişlə bütün reklamları həmişəlik ləğv edin.';

  @override
  String get skipForNow => 'Hələlik Keç';

  @override
  String get shoppingListSubtitle =>
      'Alınacaq və alınan məhsulları rahatlıqla izləyin.';

  @override
  String get clearCompletedConfirmTitle => 'Alınanları Təmizlə';

  @override
  String get clearCompletedConfirmDesc =>
      'Bütün alınan məhsullar siyahıdan çıxarılacaq. Davam edilsin?';

  @override
  String get emptyShoppingListDesc =>
      'Çörək, süd, meyvə kimi ehtiyacınız olan məhsulları yuxarıdakı sahədən əlavə edə bilərsiniz.';

  @override
  String get allPurchasedMessage => 'Bütün məhsullar alındı! 🎉';

  @override
  String get delete => 'Sil';

  @override
  String get accountTypeCash => 'Nağd';

  @override
  String get accountTypeBank => 'Bank';

  @override
  String get accountTypeCreditCard => 'Kredit Kartı';

  @override
  String get accountTypeDebtCredit => 'Cari (Borc/Alacaq)';

  @override
  String statementCutoff(String day) {
    return 'Qəbz kəsimi: $day';
  }

  @override
  String get planBudget => 'Büdcəni Planla';

  @override
  String get categoryBudgets => 'Kateqoriya Büdcələri';

  @override
  String get noBudgetsSet => 'Hələ heç bir büdcə hədəfi təyin etməmisiniz.';

  @override
  String get limitExceeded => 'Limit aşıldı!';

  @override
  String get noExpensesPeriod => 'Bu dövrdə xərc yoxdur.';

  @override
  String get expenseHistory => 'Xərc Tarixçəsi';

  @override
  String get noRecordsFound => 'Qeyd tapılmadı.';

  @override
  String get financeManagementPro => 'Maliyyə İdarəetməsi PRO';

  @override
  String get financeProDesc =>
      'Bütün gəlir, xərc və bank hesablarını idarə etmək üçün PRO-ya yüksəldin.';

  @override
  String get expirationTitle => 'Son İstifadə Tarixləri';

  @override
  String get freshnessSubtitle =>
      'Enventarınızdakı məhsulların təravətini izləyin.';

  @override
  String get searchProductLocationHint => 'Məhsul adı və ya məkan axtar...';

  @override
  String get clearExpired => 'Vaxtı Bitənləri Təmizlə';

  @override
  String get noProductsYet => 'Hələ Məhsul Yoxdur';

  @override
  String get noProductsFound => 'Məhsul Tapılmadı';

  @override
  String get addFirstProductDesc =>
      'İlk məhsulu əlavə etmək üçün \"Məhsul Əlavə Et\" düyməsinə basın.';

  @override
  String get noMatchingProductsDesc => 'Axtarışa uyğun məhsul tapılmadı.';

  @override
  String get clearFilters => 'Filtrləri Təmizlə';

  @override
  String get expirationDateLabel => 'Son İstifadə';

  @override
  String get trashAndShopping => 'Zibilə At və Alış-verişə Əlavə Et';

  @override
  String get warrantyTrackingTitle => 'Zəmanət İzləməsi';

  @override
  String get warrantySubtitle => 'Cihazlarınızın zəmanət müddətini izləyin.';

  @override
  String get searchDeviceBrandHint => 'Cihaz, marka və ya mağaza axtar...';

  @override
  String get noWarrantyRecordsYet => 'Hələ Zəmanət Qeydi Yoxdur';

  @override
  String get noWarrantyRecordsFound => 'Zəmanət Qeydi Tapılmadı';

  @override
  String get addFirstWarrantyDesc =>
      'İlk zəmanət qeydini əlavə etmək üçün \"Zəmanət Əlavə Et\" düyməsinə basın.';

  @override
  String get noMatchingWarrantiesDesc => 'Axtarışa uyğun qeyd tapılmadı.';

  @override
  String get documentsAndWarranties => 'Sənədlər və Zəmanətlər';

  @override
  String get serviceAndEmergencyNumbers => 'Servis və Təcili Nömrələr';

  @override
  String get uploadDocument => 'Sənəd Yüklə';

  @override
  String get noDocumentsTitle => 'Sənəd Tapılmadı';

  @override
  String get noDocumentsDesc => 'Vacib sənədlərinizi təhlükəsiz saxlayın.';

  @override
  String get uploadFirstDocument => 'İlk Sənədi Yüklə';

  @override
  String get addNumber => 'Nömrə Əlavə Et';

  @override
  String get noEmergencyContactsTitle => 'Qeydli Nömrə Yoxdur';

  @override
  String get noEmergencyContactsDesc =>
      'Təcili zəng üçün kontakları əlavə edin.';

  @override
  String get addFirstNumber => 'İlk Nömrəni Əlavə Et';

  @override
  String get call => 'Zəng Et';

  @override
  String get copy => 'Kopyala';

  @override
  String get newMaintenanceTask => 'Yeni Baxış Tapşırığı';

  @override
  String get maintenanceTitleLabel => 'Baxış Adı';

  @override
  String get maintenanceTitleHint => 'Məs: Kombi illik baxış';

  @override
  String get descriptionLabel => 'Təsvir / Təfərrüatlar';

  @override
  String get descriptionHint => 'Məs: Filtrlər yuyulacaq.';

  @override
  String get scheduledDateLabel => 'Planlaşdırılan Baxış Tarixi';

  @override
  String get saveTask => 'Tapşırığı Yadda Saxla';

  @override
  String get addHomeInfo => '+ Ev Məlumatı Əlavə Et';

  @override
  String get noGuideTitle => 'Rəhbər Məlumatı Yoxdur';

  @override
  String get noGuideDesc =>
      'Wi-Fi parollarını ailə üzvləri ilə anında paylaşın.';

  @override
  String get deleteItem => 'Sil';

  @override
  String get deleteConfirmDesc => 'həmişəlik silinəcək.';

  @override
  String get addWarranty => 'Zəmanət Əlavə Et';

  @override
  String get addMaintenanceTask => 'Baxış Əlavə Et';

  @override
  String get noMaintenanceTasksTitle => 'Baxış Tapşırığı Yoxdur';

  @override
  String get noMaintenanceTasksDesc =>
      'Xatırlatmalar almaq üçün baxış tapşırıqları əlavə edin.';

  @override
  String get addFirstMaintenanceTask => 'İlk Baxış Tapşırığını Əlavə Et';

  @override
  String get consentByContinuing => 'Davam edərək ';

  @override
  String get consentTermsAndPrivacy => 'İstifadə Şərtləri və Məxfilik Siyasəti';

  @override
  String get consentAcceptSuffix => '-ni qəbul etmiş olursunuz.';

  @override
  String get registerConsentPrefix => '';

  @override
  String get registerConsentSuffix => ' oxudum və qəbul edirəm.';

  @override
  String get registerConsentError =>
      'Davam etmək üçün şərtləri qəbul etməlisiniz.';

  @override
  String get addProduct => 'Məhsul Əlavə Et';

  @override
  String get perMonthSuffix => '/ bu ay';

  @override
  String get freeBudgetDescription =>
      'Aylıq xalis gəlirdən sabit xərclər çıxıldıqdan sonra qalan məbləğ.';

  @override
  String get viewDetails => 'Ətraflı Bax';

  @override
  String get everythingLooksGood => 'Evində hər şey qaydasında görünür.';

  @override
  String get statusAll => 'Hamısı';

  @override
  String get statusExpiredChip => 'Tarixi Keçənlər';

  @override
  String get statusCriticalChip => 'Kritik';

  @override
  String get statusUpcomingChip => 'Yaxınlaşanlar';

  @override
  String get statusSafeChip => 'Təhlükəsiz';

  @override
  String get statusExpired => 'Tarixi Keçib';

  @override
  String get statusToday => 'Bu Gün Son';

  @override
  String daysLeft(int count) {
    return '$count Gün Qaldı';
  }

  @override
  String get budgetPlanDescription =>
      'Aylıq xərc hədəflərinizi təyin edin. İstəmədiyiniz kateqoriyaları boş buraxa bilərsiniz.';

  @override
  String get categoryDiningOut => 'Yemək / İçmək';

  @override
  String get categoryKitchenGrocery => 'Mətbəx & Market';

  @override
  String get categoryHomeBills => 'Ev & Faturalar';

  @override
  String get categoryShoppingPersonal => 'Alış-veriş & Şəxsi';

  @override
  String get categoryTransport => 'Nəqliyyat';

  @override
  String get categoryEntertainmentSubscriptions => 'Əyləncə & Abunəliklər';

  @override
  String get categoryOther => 'Digər';

  @override
  String get saveBudgets => 'Hədəfləri Yadda Saxla';

  @override
  String get limitAmountHint => 'Limit (₺)';

  @override
  String get financialStatus => 'Maliyyə Vəziyyəti';

  @override
  String get periodYearly => 'İllik';

  @override
  String get periodMonthly => 'Aylıq';

  @override
  String get periodWeekly => 'Həftəlik';

  @override
  String get periodDaily => 'Günlük';

  @override
  String get netStatus => 'Net Vəziyyət';

  @override
  String get yearlyNetStatus => 'İllik Net Vəziyyət';

  @override
  String get monthlyNetStatus => 'Aylıq Net Vəziyyət';

  @override
  String get weeklyNetStatus => 'Həftəlik Net Vəziyyət';

  @override
  String get dailyNetStatus => 'Günlük Net Vəziyyət';

  @override
  String get upcomingPendingTransactions =>
      'Gözlənilən Təxirə Salınmış Əməliyyatlar';

  @override
  String get recentTransactions => 'Son Əməliyyatlar';

  @override
  String get futureIncome => 'Gələcək Gəlir';

  @override
  String get upcomingPayment => 'Gözlənilən Ödəniş';

  @override
  String get noTransactionsPeriod => 'Bu dövrdə heç bir əməliyyat yoxdur.';

  @override
  String get budgetPlanUpdated => 'Büdcə hədəfləri yeniləndi!';

  @override
  String get linkAccountTitle => 'Hesabınızı Bağlayın';

  @override
  String get guestModeDesc =>
      'Qonaq rejimindəsiniz. Məlumatlarınızı itirmədən hesabınızı daimi edin.';

  @override
  String get guestModeBottomSheetDesc =>
      'Qonaq rejimindəsiniz. Məlumatlarınızı itirməmək üçün bir giriş üsulu seçərək daimi hesab yaradın.';

  @override
  String get connectionOptions => 'Bağlantı Seçimləri';

  @override
  String get userRoleLabel => 'İstifadəçi';

  @override
  String get anonymousSession => 'Anonim Sessiya';

  @override
  String get notMemberOfFamilyYet => 'Hələ ki bir Ailəyə Bağlı Deyilsiniz';

  @override
  String get notMemberOfHomeYet => 'Hələ ki bir Evə Bağlı Deyilsiniz';

  @override
  String get noHomeSyncDesc =>
      'Məhsul və alış-veriş siyahılarının sinxronizasiyası üçün ev yaradın və ya davət kodu ilə mövcud evə qoşulun.';

  @override
  String get createHome => 'Ev Yaradın';

  @override
  String get enterCode => 'Kodu Daxil Edin';

  @override
  String get createOrJoinHome => 'Ev Yaradın və ya Qoşulun';

  @override
  String get createNewHomeTitle => 'Yeni Ev / Ailə Yaradın';

  @override
  String get createNewHomeDesc =>
      'Evinizə bir ad verin. 1 qısa reklama baxaraq evinizi pulsuz yarada bilərsiniz.';

  @override
  String get homeNameLabel => 'Ev / Ailə Adı';

  @override
  String get homeNameHint => 'Məs: Əliyevlər Ailəsi';

  @override
  String get homeNameRequired => 'Ev adı mütləqdir.';

  @override
  String get roleInHomeLabel => 'Evdəki Rolunuz';

  @override
  String get roleHouseOwner => '👑 Ev Sahibi';

  @override
  String get roleMother => '👨‍👩‍👧 Ana';

  @override
  String get roleFather => '👨‍👩‍👦 Ata';

  @override
  String get roleChild => '👶 Uşaq';

  @override
  String get roleRoommate => '🏠 Ev Yoldaşı';

  @override
  String get roleOtherResident => '🐾 Digər / Sakin';

  @override
  String get noUpcomingExpirationsMessage =>
      'Son istifadə tarixi yaxınlaşan məhsul yoxdur. 👍';

  @override
  String get expirationProductItem => 'Son İstifadə Tarixli Məhsul';

  @override
  String get expirationProductSubtitle =>
      'Soyuducu və ya kilerdəki qida/dərman izlənməsi';

  @override
  String get warrantyDocumentItem => 'Zəmanət Sənədi / Fayl Əlavə Et';

  @override
  String get warrantyDocumentSubtitle =>
      'Məhsul zəmanət sənədləri və məişət texnikası faylları';

  @override
  String get enterQuickExpense => 'Tez Xərc Daxil Et';

  @override
  String get amountLabel => 'Məbləğ';

  @override
  String get amountRequired => 'Zəhmət olmasa məbləğ daxil edin';

  @override
  String get validAmountRequired => 'Düzgün məbləğ daxil edin';

  @override
  String get shortDescriptionLabel => 'Qısa Təsvir';

  @override
  String get shortDescriptionHint => 'Məs: Qəhvə, Market və s.';

  @override
  String get descriptionRequired => 'Təsvir daxil edin';

  @override
  String get categoryLabel => 'Kateqoriya';

  @override
  String get addToPaymentSchedule => 'Ödəniş Təqviminə Əlavə Et';

  @override
  String get editPaymentSchedule => 'Ödəniş Təqvimini Redaktə Et';

  @override
  String get billExpenseOption => 'Qəbz / Xərc';

  @override
  String get incomeCollectionOption => 'Məxaric / Gəlir';

  @override
  String get scheduleTitleLabel => 'Başlıq (məs: İşıq Pulu, Kirayə)';

  @override
  String get titleRequired => 'Zəhmət olmasa başlıq daxil edin';

  @override
  String get dateLabel => 'Tarix';

  @override
  String get bankAccountNameOptional =>
      'Əlaqəli Bank / Hesab Adı (İstəyə Bağlı)';

  @override
  String get markAsPaid => 'Ödənildi Kimi Qeyd Et';

  @override
  String get repeatMonthly => 'Aylıq Təkrarlansın';

  @override
  String get oneTimePaymentNotice => 'Birdəfəlik ödəniş.';

  @override
  String get addToScheduleBtn => 'Təqvimə Əlavə Et';

  @override
  String get addNewDocumentTitle => 'Yeni Sənəd / Fayl Əlavə Et';

  @override
  String get editDocumentTitle => 'Sənədi Redaktə Et';

  @override
  String get documentTitleLabel => 'Sənəd Başlığı';

  @override
  String get documentTitleHint => 'Məs: Çıxarış (Mülkiyyət), Kirayə Müqaviləsi';

  @override
  String get notesDescriptionLabel => 'Təsvir / Qeydlər';

  @override
  String get notesDescriptionHint =>
      'Məs: Sənəd dolabında 2-ci siyirmədə saxlanılır.';

  @override
  String get addFileImage => 'Fayl / Şəkil Əlavə Et';

  @override
  String get selectPhotoDocument => 'Fotoşəkil / Sənəd Seçin';

  @override
  String get saveDocumentBtn => 'Sənədi Yadda Saxla';

  @override
  String get addNewContactTitle => 'Yeni Əlaqə / Servis Nömrəsi Əlavə Et';

  @override
  String get editContactTitle => 'Nömrəni Redaktə Et';

  @override
  String get namePersonLabel => 'Ad / Əlaqəli Şəxs';

  @override
  String get namePersonHint => 'Məs: Usta Həsən, Bina İdarəçiliyi';

  @override
  String get titleCategoryLabel => 'Vəzifə / Kateqoriya';

  @override
  String get titleCategoryHint => 'Məs: Santexnik, Elektrik, Çilingir';

  @override
  String get phoneNumberLabel => 'Telefon Nömrəsi';

  @override
  String get phoneNumberHint => 'Məs: +994 50 123 45 67';

  @override
  String get saveNumberBtn => 'Nömrəni Yadda Saxla';

  @override
  String get summary => 'Xülasə';

  @override
  String get creditCardExpenses => 'Kredit Kartı Xərcləri';

  @override
  String get cashExpenses => 'Nağd Xərclər';

  @override
  String get quickExpenses => 'Cəld Xərclər';

  @override
  String get pleaseSelectDocumentOrPhoto =>
      'Zəhmət olmasa bir sənəd və ya fotoşəkil seçin.';

  @override
  String get editWarranty => 'Zəmanət Qeydini Redaktə Et';

  @override
  String get productDeviceName => 'Məhsul / Cihaz Adı';

  @override
  String get productDeviceNameHint => 'Məs: Soyuducu, Noutbuk...';

  @override
  String get brand => 'Marka';

  @override
  String get brandHint => 'Məs: Samsung, Apple...';

  @override
  String get store => 'Alınan Mağaza';

  @override
  String get storeHint => 'Məs: Trendyol, Kontakt Home...';

  @override
  String get purchaseDate => 'Alış Tarixi';

  @override
  String get warrantyEndDate => 'Zəmanət Bitmə Tarixi';

  @override
  String get hasInvoice => 'Qəbz / Sənəd Mövcuddur';

  @override
  String get icon => 'İkon';

  @override
  String get optionalNotes => 'Qeydlər (İstəyə Bağlı)';

  @override
  String get optionalNotesHint => 'Əlavə məlumat...';

  @override
  String get invoiceNumberOptional => 'Qəbz Nömrəsi (İstəyə Bağlı)';

  @override
  String get invoiceNumberHint => 'Məs: AMZ-2024-12345';

  @override
  String get changeInvoiceFile => 'Qəbz Faylını Dəyişdir';

  @override
  String get uploadInvoiceFile => '📸 Qəbz Şəkli / PDF Yüklə';

  @override
  String get saveChanges => 'Dəyişiklikləri Yadda Saxla';

  @override
  String get productNameRequired => 'Məhsul adı mütləqdir.';

  @override
  String get brandRequired => 'Marka mütləqdir.';

  @override
  String get storeRequired => 'Mağaza adı mütləqdir.';

  @override
  String get selectPurchaseDateWarning => 'Zəhmət olmasa alış tarixini seçin.';

  @override
  String get selectWarrantyEndDateWarning =>
      'Zəhmət olmasa zəmanət bitmə tarixini seçin.';

  @override
  String get selectDateHint => 'Tarixi Seçin';

  @override
  String get addNewHomeInfo => 'Yeni Ev Məlumatı Əlavə Et';

  @override
  String get editHomeInfo => 'Ev Məlumatını Redaktə Et';

  @override
  String get categorySelection => 'Kategoriya Seçimi';

  @override
  String get guideTitle => 'Təlimat Başlığı';

  @override
  String get guideTitleHint => 'Məs: Qaz Abunəliyi, Su Kranı, Wi-Fi Parolu';

  @override
  String get importantValueLabel =>
      'Vacib Məlumat / Dəyər (Kopyalamaq üçün Klikləyin)';

  @override
  String get importantValueHint => 'Məs: Abunə No: 123456, Parol: xyz';

  @override
  String get detailedNotesLabel => 'Təsvir / Ətraflı Qeyd';

  @override
  String get detailedNotesHint =>
      'Məs: Sayğac eyvandakı dolabın sağ tərəfindədir.';

  @override
  String get updateInfoBtn => 'Məlumatı Yenilə';

  @override
  String get categoryWifi => '📶 Wi-Fi və Şəbəkə';

  @override
  String get categoryInstallation => '⚡ Quraşdırma və Xidmətlər';

  @override
  String get categoryPasswords => '🔑 Parollar və Kodlar';

  @override
  String get categoryGeneralHome => 'ℹ️ Ümumi Ev Məlumatı';

  @override
  String get themeSelection => 'Tema Seçimi';

  @override
  String get themeSelectionSubtitle =>
      'Tətbiq görünüşünü seçin (Sistem / Açıq / Tünd)';

  @override
  String get themeSystem => 'Sistem (Defolt)';

  @override
  String get themeLight => 'Açıq Tema';

  @override
  String get themeDark => 'Tünd Tema';

  @override
  String get editHomeNameTitle => 'Ev Adını Redaktə Et';

  @override
  String get editHomeNameLabel => 'Ev Adı';

  @override
  String get editHomeNameHint => 'Məs: Əliyevlər Evi';

  @override
  String get homeNameUpdatedToast => 'Ev adı uğurla yeniləndi! 🏠';

  @override
  String get customRoleOption => '✏️ Xüsusi Rol...';

  @override
  String get customRoleHint => 'Rol adını yazın...';

  @override
  String get aboutDeveloper => 'Tərtibatçı: Samed Kalaycı';

  @override
  String get aboutCopyright => '© 2026 Ev Asistanı. Bütün hüquqlar qorunur.';

  @override
  String get addShoppingItemSub =>
      'Çatışmayan ərzaq, təmizlik və ev ehtiyacları';

  @override
  String get guestLoginSuccess => 'Qonaq sessiyanı başladıldı. 👋';

  @override
  String guestLoginFailed(String error) {
    return 'Qonaq girişi uğursuz oldu: $error';
  }
}
