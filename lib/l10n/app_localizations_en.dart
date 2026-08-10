// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Home Assistant';

  @override
  String get languageSelection => 'Language Selection';

  @override
  String get languageSelectionSubtitle =>
      'Change app language (Turkish / English)';

  @override
  String get preferencesAndSettings => 'Preferences & Settings';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get notificationSettingsSubtitle =>
      'Manage system notification preferences';

  @override
  String get about => 'About';

  @override
  String get aboutSubtitle => 'Home Assistant v1.1.0 (Firebase Enabled)';

  @override
  String get developerLabel => 'Developer: Samed Kalaycı';

  @override
  String get aboutDescription =>
      'Description: Household organization and shared list management app.';

  @override
  String get allRightsReserved => '© 2026 Home Assistant. All rights reserved.';

  @override
  String get privacyPolicy => 'Privacy Policy & Terms of Service';

  @override
  String get privacyPolicySubtitle =>
      'Review legal information and usage conditions';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutSubtitle => 'Safely sign out of your account';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountSubtitle =>
      'Permanently delete your account and data';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get confirm => 'Confirm';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get turkish => 'Turkish';

  @override
  String get english => 'English';

  @override
  String get german => 'German';

  @override
  String get spanish => 'Spanish';

  @override
  String get french => 'French';

  @override
  String get azerbaijani => 'Azerbaijani';

  @override
  String get greek => 'Greek';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get navHome => 'Home';

  @override
  String get navInventory => 'Inventory';

  @override
  String get navShopping => 'Shopping';

  @override
  String get navFinance => 'Finance';

  @override
  String get navProfile => 'Profile';

  @override
  String get shoppingListTitle => 'Shopping List';

  @override
  String get toBuyTab => 'To Buy';

  @override
  String get purchasedTab => 'Purchased';

  @override
  String get clearCompleted => 'Clear';

  @override
  String get newProductHint => 'Add new item...';

  @override
  String itemsCount(int count) {
    return '$count Items';
  }

  @override
  String get addShoppingItemTitle => 'Add Item to Shopping List';

  @override
  String get productNameLabel => 'Item Name';

  @override
  String get productNameHint => 'E.g. Milk, Bread, Eggs...';

  @override
  String get addToListBtn => 'Add to List';

  @override
  String itemAddedToast(String name) {
    return '\"$name\" added to shopping list! 🛒';
  }

  @override
  String get emptyShoppingList => 'Your shopping list is empty.';

  @override
  String get financeOverviewTab => 'Overview';

  @override
  String get householdWalletTab => 'Household Wallet';

  @override
  String get accountsTab => 'Accounts';

  @override
  String get viewSummary => 'View Summary';

  @override
  String get incomeExpenseBalance => 'Income/Expense Balance';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get totalExpense => 'Total Expense';

  @override
  String get personalExpenses => 'Personal Expenses';

  @override
  String get noAccountYet => 'No accounts added yet.';

  @override
  String get paymentSchedule => 'Payment Schedule';

  @override
  String get realizedPayments => 'Realized Payments';

  @override
  String get accountScheduleHeader => 'Account / Schedule';

  @override
  String get monthlyFreeBudget => 'Remaining Free Budget';

  @override
  String get quickAddExpense => 'Quick Add Expense';

  @override
  String greetingUser(String name) {
    return 'Hello, $name';
  }

  @override
  String get quickAdd => 'Quick Add';

  @override
  String get expiringSoonTitle => 'Expirations Approaching';

  @override
  String get warrantiesExpiringTitle => 'Warranties Expiring & Ended';

  @override
  String get shoppingSummaryTitle => 'Shopping List Summary';

  @override
  String get viewAll => 'View All';

  @override
  String urgentExpirationsCount(int count) {
    return '$count Urgent Items';
  }

  @override
  String urgentWarrantiesCount(int count) {
    return '$count Urgent Warranties';
  }

  @override
  String get inventoryTitle => 'Home Inventory';

  @override
  String get expirationTab => 'Expiration';

  @override
  String get warrantyTab => 'Warranties';

  @override
  String get vaultTab => 'Home Vault';

  @override
  String get addExpirationItem => 'Add Item';

  @override
  String get addWarrantyItem => 'Add Warranty';

  @override
  String get periodicMaintenance => 'Maintenance Schedule';

  @override
  String get homeGuideWifi => 'Home Guide & Wi-Fi';

  @override
  String get digitalVaultSubtitle =>
      'Critical home documents, guides, and emergency numbers are encrypted and safely stored.';

  @override
  String get myHomeAndFamily => 'My Home & Family Management';

  @override
  String get inviteCode => 'Invite Code';

  @override
  String get familyMembers => 'Family Members';

  @override
  String get proMember => 'PRO Member';

  @override
  String get proHouseOwner => 'PRO Homeowner';

  @override
  String get houseOwner => 'Homeowner';

  @override
  String get legalSection => 'Legal';

  @override
  String get legalAndInfo => 'Legal & Info';

  @override
  String get accountActions => 'Account Actions';

  @override
  String get removeAdsTitle => 'Remove Ads (Ad-Free)';

  @override
  String memberCount(int count) {
    return '$count Member';
  }

  @override
  String get removeAdsSubtitle =>
      'Permanently remove ads with a one-time purchase!';

  @override
  String get removeAdsActive => 'Ad-Free Version Active ✅';

  @override
  String get specialPriceOffer => 'Special Price! Only the cost of a coffee.';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get introPopupTitle => 'Use Home Assistant Ad-Free!';

  @override
  String get introPopupDesc =>
      'Permanently remove all ads for a very low one-time price.';

  @override
  String get skipForNow => 'Skip for Now';

  @override
  String get shoppingListSubtitle =>
      'Easily track items to buy and purchased items.';

  @override
  String get clearCompletedConfirmTitle => 'Clear Purchased';

  @override
  String get clearCompletedConfirmDesc =>
      'All purchased items will be removed from the list. Continue?';

  @override
  String get emptyShoppingListDesc =>
      'You can add products you need like bread, milk, or fruit from the field above.';

  @override
  String get allPurchasedMessage => 'All items purchased! 🎉';

  @override
  String get delete => 'Delete';

  @override
  String get accountTypeCash => 'Cash';

  @override
  String get accountTypeBank => 'Bank';

  @override
  String get accountTypeCreditCard => 'Credit Card';

  @override
  String get accountTypeDebtCredit => 'Current (Debt/Credit)';

  @override
  String statementCutoff(String day) {
    return 'Statement cutoff: $day';
  }

  @override
  String get planBudget => 'Plan Budget';

  @override
  String get categoryBudgets => 'Category Budgets';

  @override
  String get noBudgetsSet =>
      'You have not set any budget target yet. Click \"Plan Budget\" to start.';

  @override
  String get limitExceeded => 'Limit exceeded!';

  @override
  String get noExpensesPeriod => 'No expenses for this period.';

  @override
  String get expenseHistory => 'Expense History';

  @override
  String get noRecordsFound => 'No records found.';

  @override
  String get financeManagementPro => 'Finance Management PRO';

  @override
  String get financeProDesc =>
      'Upgrade to PRO membership to control all family income, expenses, bank accounts, payment schedules, and cash flow.';

  @override
  String get expirationTitle => 'Expiration Dates';

  @override
  String get freshnessSubtitle =>
      'Track the freshness of items in your inventory.';

  @override
  String get searchProductLocationHint => 'Search product name or location...';

  @override
  String get clearExpired => 'Clear Expired Items';

  @override
  String get noProductsYet => 'No Products Yet';

  @override
  String get noProductsFound => 'No Products Found';

  @override
  String get addFirstProductDesc =>
      'Press \"Add Product\" to add your first item.';

  @override
  String get noMatchingProductsDesc =>
      'No products match your search or filter criteria.';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get expirationDateLabel => 'Expiration Date';

  @override
  String get trashAndShopping => 'Discard & Add to Shopping';

  @override
  String get warrantyTrackingTitle => 'Warranty Tracking';

  @override
  String get warrantySubtitle =>
      'Track warranty periods of your devices and items.';

  @override
  String get searchDeviceBrandHint => 'Search device, brand, or store...';

  @override
  String get noWarrantyRecordsYet => 'No Warranty Records Yet';

  @override
  String get noWarrantyRecordsFound => 'No Warranty Records Found';

  @override
  String get addFirstWarrantyDesc =>
      'Press \"Add Warranty\" to add your first warranty record.';

  @override
  String get noMatchingWarrantiesDesc =>
      'No records match your search or filter criteria.';

  @override
  String get documentsAndWarranties => 'Documents & Warranties';

  @override
  String get serviceAndEmergencyNumbers => 'Service & Emergency Numbers';

  @override
  String get uploadDocument => 'Upload Document';

  @override
  String get noDocumentsTitle => 'No Documents Found';

  @override
  String get noDocumentsDesc =>
      'Safely store deeds, insurance policies, or important documents in Digital Home Vault.';

  @override
  String get uploadFirstDocument => 'Upload First Document';

  @override
  String get addNumber => 'Add Number';

  @override
  String get noEmergencyContactsTitle => 'No Saved Numbers';

  @override
  String get noEmergencyContactsDesc =>
      'Add electrician, plumber, or emergency contacts for one-tap calling.';

  @override
  String get addFirstNumber => 'Add First Number';

  @override
  String get call => 'Call';

  @override
  String get copy => 'Copy';

  @override
  String get newMaintenanceTask => 'New Periodic Maintenance Task';

  @override
  String get maintenanceTitleLabel => 'Maintenance Name';

  @override
  String get maintenanceTitleHint =>
      'e.g. Boiler Annual Service, AC Filter Cleaning';

  @override
  String get descriptionLabel => 'Description / Details';

  @override
  String get descriptionHint => 'e.g. Wash filters, call technician.';

  @override
  String get scheduledDateLabel => 'Scheduled Maintenance Date';

  @override
  String get saveTask => 'Save Task';

  @override
  String get addHomeInfo => '+ Add Home Info';

  @override
  String get noGuideTitle => 'No Guide Info Found';

  @override
  String get noGuideDesc =>
      'Share Wi-Fi passwords, subscription numbers, or valve locations instantly with household members.';

  @override
  String get deleteItem => 'Delete';

  @override
  String get deleteConfirmDesc => 'will be permanently deleted.';

  @override
  String get addWarranty => 'Add Warranty';

  @override
  String get addMaintenanceTask => 'Add Maintenance';

  @override
  String get noMaintenanceTasksTitle => 'No Maintenance Tasks';

  @override
  String get noMaintenanceTasksDesc =>
      'Add boiler maintenance, chimney cleaning, or filter replacements to get reminders on time.';

  @override
  String get addFirstMaintenanceTask => 'Add First Maintenance Task';

  @override
  String get consentByContinuing => 'By continuing, you agree to our ';

  @override
  String get consentTermsAndPrivacy => 'Terms of Use and Privacy Policy';

  @override
  String get consentAcceptSuffix => '.';

  @override
  String get registerConsentPrefix => 'I read and accept the ';

  @override
  String get registerConsentSuffix => '.';

  @override
  String get registerConsentError => 'You must accept the terms to continue.';

  @override
  String get addProduct => 'Add Product';

  @override
  String get perMonthSuffix => '/ this month';

  @override
  String get freeBudgetDescription =>
      'The amount remaining from monthly net income after fixed expenses are deducted.';

  @override
  String get viewDetails => 'View Details';

  @override
  String get everythingLooksGood => 'Everything in your home looks good.';

  @override
  String get statusAll => 'All';

  @override
  String get statusExpiredChip => 'Expired';

  @override
  String get statusCriticalChip => 'Critical';

  @override
  String get statusUpcomingChip => 'Upcoming';

  @override
  String get statusSafeChip => 'Safe';

  @override
  String get statusExpired => 'Expired';

  @override
  String get statusToday => 'Last Day Today';

  @override
  String daysLeft(int count) {
    return '$count Days Left';
  }

  @override
  String get budgetPlanDescription =>
      'Set your monthly spending goals. You can leave unwanted categories blank.';

  @override
  String get categoryDiningOut => 'Dining Out';

  @override
  String get categoryKitchenGrocery => 'Kitchen & Grocery';

  @override
  String get categoryHomeBills => 'Home & Bills';

  @override
  String get categoryShoppingPersonal => 'Shopping & Personal';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryEntertainmentSubscriptions =>
      'Entertainment & Subscriptions';

  @override
  String get categoryOther => 'Other';

  @override
  String get saveBudgets => 'Save Targets';

  @override
  String get limitAmountHint => 'Limit (₺)';

  @override
  String get financialStatus => 'Financial Status';

  @override
  String get periodYearly => 'Yearly';

  @override
  String get periodMonthly => 'Monthly';

  @override
  String get periodWeekly => 'Weekly';

  @override
  String get periodDaily => 'Daily';

  @override
  String get netStatus => 'Net Status';

  @override
  String get yearlyNetStatus => 'Yearly Net Status';

  @override
  String get monthlyNetStatus => 'Monthly Net Status';

  @override
  String get weeklyNetStatus => 'Weekly Net Status';

  @override
  String get dailyNetStatus => 'Daily Net Status';

  @override
  String get upcomingPendingTransactions => 'Upcoming Pending Transactions';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get futureIncome => 'Future Income';

  @override
  String get upcomingPayment => 'Upcoming Payment';

  @override
  String get noTransactionsPeriod => 'No transactions in this period.';

  @override
  String get budgetPlanUpdated => 'Budget targets updated!';
}
