// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appName => 'Βοηθός Σπιτιού';

  @override
  String get languageSelection => 'Επιλογή Γλώσσας';

  @override
  String get languageSelectionSubtitle => 'Αλλαγή γλώσσας εφαρμογής';

  @override
  String get preferencesAndSettings => 'Προτιμήσεις & Ρυθμίσεις';

  @override
  String get notificationSettings => 'Ρυθμίσεις Ειδοποιήσεων';

  @override
  String get notificationSettingsSubtitle =>
      'Διαχείριση ειδοποιήσεων συστήματος';

  @override
  String get about => 'Σχετικά';

  @override
  String get aboutSubtitle => 'Βοηθός Σπιτιού v1.1.0 (Firebase Ενεργό)';

  @override
  String get developerLabel => 'Προγραμματιστής: Samed Kalaycı';

  @override
  String get aboutDescription =>
      'Περιγραφή: Εφαρμογή οργάνωσης σπιτιού και διαχείρισης κοινόχρηστων λιστών.';

  @override
  String get allRightsReserved =>
      '© 2026 Βοηθός Σπιτιού. Με επιφύλαξη παντός δικαιώματος.';

  @override
  String get privacyPolicy => 'Πολιτική Απορρήτου & Όροι';

  @override
  String get privacyPolicySubtitle => 'Δείτε νομικές πληροφορίες και όρους';

  @override
  String get signOut => 'Αποσύνδεση';

  @override
  String get signOutSubtitle => 'Ασφαλής αποσύνδεση από το λογαριασμό';

  @override
  String get deleteAccount => 'Διαγραφή Λογαριασμού';

  @override
  String get deleteAccountSubtitle =>
      'Μόνιμη διαγραφή λογαριασμού και δεδομένων';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get confirm => 'Επιβεβαίωση';

  @override
  String get selectLanguage => 'Επιλέξτε Γλώσσα';

  @override
  String get turkish => 'Τουρκικά';

  @override
  String get english => 'Αγγλικά';

  @override
  String get german => 'Γερμανικά';

  @override
  String get spanish => 'Ισπανικά';

  @override
  String get french => 'Γαλλικά';

  @override
  String get azerbaijani => 'Αζερμπαϊτζανικά';

  @override
  String get greek => 'Ελληνικά';

  @override
  String get portuguese => 'Πορτογαλικά';

  @override
  String get navHome => 'Αρχική';

  @override
  String get navInventory => 'Απογραφή';

  @override
  String get navShopping => 'Αγορές';

  @override
  String get navFinance => 'Οικονομικά';

  @override
  String get navProfile => 'Προφίλ';

  @override
  String get shoppingListTitle => 'Λίστα Αγορών';

  @override
  String get toBuyTab => 'Προς Αγορά';

  @override
  String get purchasedTab => 'Αγορασμένα';

  @override
  String get clearCompleted => 'Καθαρισμός';

  @override
  String get newProductHint => 'Προσθήκη νέου προϊόντος...';

  @override
  String itemsCount(int count) {
    return '$count Προϊόντα';
  }

  @override
  String get addShoppingItemTitle => 'Προσθήκη στη Λίστα Αγορών';

  @override
  String get productNameLabel => 'Όνομα Προϊόντος';

  @override
  String get productNameHint => 'π.χ. Γάλα, Ψωμί, Αυγά...';

  @override
  String get addToListBtn => 'Προσθήκη στη Λίστα';

  @override
  String itemAddedToast(String name) {
    return 'Το \"$name\" προστέθηκε στη λίστα! 🛒';
  }

  @override
  String get emptyShoppingList => 'Η λίστα αγορών είναι άδεια.';

  @override
  String get financeOverviewTab => 'Επισκόπηση';

  @override
  String get householdWalletTab => 'Πορτοφόλι Σπιτιού';

  @override
  String get accountsTab => 'Λογαριασμοί';

  @override
  String get viewSummary => 'Προβολή Σύνοψης';

  @override
  String get incomeExpenseBalance => 'Υπόλοιπο Εσόδων/Εξόδων';

  @override
  String get totalIncome => 'Συνολικά Έσοδα';

  @override
  String get totalExpense => 'Συνολικά Έξοδα';

  @override
  String get personalExpenses => 'Προσωπικά Έξοδα';

  @override
  String get noAccountYet => 'Δεν έχει προστεθεί λογαριασμός ακόμη.';

  @override
  String get paymentSchedule => 'Πρόγραμμα Πληρωμών';

  @override
  String get realizedPayments => 'Ολοκληρωμένα';

  @override
  String get accountScheduleHeader => 'Λογαριασμός / Πρόγραμμα';

  @override
  String get monthlyFreeBudget => 'Υπόλοιπο Διαθέσιμο Budget';

  @override
  String get quickAddExpense => 'Γρήγορη Προσθήκη Εξόδου';

  @override
  String greetingUser(String name) {
    return 'Γεια σου, $name';
  }

  @override
  String get quickAdd => 'Γρήγορη Προσθήκη';

  @override
  String get expiringSoonTitle => 'Προϊόντα που Λήγουν Σύντομα';

  @override
  String get warrantiesExpiringTitle => 'Εγγυήσεις που Λήγουν';

  @override
  String get shoppingSummaryTitle => 'Σύνοψη Λίστας Αγορών';

  @override
  String get viewAll => 'Προβολή Όλων';

  @override
  String urgentExpirationsCount(int count) {
    return '$count Επείγοντα Προϊόντα';
  }

  @override
  String urgentWarrantiesCount(int count) {
    return '$count Επείγουσες Εγγυήσεις';
  }

  @override
  String get inventoryTitle => 'Απογραφή Σπιτιού';

  @override
  String get expirationTab => 'Ημερομηνία Λήξης';

  @override
  String get warrantyTab => 'Εγγυήσεις';

  @override
  String get vaultTab => 'Χρηματοκιβώτιο';

  @override
  String get addExpirationItem => 'Προσθήκη Προϊόντος';

  @override
  String get addWarrantyItem => 'Προσθήκη Εγγύησης';

  @override
  String get periodicMaintenance => 'Πρόγραμμα Συντήρησης';

  @override
  String get homeGuideWifi => 'Οδηγός Σπιτιού & Wi-Fi';

  @override
  String get digitalVaultSubtitle =>
      'Σημαντικά έγγραφα και τηλέφωνα ανάγκης είναι κρυπτογραφημένα.';

  @override
  String get myHomeAndFamily => 'Το Σπίτι μου & Οικογένεια';

  @override
  String get inviteCode => 'Κωδικός Πρόσκλησης';

  @override
  String get familyMembers => 'Μέλη Οικογένειας';

  @override
  String get proMember => 'Μέλος PRO';

  @override
  String get proHouseOwner => 'Ιδιοκτήτης PRO';

  @override
  String get houseOwner => 'Ιδιοκτήτης Σπιτιού';

  @override
  String get legalSection => 'Νομικά';

  @override
  String get legalAndInfo => 'Νομικά & Πληροφορίες';

  @override
  String get accountActions => 'Ενέργειες Λογαριασμού';

  @override
  String get removeAdsTitle => 'Αφαίρεση Διαφημίσεων';

  @override
  String memberCount(int count) {
    return '$count Μέλος';
  }

  @override
  String get removeAdsSubtitle =>
      'Χωρίς διαφημίσεις για πάντα με μία εφάπαξ πληρωμή!';

  @override
  String get removeAdsActive => 'Έκδοση Χωρίς Διαφημίσεις Ενεργή ✅';

  @override
  String get specialPriceOffer => 'Ειδική Τιμή! Στην τιμή ενός καφέ.';

  @override
  String get buyNow => 'Αγορά Τώρα';

  @override
  String get restorePurchases => 'Επαναφορά Αγορών';

  @override
  String get introPopupTitle =>
      'Χρησιμοποιήστε την Εφαρμογή Χωρίς Διαφημίσεις!';

  @override
  String get introPopupDesc =>
      'Αφαιρέστε μόνιμα όλες τις διαφημίσεις με μία μικρή εφάπαξ πληρωμή.';

  @override
  String get skipForNow => 'Παράκαμψη προς το παρόν';

  @override
  String get shoppingListSubtitle =>
      'Παρακολουθήστε εύκολα τα προς αγορά και τα αγορασμένα είδη.';

  @override
  String get clearCompletedConfirmTitle => 'Εκκαθάριση αγορασμένων';

  @override
  String get clearCompletedConfirmDesc =>
      'Όλα τα αγορασμένα είδη θα αφαιρεθούν από τη λίστα. Συνέχεια;';

  @override
  String get emptyShoppingListDesc =>
      'Μπορείτε να προσθέσετε προϊόντα που χρειάζεστε όπως ψωμί, γάλα ή φρούτα από το παραπάνω πεδίο.';

  @override
  String get allPurchasedMessage => 'Όλα τα είδη αγοράστηκαν! 🎉';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get accountTypeCash => 'Μετρητά';

  @override
  String get accountTypeBank => 'Τράπεζα';

  @override
  String get accountTypeCreditCard => 'Πιστωτική Κάρτα';

  @override
  String get accountTypeDebtCredit => 'Λογαριασμός (Χρέος/Πίστωση)';

  @override
  String statementCutoff(String day) {
    return 'Ημερομηνία έκδοσης: $day';
  }

  @override
  String get planBudget => 'Προγραμματισμός Προϋπολογισμού';

  @override
  String get categoryBudgets => 'Προϋπολογισμοί Κατηγοριών';

  @override
  String get noBudgetsSet => 'Δεν έχετε ορίσει ακόμα στόχο προϋπολογισμού.';

  @override
  String get limitExceeded => 'Υπέρβαση ορίου!';

  @override
  String get noExpensesPeriod => 'Καμία δαπάνη για αυτή την περίοδο.';

  @override
  String get expenseHistory => 'Ιστορικό Δαπανών';

  @override
  String get noRecordsFound => 'Δεν βρέθηκαν εγγραφές.';

  @override
  String get financeManagementPro => 'Διαχείριση Οικονομικών PRO';

  @override
  String get financeProDesc =>
      'Αναβαθμίστε σε PRO για να διαχειρίζεστε όλα τα έσοδα, έξοδα και λογαριασμούς.';

  @override
  String get expirationTitle => 'Ημερομηνίες Λήξης';

  @override
  String get freshnessSubtitle =>
      'Παρακολουθήστε τη φρεσκάδα των ειδών στο αποθετήριό σας.';

  @override
  String get searchProductLocationHint => 'Αναζήτηση προϊόντος ή τοποθεσίας...';

  @override
  String get clearExpired => 'Εκκαθάριση ληγμένων ειδών';

  @override
  String get noProductsYet => 'Δεν υπάρχουν ακόμα προϊόντα';

  @override
  String get noProductsFound => 'Δεν βρέθηκαν προϊόντα';

  @override
  String get addFirstProductDesc => 'Πατήστε \"Προσθήκη Προϊόντος\".';

  @override
  String get noMatchingProductsDesc =>
      'Δεν βρέθηκαν προϊόντα που να ταιριάζουν.';

  @override
  String get clearFilters => 'Εκκαθάριση Φίλτρων';

  @override
  String get expirationDateLabel => 'Ημερομηνία Λήξης';

  @override
  String get trashAndShopping => 'Απόρριψη & Προσθήκη στις Αγορές';

  @override
  String get warrantyTrackingTitle => 'Παρακολούθηση Εγγυήσεων';

  @override
  String get warrantySubtitle =>
      'Παρακολουθήστε τις περιόδους εγγύησης των συσκευών σας.';

  @override
  String get searchDeviceBrandHint =>
      'Αναζήτηση συσκευής, μάρκας ή καταστήματος...';

  @override
  String get noWarrantyRecordsYet => 'Δεν υπάρχουν εγγραφές εγγύησης';

  @override
  String get noWarrantyRecordsFound => 'Δεν βρέθηκαν εγγραφές εγγύησης';

  @override
  String get addFirstWarrantyDesc => 'Πατήστε \"Προσθήκη Εγγύησης\".';

  @override
  String get noMatchingWarrantiesDesc =>
      'Δεν βρέθηκαν εγγραφές που να ταιριάζουν.';

  @override
  String get documentsAndWarranties => 'Έγγραφα & Εγγυήσεις';

  @override
  String get serviceAndEmergencyNumbers => 'Σέρβις & Αριθμοί Έκτακτης Ανάγκης';

  @override
  String get uploadDocument => 'Μεταφόρτωση Εγγράφου';

  @override
  String get noDocumentsTitle => 'Δεν βρέθηκαν έγγραφα';

  @override
  String get noDocumentsDesc =>
      'Αποθηκεύστε έγγραφα με ασφάλεια στο ψηφιακό θησαυροφυλάκιο.';

  @override
  String get uploadFirstDocument => 'Μεταφόρτωση Πρώτου Εγγράφου';

  @override
  String get addNumber => 'Προσθήκη Αριθμού';

  @override
  String get noEmergencyContactsTitle => 'Δεν υπάρχουν αποθηκευμένοι αριθμοί';

  @override
  String get noEmergencyContactsDesc => 'Προσθέστε επαφές έκτακτης ανάγκης.';

  @override
  String get addFirstNumber => 'Προσθήκη Πρώτου Αριθμού';

  @override
  String get call => 'Κλήση';

  @override
  String get copy => 'Αντιγραφή';

  @override
  String get newMaintenanceTask => 'Νέα Εργασία Συντήρησης';

  @override
  String get maintenanceTitleLabel => 'Όνομα Συντήρησης';

  @override
  String get maintenanceTitleHint => 'π.χ. Ετήσια συντήρηση λέβητα';

  @override
  String get descriptionLabel => 'Περιγραφή / Λεπτομέρειες';

  @override
  String get descriptionHint => 'π.χ. Καθαρισμός φίλτρων.';

  @override
  String get scheduledDateLabel => 'Προγραμματισμένη Ημερομηνία';

  @override
  String get saveTask => 'Αποθήκευση Εργασίας';

  @override
  String get addHomeInfo => '+ Προσθήκη Πληροφοριών Σπιτιού';

  @override
  String get noGuideTitle => 'Δεν βρέθηκαν πληροφορίες οδηγού';

  @override
  String get noGuideDesc => 'Μοιραστείτε κωδικούς Wi-Fi με την οικογένεια.';

  @override
  String get deleteItem => 'Διαγραφή';

  @override
  String get deleteConfirmDesc => 'θα διαγραφεί οριστικά.';

  @override
  String get addWarranty => 'Προσθήκη Εγγύησης';

  @override
  String get addMaintenanceTask => 'Προσθήκη Συντήρησης';

  @override
  String get noMaintenanceTasksTitle => 'Δεν υπάρχουν εργασίες συντήρησης';

  @override
  String get noMaintenanceTasksDesc =>
      'Προσθέστε εργασίες συντήρησης για υπενθυμίσεις.';

  @override
  String get addFirstMaintenanceTask => 'Προσθήκη Πρώτης Εργασίας Συντήρησης';

  @override
  String get consentByContinuing => 'Συνεχίζοντας, αποδέχεστε τους ';

  @override
  String get consentTermsAndPrivacy =>
      'Όρους Χρήσης και την Πολιτική Απορρήτου';

  @override
  String get consentAcceptSuffix => ' μας.';

  @override
  String get registerConsentPrefix => 'Έχω διαβάσει και αποδέχομαι τους ';

  @override
  String get registerConsentSuffix => '.';

  @override
  String get registerConsentError =>
      'Πρέπει να αποδεχτείτε τους όρους για να συνεχίσετε.';

  @override
  String get addProduct => 'Προσθήκη Προϊόντος';

  @override
  String get perMonthSuffix => '/ αυτόν τον μήνα';

  @override
  String get freeBudgetDescription =>
      'Το ποσό που απομένει από το μηνιαίο καθαρό εισόδημα μετά την αφαίρεση των πάγιων εξόδων.';

  @override
  String get viewDetails => 'Προβολή λεπτομερειών';

  @override
  String get everythingLooksGood =>
      'Όλα φαίνεται να πηγαίνουν καλά στο σπίτι σου.';

  @override
  String get statusAll => 'Όλα';

  @override
  String get statusExpiredChip => 'Ληγμένα';

  @override
  String get statusCriticalChip => 'Κρίσιμα';

  @override
  String get statusUpcomingChip => 'Επερχόμενα';

  @override
  String get statusSafeChip => 'Ασφαλή';

  @override
  String get statusExpired => 'Έληξε';

  @override
  String get statusToday => 'Τελευταία μέρα σήμερα';

  @override
  String daysLeft(int count) {
    return '$count Ημέρες απομένουν';
  }

  @override
  String get budgetPlanDescription =>
      'Ορίστε τους μηνιαίους στόχους δαπανών σας. Μπορείτε να αφήσετε κενές τις ανεπιθύμητες κατηγορίες.';

  @override
  String get categoryDiningOut => 'Φαγητό έξω';

  @override
  String get categoryKitchenGrocery => 'Κουζίνα & Σούπερ Μάρκετ';

  @override
  String get categoryHomeBills => 'Σπίτι & Λογαριασμοί';

  @override
  String get categoryShoppingPersonal => 'Ψώνια & Προσωπικά';

  @override
  String get categoryTransport => 'Μεταφορές';

  @override
  String get categoryEntertainmentSubscriptions => 'Ψυχαγωγία & Συνδρομές';

  @override
  String get categoryOther => 'Άλλο';

  @override
  String get saveBudgets => 'Αποθήκευση Στόχων';

  @override
  String get limitAmountHint => 'Όριο (₺)';

  @override
  String get financialStatus => 'Χρηματοοικονομική Κατάσταση';

  @override
  String get periodYearly => 'Ετήσια';

  @override
  String get periodMonthly => 'Μηνιαία';

  @override
  String get periodWeekly => 'Εβδομαδιαία';

  @override
  String get periodDaily => 'Ημερήσια';

  @override
  String get netStatus => 'Καθαρές Δαπάνες';

  @override
  String get yearlyNetStatus => 'Ετήσια Καθαρή Κατάσταση';

  @override
  String get monthlyNetStatus => 'Μηνιαία Καθαρή Κατάσταση';

  @override
  String get weeklyNetStatus => 'Εβδομαδιαία Καθαρή Κατάσταση';

  @override
  String get dailyNetStatus => 'Ημερήσια Καθαρή Κατάσταση';

  @override
  String get upcomingPendingTransactions => 'Επερχόμενες Εκκρεμείς Συναλλαγές';

  @override
  String get recentTransactions => 'Πρόσφατες Συναλλαγές';

  @override
  String get futureIncome => 'Μελλοντικό Εισόδημα';

  @override
  String get upcomingPayment => 'Επερχόμενη Πληρωμή';

  @override
  String get noTransactionsPeriod =>
      'Δεν υπάρχουν συναλλαγές σε αυτήν την περίοδο.';

  @override
  String get budgetPlanUpdated => 'Οι στόχοι του προϋπολογισμού ενημερώθηκαν!';
}
