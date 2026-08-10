// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Haushaltsassistent';

  @override
  String get languageSelection => 'Sprachauswahl';

  @override
  String get languageSelectionSubtitle => 'App-Sprache ändern';

  @override
  String get preferencesAndSettings => 'Einstellungen & Optionen';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get notificationSettingsSubtitle =>
      'Systembenachrichtigungen verwalten';

  @override
  String get about => 'Über die App';

  @override
  String get aboutSubtitle => 'Haushaltsassistent v1.1.0 (Firebase Aktiv)';

  @override
  String get developerLabel => 'Entwickler: Samed Kalaycı';

  @override
  String get aboutDescription =>
      'Beschreibung: App zur Haushaltsorganisation und gemeinsamen Listenverwaltung.';

  @override
  String get allRightsReserved =>
      '© 2026 Haushaltsassistent. Alle Rechte vorbehalten.';

  @override
  String get privacyPolicy => 'Datenschutz & Nutzungsbedingungen';

  @override
  String get privacyPolicySubtitle => 'Rechtliche Hinweise einsehen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get signOutSubtitle => 'Sicher vom Konto abmelden';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountSubtitle => 'Konto und Daten dauerhaft löschen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get selectLanguage => 'Sprache wählen';

  @override
  String get turkish => 'Türkisch';

  @override
  String get english => 'Englisch';

  @override
  String get german => 'Deutsch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get french => 'Französisch';

  @override
  String get azerbaijani => 'Aserbaidschanisch';

  @override
  String get greek => 'Griechisch';

  @override
  String get portuguese => 'Portugiesisch';

  @override
  String get navHome => 'Startseite';

  @override
  String get navInventory => 'Inventar';

  @override
  String get navShopping => 'Einkauf';

  @override
  String get navFinance => 'Finanzen';

  @override
  String get navProfile => 'Profil';

  @override
  String get shoppingListTitle => 'Einkaufsliste';

  @override
  String get toBuyTab => 'Einzukaufen';

  @override
  String get purchasedTab => 'Gekauft';

  @override
  String get clearCompleted => 'Löschen';

  @override
  String get newProductHint => 'Neues Produkt hinzufügen...';

  @override
  String itemsCount(int count) {
    return '$count Artikel';
  }

  @override
  String get addShoppingItemTitle => 'Artikel zur Einkaufsliste hinzufügen';

  @override
  String get productNameLabel => 'Produktname';

  @override
  String get productNameHint => 'z.B. Milch, Brot, Eier...';

  @override
  String get addToListBtn => 'Zur Liste hinzufügen';

  @override
  String itemAddedToast(String name) {
    return '\"$name\" zur Einkaufsliste hinzugefügt! 🛒';
  }

  @override
  String get emptyShoppingList => 'Ihre Einkaufsliste ist leer.';

  @override
  String get financeOverviewTab => 'Übersicht';

  @override
  String get householdWalletTab => 'Haushaltskasse';

  @override
  String get accountsTab => 'Konten';

  @override
  String get viewSummary => 'Zusammenfassung';

  @override
  String get incomeExpenseBalance => 'Einnahmen/Ausgaben';

  @override
  String get totalIncome => 'Gesamteinnahmen';

  @override
  String get totalExpense => 'Gesamtausgaben';

  @override
  String get personalExpenses => 'Persönliche Ausgaben';

  @override
  String get noAccountYet => 'Noch kein Konto hinzugefügt.';

  @override
  String get paymentSchedule => 'Zahlungsplan';

  @override
  String get realizedPayments => 'Ausgeführt';

  @override
  String get accountScheduleHeader => 'Konto / Zeitplan';

  @override
  String get monthlyFreeBudget => 'Verbleibendes freies Budget';

  @override
  String get quickAddExpense => 'Schnellausgabe hinzufügen';

  @override
  String greetingUser(String name) {
    return 'Hallo, $name';
  }

  @override
  String get quickAdd => 'Schnell hinzufügen';

  @override
  String get expiringSoonTitle => 'Ablaufende Produkte';

  @override
  String get warrantiesExpiringTitle => 'Ablaufende Garantien';

  @override
  String get shoppingSummaryTitle => 'Einkaufslisten-Übersicht';

  @override
  String get viewAll => 'Alle anzeigen';

  @override
  String urgentExpirationsCount(int count) {
    return '$count Dringende Artikel';
  }

  @override
  String urgentWarrantiesCount(int count) {
    return '$count Dringende Garantien';
  }

  @override
  String get inventoryTitle => 'Haushaltsinventar';

  @override
  String get expirationTab => 'Ablaufdatum';

  @override
  String get warrantyTab => 'Garantien';

  @override
  String get vaultTab => 'Tresor';

  @override
  String get addExpirationItem => 'Produkt hinzufügen';

  @override
  String get addWarrantyItem => 'Garantie hinzufügen';

  @override
  String get periodicMaintenance => 'Wartungsplan';

  @override
  String get homeGuideWifi => 'WLAN & Hausratgeber';

  @override
  String get digitalVaultSubtitle =>
      'Wichtige Dokumente und Notfallnummern werden verschlüsselt gespeichert.';

  @override
  String get myHomeAndFamily => 'Mein Zuhause & Familie';

  @override
  String get inviteCode => 'Einladungscode';

  @override
  String get familyMembers => 'Familienmitglieder';

  @override
  String get proMember => 'PRO-Mitglied';

  @override
  String get proHouseOwner => 'PRO-Hauseigentümer';

  @override
  String get houseOwner => 'Hauseigentümer';

  @override
  String get legalSection => 'Rechtliches';

  @override
  String get legalAndInfo => 'Rechtliches & Info';

  @override
  String get accountActions => 'Kontoaktionen';

  @override
  String get removeAdsTitle => 'Werbung entfernen';

  @override
  String memberCount(int count) {
    return '$count Mitglied';
  }

  @override
  String get removeAdsSubtitle => 'Dauerhaft werbefrei mit einmaligem Kauf!';

  @override
  String get removeAdsActive => 'Werbefreie Version aktiv ✅';

  @override
  String get specialPriceOffer => 'Sonderpreis! Nur der Preis eines Kaffees.';

  @override
  String get buyNow => 'Jetzt kaufen';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get introPopupTitle => 'Verwenden Sie den Assistenten werbefrei!';

  @override
  String get introPopupDesc =>
      'Entfernen Sie alle Anzeigen dauerhaft für einen einmaligen Preis.';

  @override
  String get skipForNow => 'Vorerst überspringen';

  @override
  String get shoppingListSubtitle =>
      'Verfolgen Sie einfach zu kaufende und gekaufte Artikel.';

  @override
  String get clearCompletedConfirmTitle => 'Gekaufte löschen';

  @override
  String get clearCompletedConfirmDesc =>
      'Alle gekauften Artikel werden aus der Liste entfernt. Fortfahren?';

  @override
  String get emptyShoppingListDesc =>
      'Sie können benötigte Produkte wie Brot, Milch oder Obst im obigen Feld hinzufügen.';

  @override
  String get allPurchasedMessage => 'Alle Artikel gekauft! 🎉';

  @override
  String get delete => 'Löschen';

  @override
  String get accountTypeCash => 'Bargeld';

  @override
  String get accountTypeBank => 'Bank';

  @override
  String get accountTypeCreditCard => 'Kreditkarte';

  @override
  String get accountTypeDebtCredit => 'Konto (Schulden/Guthaben)';

  @override
  String statementCutoff(String day) {
    return 'Abrechnungstag: $day';
  }

  @override
  String get planBudget => 'Budget planen';

  @override
  String get categoryBudgets => 'Kategorie-Budgets';

  @override
  String get noBudgetsSet => 'Sie haben noch kein Budgetziel festgelegt.';

  @override
  String get limitExceeded => 'Limit überschritten!';

  @override
  String get noExpensesPeriod => 'Keine Ausgaben in diesem Zeitraum.';

  @override
  String get expenseHistory => 'Ausgabenverlauf';

  @override
  String get noRecordsFound => 'Keine Einträge gefunden.';

  @override
  String get financeManagementPro => 'Finanzmanagement PRO';

  @override
  String get financeProDesc =>
      'Upgrade auf PRO, um alle Einnahmen, Ausgaben und Konten zu verwalten.';

  @override
  String get expirationTitle => 'MHD & Ablaufdaten';

  @override
  String get freshnessSubtitle =>
      'Verfolgen Sie die Frische der Artikel in Ihrem Inventar.';

  @override
  String get searchProductLocationHint => 'Produktname oder Ort suchen...';

  @override
  String get clearExpired => 'Abgelaufene Artikel löschen';

  @override
  String get noProductsYet => 'Noch keine Produkte';

  @override
  String get noProductsFound => 'Keine Produkte gefunden';

  @override
  String get addFirstProductDesc => 'Klicken Sie auf \"Produkt hinzufügen\".';

  @override
  String get noMatchingProductsDesc =>
      'Keine Produkte entsprechen Ihren Suchkriterien.';

  @override
  String get clearFilters => 'Filter zurücksetzen';

  @override
  String get expirationDateLabel => 'Ablaufdatum';

  @override
  String get trashAndShopping => 'Entsorgen & Zur Einkaufsliste';

  @override
  String get warrantyTrackingTitle => 'Garantieverfolgung';

  @override
  String get warrantySubtitle => 'Verfolgen Sie Garantiezeiten Ihrer Geräte.';

  @override
  String get searchDeviceBrandHint => 'Gerät, Marke oder Geschäft suchen...';

  @override
  String get noWarrantyRecordsYet => 'Noch keine Garantie-Einträge';

  @override
  String get noWarrantyRecordsFound => 'Keine Garantie-Einträge gefunden';

  @override
  String get addFirstWarrantyDesc => 'Klicken Sie auf \"Garantie hinzufügen\".';

  @override
  String get noMatchingWarrantiesDesc =>
      'Keine Einträge entsprechen Ihren Suchkriterien.';

  @override
  String get documentsAndWarranties => 'Dokumente & Garantien';

  @override
  String get serviceAndEmergencyNumbers => 'Service & Notfallnummern';

  @override
  String get uploadDocument => 'Dokument hochladen';

  @override
  String get noDocumentsTitle => 'Keine Dokumente gefunden';

  @override
  String get noDocumentsDesc =>
      'Speichern Sie Dokumente sicher im digitalen Tresor.';

  @override
  String get uploadFirstDocument => 'Erstes Dokument hochladen';

  @override
  String get addNumber => 'Nummer hinzufügen';

  @override
  String get noEmergencyContactsTitle => 'Keine Nummern gespeichert';

  @override
  String get noEmergencyContactsDesc => 'Fügen Sie Notfallkontakte hinzu.';

  @override
  String get addFirstNumber => 'Erste Nummer hinzufügen';

  @override
  String get call => 'Anrufen';

  @override
  String get copy => 'Kopieren';

  @override
  String get newMaintenanceTask => 'Neue Wartungsaufgabe';

  @override
  String get maintenanceTitleLabel => 'Wartungsname';

  @override
  String get maintenanceTitleHint =>
      'z.B. Heizungswartung, Klimaanlagenreinigung';

  @override
  String get descriptionLabel => 'Beschreibung / Details';

  @override
  String get descriptionHint => 'z.B. Filter waschen, Techniker rufen.';

  @override
  String get scheduledDateLabel => 'Geplantes Wartungsdatum';

  @override
  String get saveTask => 'Aufgabe speichern';

  @override
  String get addHomeInfo => '+ Haus-Info hinzufügen';

  @override
  String get noGuideTitle => 'Keine Leitfaden-Info gefunden';

  @override
  String get noGuideDesc =>
      'Teilen Sie WLAN-Passwörter oder Ventil-Standorte mit der Familie.';

  @override
  String get deleteItem => 'Löschen';

  @override
  String get deleteConfirmDesc => 'wird dauerhaft gelöscht.';

  @override
  String get addWarranty => 'Garantie hinzufügen';

  @override
  String get addMaintenanceTask => 'Wartung hinzufügen';

  @override
  String get noMaintenanceTasksTitle => 'Keine Wartungsaufgaben';

  @override
  String get noMaintenanceTasksDesc =>
      'Fügen Sie Wartungsaufgaben hinzu, um rechtzeitig erinnert zu werden.';

  @override
  String get addFirstMaintenanceTask => 'Erste Wartungsaufgabe hinzufügen';

  @override
  String get consentByContinuing => 'Mit der Fortsetzung stimmen Sie unseren ';

  @override
  String get consentTermsAndPrivacy =>
      'Nutzungsbedingungen und Datenschutzbestimmungen';

  @override
  String get consentAcceptSuffix => ' zu.';

  @override
  String get registerConsentPrefix => 'Ich habe die ';

  @override
  String get registerConsentSuffix => ' gelesen und akzeptiere sie.';

  @override
  String get registerConsentError =>
      'Sie müssen den Bedingungen zustimmen, um fortzufahren.';

  @override
  String get addProduct => 'Produkt hinzufügen';

  @override
  String get perMonthSuffix => '/ diesen Monat';

  @override
  String get freeBudgetDescription =>
      'Der verbleibende Betrag des monatlichen Nettoeinkommens nach Abzug der Fixkosten.';

  @override
  String get viewDetails => 'Details anzeigen';

  @override
  String get everythingLooksGood => 'In Ihrem Zuhause sieht alles gut aus.';

  @override
  String get statusAll => 'Alle';

  @override
  String get statusExpiredChip => 'Abgelaufen';

  @override
  String get statusCriticalChip => 'Kritisch';

  @override
  String get statusUpcomingChip => 'Bevorstehend';

  @override
  String get statusSafeChip => 'Sicher';

  @override
  String get statusExpired => 'Abgelaufen';

  @override
  String get statusToday => 'Heute letzter Tag';

  @override
  String daysLeft(int count) {
    return 'Noch $count Tage';
  }

  @override
  String get budgetPlanDescription =>
      'Legen Sie Ihre monatlichen Ausgabenziele fest. Sie können unerwünschte Kategorien leer lassen.';

  @override
  String get categoryDiningOut => 'Auswärts essen';

  @override
  String get categoryKitchenGrocery => 'Küche & Lebensmittel';

  @override
  String get categoryHomeBills => 'Haus & Rechnungen';

  @override
  String get categoryShoppingPersonal => 'Shopping & Persönliches';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryEntertainmentSubscriptions => 'Unterhaltung & Abonnements';

  @override
  String get categoryOther => 'Andere';

  @override
  String get saveBudgets => 'Ziele speichern';

  @override
  String get limitAmountHint => 'Limit (₺)';

  @override
  String get financialStatus => 'Finanzstatus';

  @override
  String get periodYearly => 'Jährlich';

  @override
  String get periodMonthly => 'Monatlich';

  @override
  String get periodWeekly => 'Wöchentlich';

  @override
  String get periodDaily => 'Täglich';

  @override
  String get netStatus => 'Netto-Status';

  @override
  String get yearlyNetStatus => 'Jährlicher Netto-Status';

  @override
  String get monthlyNetStatus => 'Monatlicher Netto-Status';

  @override
  String get weeklyNetStatus => 'Wöchentlicher Netto-Status';

  @override
  String get dailyNetStatus => 'Täglicher Netto-Status';

  @override
  String get upcomingPendingTransactions =>
      'Anstehende ausstehende Transaktionen';

  @override
  String get recentTransactions => 'Letzte Transaktionen';

  @override
  String get futureIncome => 'Zukünftiges Einkommen';

  @override
  String get upcomingPayment => 'Anstehende Zahlung';

  @override
  String get noTransactionsPeriod => 'Keine Transaktionen in diesem Zeitraum.';

  @override
  String get budgetPlanUpdated => 'Budgetziele aktualisiert!';
}
