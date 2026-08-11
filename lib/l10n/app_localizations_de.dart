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
  String get currencySelection => 'Währung';

  @override
  String get currencySelectionSubtitle =>
      'Währung für Budget- und Finanzbildschirme auswählen';

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
      'Beschreibung: Intelligente Haushaltsorganisation.';

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

  @override
  String get linkAccountTitle => 'Konto verknüpfen';

  @override
  String get guestModeDesc =>
      'Sie befinden sich im Gastmodus. Machen Sie Ihr Konto dauerhaft, ohne Daten zu verlieren.';

  @override
  String get guestModeBottomSheetDesc =>
      'Sie befinden sich im Gastmodus. Wählen Sie eine Anmeldemethode, um ein dauerhaftes Konto zu erstellen.';

  @override
  String get connectionOptions => 'Anmeldeoptionen';

  @override
  String get userRoleLabel => 'Benutzer';

  @override
  String get anonymousSession => 'Anonyme Sitzung';

  @override
  String get notMemberOfFamilyYet => 'Noch nicht mit einer Familie verbunden';

  @override
  String get notMemberOfHomeYet => 'Noch nicht mit einem Zuhause verbunden';

  @override
  String get noHomeSyncDesc =>
      'Erstellen Sie ein Zuhause oder treten Sie einem bestehenden bei, um Artikel und Einkaufslisten zu synchronisieren.';

  @override
  String get createHome => 'Zuhause erstellen';

  @override
  String get enterCode => 'Code eingeben';

  @override
  String get createOrJoinHome => 'Zuhause erstellen oder beitreten';

  @override
  String get createNewHomeTitle => 'Neues Zuhause / Familie erstellen';

  @override
  String get createNewHomeDesc =>
      'Benennen Sie Ihr Zuhause. Sie können Ihr Zuhause kostenlos erstellen, indem Sie 1 kurze Werbung ansehen.';

  @override
  String get homeNameLabel => 'Name des Zuhauses / der Familie';

  @override
  String get homeNameHint => 'z.B. Familie Müller';

  @override
  String get homeNameRequired => 'Hausname ist erforderlich.';

  @override
  String get roleInHomeLabel => 'Ihre Rolle im Hause';

  @override
  String get roleHouseOwner => '👑 Hauseigentümer';

  @override
  String get roleMother => '👨‍👩‍👧 Mutter';

  @override
  String get roleFather => '👨‍👩‍👦 Vater';

  @override
  String get roleChild => '👶 Kind';

  @override
  String get roleRoommate => '🏠 Mitbewohner';

  @override
  String get roleOtherResident => '🐾 Sonstiger / Bewohner';

  @override
  String get noUpcomingExpirationsMessage =>
      'Keine Produkte mit bevorstehendem Ablaufdatum. 👍';

  @override
  String get expirationProductItem => 'Produkt mit Ablaufdatum';

  @override
  String get expirationProductSubtitle =>
      'Lebensmittel/Medikamente im Kühlschrank oder Vorratsschrank verfolgen';

  @override
  String get warrantyDocumentItem => 'Garantiedokument / Datei hinzufügen';

  @override
  String get warrantyDocumentSubtitle =>
      'Produktgarantiedokumente und Gerätedateien';

  @override
  String get enterQuickExpense => 'Schnellausgabe eingeben';

  @override
  String get amountLabel => 'Betrag';

  @override
  String get amountRequired => 'Bitte Betrag eingeben';

  @override
  String get validAmountRequired => 'Bitte gültigen Betrag eingeben';

  @override
  String get shortDescriptionLabel => 'Kurzbeschreibung';

  @override
  String get shortDescriptionHint => 'z.B. Kaffee, Lebensmittel etc.';

  @override
  String get descriptionRequired => 'Beschreibung eingeben';

  @override
  String get categoryLabel => 'Kategorie';

  @override
  String get addToPaymentSchedule => 'Zum Zahlungsplan hinzufügen';

  @override
  String get editPaymentSchedule => 'Zahlungsplan bearbeiten';

  @override
  String get billExpenseOption => 'Rechnung / Ausgabe';

  @override
  String get incomeCollectionOption => 'Einnahme / Inkasso';

  @override
  String get scheduleTitleLabel => 'Titel (z.B. Stromrechnung, Miete)';

  @override
  String get titleRequired => 'Bitte Titel eingeben';

  @override
  String get dateLabel => 'Datum';

  @override
  String get bankAccountNameOptional =>
      'Zugehöriges Bank- / Kontoname (Optional)';

  @override
  String get markAsPaid => 'Als bezahlt markieren';

  @override
  String get repeatMonthly => 'Monatlich wiederholen';

  @override
  String get oneTimePaymentNotice => 'Einmalige Zahlung.';

  @override
  String get addToScheduleBtn => 'Zum Zeitplan hinzufügen';

  @override
  String get addNewDocumentTitle => 'Neues Dokument / Datei hinzufügen';

  @override
  String get editDocumentTitle => 'Dokument bearbeiten';

  @override
  String get documentTitleLabel => 'Dokumententitel';

  @override
  String get documentTitleHint => 'z.B. Grundbuchauszug, Mietvertrag';

  @override
  String get notesDescriptionLabel => 'Beschreibung / Notizen';

  @override
  String get notesDescriptionHint =>
      'z.B. Im 2. Schubfach des Akten-Schranks aufbewahrt.';

  @override
  String get addFileImage => 'Datei / Bild hinzufügen';

  @override
  String get selectPhotoDocument => 'Foto / Dokument auswählen';

  @override
  String get saveDocumentBtn => 'Dokument speichern';

  @override
  String get addNewContactTitle => 'Neuen Kontakt / Servicenummer hinzufügen';

  @override
  String get editContactTitle => 'Nummer bearbeiten';

  @override
  String get namePersonLabel => 'Name / Kontaktperson';

  @override
  String get namePersonHint => 'z.B. Klempner Hans, Hausverwaltung';

  @override
  String get titleCategoryLabel => 'Titel / Kategorie';

  @override
  String get titleCategoryHint => 'z.B. Sanitär, Elektrik, Schlüsseldienst';

  @override
  String get phoneNumberLabel => 'Telefonnummer';

  @override
  String get phoneNumberHint => 'z.B. +49 151 12345678';

  @override
  String get saveNumberBtn => 'Nummer speichern';

  @override
  String get summary => 'Zusammenfassung';

  @override
  String get creditCardExpenses => 'Kreditkartenausgaben';

  @override
  String get cashExpenses => 'Bargeldausgaben';

  @override
  String get quickExpenses => 'Schnellausgaben';

  @override
  String get pleaseSelectDocumentOrPhoto =>
      'Bitte wählen Sie ein Dokument oder Foto aus.';

  @override
  String get editWarranty => 'Garantieeintrag bearbeiten';

  @override
  String get productDeviceName => 'Produkt- / Gerätename';

  @override
  String get productDeviceNameHint => 'z.B. Kühlschrank, Laptop...';

  @override
  String get brand => 'Marke';

  @override
  String get brandHint => 'z.B. Samsung, Apple...';

  @override
  String get store => 'Gekauft bei Store';

  @override
  String get storeHint => 'z.B. MediaMarkt, Amazon...';

  @override
  String get purchaseDate => 'Kaufdatum';

  @override
  String get warrantyEndDate => 'Garantieablaufdatum';

  @override
  String get hasInvoice => 'Rechnung / Dokument vorhanden';

  @override
  String get icon => 'Symbol';

  @override
  String get optionalNotes => 'Notizen (Optional)';

  @override
  String get optionalNotesHint => 'Zusätzliche Infos...';

  @override
  String get invoiceNumberOptional => 'Rechnungsnummer (Optional)';

  @override
  String get invoiceNumberHint => 'z.B. AMZ-2024-12345';

  @override
  String get changeInvoiceFile => 'Rechnungsdatei ändern';

  @override
  String get uploadInvoiceFile => '📸 Rechnungsbild / PDF hochladen';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get productNameRequired => 'Produktname ist erforderlich.';

  @override
  String get brandRequired => 'Marke ist erforderlich.';

  @override
  String get storeRequired => 'Geschäftsname ist erforderlich.';

  @override
  String get selectPurchaseDateWarning => 'Bitte Kaufdatum auswählen.';

  @override
  String get selectWarrantyEndDateWarning =>
      'Bitte Garantieablaufdatum auswählen.';

  @override
  String get selectDateHint => 'Datum auswählen';

  @override
  String get addNewHomeInfo => 'Neue Hausinfo hinzufügen';

  @override
  String get editHomeInfo => 'Hausinfo bearbeiten';

  @override
  String get categorySelection => 'Kategorieauswahl';

  @override
  String get guideTitle => 'Titel der Anleitung';

  @override
  String get guideTitleHint => 'z.B. Gasvertrag, Wasserventil, WLAN-Passwort';

  @override
  String get importantValueLabel => 'Wichtige Info / Wert (Klick zum Kopieren)';

  @override
  String get importantValueHint => 'z.B. Abo-Nr.: 123456, Passwort: xyz';

  @override
  String get detailedNotesLabel => 'Beschreibung / Detaillierte Notiz';

  @override
  String get detailedNotesHint =>
      'z.B. Zähler befindet sich im Balkonschrank rechts.';

  @override
  String get updateInfoBtn => 'Info aktualisieren';

  @override
  String get categoryWifi => '📶 WLAN & Netzwerk';

  @override
  String get categoryInstallation => '⚡ Installation & Abos';

  @override
  String get categoryPasswords => '🔑 Passwörter & Codes';

  @override
  String get categoryGeneralHome => 'ℹ️ Allgemeine Hausinfo';

  @override
  String get themeSelection => 'Themenauswahl';

  @override
  String get themeSelectionSubtitle =>
      'Erscheinungsbild wählen (System / Hell / Dunkel)';

  @override
  String get themeSystem => 'System (Standard)';

  @override
  String get themeLight => 'Helles Thema';

  @override
  String get themeDark => 'Dunkles Thema';

  @override
  String get editHomeNameTitle => 'Hausnamen bearbeiten';

  @override
  String get editHomeNameLabel => 'Hausname';

  @override
  String get editHomeNameHint => 'z. B. Familie Müller, Haus 4';

  @override
  String get homeNameUpdatedToast => 'Hausname erfolgreich aktualisiert! 🏠';

  @override
  String get customRoleOption => '✏️ Eigene Rolle...';

  @override
  String get customRoleHint => 'Rollenname eingeben...';

  @override
  String get aboutDeveloper => 'Entwickler: Samed Kalaycı';

  @override
  String get aboutCopyright => '© 2026 Ev Asistanı. Alle Rechte vorbehalten.';

  @override
  String get addShoppingItemSub =>
      'Fehlende Lebensmittel, Reinigung und Haushaltsbedarf';

  @override
  String get guestLoginSuccess => 'Gastsitzung gestartet. 👋';

  @override
  String guestLoginFailed(String error) {
    return 'Gastanmeldung fehlgeschlagen: $error';
  }
}
