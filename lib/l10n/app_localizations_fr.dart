// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Assistant Maison';

  @override
  String get languageSelection => 'Choix de la Langue';

  @override
  String get languageSelectionSubtitle => 'Changer la langue de l\'application';

  @override
  String get currencySelection => 'Devise';

  @override
  String get currencySelectionSubtitle =>
      'Sélectionner la devise pour les écrans de budget et de finances';

  @override
  String get preferencesAndSettings => 'Préférences et Paramètres';

  @override
  String get notificationSettings => 'Paramètres de Notification';

  @override
  String get notificationSettingsSubtitle => 'Gérer les notifications système';

  @override
  String get about => 'À propos';

  @override
  String get aboutSubtitle => 'Assistant Maison v1.1.0 (Firebase Activé)';

  @override
  String get developerLabel => 'Développeur : Samed Kalaycı';

  @override
  String get aboutDescription =>
      'Description : Organisation intelligente du foyer.';

  @override
  String get allRightsReserved =>
      '© 2026 Assistant Maison. Tous droits réservés.';

  @override
  String get privacyPolicy => 'Politique de Confidentialité & Conditions';

  @override
  String get privacyPolicySubtitle => 'Consulter les informations légales';

  @override
  String get signOut => 'Se Déconnecter';

  @override
  String get signOutSubtitle => 'Se déconnecter en toute sécurité';

  @override
  String get deleteAccount => 'Supprimer le Compte';

  @override
  String get deleteAccountSubtitle =>
      'Supprimer définitivement le compte et les données';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get selectLanguage => 'Sélectionner la Langue';

  @override
  String get turkish => 'Turc';

  @override
  String get english => 'Anglais';

  @override
  String get german => 'Allemand';

  @override
  String get spanish => 'Espagnol';

  @override
  String get french => 'Français';

  @override
  String get azerbaijani => 'Azerbaïdjanais';

  @override
  String get greek => 'Grec';

  @override
  String get portuguese => 'Portugais';

  @override
  String get navHome => 'Accueil';

  @override
  String get navInventory => 'Inventaire';

  @override
  String get navShopping => 'Achats';

  @override
  String get navFinance => 'Finances';

  @override
  String get navProfile => 'Profil';

  @override
  String get shoppingListTitle => 'Liste de Courses';

  @override
  String get toBuyTab => 'À Acheter';

  @override
  String get purchasedTab => 'Achetés';

  @override
  String get clearCompleted => 'Effacer';

  @override
  String get newProductHint => 'Ajouter un article...';

  @override
  String itemsCount(int count) {
    return '$count Articles';
  }

  @override
  String get addShoppingItemTitle => 'Ajouter un Article à la Liste';

  @override
  String get productNameLabel => 'Nom de l\'Article';

  @override
  String get productNameHint => 'Ex : Lait, Pain, Œufs...';

  @override
  String get addToListBtn => 'Ajouter à la Liste';

  @override
  String itemAddedToast(String name) {
    return '\"$name\" ajouté à la liste ! 🛒';
  }

  @override
  String get emptyShoppingList => 'Votre liste de courses est vide.';

  @override
  String get financeOverviewTab => 'Aperçu';

  @override
  String get householdWalletTab => 'Portefeuille du Foyer';

  @override
  String get accountsTab => 'Comptes';

  @override
  String get viewSummary => 'Voir le Résumé';

  @override
  String get incomeExpenseBalance => 'Balance Revenus/Dépenses';

  @override
  String get totalIncome => 'Revenus Totaux';

  @override
  String get totalExpense => 'Dépenses Totales';

  @override
  String get personalExpenses => 'Dépenses Personnelles';

  @override
  String get noAccountYet => 'Aucun compte ajouté pour l\'instant.';

  @override
  String get paymentSchedule => 'Calendrier de Paiement';

  @override
  String get realizedPayments => 'Effectués';

  @override
  String get accountScheduleHeader => 'Compte / Calendrier';

  @override
  String get monthlyFreeBudget => 'Budget Libre Restant';

  @override
  String get quickAddExpense => 'Ajout Rapide de Dépense';

  @override
  String greetingUser(String name) {
    return 'Bonjour, $name';
  }

  @override
  String get quickAdd => 'Ajout Rapide';

  @override
  String get expiringSoonTitle => 'Expirations Proches';

  @override
  String get warrantiesExpiringTitle => 'Garanties Proches de l\'Expiration';

  @override
  String get shoppingSummaryTitle => 'Résumé des Courses';

  @override
  String get viewAll => 'Tout Voir';

  @override
  String urgentExpirationsCount(int count) {
    return '$count Articles Urgents';
  }

  @override
  String urgentWarrantiesCount(int count) {
    return '$count Garanties Urgentes';
  }

  @override
  String get inventoryTitle => 'Inventaire du Foyer';

  @override
  String get expirationTab => 'Expiration';

  @override
  String get warrantyTab => 'Garanties';

  @override
  String get vaultTab => 'Coffre-Fort';

  @override
  String get addExpirationItem => 'Ajouter un Article';

  @override
  String get addWarrantyItem => 'Ajouter une Garantie';

  @override
  String get periodicMaintenance => 'Calendrier d\'Entretien';

  @override
  String get homeGuideWifi => 'Guide Maison & Wi-Fi';

  @override
  String get digitalVaultSubtitle =>
      'Les documents essentiels et numéros d\'urgence sont chiffrés et sécurisés.';

  @override
  String get myHomeAndFamily => 'Ma Maison & Gestion Familiale';

  @override
  String get inviteCode => 'Code d\'Invitation';

  @override
  String get familyMembers => 'Membres de la Famille';

  @override
  String get proMember => 'Membre PRO';

  @override
  String get proHouseOwner => 'Propriétaire PRO';

  @override
  String get houseOwner => 'Propriétaire de la Maison';

  @override
  String get legalSection => 'Mentions Légales';

  @override
  String get legalAndInfo => 'Légal & Info';

  @override
  String get accountActions => 'Actions du Compte';

  @override
  String get removeAdsTitle => 'Supprimer les Publicités';

  @override
  String memberCount(int count) {
    return '$count Membre';
  }

  @override
  String get removeAdsSubtitle =>
      'Sans publicité pour toujours avec un achat unique !';

  @override
  String get removeAdsActive => 'Version Sans Publicité Active ✅';

  @override
  String get specialPriceOffer => 'Offre Spéciale ! Pour le prix d\'un café.';

  @override
  String get buyNow => 'Acheter Maintenant';

  @override
  String get restorePurchases => 'Restaurer les Achats';

  @override
  String get introPopupTitle => 'Utilisez l\'App Sans Pub !';

  @override
  String get introPopupDesc =>
      'Supprimez définitivement toutes les publicités pour un petit prix unique.';

  @override
  String get skipForNow => 'Passer pour l\'instant';

  @override
  String get shoppingListSubtitle =>
      'Suivez facilement les articles à acheter et achetés.';

  @override
  String get clearCompletedConfirmTitle => 'Effacer les achetés';

  @override
  String get clearCompletedConfirmDesc =>
      'Tous les articles achetés seront retirés de la liste. Continuer?';

  @override
  String get emptyShoppingListDesc =>
      'Vous pouvez ajouter des produits dont vous avez besoin comme le pain, le lait ou les fruits ci-dessus.';

  @override
  String get allPurchasedMessage => 'Tous les articles sont achetés ! 🎉';

  @override
  String get delete => 'Supprimer';

  @override
  String get accountTypeCash => 'Espèces';

  @override
  String get accountTypeBank => 'Banque';

  @override
  String get accountTypeCreditCard => 'Carte de Crédit';

  @override
  String get accountTypeDebtCredit => 'Compte (Dette/Crédit)';

  @override
  String statementCutoff(String day) {
    return 'Date de relevé : $day';
  }

  @override
  String get planBudget => 'Planifier le Budget';

  @override
  String get categoryBudgets => 'Budgets par Catégorie';

  @override
  String get noBudgetsSet => 'Vous n\'avez pas encore défini de budget.';

  @override
  String get limitExceeded => 'Limite dépassée !';

  @override
  String get noExpensesPeriod => 'Aucune dépense pour cette période.';

  @override
  String get expenseHistory => 'Historique des Dépenses';

  @override
  String get noRecordsFound => 'Aucun enregistrement trouvé.';

  @override
  String get financeManagementPro => 'Gestion Financière PRO';

  @override
  String get financeProDesc =>
      'Passez à PRO pour contrôler les revenus, dépenses et comptes bancaires.';

  @override
  String get expirationTitle => 'Dates de Péremption';

  @override
  String get freshnessSubtitle =>
      'Suivez la fraîcheur des articles de votre inventaire.';

  @override
  String get searchProductLocationHint =>
      'Rechercher un produit ou un emplacement...';

  @override
  String get clearExpired => 'Effacer les Articles Périmés';

  @override
  String get noProductsYet => 'Pas encore de produits';

  @override
  String get noProductsFound => 'Aucun produit trouvé';

  @override
  String get addFirstProductDesc => 'Appuyez sur \"Ajouter un produit\".';

  @override
  String get noMatchingProductsDesc =>
      'Aucun produit ne correspond à votre recherche.';

  @override
  String get clearFilters => 'Effacer les Filtres';

  @override
  String get expirationDateLabel => 'Date de Péremption';

  @override
  String get trashAndShopping => 'Jeter & Ajouter aux Achats';

  @override
  String get warrantyTrackingTitle => 'Suivi des Garanties';

  @override
  String get warrantySubtitle =>
      'Suivez les périodes de garantie de vos appareils.';

  @override
  String get searchDeviceBrandHint =>
      'Rechercher appareil, marque ou magasin...';

  @override
  String get noWarrantyRecordsYet => 'Pas encore de garanties';

  @override
  String get noWarrantyRecordsFound => 'Aucune garantie trouvée';

  @override
  String get addFirstWarrantyDesc => 'Appuyez sur \"Ajouter une garantie\".';

  @override
  String get noMatchingWarrantiesDesc => 'Aucun enregistrement ne correspond.';

  @override
  String get documentsAndWarranties => 'Documents & Garanties';

  @override
  String get serviceAndEmergencyNumbers => 'Services & Numéros d\'Urgence';

  @override
  String get uploadDocument => 'Téléverser un Document';

  @override
  String get noDocumentsTitle => 'Aucun document trouvé';

  @override
  String get noDocumentsDesc =>
      'Conservez vos actes et polices en toute sécurité.';

  @override
  String get uploadFirstDocument => 'Téléverser le Premier Document';

  @override
  String get addNumber => 'Ajouter un Numéro';

  @override
  String get noEmergencyContactsTitle => 'Aucun numéro enregistré';

  @override
  String get noEmergencyContactsDesc =>
      'Ajoutez des contacts d\'urgence pour appeler en un clic.';

  @override
  String get addFirstNumber => 'Ajouter le Premier Numéro';

  @override
  String get call => 'Appeler';

  @override
  String get copy => 'Copier';

  @override
  String get newMaintenanceTask => 'Nouvelle Tâche d\'Entretien';

  @override
  String get maintenanceTitleLabel => 'Nom de l\'Entretien';

  @override
  String get maintenanceTitleHint => 'Ex : Entretien chaudière';

  @override
  String get descriptionLabel => 'Description / Détails';

  @override
  String get descriptionHint =>
      'Ex : Laver les filtres, appeler le technicien.';

  @override
  String get scheduledDateLabel => 'Date d\'Entretien Prévue';

  @override
  String get saveTask => 'Enregistrer la Tâche';

  @override
  String get addHomeInfo => '+ Ajouter Info Maison';

  @override
  String get noGuideTitle => 'Aucune Info de Guide';

  @override
  String get noGuideDesc => 'Partagez les mots de passe Wi-Fi et infos maison.';

  @override
  String get deleteItem => 'Supprimer';

  @override
  String get deleteConfirmDesc => 'sera supprimé définitivement.';

  @override
  String get addWarranty => 'Ajouter une Garantie';

  @override
  String get addMaintenanceTask => 'Ajouter un Entretien';

  @override
  String get noMaintenanceTasksTitle => 'Aucune Tâche d\'Entretien';

  @override
  String get noMaintenanceTasksDesc =>
      'Ajoutez des entretiens pour recevoir des rappels à temps.';

  @override
  String get addFirstMaintenanceTask =>
      'Ajouter la Première Tâche d\'Entretien';

  @override
  String get consentByContinuing => 'En continuant, vous acceptez nos ';

  @override
  String get consentTermsAndPrivacy =>
      'Conditions d\'utilisation et Politique de confidentialité';

  @override
  String get consentAcceptSuffix => '.';

  @override
  String get registerConsentPrefix => 'J\'ai lu et j\'accepte les ';

  @override
  String get registerConsentSuffix => '.';

  @override
  String get registerConsentError =>
      'Vous devez accepter les conditions pour continuer.';

  @override
  String get addProduct => 'Ajouter un Produit';

  @override
  String get perMonthSuffix => '/ ce mois-ci';

  @override
  String get freeBudgetDescription =>
      'Le montant restant du revenu net mensuel après déduction des dépenses fixes.';

  @override
  String get viewDetails => 'Voir les détails';

  @override
  String get everythingLooksGood => 'Tout semble aller bien chez vous.';

  @override
  String get statusAll => 'Tout';

  @override
  String get statusExpiredChip => 'Expirés';

  @override
  String get statusCriticalChip => 'Critiques';

  @override
  String get statusUpcomingChip => 'À venir';

  @override
  String get statusSafeChip => 'Sûrs';

  @override
  String get statusExpired => 'Expiré';

  @override
  String get statusToday => 'Dernier jour aujourd\'hui';

  @override
  String daysLeft(int count) {
    return '$count Jours restants';
  }

  @override
  String get budgetPlanDescription =>
      'Définissez vos objectifs de dépenses mensuelles. Vous pouvez laisser vides les catégories indésirables.';

  @override
  String get categoryDiningOut => 'Dîner dehors';

  @override
  String get categoryKitchenGrocery => 'Cuisine & Épicerie';

  @override
  String get categoryHomeBills => 'Maison & Factures';

  @override
  String get categoryShoppingPersonal => 'Shopping & Personnel';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryEntertainmentSubscriptions =>
      'Divertissement & Abonnements';

  @override
  String get categoryOther => 'Autre';

  @override
  String get saveBudgets => 'Enregistrer les objectifs';

  @override
  String get limitAmountHint => 'Limite (₺)';

  @override
  String get financialStatus => 'État financier';

  @override
  String get periodYearly => 'Annuel';

  @override
  String get periodMonthly => 'Mensuel';

  @override
  String get periodWeekly => 'Hebdomadaire';

  @override
  String get periodDaily => 'Quotidien';

  @override
  String get netStatus => 'Statut net';

  @override
  String get yearlyNetStatus => 'Statut net annuel';

  @override
  String get monthlyNetStatus => 'Statut net mensuel';

  @override
  String get weeklyNetStatus => 'Statut net hebdomadaire';

  @override
  String get dailyNetStatus => 'Statut net quotidien';

  @override
  String get upcomingPendingTransactions => 'Transactions en attente à venir';

  @override
  String get recentTransactions => 'Transactions récentes';

  @override
  String get futureIncome => 'Revenu futur';

  @override
  String get upcomingPayment => 'Paiement à venir';

  @override
  String get noTransactionsPeriod =>
      'Aucune transaction au cours de cette période.';

  @override
  String get budgetPlanUpdated => 'Objectifs budgétaires mis à jour !';

  @override
  String get linkAccountTitle => 'Lier Votre Compte';

  @override
  String get guestModeDesc =>
      'Vous êtes en mode invité. Rendez votre compte permanent sans perdre vos données.';

  @override
  String get guestModeBottomSheetDesc =>
      'Vous êtes en mode invité. Sélectionnez une méthode de connexion pour créer un compte permanent et ne pas perdre vos données.';

  @override
  String get connectionOptions => 'Options de Connexion';

  @override
  String get userRoleLabel => 'Utilisateur';

  @override
  String get anonymousSession => 'Session Anonyme';

  @override
  String get notMemberOfFamilyYet => 'Pas encore connecté à une famille';

  @override
  String get notMemberOfHomeYet => 'Pas encore connecté à un foyer';

  @override
  String get noHomeSyncDesc =>
      'Créez un foyer ou rejoignez-en un existant avec un code d\'invitation pour synchroniser vos articles et vos listes de courses.';

  @override
  String get createHome => 'Créer un Foyer';

  @override
  String get enterCode => 'Saisir le Code';

  @override
  String get createOrJoinHome => 'Créer ou Rejoindre un Foyer';

  @override
  String get createNewHomeTitle => 'Créer un Nouveau Foyer / Famille';

  @override
  String get createNewHomeDesc =>
      'Nommez votre foyer. Vous pouvez le créer gratuitement en regardant 1 courte publicité.';

  @override
  String get homeNameLabel => 'Nom du Foyer / Famille';

  @override
  String get homeNameHint => 'ex: Famille Dupont';

  @override
  String get homeNameRequired => 'Le nom du foyer est obligatoire.';

  @override
  String get roleInHomeLabel => 'Votre Rôle dans le Foyer';

  @override
  String get roleHouseOwner => '👑 Chef de Famille';

  @override
  String get roleMother => '👨‍👩‍👧 Mère';

  @override
  String get roleFather => '👨‍👩‍👦 Père';

  @override
  String get roleChild => '👶 Enfant';

  @override
  String get roleRoommate => '🏠 Colocataire';

  @override
  String get roleOtherResident => '🐾 Autre / Résident';

  @override
  String get noUpcomingExpirationsMessage =>
      'Aucun produit avec date de péremption proche. 👍';

  @override
  String get expirationProductItem => 'Produit avec Date de Péremption';

  @override
  String get expirationProductSubtitle =>
      'Suivre aliments/médicaments dans le frigo ou le garde-manger';

  @override
  String get warrantyDocumentItem => 'Ajouter Document / Fichier de Garantie';

  @override
  String get warrantyDocumentSubtitle =>
      'Documents de garantie d\'un produit et fichiers d\'électroménager';

  @override
  String get enterQuickExpense => 'Ajout Rapide de Dépense';

  @override
  String get amountLabel => 'Montant';

  @override
  String get amountRequired => 'Veuillez saisir un montant';

  @override
  String get validAmountRequired => 'Veuillez saisir un montant valide';

  @override
  String get shortDescriptionLabel => 'Courte Description';

  @override
  String get shortDescriptionHint => 'ex: Café, Courses, etc.';

  @override
  String get descriptionRequired => 'Saisissez une description';

  @override
  String get categoryLabel => 'Catégorie';

  @override
  String get addToPaymentSchedule => 'Ajouter au Calendrier de Paiement';

  @override
  String get editPaymentSchedule => 'Modifier le Calendrier de Paiement';

  @override
  String get billExpenseOption => 'Facture / Dépense';

  @override
  String get incomeCollectionOption => 'Revenu / Recouvrement';

  @override
  String get scheduleTitleLabel => 'Titre (ex: Facture d\'Électricité, Loyer)';

  @override
  String get titleRequired => 'Veuillez saisir un titre';

  @override
  String get dateLabel => 'Date';

  @override
  String get bankAccountNameOptional =>
      'Banque Associée / Nom du Compte (Optionnel)';

  @override
  String get markAsPaid => 'Marquer comme Payé';

  @override
  String get repeatMonthly => 'Répéter Mensuellement';

  @override
  String get oneTimePaymentNotice => 'Paiement unique.';

  @override
  String get addToScheduleBtn => 'Ajouter au Calendrier';

  @override
  String get addNewDocumentTitle => 'Ajouter un Nouveau Document / Fichier';

  @override
  String get editDocumentTitle => 'Modifier le Document';

  @override
  String get documentTitleLabel => 'Titre du Document';

  @override
  String get documentTitleHint => 'ex: Acte de Propriété, Contrat de Location';

  @override
  String get notesDescriptionLabel => 'Description / Notes';

  @override
  String get notesDescriptionHint =>
      'ex: Rangé dans le 2ème tiroir du classeur.';

  @override
  String get addFileImage => 'Ajouter un Fichier / Image';

  @override
  String get selectPhotoDocument => 'Sélectionner Photo / Document';

  @override
  String get saveDocumentBtn => 'Enregistrer le Document';

  @override
  String get addNewContactTitle => 'Ajouter un Nouveau Contact / Numéro Utile';

  @override
  String get editContactTitle => 'Modifier le Numéro';

  @override
  String get namePersonLabel => 'Nom / Personne de Contact';

  @override
  String get namePersonHint => 'ex: Plombier Jean, Syndic d\'Immeuble';

  @override
  String get titleCategoryLabel => 'Titre / Catégorie';

  @override
  String get titleCategoryHint => 'ex: Plomberie, Électricité, Serrurier';

  @override
  String get phoneNumberLabel => 'Numéro de Téléphone';

  @override
  String get phoneNumberHint => 'ex: +33 6 12 34 56 78';

  @override
  String get saveNumberBtn => 'Enregistrer le Numéro';

  @override
  String get summary => 'Résumé';

  @override
  String get creditCardExpenses => 'Dépenses par Carte de Crédit';

  @override
  String get cashExpenses => 'Dépenses en Espèces';

  @override
  String get quickExpenses => 'Dépenses Rapides';

  @override
  String get pleaseSelectDocumentOrPhoto =>
      'Veuillez sélectionner un document ou une photo.';

  @override
  String get editWarranty => 'Modifier l\'Enregistrement de Garantie';

  @override
  String get productDeviceName => 'Nom du Produit / Appareil';

  @override
  String get productDeviceNameHint => 'ex: Réfrigérateur, Ordinateur...';

  @override
  String get brand => 'Marque';

  @override
  String get brandHint => 'ex: Samsung, Apple...';

  @override
  String get store => 'Magasin d\'Achat';

  @override
  String get storeHint => 'ex: Fnac, Amazon...';

  @override
  String get purchaseDate => 'Date d\'Achat';

  @override
  String get warrantyEndDate => 'Date de Fin de Garantie';

  @override
  String get hasInvoice => 'Facture / Document Disponible';

  @override
  String get icon => 'Icône';

  @override
  String get optionalNotes => 'Remarques (Optionnel)';

  @override
  String get optionalNotesHint => 'Informations supplémentaires...';

  @override
  String get invoiceNumberOptional => 'Numéro de Facture (Optionnel)';

  @override
  String get invoiceNumberHint => 'ex: AMZ-2024-12345';

  @override
  String get changeInvoiceFile => 'Changer le Fichier de Facture';

  @override
  String get uploadInvoiceFile => '📸 Télécharger l\'Image de Facture / PDF';

  @override
  String get saveChanges => 'Enregistrer les Modifications';

  @override
  String get productNameRequired => 'Le nom du produit est requis.';

  @override
  String get brandRequired => 'La marque est requise.';

  @override
  String get storeRequired => 'Le nom du magasin est requis.';

  @override
  String get selectPurchaseDateWarning =>
      'Veuillez sélectionner la date d\'achat.';

  @override
  String get selectWarrantyEndDateWarning =>
      'Veuillez sélectionner la date de fin de garantie.';

  @override
  String get selectDateHint => 'Sélectionner la Date';

  @override
  String get addNewHomeInfo =>
      'Ajouter de Nouvelles Informations sur le Logement';

  @override
  String get editHomeInfo => 'Modifier les Informations sur le Logement';

  @override
  String get categorySelection => 'Sélection de Catégorie';

  @override
  String get guideTitle => 'Titre du Guide';

  @override
  String get guideTitleHint =>
      'ex: Abonnement Gaz, Vanne d\'Eau, Mot de Passe Wi-Fi';

  @override
  String get importantValueLabel =>
      'Information Importante / Valeur (Cliquer pour Copier)';

  @override
  String get importantValueHint => 'ex: N° Ababonné: 123456, Mot de passe: xyz';

  @override
  String get detailedNotesLabel => 'Description / Note Détaillée';

  @override
  String get detailedNotesHint =>
      'ex: Le compteur est dans le placard du balcon à droite.';

  @override
  String get updateInfoBtn => 'Mettre à Jour les Informations';

  @override
  String get categoryWifi => '📶 Wi-Fi & Réseau';

  @override
  String get categoryInstallation => '⚡ Installation & Services';

  @override
  String get categoryPasswords => '🔑 Mots de Passe & Codes';

  @override
  String get categoryGeneralHome => 'ℹ️ Infos Générales du Logement';

  @override
  String get themeSelection => 'Sélection du Thème';

  @override
  String get themeSelectionSubtitle =>
      'Choisissez l\'apparence de l\'application (Système / Clair / Sombre)';

  @override
  String get themeSystem => 'Système (Par défaut)';

  @override
  String get themeLight => 'Thème Clair';

  @override
  String get themeDark => 'Thème Sombre';

  @override
  String get editHomeNameTitle => 'Modifier le Nom du Foyer';

  @override
  String get editHomeNameLabel => 'Nom du Foyer';

  @override
  String get editHomeNameHint => 'ex: Maison Dupont';

  @override
  String get homeNameUpdatedToast => 'Nom du foyer mis à jour avec succès ! 🏠';

  @override
  String get customRoleOption => '✏️ Rôle Personnalisé...';

  @override
  String get customRoleHint => 'Saisissez le rôle...';

  @override
  String get aboutDeveloper => 'Développeur : Samed Kalaycı';

  @override
  String get aboutCopyright => '© 2026 Ev Asistanı. Tous droits réservés.';

  @override
  String get addShoppingItemSub =>
      'Épicerie, nettoyage et besoins ménagers manquants';

  @override
  String get guestLoginSuccess => 'Session invité démarrée. 👋';

  @override
  String guestLoginFailed(String error) {
    return 'Connexion en tant qu\'invité échouée : $error';
  }
}
