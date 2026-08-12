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
  String get currencySelection => 'Moneda';

  @override
  String get currencySelectionSubtitle =>
      'Seleccionar moneda para pantallas de presupuesto y finanzas';

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
      'Descripción: Organización inteligente del hogar.';

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
  String get restorePurchases => 'Restaurar compras';

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

  @override
  String get linkAccountTitle => 'Vincular su Cuenta';

  @override
  String get guestModeDesc =>
      'Está en modo invitado. Haga su cuenta permanente sin perder datos.';

  @override
  String get guestModeBottomSheetDesc =>
      'Está en modo invitado. Seleccione un método de inicio de sesión para crear una cuenta permanente y no perder sus datos.';

  @override
  String get connectionOptions => 'Opciones de Inicio de Sesión';

  @override
  String get userRoleLabel => 'Usuario';

  @override
  String get anonymousSession => 'Sesión Anónima';

  @override
  String get notMemberOfFamilyYet => 'Aún no está conectado a una familia';

  @override
  String get notMemberOfHomeYet => 'Aún no está conectado a un hogar';

  @override
  String get noHomeSyncDesc =>
      'Cree un hogar o únase a uno existente con un código de invitación para sincronizar elementos y listas de compras.';

  @override
  String get createHome => 'Crear Hogar';

  @override
  String get enterCode => 'Ingresar Código';

  @override
  String get createOrJoinHome => 'Crear o Unirse a un Hogar';

  @override
  String get createNewHomeTitle => 'Crear Nuevo Hogar / Familia';

  @override
  String get createNewHomeDesc =>
      'Nombre su hogar. Puede crear su hogar gratis viendo 1 anuncio corto.';

  @override
  String get homeNameLabel => 'Nombre del Hogar / Familia';

  @override
  String get homeNameHint => 'Ej: Familia García';

  @override
  String get homeNameRequired => 'El nombre del hogar es obligatorio.';

  @override
  String get roleInHomeLabel => 'Su Rol en el Hogar';

  @override
  String get roleHouseOwner => '👑 Propietario de la Casa';

  @override
  String get roleMother => '👨‍👩‍👧 Madre';

  @override
  String get roleFather => '👨‍👩‍👦 Padre';

  @override
  String get roleChild => '👶 Hijo/a';

  @override
  String get roleRoommate => '🏠 Compañero/a de Piso';

  @override
  String get roleOtherResident => '🐾 Otro / Residente';

  @override
  String get noUpcomingExpirationsMessage =>
      'Sin productos con fechas de caducidad próximas. 👍';

  @override
  String get expirationProductItem => 'Producto con Fecha de Caducidad';

  @override
  String get expirationProductSubtitle =>
      'Rastrear alimentos/medicinas en nevera o despensa';

  @override
  String get warrantyDocumentItem => 'Agregar Documento / Archivo de Garantía';

  @override
  String get warrantyDocumentSubtitle =>
      'Documentos de garantía y archivos de electrodomésticos';

  @override
  String get enterQuickExpense => 'Añadir Gasto Rápido';

  @override
  String get amountLabel => 'Monto';

  @override
  String get amountRequired => 'Por favor ingrese un monto';

  @override
  String get validAmountRequired => 'Por favor ingrese un monto válido';

  @override
  String get shortDescriptionLabel => 'Descripción Corta';

  @override
  String get shortDescriptionHint => 'Ej: Café, Compras, etc.';

  @override
  String get descriptionRequired => 'Ingrese una descripción';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get addToPaymentSchedule => 'Añadir al Calendario de Pagos';

  @override
  String get editPaymentSchedule => 'Editar Calendario de Pagos';

  @override
  String get billExpenseOption => 'Factura / Gasto';

  @override
  String get incomeCollectionOption => 'Ingreso / Cobro';

  @override
  String get scheduleTitleLabel => 'Título (Ej: Factura de Luz, Alquiler)';

  @override
  String get titleRequired => 'Por favor ingrese un título';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get bankAccountNameOptional =>
      'Banco Asociado / Nombre de Cuenta (Opcional)';

  @override
  String get markAsPaid => 'Marcar como Pagado';

  @override
  String get repeatMonthly => 'Repetir Mensualmente';

  @override
  String get oneTimePaymentNotice => 'Pago único.';

  @override
  String get addToScheduleBtn => 'Añadir al Calendario';

  @override
  String get addNewDocumentTitle => 'Agregar Nuevo Documento / Archivo';

  @override
  String get editDocumentTitle => 'Editar Documento';

  @override
  String get documentTitleLabel => 'Título del Documento';

  @override
  String get documentTitleHint => 'Ej: Escritura, Contrato de Alquiler';

  @override
  String get notesDescriptionLabel => 'Descripción / Notas';

  @override
  String get notesDescriptionHint =>
      'Ej: Guardado en el segundo cajón del archivador.';

  @override
  String get addFileImage => 'Agregar Archivo / Imagen';

  @override
  String get selectPhotoDocument => 'Seleccionar Foto / Documento';

  @override
  String get saveDocumentBtn => 'Guardar Documento';

  @override
  String get addNewContactTitle => 'Agregar Nuevo Contacto / Servicio';

  @override
  String get editContactTitle => 'Editar Número';

  @override
  String get namePersonLabel => 'Nombre / Persona de Contacto';

  @override
  String get namePersonHint =>
      'Ej: Fontanero Juan, Administración del Edificio';

  @override
  String get titleCategoryLabel => 'Título / Categoría';

  @override
  String get titleCategoryHint => 'Ej: Fontanería, Electricidad, Cerrajero';

  @override
  String get phoneNumberLabel => 'Número de Teléfono';

  @override
  String get phoneNumberHint => 'Ej: +34 600 123 456';

  @override
  String get saveNumberBtn => 'Guardar Número';

  @override
  String get summary => 'Resumen';

  @override
  String get creditCardExpenses => 'Gastos de Tarjeta de Crédito';

  @override
  String get cashExpenses => 'Gastos en Efectivo';

  @override
  String get quickExpenses => 'Gastos Rápidos';

  @override
  String get pleaseSelectDocumentOrPhoto =>
      'Por favor seleccione un documento o foto.';

  @override
  String get editWarranty => 'Editar Registro de Garantía';

  @override
  String get productDeviceName => 'Nombre del Producto / Dispositivo';

  @override
  String get productDeviceNameHint => 'Ej: Nevera, Laptop...';

  @override
  String get brand => 'Marca';

  @override
  String get brandHint => 'Ej: Samsung, Apple...';

  @override
  String get store => 'Tienda de Compra';

  @override
  String get storeHint => 'Ej: Amazon, BestBuy...';

  @override
  String get purchaseDate => 'Fecha de Compra';

  @override
  String get warrantyEndDate => 'Fecha de Vencimiento de Garantía';

  @override
  String get hasInvoice => 'Factura / Documento Disponible';

  @override
  String get icon => 'Icono';

  @override
  String get optionalNotes => 'Notas (Opcional)';

  @override
  String get optionalNotesHint => 'Información adicional...';

  @override
  String get invoiceNumberOptional => 'Número de Factura (Opcional)';

  @override
  String get invoiceNumberHint => 'Ej: AMZ-2024-12345';

  @override
  String get changeInvoiceFile => 'Cambiar Archivo de Factura';

  @override
  String get uploadInvoiceFile => '📸 Cargar Imagen de Factura / PDF';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get productNameRequired => 'El nombre del producto es obligatorio.';

  @override
  String get brandRequired => 'La marca es obligatoria.';

  @override
  String get storeRequired => 'El nombre de la tienda es obligatorio.';

  @override
  String get selectPurchaseDateWarning =>
      'Por favor seleccione la fecha de compra.';

  @override
  String get selectWarrantyEndDateWarning =>
      'Por favor seleccione la fecha de fin de garantía.';

  @override
  String get selectDateHint => 'Seleccionar Fecha';

  @override
  String get addNewHomeInfo => 'Agregar Nueva Información del Hogar';

  @override
  String get editHomeInfo => 'Editar Información del Hogar';

  @override
  String get categorySelection => 'Selección de Categoría';

  @override
  String get guideTitle => 'Título de la Guía';

  @override
  String get guideTitleHint =>
      'Ej: Suscripción de Gas, Válvula de Agua, Clave Wi-Fi';

  @override
  String get importantValueLabel =>
      'Información Importante / Valor (Clic para Copiar)';

  @override
  String get importantValueHint => 'Ej: N° Sub: 123456, Clave: xyz';

  @override
  String get detailedNotesLabel => 'Descripción / Nota Detallada';

  @override
  String get detailedNotesHint =>
      'Ej: El medidor está en el armario del balcón a la derecha.';

  @override
  String get updateInfoBtn => 'Actualizar Información';

  @override
  String get categoryWifi => '📶 Wi-Fi y Red';

  @override
  String get categoryInstallation => '⚡ Instalación y Servicios';

  @override
  String get categoryPasswords => '🔑 Contraseñas y Códigos';

  @override
  String get categoryGeneralHome => 'ℹ️ Información General del Hogar';

  @override
  String get themeSelection => 'Selección de Tema';

  @override
  String get themeSelectionSubtitle =>
      'Elige la apariencia de la app (Sistema / Claro / Oscuro)';

  @override
  String get themeSystem => 'Sistema (Predeterminado)';

  @override
  String get themeLight => 'Tema Claro';

  @override
  String get themeDark => 'Tema Oscuro';

  @override
  String get editHomeNameTitle => 'Editar Nombre del Hogar';

  @override
  String get editHomeNameLabel => 'Nombre del Hogar';

  @override
  String get editHomeNameHint => 'Ej: Casa García';

  @override
  String get homeNameUpdatedToast => '¡Nombre del hogar actualizado! 🏠';

  @override
  String get customRoleOption => '✏️ Rol Personalizado...';

  @override
  String get customRoleHint => 'Escribe el rol...';

  @override
  String get aboutDeveloper => 'Desarrollador: Samed Kalaycı';

  @override
  String get aboutCopyright =>
      '© 2026 Ev Asistanı. Todos los derechos reservados.';

  @override
  String get addShoppingItemSub =>
      'Alimentos, limpieza y necesidades del hogar faltantes';

  @override
  String get guestLoginSuccess => 'Sesión de invitado iniciada. 👋';

  @override
  String guestLoginFailed(String error) {
    return 'Inicio de sesión de invitado fallido: $error';
  }

  @override
  String get noUpcomingWarranties =>
      'No hay vencimientos de garantía próximos. 👍';

  @override
  String get noUpcomingPayments => 'No hay pagos próximos. 👍';

  @override
  String get editProduct => 'Editar producto';

  @override
  String get locationLabel => 'Ubicación';

  @override
  String get locationHint => 'Ej: Nevera, Despensa...';

  @override
  String get locationRequired => 'La ubicación es requerida.';

  @override
  String get additionalNotesHint => 'Agregar notas adicionales...';

  @override
  String get selectExpirationDateWarning =>
      'Por favor seleccione la fecha de vencimiento.';

  @override
  String get productNameExampleHint => 'Ej: Leche, Huevos...';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get signInBtn => 'Iniciar sesión';

  @override
  String get signInFailed => 'Error al iniciar sesión.';

  @override
  String get signUpBtn => 'Registrarse';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get welcomeToApp => 'Bienvenido a Asistente de Hogar';

  @override
  String get smartHomeTagline =>
      'Gestiona todo en tu hogar de forma inteligente';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get signInWithApple => 'Iniciar sesión con Apple';

  @override
  String get tryAsGuest => 'Probar como invitado (Sin cuenta)';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordDesc =>
      'Ingrese su correo electrónico. Le enviaremos un enlace de restablecimiento.';

  @override
  String get emailAddress => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get confirmPasswordHint => 'Confirma tu contraseña';

  @override
  String get fullNameLabel => 'Nombre y apellido';

  @override
  String get fullNameRequired => 'El nombre completo es requerido.';

  @override
  String get passwordRequired => 'La contraseña es requerida.';

  @override
  String get confirmPasswordRequired =>
      'La confirmación de contraseña es requerida.';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden.';

  @override
  String get emailRequired => 'El correo electrónico es requerido.';

  @override
  String get enterValidEmail =>
      'Por favor ingrese un correo electrónico válido.';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get orDivider => 'o';

  @override
  String get send => 'Enviar';

  @override
  String get passwordResetSent =>
      '¡Enlace de restablecimiento enviado a su correo! 📧';

  @override
  String get googleLoginSuccess => 'Sesión iniciada con Google. 👋';

  @override
  String get appleLoginSuccess => 'Sesión iniciada con Apple. 👋';

  @override
  String get verificationEmailSent =>
      'Enlace de verificación enviado. Por favor verifique su correo.';

  @override
  String get emailAlreadyInUse => 'Este correo electrónico ya está en uso.';

  @override
  String get weakPassword =>
      'La contraseña es muy débil. Use al menos 6 caracteres.';

  @override
  String get linkWithGoogle => 'Vincular con Google';

  @override
  String get linkWithApple => 'Vincular con Apple';

  @override
  String get linkWithEmail => 'Vincular con correo';

  @override
  String get connecting => 'Conectando...';

  @override
  String get emailHint => 'ejemplo@gmail.com';

  @override
  String get guestUser => 'Invitado';

  @override
  String get deleteAccountConfirmDesc =>
      '¿Está seguro de que desea eliminar su cuenta y todos sus datos personales? Esta acción no se puede deshacer.';

  @override
  String get deleteAccountConfirmBtn => 'Sí, eliminar';

  @override
  String get deleteAccountReauthNotice =>
      'Por razones de seguridad, inicie sesión de nuevo para eliminar su cuenta.';

  @override
  String get adFreeActiveTitle => 'Versión sin anuncios activa ✨';

  @override
  String get adFreeActiveDesc =>
      '¡Has eliminado los anuncios por completo, disfruta de la aplicación!';

  @override
  String get activeBadge => 'ACTIVO';

  @override
  String get buyAdFreeTitle => 'Obtener versión sin anuncios';

  @override
  String get buyAdFreeDesc =>
      'Elimine todos los anuncios en la aplicación para una experiencia sin interrupciones.';

  @override
  String get monthlyYearlyFlexiblePlans =>
      'Planes flexibles mensuales y anuales';

  @override
  String get inspectAndBuyPlans => 'Ver planes y comprar';

  @override
  String get adFreeTitle => 'Versión sin anuncios';

  @override
  String get adFreeHeaderSubtitle =>
      'Elimine todos los anuncios para una experiencia rápida y fluida.';

  @override
  String get zeroAdsTitle => 'Cero anuncios, uso sin interrupciones';

  @override
  String get zeroAdsSubtitle =>
      'Todos los anuncios en transiciones de página son bloqueados.';

  @override
  String get allFamilyIncludedTitle =>
      'Incluido para todos los miembros de la familia';

  @override
  String get allFamilyIncludedSubtitle =>
      'Todos en su hogar obtienen acceso sin anuncios automáticamente.';

  @override
  String get fasterPageTransitionsTitle => 'Transiciones de página más rápidas';

  @override
  String get fasterPageTransitionsSubtitle =>
      'La aplicación funciona más rápida sin la carga de anuncios.';

  @override
  String get annualPlanRecommended => 'Plan anual (Recomendado)';

  @override
  String get save30Percent => 'AHORRA 30%';

  @override
  String get annualPlanSubprice => 'Mejor precio con pago anual';

  @override
  String get monthlyPlanTitle => 'Plan mensual';

  @override
  String get flexibleBadge => 'FLEXIBLE';

  @override
  String get cancelAnytimeSubprice => 'Cancela fácilmente en cualquier momento';

  @override
  String get switchToAnnualPlan => 'Cambiar al plan anual sin anuncios';

  @override
  String get switchToMonthlyPlan => 'Cambiar al plan mensual sin anuncios';

  @override
  String get cancelNoticeIos =>
      'Puede cancelar en cualquier momento en los ajustes de App Store / Apple ID.';

  @override
  String get cancelNoticeAndroid =>
      'Puede cancelar en cualquier momento en los ajustes de Google Play Store.';

  @override
  String get termsOfUseEula => 'Términos de uso (EULA)';

  @override
  String get adFreeActivatedToast =>
      '¡🎉 Tu suscripción sin anuncios ha sido activada!';

  @override
  String get purchasesRestoredToast => '¡🎉 Compras restauradas con éxito!';

  @override
  String get signOutAnonymousTitle => 'Cerrar sesión de cuenta de invitado';

  @override
  String get signOutAnonymousDesc =>
      'Todos sus datos y el acceso familiar se perderán. ¿Está seguro de que desea cerrar sesión sin vincular su cuenta?';

  @override
  String get signOutConfirmDesc =>
      '¿Está seguro de que desea cerrar sesión de su cuenta?';

  @override
  String get linkAccountBtn => 'Vincular cuenta';
}
