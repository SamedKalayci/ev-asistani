// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Asistente del Hogar';

  @override
  String get languageSelection => 'Selección de Idioma';

  @override
  String get languageSelectionSubtitle => 'Cambiar idioma de la aplicación';

  @override
  String get preferencesAndSettings => 'Preferencias y Ajustes';

  @override
  String get notificationSettings => 'Ajustes de Notificaciones';

  @override
  String get notificationSettingsSubtitle =>
      'Gestionar notificaciones del sistema';

  @override
  String get about => 'Acerca de';

  @override
  String get aboutSubtitle =>
      'Asistente del Hogar v1.1.0 (Firebase Habilitado)';

  @override
  String get developerLabel => 'Desarrollador: Samed Kalaycı';

  @override
  String get aboutDescription =>
      'Descripción: Aplicación de organización del hogar y gestión de listas compartidas.';

  @override
  String get allRightsReserved =>
      '© 2026 Asistente del Hogar. Todos los derechos reservados.';

  @override
  String get privacyPolicy => 'Política de Privacidad y Términos';

  @override
  String get privacyPolicySubtitle => 'Revisar avisos legales y condiciones';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get signOutSubtitle => 'Cerrar sesión de forma segura';

  @override
  String get deleteAccount => 'Eliminar Cuenta';

  @override
  String get deleteAccountSubtitle => 'Eliminar cuenta y datos permanentemente';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get turkish => 'Turco';

  @override
  String get english => 'Inglés';

  @override
  String get german => 'Alemán';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Francés';

  @override
  String get azerbaijani => 'Azerbaiyano';

  @override
  String get greek => 'Griego';

  @override
  String get portuguese => 'Portugués';

  @override
  String get navHome => 'Inicio';

  @override
  String get navInventory => 'Inventario';

  @override
  String get navShopping => 'Compras';

  @override
  String get navFinance => 'Finanzas';

  @override
  String get navProfile => 'Perfil';

  @override
  String get shoppingListTitle => 'Lista de Compras';

  @override
  String get toBuyTab => 'Por Comprar';

  @override
  String get purchasedTab => 'Comprado';

  @override
  String get clearCompleted => 'Limpiar';

  @override
  String get newProductHint => 'Añadir nuevo artículo...';

  @override
  String itemsCount(int count) {
    return '$count Artículos';
  }

  @override
  String get addShoppingItemTitle => 'Añadir Artículo a la Lista';

  @override
  String get productNameLabel => 'Nombre del Artículo';

  @override
  String get productNameHint => 'Ej: Leche, Pan, Huevos...';

  @override
  String get addToListBtn => 'Añadir a la Lista';

  @override
  String itemAddedToast(String name) {
    return '¡\"$name\" añadido a la lista! 🛒';
  }

  @override
  String get emptyShoppingList => 'Tu lista de compras está vacía.';

  @override
  String get financeOverviewTab => 'Resumen';

  @override
  String get householdWalletTab => 'Billetera del Hogar';

  @override
  String get accountsTab => 'Cuentas';

  @override
  String get viewSummary => 'Ver Resumen';

  @override
  String get incomeExpenseBalance => 'Balance Ingresos/Gastos';

  @override
  String get totalIncome => 'Ingresos Totales';

  @override
  String get totalExpense => 'Gastos Totales';

  @override
  String get personalExpenses => 'Gastos Personales';

  @override
  String get noAccountYet => 'Aún no se ha añadido ninguna cuenta.';

  @override
  String get paymentSchedule => 'Calendario de Pagos';

  @override
  String get realizedPayments => 'Realizados';

  @override
  String get accountScheduleHeader => 'Cuenta / Calendario';

  @override
  String get monthlyFreeBudget => 'Presupuesto Libre Restante';

  @override
  String get quickAddExpense => 'Añadir Gasto Rápido';

  @override
  String greetingUser(String name) {
    return 'Hola, $name';
  }

  @override
  String get quickAdd => 'Añadir Rápido';

  @override
  String get expiringSoonTitle => 'Vencimientos Próximos';

  @override
  String get warrantiesExpiringTitle => 'Garantías por Vencer';

  @override
  String get shoppingSummaryTitle => 'Resumen de Compras';

  @override
  String get viewAll => 'Ver Todo';

  @override
  String urgentExpirationsCount(int count) {
    return '$count Artículos Urgentes';
  }

  @override
  String urgentWarrantiesCount(int count) {
    return '$count Garantías Urgentes';
  }

  @override
  String get inventoryTitle => 'Inventario del Hogar';

  @override
  String get expirationTab => 'Vencimiento';

  @override
  String get warrantyTab => 'Garantías';

  @override
  String get vaultTab => 'Bóveda';

  @override
  String get addExpirationItem => 'Añadir Artículo';

  @override
  String get addWarrantyItem => 'Añadir Garantía';

  @override
  String get periodicMaintenance => 'Calendario de Mantenimiento';

  @override
  String get homeGuideWifi => 'Guía del Hogar y Wi-Fi';

  @override
  String get digitalVaultSubtitle =>
      'Los documentos críticos y contactos de emergencia están cifrados y seguros.';

  @override
  String get myHomeAndFamily => 'Mi Hogar y Gestión Familiar';

  @override
  String get inviteCode => 'Código de Invitación';

  @override
  String get familyMembers => 'Miembros de la Familia';

  @override
  String get proMember => 'Miembro PRO';

  @override
  String get proHouseOwner => 'Propietario PRO';

  @override
  String get houseOwner => 'Propietario del Hogar';

  @override
  String get legalSection => 'Legal';

  @override
  String get legalAndInfo => 'Legal e Info';

  @override
  String get accountActions => 'Acciones de Cuenta';

  @override
  String get removeAdsTitle => 'Eliminar Anuncios';

  @override
  String memberCount(int count) {
    return '$count Miembro';
  }

  @override
  String get removeAdsSubtitle =>
      '¡Sin anuncios para siempre con un solo pago!';

  @override
  String get removeAdsActive => 'Versión Sin Anuncios Activa ✅';

  @override
  String get specialPriceOffer => '¡Precio Especial! Solo el costo de un café.';

  @override
  String get buyNow => 'Comprar Ahora';

  @override
  String get restorePurchases => 'Restaurar Compras';

  @override
  String get introPopupTitle => '¡Usa la App Sin Anuncios!';

  @override
  String get introPopupDesc =>
      'Elimina todos los anuncios permanentemente por un pago único muy económico.';

  @override
  String get skipForNow => 'Omitir por ahora';

  @override
  String get shoppingListSubtitle =>
      'Siga fácilmente los artículos para comprar y comprados.';

  @override
  String get clearCompletedConfirmTitle => 'Borrar comprados';

  @override
  String get clearCompletedConfirmDesc =>
      'Todos los artículos comprados se eliminarán de la lista. ¿Continuar?';

  @override
  String get emptyShoppingListDesc =>
      'Puede agregar productos que necesite como pan, leche o frutas en el campo de arriba.';

  @override
  String get allPurchasedMessage => '¡Todos los artículos comprados! 🎉';

  @override
  String get delete => 'Eliminar';

  @override
  String get accountTypeCash => 'Efectivo';

  @override
  String get accountTypeBank => 'Banco';

  @override
  String get accountTypeCreditCard => 'Tarjeta de Crédito';

  @override
  String get accountTypeDebtCredit => 'Cuenta (Deuda/Crédito)';

  @override
  String statementCutoff(String day) {
    return 'Corte de cuenta: $day';
  }

  @override
  String get planBudget => 'Planificar Presupuesto';

  @override
  String get categoryBudgets => 'Presupuestos por Categoría';

  @override
  String get noBudgetsSet => 'Aún no ha establecido un presupuesto.';

  @override
  String get limitExceeded => '¡Límite superado!';

  @override
  String get noExpensesPeriod => 'Sin gastos en este período.';

  @override
  String get expenseHistory => 'Historial de Gastos';

  @override
  String get noRecordsFound => 'No se encontraron registros.';

  @override
  String get financeManagementPro => 'Gestión Financiera PRO';

  @override
  String get financeProDesc =>
      'Actualice a PRO para controlar ingresos, gastos y cuentas bancarias.';

  @override
  String get expirationTitle => 'Fechas de Caducidad';

  @override
  String get freshnessSubtitle =>
      'Siga la frescura de los artículos en su inventario.';

  @override
  String get searchProductLocationHint => 'Buscar producto o ubicación...';

  @override
  String get clearExpired => 'Limpiar Vencidos';

  @override
  String get noProductsYet => 'Aún no hay productos';

  @override
  String get noProductsFound => 'No se encontraron productos';

  @override
  String get addFirstProductDesc =>
      'Presione \"Agregar Producto\" para añadir el primero.';

  @override
  String get noMatchingProductsDesc =>
      'No hay productos que coincidan con la búsqueda.';

  @override
  String get clearFilters => 'Limpiar Filtros';

  @override
  String get expirationDateLabel => 'Fecha de Vencimiento';

  @override
  String get trashAndShopping => 'Desechar y Añadir a Compras';

  @override
  String get warrantyTrackingTitle => 'Seguimiento de Garantías';

  @override
  String get warrantySubtitle =>
      'Siga los períodos de garantía de sus dispositivos.';

  @override
  String get searchDeviceBrandHint => 'Buscar dispositivo, marca o tienda...';

  @override
  String get noWarrantyRecordsYet => 'Aún no hay garantías';

  @override
  String get noWarrantyRecordsFound => 'No se encontraron garantías';

  @override
  String get addFirstWarrantyDesc =>
      'Presione \"Agregar Garantía\" para empezar.';

  @override
  String get noMatchingWarrantiesDesc =>
      'No hay registros que coincidan con la búsqueda.';

  @override
  String get documentsAndWarranties => 'Documentos y Garantías';

  @override
  String get serviceAndEmergencyNumbers => 'Servicio y Números de Emergencia';

  @override
  String get uploadDocument => 'Subir Documento';

  @override
  String get noDocumentsTitle => 'No hay documentos';

  @override
  String get noDocumentsDesc => 'Guarde escrituras y pólizas de forma segura.';

  @override
  String get uploadFirstDocument => 'Subir Primer Documento';

  @override
  String get addNumber => 'Agregar Número';

  @override
  String get noEmergencyContactsTitle => 'Sin números guardados';

  @override
  String get noEmergencyContactsDesc =>
      'Agregue contactos de emergencia para llamar con un toque.';

  @override
  String get addFirstNumber => 'Agregar Primer Número';

  @override
  String get call => 'Llamar';

  @override
  String get copy => 'Copiar';

  @override
  String get newMaintenanceTask => 'Nueva Tarea de Mantenimiento';

  @override
  String get maintenanceTitleLabel => 'Nombre del Mantenimiento';

  @override
  String get maintenanceTitleHint => 'Ej: Mantenimiento de caldera';

  @override
  String get descriptionLabel => 'Descripción / Detalles';

  @override
  String get descriptionHint => 'Ej: Limpiar filtros, llamar técnico.';

  @override
  String get scheduledDateLabel => 'Fecha de Mantenimiento Programada';

  @override
  String get saveTask => 'Guardar Tarea';

  @override
  String get addHomeInfo => '+ Agregar Info de Casa';

  @override
  String get noGuideTitle => 'Sin Información de Guía';

  @override
  String get noGuideDesc =>
      'Comparta contraseñas Wi-Fi e información de la casa.';

  @override
  String get deleteItem => 'Eliminar';

  @override
  String get deleteConfirmDesc => 'se eliminará permanentemente.';

  @override
  String get addWarranty => 'Agregar Garantía';

  @override
  String get addMaintenanceTask => 'Agregar Mantenimiento';

  @override
  String get noMaintenanceTasksTitle => 'Sin Tareas de Mantenimiento';

  @override
  String get noMaintenanceTasksDesc =>
      'Agregue mantenimientos para recibir recordatorios.';

  @override
  String get addFirstMaintenanceTask =>
      'Agregar Primera Tarea de Mantenimiento';

  @override
  String get consentByContinuing => 'Al continuar, acepta nuestros ';

  @override
  String get consentTermsAndPrivacy =>
      'Términos de uso y Política de privacidad';

  @override
  String get consentAcceptSuffix => '.';

  @override
  String get registerConsentPrefix => 'He leído y acepto los ';

  @override
  String get registerConsentSuffix => '.';

  @override
  String get registerConsentError =>
      'Debe aceptar los términos para continuar.';

  @override
  String get addProduct => 'Agregar Producto';

  @override
  String get perMonthSuffix => '/ este mes';

  @override
  String get freeBudgetDescription =>
      'La cantidad restante de los ingresos netos mensuales una vez deducidos los gastos fijos.';

  @override
  String get viewDetails => 'Ver detalles';

  @override
  String get everythingLooksGood => 'Todo en tu casa parece estar bien.';

  @override
  String get statusAll => 'Todos';

  @override
  String get statusExpiredChip => 'Vencidos';

  @override
  String get statusCriticalChip => 'Críticos';

  @override
  String get statusUpcomingChip => 'Próximos';

  @override
  String get statusSafeChip => 'Seguros';

  @override
  String get statusExpired => 'Vencido';

  @override
  String get statusToday => 'Último día hoy';

  @override
  String daysLeft(int count) {
    return '$count Días restantes';
  }

  @override
  String get budgetPlanDescription =>
      'Establece tus objetivos de gasto mensual. Puedes dejar en blanco las categorías no deseadas.';

  @override
  String get categoryDiningOut => 'Comer Fuera';

  @override
  String get categoryKitchenGrocery => 'Cocina & Supermercado';

  @override
  String get categoryHomeBills => 'Casa & Facturas';

  @override
  String get categoryShoppingPersonal => 'Compras & Personal';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryEntertainmentSubscriptions =>
      'Entretenimiento & Suscripciones';

  @override
  String get categoryOther => 'Otros';

  @override
  String get saveBudgets => 'Guardar Objetivos';

  @override
  String get limitAmountHint => 'Límite (₺)';

  @override
  String get financialStatus => 'Estado Financiero';

  @override
  String get periodYearly => 'Anual';

  @override
  String get periodMonthly => 'Mensual';

  @override
  String get periodWeekly => 'Semanal';

  @override
  String get periodDaily => 'Diario';

  @override
  String get netStatus => 'Estado Neto';

  @override
  String get yearlyNetStatus => 'Estado Neto Anual';

  @override
  String get monthlyNetStatus => 'Estado Neto Mensual';

  @override
  String get weeklyNetStatus => 'Estado Neto Semanal';

  @override
  String get dailyNetStatus => 'Estado Neto Diario';

  @override
  String get upcomingPendingTransactions => 'Próximas Transacciones Pendientes';

  @override
  String get recentTransactions => 'Transacciones Recientes';

  @override
  String get futureIncome => 'Ingreso Futuro';

  @override
  String get upcomingPayment => 'Próximo Pago';

  @override
  String get noTransactionsPeriod => 'No hay transacciones en este período.';

  @override
  String get budgetPlanUpdated => '¡Objetivos de presupuesto actualizados!';
}
