import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

extension FinanceL10nExtension on AppLocalizations {
  String get currentLang => localeName.split('_').first.toLowerCase();

  String get paymentType {
    switch (currentLang) {
      case 'az': return 'Ödəniş növü';
      case 'de': return 'Zahlungsart';
      case 'el': return 'Τρόπος πληρωμής';
      case 'es': return 'Tipo de pago';
      case 'fr': return 'Type de paiement';
      case 'pt': return 'Tipo de pagamento';
      case 'en': return 'Payment Type';
      case 'tr':
      default: return 'Ödeme Türü';
    }
  }

  String get cash {
    switch (currentLang) {
      case 'az': return 'Nağd';
      case 'de': return 'Bargeld';
      case 'el': return 'Μετρητά';
      case 'es': return 'Efectivo';
      case 'fr': return 'Espèces';
      case 'pt': return 'Dinheiro';
      case 'en': return 'Cash';
      case 'tr':
      default: return 'Nakit';
    }
  }

  String get creditCard {
    switch (currentLang) {
      case 'az': return 'Kredit kartı';
      case 'de': return 'Kreditkarte';
      case 'el': return 'Πιστωτική κάρτα';
      case 'es': return 'Tarjeta de crédito';
      case 'fr': return 'Carte de crédit';
      case 'pt': return 'Cartão de crédito';
      case 'en': return 'Credit Card';
      case 'tr':
      default: return 'Kredi Kartı';
    }
  }

  String get accountCreditCard {
    switch (currentLang) {
      case 'az': return 'Hesab / Kredit kartı';
      case 'de': return 'Konto / Kreditkarte';
      case 'el': return 'Λογαριασμός / Πιστωτική κάρτα';
      case 'es': return 'Cuenta / Tarjeta de crédito';
      case 'fr': return 'Compte / Carte de crédit';
      case 'pt': return 'Conta / Cartão de crédito';
      case 'en': return 'Account / Credit Card';
      case 'tr':
      default: return 'Hesap / Kredi Kartı';
    }
  }

  String get accountCreditCardHint {
    switch (currentLang) {
      case 'az': return 'Məs: Bonus, World, Nağd, QNB...';
      case 'de': return 'Z.B.: Bonus, World, Bargeld, QNB...';
      case 'el': return 'Π.χ.: Bonus, World, Μετρητά, QNB...';
      case 'es': return 'Ej: Bonus, World, Efectivo, QNB...';
      case 'fr': return 'Ex: Bonus, World, Espèces, QNB...';
      case 'pt': return 'Ex: Bonus, World, Dinheiro, QNB...';
      case 'en': return 'E.g.: Bonus, World, Cash, QNB...';
      case 'tr':
      default: return 'Örn: Bonus, World, Nakit, QNB...';
    }
  }

  String get categoryDistribution {
    switch (currentLang) {
      case 'az': return 'Kateqoriya Bölgüsü';
      case 'de': return 'Kategorieverteilung';
      case 'el': return 'Κατανομή Κατηγοριών';
      case 'es': return 'Distribución por Categorías';
      case 'fr': return 'Répartition par Catégorie';
      case 'pt': return 'Distribuição por Categorias';
      case 'en': return 'Category Distribution';
      case 'tr':
      default: return 'Kategori Dağılımı';
    }
  }

  String get totalMonthlyExpenseLabel {
    switch (currentLang) {
      case 'az': return 'Toplam Aylıq Xərc';
      case 'de': return 'Monatliche Gesamtausgaben';
      case 'el': return 'Συνολικά Μηνιαία Έξοδα';
      case 'es': return 'Gasto Mensual Total';
      case 'fr': return 'Dépenses Mensuelles Totales';
      case 'pt': return 'Despesa Mensal Total';
      case 'en': return 'Total Monthly Expense';
      case 'tr':
      default: return 'Toplam Aylık Gider';
    }
  }

  String get paymentTypeRequired {
    switch (currentLang) {
      case 'az': return 'Ödəniş növünün seçilməsi məcburidir.';
      case 'de': return 'Die Auswahl der Zahlungsart ist erforderlich.';
      case 'el': return 'Απαιτείται επιλογή τρόπου πληρωμής.';
      case 'es': return 'La selección del tipo de pago es obligatoria.';
      case 'fr': return 'La sélection du type de paiement est obligatoire.';
      case 'pt': return 'A seleção do tipo de pagamento é obrigatória.';
      case 'en': return 'Payment type selection is required.';
      case 'tr':
      default: return 'Ödeme türü seçimi zorunludur.';
    }
  }

  String get recurringExpenses {
    switch (currentLang) {
      case 'az': return 'Təkrarlanan Xərclər';
      case 'de': return 'Wiederkehrende Ausgaben';
      case 'el': return 'Επαναλαμβανόμενα Έξοδα';
      case 'es': return 'Gastos Recurrentes';
      case 'fr': return 'Dépenses Récurrentes';
      case 'pt': return 'Despesas Recorrentes';
      case 'en': return 'Recurring Expenses';
      case 'tr':
      default: return 'Tekrarlayan Harcamalar';
    }
  }

  String get recurringExpensesDesc {
    switch (currentLang) {
      case 'az': return 'Xərc əlavə edərkən sürətli doldurulma və avtomatik kateqoriya uyğunlaşdırılması üçün şablonları idarə edin.';
      case 'de': return 'Verwalten Sie Vorlagen für schnelles Ausfüllen und automatische Kategoriezuordnung beim Hinzufügen von Ausgaben.';
      case 'el': return 'Διαχειριστείτε πρότυπα για γρήγορη συμπλήρωση και αυτόματη αντιστοίχιση κατηγοριών κατά την προσθήκη εξόδων.';
      case 'es': return 'Gestione plantillas para un llenado rápido y asignación automática de categorías al agregar gastos.';
      case 'fr': return 'Gérez les modèles pour un remplissage rapide et une attribution automatique de catégorie lors de l\'ajout de dépenses.';
      case 'pt': return 'Gerencie modelos para preenchimento rápido e atribuição automática de categoria ao adicionar despesas.';
      case 'en': return 'Manage templates for quick filling and automatic category mapping when adding expenses.';
      case 'tr':
      default: return 'Harcama eklerken hızlı dolum ve otomatik kategori eşleme için şablonları yönetin.';
    }
  }

  String get templateNameLabel {
    switch (currentLang) {
      case 'az': return 'Şablon Adı / Açıqlama';
      case 'de': return 'Vorlagenname / Beschreibung';
      case 'el': return 'Όνομα Προτύπου / Περιγραφή';
      case 'es': return 'Nombre de plantilla / Descripción';
      case 'fr': return 'Nom du modèle / Description';
      case 'pt': return 'Nome do modelo / Descrição';
      case 'en': return 'Template Name / Description';
      case 'tr':
      default: return 'Şablon Adı / Açıklama';
    }
  }

  String get templateNameHint {
    switch (currentLang) {
      case 'az': return 'Məs: Miqros Alış-verişi, Shell Benzin, Netflix...';
      case 'de': return 'Z.B.: Migros Einkauf, Shell Benzin, Netflix...';
      case 'el': return 'Π.χ.: Ψώνια Migros, Shell Βενζίνη, Netflix...';
      case 'es': return 'Ej: Compra Migros, Gasolina Shell, Netflix...';
      case 'fr': return 'Ex: Courses Migros, Essence Shell, Netflix...';
      case 'pt': return 'Ex: Compras Migros, Gasolina Shell, Netflix...';
      case 'en': return 'E.g.: Migros Shopping, Shell Petrol, Netflix...';
      case 'tr':
      default: return 'Örn: Migros Alışverişi, Shell Benzin, Netflix...';
    }
  }

  String get noTemplatesYet {
    switch (currentLang) {
      case 'az': return 'Hələ şablon əlavə edilməyib.';
      case 'de': return 'Noch keine Vorlagen hinzugefügt.';
      case 'el': return 'Δεν έχουν προστεθεί πρότυπα ακόμη.';
      case 'es': return 'Aún no se han añadido plantillas.';
      case 'fr': return 'Aucun modèle ajouté pour le moment.';
      case 'pt': return 'Nenhum modelo adicionado ainda.';
      case 'en': return 'No templates added yet.';
      case 'tr':
      default: return 'Henüz şablon eklenmedi.';
    }
  }

  String get unknown {
    switch (currentLang) {
      case 'az': return 'Bilinməyən';
      case 'de': return 'Unbekannt';
      case 'el': return 'Άγνωστος';
      case 'es': return 'Desconocido';
      case 'fr': return 'Inconnu';
      case 'pt': return 'Desconhecido';
      case 'en': return 'Unknown';
      case 'tr':
      default: return 'Bilinmeyen';
    }
  }

  String get deleted {
    switch (currentLang) {
      case 'az': return 'silindi';
      case 'de': return 'gelöscht';
      case 'el': return 'διαγράφηκε';
      case 'es': return 'eliminado';
      case 'fr': return 'supprimé';
      case 'pt': return 'excluído';
      case 'en': return 'deleted';
      case 'tr':
      default: return 'silindi';
    }
  }

  String get transactionsTitle {
    switch (currentLang) {
      case 'az': return 'Əməliyyatlar';
      case 'de': return 'Transaktionen';
      case 'el': return 'Συναλλαγές';
      case 'es': return 'Transacciones';
      case 'fr': return 'Transactions';
      case 'pt': return 'Transações';
      case 'en': return 'Transactions';
      case 'tr':
      default: return 'İşlemler';
    }
  }

  String get periodAndRolloverSettings {
    switch (currentLang) {
      case 'az': return 'Dövr və Transfer Ayarları';
      case 'de': return 'Abrechnungszeitraum-Einstellungen';
      case 'el': return 'Ρυθμίσεις Περιόδου & Μεταφοράς';
      case 'es': return 'Configuración de Período y Traspaso';
      case 'fr': return 'Paramètres de Période et Report';
      case 'pt': return 'Configurações de Período e Rolover';
      case 'en': return 'Period & Rollover Settings';
      case 'tr':
      default: return 'Dönem ve Devir Ayarları';
    }
  }

  String get periodAndRolloverSettingsDesc {
    switch (currentLang) {
      case 'az': return 'Aylıq başlanğıc günü və transfer variantları';
      case 'de': return 'Monatlicher Starttag und Übertragungsoptionen';
      case 'el': return 'Μηνιαία ημέρα έναρξης και επιλογές μεταφοράς';
      case 'es': return 'Día de inicio mensual y opciones de traspaso';
      case 'fr': return 'Jour de début mensuel et options de report';
      case 'pt': return 'Dia de início mensal e opções de rolover';
      case 'en': return 'Monthly start day and rollover options';
      case 'tr':
      default: return 'Aylık başlangıç günü ve devir seçenekleri';
    }
  }

  String get categoriesAndAccounts {
    switch (currentLang) {
      case 'az': return 'Kateqoriyalar və Hesablar';
      case 'de': return 'Kategorien & Konten';
      case 'el': return 'Κατηγορίες & Λογαριασμοί';
      case 'es': return 'Categorías y Cuentas';
      case 'fr': return 'Catégories & Comptes';
      case 'pt': return 'Categorias & Contas';
      case 'en': return 'Categories & Accounts';
      case 'tr':
      default: return 'Kategoriler ve Hesaplar';
    }
  }

  String get myAccounts {
    switch (currentLang) {
      case 'az': return 'Hesablarım';
      case 'de': return 'Meine Konten';
      case 'el': return 'Οι λογαριασμοί μου';
      case 'es': return 'Mis Cuentas';
      case 'fr': return 'Mes Comptes';
      case 'pt': return 'Minhas Contas';
      case 'en': return 'My Accounts';
      case 'tr':
      default: return 'Hesaplarım';
    }
  }

  String get myAccountsDesc {
    switch (currentLang) {
      case 'az': return 'Nağd pul, bank və kredit kartı əlavə edin / redaktə edin';
      case 'de': return 'Bargeld, Bank- und Kreditkarten hinzufügen / bearbeiten';
      case 'el': return 'Προσθήκη / επεξεργασία μετρητών, τραπεζικών λογαριασμών και πιστωτικών καρτών';
      case 'es': return 'Agregar / editar efectivo, cuentas bancarias y tarjetas de crédito';
      case 'fr': return 'Ajouter / modifier des espèces, des comptes bancaires et des cartes de crédit';
      case 'pt': return 'Adicionar / editar dinheiro, contas bancárias e cartões de crédito';
      case 'en': return 'Add / edit cash, bank accounts and credit cards';
      case 'tr':
      default: return 'Nakit, banka ve kredi kartı ekle / düzenle';
    }
  }

  String get recurringExpensesDescSetting {
    switch (currentLang) {
      case 'az': return 'Sıx istifadə olunan xərclər üçün avtomatik doldurma şablonları';
      case 'de': return 'Automatische Ausfüllvorlagen für häufig genutzte Ausgaben';
      case 'el': return 'Πρότυπα αυτόματης συμπλήρωσης για συχνά έξοδα';
      case 'es': return 'Plantillas de llenado automático para gastos frecuentes';
      case 'fr': return 'Modèles de remplissage automatique pour les dépenses fréquentes';
      case 'pt': return 'Modelos de preenchimento automático para despesas frequentes';
      case 'en': return 'Auto-complete templates for frequently used expenses';
      case 'tr':
      default: return 'Sık kullanılan harcamalar için otomatik tamamlama şablonları';
    }
  }

  String get categoryBudgets {
    switch (currentLang) {
      case 'az': return 'Kateqoriya Büdcələri';
      case 'de': return 'Kategorie-Budgets';
      case 'el': return 'Προϋπολογισμοί Κατηγοριών';
      case 'es': return 'Presupuestos de Categorías';
      case 'fr': return 'Budgets de Catégorie';
      case 'pt': return 'Orçamentos de Categorias';
      case 'en': return 'Category Budgets';
      case 'tr':
      default: return 'Kategori Bütçeleri';
    }
  }

  String get categoryBudgetsDesc {
    switch (currentLang) {
      case 'az': return 'Kateqoriyalar üzrə aylıq xərc limitlərini təyin edin və izləyin';
      case 'de': return 'Legen Sie monatliche Ausgabenlimits nach Kategorien fest und verfolgen Sie diese';
      case 'el': return 'Ορίστε και παρακολουθήστε μηνιαία όρια εξόδων ανά κατηγορία';
      case 'es': return 'Establezca y realice un seguimiento de los límites de gastos mensuales por categoría';
      case 'fr': return 'Définissez et suivez les limites de dépenses mensuelles par catégorie';
      case 'pt': return 'Defina e acompanhe limites de gastos mensais por categoria';
      case 'en': return 'Set and track monthly spending limits by category';
      case 'tr':
      default: return 'Kategorilere göre aylık harcama limitlerini belirleyin ve takip edin';
    }
  }

  String get comingSoon {
    switch (currentLang) {
      case 'az': return 'Tezliklə gələcək! ⏳';
      case 'de': return 'Demnächst verfügbar! ⏳';
      case 'el': return 'Έρχεται σύντομα! ⏳';
      case 'es': return '¡Próximamente! ⏳';
      case 'fr': return 'Prochainement! ⏳';
      case 'pt': return 'Em breve! ⏳';
      case 'en': return 'Coming soon! ⏳';
      case 'tr':
      default: return 'Yakında gelecek! ⏳';
    }
  }

  String get addBudget {
    switch (currentLang) {
      case 'az': return 'Yeni Büdcə Əlavə Et';
      case 'de': return 'Neues Budget hinzufügen';
      case 'el': return 'Προσθήκη νέου προϋπολογισμού';
      case 'es': return 'Agregar nuevo presupuesto';
      case 'fr': return 'Ajouter un nouveau budget';
      case 'pt': return 'Adicionar novo orçamento';
      case 'en': return 'Add New Budget';
      case 'tr':
      default: return 'Yeni Bütçe Ekle';
    }
  }

  String get deleteBudgetConfirm {
    switch (currentLang) {
      case 'az': return 'Bu kateqoriyanın büdcə hədəfini silmək istədiyinizə əminsiniz?';
      case 'de': return 'Möchten Sie das Budgetziel für diese Kategorie wirklich löschen?';
      case 'el': return 'Είστε βέβαιοι ότι θέλετε να διαγράψετε τον στόχο προϋπολογισμού για αυτήν την κατηγορία;';
      case 'es': return '¿Está seguro de que desea eliminar el objetivo de presupuesto para esta categoría?';
      case 'fr': return 'Êtes-vous sûr de vouloir supprimer l\'objectif budgétaire de cette catégorie ?';
      case 'pt': return 'Tem certeza de que deseja excluir a meta de orçamento para esta categoria?';
      case 'en': return 'Are you sure you want to delete the budget goal for this category?';
      case 'tr':
      default: return 'Bu kategorinin bütçe hedefini silmek istediğinize emin misiniz?';
    }
  }

  String get budgetDeleted {
    switch (currentLang) {
      case 'az': return 'Büdcə silindi.';
      case 'de': return 'Budget gelöscht.';
      case 'el': return 'Ο προϋπολογισμός διαγράφηκε.';
      case 'es': return 'Presupuesto eliminado.';
      case 'fr': return 'Budget supprimé.';
      case 'pt': return 'Orçamento excluído.';
      case 'en': return 'Budget deleted.';
      case 'tr':
      default: return 'Bütçe silindi.';
    }
  }

  String get selectCategory {
    switch (currentLang) {
      case 'az': return 'Kateqoriya Seçin';
      case 'de': return 'Kategorie wählen';
      case 'el': return 'Επιλογή κατηγορίας';
      case 'es': return 'Seleccionar categoría';
      case 'fr': return 'Sélectionner une catégorie';
      case 'pt': return 'Selecionar categoria';
      case 'en': return 'Select Category';
      case 'tr':
      default: return 'Kategori Seçin';
    }
  }

  String get enterLimit {
    switch (currentLang) {
      case 'az': return 'Limit Məbləği Daxil Edin';
      case 'de': return 'Limitbetrag eingeben';
      case 'el': return 'Εισαγωγή ποσού ορίου';
      case 'es': return 'Ingresar monto límite';
      case 'fr': return 'Saisir le montant limite';
      case 'pt': return 'Inserir valor limite';
      case 'en': return 'Enter Limit Amount';
      case 'tr':
      default: return 'Limit Tutarı Girin';
    }
  }

  String get categoryAlreadyHasBudget {
    switch (currentLang) {
      case 'az': return 'Bu kateqoriya üçün artıq büdcə təyin edilib!';
      case 'de': return 'Für diese Kategorie ist bereits ein Budget definiert!';
      case 'el': return 'Έχει ήδη οριστεί προϋπολογισμός για αυτήν την κατηγορία!';
      case 'es': return '¡Ya se ha definido un presupuesto para esta categoría!';
      case 'fr': return 'Un budget est déjà défini pour cette catégorie !';
      case 'pt': return 'Já existe um orçamento definido para esta categoria!';
      case 'en': return 'This category already has a budget defined!';
      case 'tr':
      default: return 'Bu kategori için zaten bütçe tanımlanmış!';
    }
  }

  String get pleaseSelectCategory {
    switch (currentLang) {
      case 'az': return 'Zəhmət olmasa bir kateqoriya seçin';
      case 'de': return 'Bitte wählen Sie eine Kategorie';
      case 'el': return 'Παρακαλώ επιλέξτε μια κατηγορία';
      case 'es': return 'Por favor seleccione una categoría';
      case 'fr': return 'Veuillez sélectionner une catégorie';
      case 'pt': return 'Por favor selecione uma categoria';
      case 'en': return 'Please select a category';
      case 'tr':
      default: return 'Lütfen bir kategori seçin';
    }
  }

  String get pleaseEnterValidLimit {
    switch (currentLang) {
      case 'az': return 'Zəhmət olmasa etibarlı bir limit daxil edin';
      case 'de': return 'Bitte geben Sie ein gültiges Limit ein';
      case 'el': return 'Παρακαλώ εισάγετε ένα έγκυρο όριο';
      case 'es': return 'Por favor ingrese un límite válido';
      case 'fr': return 'Veuillez saisir une limite valide';
      case 'pt': return 'Por favor insira um limite válido';
      case 'en': return 'Please enter a valid limit';
      case 'tr':
      default: return 'Lütfen geçerli bir limit girin';
    }
  }

  String get budgetAdded {
    switch (currentLang) {
      case 'az': return 'Büdcə uğurla əlavə edildi!';
      case 'de': return 'Budget erfolgreich hinzugefügt!';
      case 'el': return 'Ο προϋπολογισμός προστέθηκε με επιτυχία!';
      case 'es': return '¡Presupuesto agregado con éxito!';
      case 'fr': return 'Budget ajouté avec succès !';
      case 'pt': return 'Orçamento adicionado com sucesso!';
      case 'en': return 'Budget added successfully!';
      case 'tr':
      default: return 'Bütçe başarıyla eklendi!';
    }
  }

  String get addLabel {
    switch (currentLang) {
      case 'az': return 'Əlavə et';
      case 'de': return 'Hinzufügen';
      case 'el': return 'Προσθήκη';
      case 'es': return 'Agregar';
      case 'fr': return 'Ajouter';
      case 'pt': return 'Adicionar';
      case 'en': return 'Add';
      case 'tr':
      default: return 'Ekle';
    }
  }

  String get noBudgetsScreenDesc {
    switch (currentLang) {
      case 'az': return 'Hələ heç bir büdcə təyin etməmisiniz. Sağ üst küncdəki "+" düyməsindən istifadə edərək ilk büdcə hədəfinizi əlavə edə bilərsiniz.';
      case 'de': return 'Sie haben noch keine Budgets definiert. Sie können Ihr erstes Budgetziel mit der Schaltfläche "+" in der oberen rechten Ecke hinzufügen.';
      case 'el': return 'Δεν έχετε ορίσει ακόμη προϋπολογισμούς. Μπορείτε να προσθέσετε τον πρώτο σας στόχο προϋπολογισμού χρησιμοποιώντας το κουμπί "+" στην επάνω δεξιά γωνία.';
      case 'es': return 'Aún no ha definido ningún presupuesto. Puede agregar su primer objetivo de presupuesto usando el botón "+" en la esquina superior derecha.';
      case 'fr': return 'Vous n\'avez pas encore défini de budget. Vous pouvez ajouter votre premier objectif budgétaire en utilisant le bouton "+" dans le coin supérieur droit.';
      case 'pt': return 'Você ainda não definiu nenhum orçamento. Você pode adicionar sua primeira meta de orçamento usando o botão "+" no canto superior direito.';
      case 'en': return 'You haven\'t defined any budgets yet. You can add your first budget goal using the "+" button in the top right corner.';
      case 'tr':
      default: return 'Henüz bütçe tanımlamadınız. Sağ üst köşedeki "+" butonunu kullanarak ilk bütçe hedefinizi ekleyebilirsiniz.';
    }
  }

  String get budgetCategoryName {
    switch (currentLang) {
      case 'az': return 'Büdcə / Kateqoriya Adı';
      case 'de': return 'Budget- / Kategoriename';
      case 'el': return 'Όνομα Προϋπολογισμού / Κατηγορίας';
      case 'es': return 'Nombre de Presupuesto / Categoría';
      case 'fr': return 'Nom du Budget / de la Catégorie';
      case 'pt': return 'Nome do Orçamento / Categoria';
      case 'en': return 'Budget / Category Name';
      case 'tr':
      default: return 'Bütçe / Kategori Adı';
    }
  }

  String get limitAmountLabel {
    switch (currentLang) {
      case 'az': return 'Limit Məbləği';
      case 'de': return 'Limitbetrag';
      case 'el': return 'Ποσό Ορίου';
      case 'es': return 'Monto Límite';
      case 'fr': return 'Montant Limite';
      case 'pt': return 'Valor Limite';
      case 'en': return 'Limit Amount';
      case 'tr':
      default: return 'Limit Tutarı';
    }
  }

  String get pleaseEnterBudgetName {
    switch (currentLang) {
      case 'az': return 'Zəhmət olmasa büdcə adı daxil edin';
      case 'de': return 'Bitte geben Sie einen Budgetnamen ein';
      case 'el': return 'Παρακαλώ εισάγετε ένα όνομα προϋπολογισμού';
      case 'es': return 'Por favor ingrese un nombre de presupuesto';
      case 'fr': return 'Veuillez saisir un nom de budget';
      case 'pt': return 'Por favor insira um nome de orçamento';
      case 'en': return 'Please enter a budget name';
      case 'tr':
      default: return 'Lütfen bir bütçe adı girin';
    }
  }

  String get pleaseSelectDocumentOrPhoto {
    switch (currentLang) {
      case 'az': return 'Zəhmət olmasa bir sənəd və ya fotoşəkil seçin.';
      case 'de': return 'Bitte wählen Sie ein Dokument oder ein Foto aus.';
      case 'el': return 'Παρακαλώ επιλέξτε ένα έγγραφο ή μια φωτογραφία.';
      case 'es': return 'Por favor seleccione un documento o foto.';
      case 'fr': return 'Veuillez sélectionner un document ou une photo.';
      case 'pt': return 'Por favor, selecione um documento ou foto.';
      case 'en': return 'Please select a document or photo.';
      case 'tr':
      default: return 'Lütfen bir belge veya fotoğraf seçin.';
    }
  }

  String get noUpcomingWarranties {
    switch (currentLang) {
      case 'az': return 'Yaxınlaşan zəmanət bitməsi yoxdur. 👍';
      case 'de': return 'Keine anstehenden Garantieabläufe. 👍';
      case 'el': return 'Δεν υπάρχουν προσεχείς λήξεις εγγύησης. 👍';
      case 'es': return 'No hay vencimientos de garantía próximos. 👍';
      case 'fr': return 'Aucune expiration de garantie à venir. 👍';
      case 'pt': return 'Nenhum vencimento de garantia próximo. 👍';
      case 'en': return 'No upcoming warranty expirations. 👍';
      case 'tr':
      default: return 'Yaklaşan garanti bitişi bulunmuyor. 👍';
    }
  }

  String get noUpcomingPayments {
    switch (currentLang) {
      case 'az': return 'Yaxınlaşan ödəniş yoxdur. 👍';
      case 'de': return 'Keine anstehenden Zahlungen. 👍';
      case 'el': return 'Δεν υπάρχουν προσεχείς πληρωμές. 👍';
      case 'es': return 'No hay pagos próximos. 👍';
      case 'fr': return 'Aucun paiement à venir. 👍';
      case 'pt': return 'Nenhum pagamento próximo. 👍';
      case 'en': return 'No upcoming payments. 👍';
      case 'tr':
      default: return 'Yaklaşan ödeme bulunmuyor. 👍';
    }
  }

  String get editProduct {
    switch (currentLang) {
      case 'az': return 'Məhsulu redaktə et';
      case 'de': return 'Produkt bearbeiten';
      case 'el': return 'Επεξεργασία προϊόντος';
      case 'es': return 'Editar producto';
      case 'fr': return 'Modifier le produit';
      case 'pt': return 'Editar produto';
      case 'en': return 'Edit Product';
      case 'tr':
      default: return 'Ürünü Düzenle';
    }
  }

  String get locationLabel {
    switch (currentLang) {
      case 'az': return 'Məkan';
      case 'de': return 'Standort';
      case 'el': return 'Τοποθεσία';
      case 'es': return 'Ubicación';
      case 'fr': return 'Emplacement';
      case 'pt': return 'Localização';
      case 'en': return 'Location';
      case 'tr':
      default: return 'Konum';
    }
  }

  String get locationHint {
    switch (currentLang) {
      case 'az': return 'Məs: Soyuducu, Anbar...';
      case 'de': return 'Z.B.: Kühlschrank, Speisekammer...';
      case 'el': return 'Π.χ.: Ψυγείο, Τροφοθήκη...';
      case 'es': return 'Ej: Nevera, Despensa...';
      case 'fr': return 'Ex: Réfrigérateur, Cellier...';
      case 'pt': return 'Ex: Geladeira, Despensa...';
      case 'en': return 'Ex: Fridge, Pantry...';
      case 'tr':
      default: return 'Örn: Buzdolabı, Kiler...';
    }
  }

  String get locationRequired {
    switch (currentLang) {
      case 'az': return 'Məkan tələb olunur.';
      case 'de': return 'Standort ist erforderlich.';
      case 'el': return 'Η τοποθεσία είναι υποχρεωτική.';
      case 'es': return 'La ubicación es requerida.';
      case 'fr': return 'L\'emplacement est requis.';
      case 'pt': return 'Localização é obrigatória.';
      case 'en': return 'Location is required.';
      case 'tr':
      default: return 'Konum zorunludur.';
    }
  }

  String get additionalNotesHint {
    switch (currentLang) {
      case 'az': return 'Əlavə qeydlər əlavə edin...';
      case 'de': return 'Zusätzliche Notizen hinzufügen...';
      case 'el': return 'Προσθήκη επιπλέον σημειώσεων...';
      case 'es': return 'Agregar notas adicionales...';
      case 'fr': return 'Ajouter des notes supplémentaires...';
      case 'pt': return 'Adicionar notas adicionais...';
      case 'en': return 'Add additional notes...';
      case 'tr':
      default: return 'Ek bilgi ekleyin...';
    }
  }

  String get selectExpirationDateWarning {
    switch (currentLang) {
      case 'az': return 'Zəhmət olmasa son istifadə tarixini seçin.';
      case 'de': return 'Bitte Ablaufdatum auswählen.';
      case 'el': return 'Παρακαλώ επιλέξτε ημερομηνία λήξης.';
      case 'es': return 'Por favor seleccione la fecha de vencimiento.';
      case 'fr': return 'Veuillez sélectionner la date d\'expiration.';
      case 'pt': return 'Por favor selecione a data de validade.';
      case 'en': return 'Please select expiration date.';
      case 'tr':
      default: return 'Lütfen son kullanma tarihini seçin.';
    }
  }

  String get productNameExampleHint {
    switch (currentLang) {
      case 'az': return 'Məs: Süd, Yumurta...';
      case 'de': return 'Z.B.: Milch, Eier...';
      case 'el': return 'Π.χ.: Γάλα, Αυγά...';
      case 'es': return 'Ej: Leche, Huevos...';
      case 'fr': return 'Ex: Lait, Œufs...';
      case 'pt': return 'Ex: Leite, Ovos...';
      case 'en': return 'Ex: Milk, Eggs...';
      case 'tr':
      default: return 'Örn: Süt, Yumurta...';
    }
  }

  String get selectDate {
    switch (currentLang) {
      case 'az': return 'Tarix seçin';
      case 'de': return 'Datum auswählen';
      case 'el': return 'Επιλέξτε ημερομηνία';
      case 'es': return 'Seleccionar fecha';
      case 'fr': return 'Sélectionner une date';
      case 'pt': return 'Selecionar data';
      case 'en': return 'Select Date';
      case 'tr':
      default: return 'Tarih Seçiniz';
    }
  }

  String get signInBtn {
    switch (currentLang) {
      case 'az': return 'Giriş et';
      case 'de': return 'Anmelden';
      case 'el': return 'Σύνδεση';
      case 'es': return 'Iniciar sesión';
      case 'fr': return 'Se connecter';
      case 'pt': return 'Entrar';
      case 'en': return 'Sign In';
      case 'tr':
      default: return 'Giriş Yap';
    }
  }

  String get signInFailed {
    switch (currentLang) {
      case 'az': return 'Giriş uğursuz oldu.';
      case 'de': return 'Anmeldung fehlgeschlagen.';
      case 'el': return 'Η σύνδεση απέτυχε.';
      case 'es': return 'Error al iniciar sesión.';
      case 'fr': return 'Échec de la connexion.';
      case 'pt': return 'Falha ao entrar.';
      case 'en': return 'Sign-in failed.';
      case 'tr':
      default: return 'Giriş yapılamadı.';
    }
  }

  String get emailHint {
    switch (currentLang) {
      case 'az':
      case 'tr':
        return 'ornek@gmail.com';
      case 'de':
      case 'el':
      case 'es':
      case 'fr':
      case 'pt':
      case 'en':
      default:
        return 'example@gmail.com';
    }
  }

  String get guestUser {
    switch (currentLang) {
      case 'az': return 'Qonaq';
      case 'de': return 'Gast';
      case 'el': return 'Επισκέπτης';
      case 'es': return 'Invitado';
      case 'fr': return 'Invité';
      case 'pt': return 'Convidado';
      case 'en': return 'Guest';
      case 'tr':
      default: return 'Misafir';
    }
  }

  String get deleteAccountConfirmDesc {
    switch (currentLang) {
      case 'az': return 'Hesabınızı və bütün şəxsi məlumatlarınızı silmək istədiyinizdən əminsiniz? Bu əməliyyat geri qaytarıla bilməz.';
      case 'de': return 'Möchten Sie Ihr Konto und alle persönlichen Daten wirklich löschen? Dies kann nicht rückgängig gemacht werden.';
      case 'el': return 'Είστε βέβαιοι ότι θέλετε να διαγράψετε το λογαριασμό σας και όλα τα προσωπικά σας δεδομένα; Αυτή η ενέργεια δεν μπορεί να αναιρεθεί.';
      case 'es': return '¿Está seguro de que desea eliminar su cuenta y todos sus datos personales? Esta acción no se puede deshacer.';
      case 'fr': return 'Êtes-vous sûr de vouloir supprimer votre compte et toutes vos données personnelles ? Cette action est irréversible.';
      case 'pt': return 'Tem certeza de que deseja excluir sua conta e todos os seus dados pessoais? Esta ação não pode ser desfeita.';
      case 'en': return 'Are you sure you want to delete your account and all personal data? This action cannot be undone.';
      case 'tr':
      default: return 'Hesabınızı ve tüm kişisel verilerinizi silmek istediğinize emin misiniz? Bu işlem geri alınamaz.';
    }
  }

  String get deleteAccountConfirmBtn {
    switch (currentLang) {
      case 'az': return 'Bəli, sil';
      case 'de': return 'Ja, löschen';
      case 'el': return 'Ναι, διαγραφή';
      case 'es': return 'Sí, eliminar';
      case 'fr': return 'Oui, supprimer';
      case 'pt': return 'Sim, excluir';
      case 'en': return 'Yes, Delete';
      case 'tr':
      default: return 'Evet, Sil';
    }
  }

  String get deleteAccountReauthNotice {
    switch (currentLang) {
      case 'az': return 'Təhlükəsizlik səbəbiylə hesabınızı silmək üçün zəhmət olmasa çıxış edib yenidən daxil olun.';
      case 'de': return 'Aus Sicherheitsgründen melden Sie sich bitte ab und wieder an, um Ihr Konto zu löschen.';
      case 'el': return 'Για λόγους ασφαλείας, παρακαλώ αποσυνδεθείτε και συνδεθείτε ξανά για να διαγράψετε το λογαριασμό σας.';
      case 'es': return 'Por razones de seguridad, inicie sesión de nuevo para eliminar su cuenta.';
      case 'fr': return 'Pour des raisons de sécurité, veuillez vous déconnecter puis vous reconnecter pour supprimer votre compte.';
      case 'pt': return 'Por razões de segurança, faça login novamente para excluir sua conta.';
      case 'en': return 'For security reasons, please log out and log back in to delete your account.';
      case 'tr':
      default: return 'Güvenlik nedeniyle hesabınızı silmek için lütfen çıkış yapıp tekrar giriş yapın.';
    }
  }

  String get adFreeActiveTitle {
    switch (currentLang) {
      case 'az': return 'Reklamsız Versiya Aktivdir ✨';
      case 'de': return 'Werbefreie Version aktiv ✨';
      case 'el': return 'Έκδοση χωρίς διαφημίσεις ενεργή ✨';
      case 'es': return 'Versión sin anuncios activa ✨';
      case 'fr': return 'Version sans pub active ✨';
      case 'pt': return 'Versão sem anúncios ativa ✨';
      case 'en': return 'Ad-Free Version Active ✨';
      case 'tr':
      default: return 'Reklamsız Gösterim Aktif ✨';
    }
  }

  String get adFreeActiveDesc {
    switch (currentLang) {
      case 'az': return 'Reklamlardan tamamilə azad oldunuz, tətbiqdən həzz alın!';
      case 'de': return 'Sie haben Werbung vollständig entfernt, genießen Sie die App!';
      case 'el': return 'Έχετε αφαιρέσει εντελώς τις διαφημίσεις, απολαύστε την εφαρμογή!';
      case 'es': return '¡Has eliminado los anuncios por completo, disfruta de la aplicación!';
      case 'fr': return 'Vous avez supprimé les publicités, profitez de l\'application !';
      case 'pt': return 'Você removeu todos os anúncios, aproveite o aplicativo!';
      case 'en': return 'You\'ve completely removed ads, enjoy the app experience!';
      case 'tr':
      default: return 'Reklamlardan tamamen kurtuldunuz, uygulamanın keyfini çıkarın!';
    }
  }

  String get activeBadge {
    switch (currentLang) {
      case 'az': return 'AKTİV';
      case 'de': return 'AKTIV';
      case 'el': return 'ΕΝΕΡΓΟ';
      case 'es': return 'ACTIVO';
      case 'fr': return 'ACTIF';
      case 'pt': return 'ATIVO';
      case 'en': return 'ACTIVE';
      case 'tr':
      default: return 'AKTİF';
    }
  }

  String get buyAdFreeTitle {
    switch (currentLang) {
      case 'az': return 'Reklamsız Versiya Alın';
      case 'de': return 'Werbefreie Version kaufen';
      case 'el': return 'Αγορά έκδοσης χωρίς διαφημίσεις';
      case 'es': return 'Obtener versión sin anuncios';
      case 'fr': return 'Obtenir la version sans pub';
      case 'pt': return 'Obter versão sem anúncios';
      case 'en': return 'Get Ad-Free Version';
      case 'tr':
      default: return 'Reklamsız Gösterim Satın Al';
    }
  }

  String get buyAdFreeDesc {
    switch (currentLang) {
      case 'az': return 'Tətbiq daxilində bütün reklamları silin, fasiləsiz təcrübə yaşayın.';
      case 'de': return 'Entfernen Sie alle Anzeigen in der App für ein unterbrechungsfreies Erlebnis.';
      case 'el': return 'Αφαιρέστε όλες τις διαφημίσεις για μια εμπειρία χωρίς διακοπές.';
      case 'es': return 'Elimine todos los anuncios en la aplicación para una experiencia sin interrupciones.';
      case 'fr': return 'Supprimez toutes les publicités pour une expérience sans interruption.';
      case 'pt': return 'Remova todos os anúncios do app para uma experiência sem interrupções.';
      case 'en': return 'Remove all ads across the app, enjoy an uninterrupted experience.';
      case 'tr':
      default: return 'Uygulama genelinde tüm reklamları kaldırın, kesintisiz bir deneyim yaşayın.';
    }
  }

  String get monthlyYearlyFlexiblePlans {
    switch (currentLang) {
      case 'az': return 'Aylıq və İllik Çevik Planlar';
      case 'de': return 'Monatliche & Jährliche Flexible Pläne';
      case 'el': return 'Μηνιαία & Ετήσια Ευέλικτα Σχέδια';
      case 'es': return 'Planes flexibles mensuales y anuales';
      case 'fr': return 'Plans flexibles mensuels et annuels';
      case 'pt': return 'Planos flexíveis mensais e anuais';
      case 'en': return 'Monthly & Yearly Flexible Plans';
      case 'tr':
      default: return 'Aylık & Yıllık Esnek Planlar';
    }
  }

  String get inspectAndBuyPlans {
    switch (currentLang) {
      case 'az': return 'Planları İncələ və Al';
      case 'de': return 'Pläne ansehen & wählen';
      case 'el': return 'Προβολή σχεδίων & αγορά';
      case 'es': return 'Ver planes y comprar';
      case 'fr': return 'Voir les offres et acheter';
      case 'pt': return 'Ver planos e adquirir';
      case 'en': return 'Inspect & Choose Plan';
      case 'tr':
      default: return 'Planları İncele & Satın Al';
    }
  }

  String get adFreeTitle {
    switch (currentLang) {
      case 'az': return 'Reklamsız Göstəriş';
      case 'de': return 'Werbefreie Version';
      case 'el': return 'Έκδοση χωρίς διαφημίσεις';
      case 'es': return 'Versión sin anuncios';
      case 'fr': return 'Version sans publicité';
      case 'pt': return 'Versão sem anúncios';
      case 'en': return 'Ad-Free Version';
      case 'tr':
      default: return 'Reklamsız Gösterim';
    }
  }

  String get adFreeHeaderSubtitle {
    switch (currentLang) {
      case 'az': return 'Bütün reklamları silin, fasiləsiz və sürətli təcrübə yaşayın.';
      case 'de': return 'Entfernen Sie alle Anzeigen für ein nahtloses und schnelles Erlebnis.';
      case 'el': return 'Αφαιρέστε όλες τις διαφημίσεις για μια γρήγορη και ομαλή εμπειρία.';
      case 'es': return 'Elimine todos los anuncios para una experiencia rápida y fluida.';
      case 'fr': return 'Supprimez toutes les publicités pour une expérience rapide et fluide.';
      case 'pt': return 'Remova todos os anúncios para uma experiência rápida e contínua.';
      case 'en': return 'Remove all ads for a seamless and fast home experience.';
      case 'tr':
      default: return 'Tüm reklamları kaldırın, kesintisiz ve hızlı bir deneyim yaşayın.';
    }
  }

  String get zeroAdsTitle {
    switch (currentLang) {
      case 'az': return 'Sıfır Reklam, Fasiləsiz İstifadə';
      case 'de': return 'Null Werbung, Nahtlose Nutzung';
      case 'el': return 'Μηδέν διαφημίσεις, ομαλή χρήση';
      case 'es': return 'Cero anuncios, uso sin interrupciones';
      case 'fr': return 'Zéro publicité, utilisation fluide';
      case 'pt': return 'Zero anúncios, uso contínuo';
      case 'en': return 'Zero Ads, Seamless Usage';
      case 'tr':
      default: return 'Sıfır Reklam, Kesintisiz Kullanım';
    }
  }

  String get zeroAdsSubtitle {
    switch (currentLang) {
      case 'az': return 'Səhifə keçidlərində və əməliyyatlarda bütün reklamlar bloklanır.';
      case 'de': return 'Alle Anzeigen bei Seitenübergängen und Aktionen werden blockiert.';
      case 'el': return 'Όλες οι διαφημίσεις στις μεταβάσεις σελίδων αποκλείονται.';
      case 'es': return 'Todos los anuncios en transiciones de página son bloqueados.';
      case 'fr': return 'Toutes les publicités lors des transitions de page sont bloquées.';
      case 'pt': return 'Todos os anúncios em transições de página são bloqueados.';
      case 'en': return 'All pop-up and banner ads across screens are blocked.';
      case 'tr':
      default: return 'Sayfa geçişlerinde veya işlemlerde çıkan tüm reklamlar engellenir.';
    }
  }

  String get allFamilyIncludedTitle {
    switch (currentLang) {
      case 'az': return 'Bütün Ailə Üvləri Üçün Daxildir';
      case 'de': return 'Für alle Familienmitglieder enthalten';
      case 'el': return 'Περιλαμβάνεται για όλα τα μέλη της οικογένειας';
      case 'es': return 'Incluido para todos los miembros de la familia';
      case 'fr': return 'Inclus pour tous les membres de la famille';
      case 'pt': return 'Incluído para todos os membros da família';
      case 'en': return 'Included for All Family Members';
      case 'tr':
      default: return 'Tüm Aile Üyelerine Dahil';
    }
  }

  String get allFamilyIncludedSubtitle {
    switch (currentLang) {
      case 'az': return 'Ailənizdəki bütün fərdlər avtomatik olaraq reklamsız istifadə edir.';
      case 'de': return 'Jeder in Ihrem Haushalt erhält automatisch werbefreien Zugriff.';
      case 'el': return 'Όλοι στην οικογένειά σας αποκτούν αυτόματα πρόσβαση χωρίς διαφημίσεις.';
      case 'es': return 'Todos en su hogar obtienen acceso sin anuncios automáticamente.';
      case 'fr': return 'Tous les membres de votre foyer bénéficient de l\'accès sans pub.';
      case 'pt': return 'Todos na sua família recebem acesso sem anúncios automaticamente.';
      case 'en': return 'Everyone in your household gets ad-free access automatically.';
      case 'tr':
      default: return 'Ailenizdeki tüm bireyler otomatik olarak reklamsız kullanır.';
    }
  }

  String get fasterPageTransitionsTitle {
    switch (currentLang) {
      case 'az': return 'Daha Sürətli Səhifə Keçidləri';
      case 'de': return 'Schnellere Seitenübergänge';
      case 'el': return 'Ταχύτερες μεταβάσεις σελίδων';
      case 'es': return 'Transiciones de página más rápidas';
      case 'fr': return 'Transitions de page plus rapides';
      case 'pt': return 'Transições de página mais rápidas';
      case 'en': return 'Faster Page Transitions';
      case 'tr':
      default: return 'Daha Hızlı Sayfa Geçişleri';
    }
  }

  String get fasterPageTransitionsSubtitle {
    switch (currentLang) {
      case 'az': return 'Reklam yüklənmələri olmadan tətbiq daha yüngül və sürətli işləyir.';
      case 'de': return 'Die App läuft leichter und schneller ohne Werbelasten.';
      case 'el': return 'Η εφαρμογή εκτελείται πιο γρήγορα χωρίς τη φόρτωση διαφημίσεων.';
      case 'es': return 'La aplicación funciona más rápida sin la carga de anuncios.';
      case 'fr': return 'L\'application fonctionne plus rapidement sans le chargement de pubs.';
      case 'pt': return 'O aplicativo roda mais leve e rápido sem carregamento de anúncios.';
      case 'en': return 'App runs lighter and faster without ad loading overhead.';
      case 'tr':
      default: return 'Reklam yüklemeleri olmadan uygulama daha hafif ve hızlı çalışır.';
    }
  }

  String get annualPlanRecommended {
    switch (currentLang) {
      case 'az': return 'İllik Plan (Tövsiyə olunan)';
      case 'de': return 'Jahresplan (Empfohlen)';
      case 'el': return 'Ετήσιο σχέδιο (Συνιστάται)';
      case 'es': return 'Plan anual (Recomendado)';
      case 'fr': return 'Plan annuel (Recommandé)';
      case 'pt': return 'Plano anual (Recomendado)';
      case 'en': return 'Annual Plan (Recommended)';
      case 'tr':
      default: return 'Yıllık Plan (Önerilen)';
    }
  }

  String get save30Percent {
    switch (currentLang) {
      case 'az': return '%30 QƏNAƏT';
      case 'de': return '30% SPAREN';
      case 'el': return 'ΕΞΟΙΚΟΝΟΜΗΣΤΕ 30%';
      case 'es': return 'AHORRA 30%';
      case 'fr': return 'ÉCONOMISEZ 30%';
      case 'pt': return 'ECONOMIZE 30%';
      case 'en': return 'SAVE 30%';
      case 'tr':
      default: return '%30 TASARRUF';
    }
  }

  String get annualPlanSubprice {
    switch (currentLang) {
      case 'az': return 'İllik ödəniş ilə ən sərfəli qiymət';
      case 'de': return 'Bestes Angebot bei jährlicher Zahlung';
      case 'el': return 'Καλύτερη τιμή με ετήσια πληρωμή';
      case 'es': return 'Mejor precio con pago anual';
      case 'fr': return 'Meilleure valeur avec paiement annuel';
      case 'pt': return 'Melhor valor com pagamento anual';
      case 'en': return 'Best value with yearly payment';
      case 'tr':
      default: return 'En avantajlı fiyat ile yıllık ödeme';
    }
  }

  String get monthlyPlanTitle {
    switch (currentLang) {
      case 'az': return 'Aylıq Plan';
      case 'de': return 'Monatsplan';
      case 'el': return 'Μηνιαίο σχέδιο';
      case 'es': return 'Plan mensual';
      case 'fr': return 'Plan mensuel';
      case 'pt': return 'Plano mensal';
      case 'en': return 'Monthly Plan';
      case 'tr':
      default: return 'Aylık Plan';
    }
  }

  String get flexibleBadge {
    switch (currentLang) {
      case 'az': return 'ÇEVİK';
      case 'de': return 'FLEXIBEL';
      case 'el': return 'ΕΥΕΛΙΚΤΟ';
      case 'es': return 'FLEXIBLE';
      case 'fr': return 'FLEXIBLE';
      case 'pt': return 'FLEXÍVEL';
      case 'en': return 'FLEXIBLE';
      case 'tr':
      default: return 'ESNEK';
    }
  }

  String get cancelAnytimeSubprice {
    switch (currentLang) {
      case 'az': return 'İstədiyiniz vaxt asanlıqla ləğv edin';
      case 'de': return 'Jederzeit einfach kündbar';
      case 'el': return 'Ακυρώστε εύκολα ανά πάσα στιγμή';
      case 'es': return 'Cancela fácilmente en cualquier momento';
      case 'fr': return 'Annulez facilement à tout moment';
      case 'pt': return 'Cancele facilmente a qualquer momento';
      case 'en': return 'Cancel easily anytime';
      case 'tr':
      default: return 'İstediğin zaman kolayca iptal et';
    }
  }

  String get switchToAnnualPlan {
    switch (currentLang) {
      case 'az': return 'İllik Reklamsız Plana Keçin';
      case 'de': return 'Zum jährlichen werbefreien Plan wechseln';
      case 'el': return 'Μετάβαση στο ετήσιο σχέδιο χωρίς διαφημίσεις';
      case 'es': return 'Cambiar al plan anual sin anuncios';
      case 'fr': return 'Passer au plan annuel sans pub';
      case 'pt': return 'Mudar para o plano anual sem anúncios';
      case 'en': return 'Switch to Annual Ad-Free Plan';
      case 'tr':
      default: return 'Yıllık Reklamsız Plana Geç';
    }
  }

  String get switchToMonthlyPlan {
    switch (currentLang) {
      case 'az': return 'Aylıq Reklamsız Plana Keçin';
      case 'de': return 'Zum monatlichen werbefreien Plan wechseln';
      case 'el': return 'Μετάβαση στο μηνιαίο σχέδιο χωρίς διαφημίσεις';
      case 'es': return 'Cambiar al plan mensual sin anuncios';
      case 'fr': return 'Passer au plan mensuel sans pub';
      case 'pt': return 'Mudar para o plano mensal sem anúncios';
      case 'en': return 'Switch to Monthly Ad-Free Plan';
      case 'tr':
      default: return 'Aylık Reklamsız Plana Geç';
    }
  }

  String get cancelNoticeIos {
    switch (currentLang) {
      case 'az': return 'İstədiyiniz vaxt App Store / Apple ID tənzimləmələrinizdən ləğv edə bilərsiniz.';
      case 'de': return 'Sie können jederzeit in Ihren App Store / Apple ID Einstellungen kündigen.';
      case 'el': return 'Μπορείτε να ακυρώσετε ανά πάσα στιγμή στις ρυθμίσεις του App Store / Apple ID.';
      case 'es': return 'Puede cancelar en cualquier momento en los ajustes de App Store / Apple ID.';
      case 'fr': return 'Vous pouvez annuler à tout moment dans les réglages de votre App Store / Apple ID.';
      case 'pt': return 'Você pode cancelar a qualquer momento nas configurações da App Store / Apple ID.';
      case 'en': return 'You can cancel anytime in your App Store / Apple ID settings.';
      case 'tr':
      default: return 'İstediğiniz zaman App Store / Apple ID ayarlarınızdan iptal edebilirsiniz.';
    }
  }

  String get cancelNoticeAndroid {
    switch (currentLang) {
      case 'az': return 'İstədiyiniz vaxt Google Play Store tənzimləmələrinizdən ləğv edə bilərsiniz.';
      case 'de': return 'Sie können jederzeit in Ihren Google Play Store Einstellungen kündigen.';
      case 'el': return 'Μπορείτε να ακυρώσετε ανά πάσα στιγμή στις ρυθμίσεις του Google Play Store.';
      case 'es': return 'Puede cancelar en cualquier momento en los ajustes de Google Play Store.';
      case 'fr': return 'Vous pouvez annuler à tout moment dans les paramètres de Google Play Store.';
      case 'pt': return 'Você pode cancelar a qualquer momento nas configurações da Google Play Store.';
      case 'en': return 'You can cancel anytime in your Google Play Store settings.';
      case 'tr':
      default: return 'İstediğiniz zaman Google Play Store ayarlarınızdan iptal edebilirsiniz.';
    }
  }

  String get termsOfUseEula {
    switch (currentLang) {
      case 'az': return 'İstifadə Şərtləri (EULA)';
      case 'de': return 'Nutzungsbedingungen (EULA)';
      case 'el': return 'Όροι χρήσης (EULA)';
      case 'es': return 'Términos de uso (EULA)';
      case 'fr': return 'Conditions d\'utilisation (CLUF)';
      case 'pt': return 'Termos de uso (EULA)';
      case 'en': return 'Terms of Use (EULA)';
      case 'tr':
      default: return 'Kullanım Koşulları (EULA)';
    }
  }

  String get restorePurchases {
    switch (currentLang) {
      case 'az': return 'Alışları Bərpa Et';
      case 'de': return 'Käufe wiederherstellen';
      case 'el': return 'Επαναφορά αγορών';
      case 'es': return 'Restaurar compras';
      case 'fr': return 'Restaurer les achats';
      case 'pt': return 'Restaurar compras';
      case 'en': return 'Restore Purchases';
      case 'tr':
      default: return 'Satın Alımları Geri Yükle';
    }
  }

  String get adFreeActivatedToast {
    switch (currentLang) {
      case 'az': return '🎉 Reklamsız göstəriş abunəliyiniz aktivləşdirildi!';
      case 'de': return '🎉 Ihr werbefreies Abonnement wurde aktiviert!';
      case 'el': return '🎉 Η συνδρομή σας χωρίς διαφημίσεις ενεργοποιήθηκε!';
      case 'es': return '¡🎉 Tu suscripción sin anuncios ha sido activada!';
      case 'fr': return '🎉 Votre abonnement sans publicité a été activé !';
      case 'pt': return '🎉 Sua assinatura sem anúncios foi activada!';
      case 'en': return '🎉 Your ad-free subscription has been activated!';
      case 'tr':
      default: return '🎉 Reklamsız gösterim aboneliğiniz aktifleştirildi!';
    }
  }

  String get purchasesRestoredToast {
    switch (currentLang) {
      case 'az': return '🎉 Alışlar uğurla bərpa olundu!';
      case 'de': return '🎉 Käufe erfolgreich wiederhergestellt!';
      case 'el': return '🎉 Οι αγορές αποκαταστάθηκαν με επιτυχία!';
      case 'es': return '¡🎉 Compras restauradas con éxito!';
      case 'fr': return '🎉 Achats restaurés avec succès !';
      case 'pt': return '🎉 Compras restauradas com sucesso!';
      case 'en': return '🎉 Purchases successfully restored!';
      case 'tr':
      default: return '🎉 Satın alımları başarıyla geri yüklendi!';
    }
  }

  String get signUpBtn {
    switch (currentLang) {
      case 'az': return 'Qeydiyyatdan keç';
      case 'de': return 'Registrieren';
      case 'el': return 'Εγγραφή';
      case 'es': return 'Registrarse';
      case 'fr': return 'S\'inscrire';
      case 'pt': return 'Cadastrar';
      case 'en': return 'Sign Up';
      case 'tr':
      default: return 'Kayıt Ol';
    }
  }

  String get createAccount {
    switch (currentLang) {
      case 'az': return 'Hesab yaradın';
      case 'de': return 'Konto erstellen';
      case 'el': return 'Δημιουργία λογαριασμού';
      case 'es': return 'Crear cuenta';
      case 'fr': return 'Créer un compte';
      case 'pt': return 'Criar conta';
      case 'en': return 'Create Account';
      case 'tr':
      default: return 'Hesap Oluştur';
    }
  }

  String get welcomeToApp {
    switch (currentLang) {
      case 'az': return 'Ev Asistanı dünyasına xoş gəlmisiniz';
      case 'de': return 'Willkommen bei Home Assistant';
      case 'el': return 'Καλώς ορίσατε στο Home Assistant';
      case 'es': return 'Bienvenido a Asistente de Hogar';
      case 'fr': return 'Bienvenue sur Assistant Maison';
      case 'pt': return 'Bem-vindo ao Assistente de Casa';
      case 'en': return 'Welcome to Home Assistant';
      case 'tr':
      default: return 'Ev Asistanı dünyasına hoş geldiniz';
    }
  }

  String get smartHomeTagline {
    switch (currentLang) {
      case 'az': return 'Evindəki hər şeyi ağıllı idarə et';
      case 'de': return 'Verwalten Sie Ihr Zuhause intelligent';
      case 'el': return 'Διαχειριστείτε το σπίτι σας έξυπνα';
      case 'es': return 'Gestiona todo en tu hogar de forma inteligente';
      case 'fr': return 'Gérez tout dans votre maison de manière intelligente';
      case 'pt': return 'Gerencie tudo em sua casa de forma inteligente';
      case 'en': return 'Manage everything in your home smartly';
      case 'tr':
      default: return 'Evindeki her şeyi akıllıca yönet';
    }
  }

  String get signInWithGoogle {
    switch (currentLang) {
      case 'az': return 'Google ilə giriş et';
      case 'de': return 'Mit Google anmelden';
      case 'el': return 'Σύνδεση με Google';
      case 'es': return 'Iniciar sesión con Google';
      case 'fr': return 'Se connecter avec Google';
      case 'pt': return 'Entrar com o Google';
      case 'en': return 'Sign in with Google';
      case 'tr':
      default: return 'Google ile Giriş Yap';
    }
  }

  String get signInWithApple {
    switch (currentLang) {
      case 'az': return 'Apple ilə giriş et';
      case 'de': return 'Mit Apple anmelden';
      case 'el': return 'Σύνδεση με Apple';
      case 'es': return 'Iniciar sesión con Apple';
      case 'fr': return 'Se connecter avec Apple';
      case 'pt': return 'Entrar com a Apple';
      case 'en': return 'Sign in with Apple';
      case 'tr':
      default: return 'Apple ile Giriş Yap';
    }
  }

  String get tryAsGuest {
    switch (currentLang) {
      case 'az': return 'Qonaq olaraq sınayın (Üzvlüksüz)';
      case 'de': return 'Als Gast testen (Ohne Konto)';
      case 'el': return 'Δοκιμάστε ως επισκέπτης';
      case 'es': return 'Probar como invitado (Sin cuenta)';
      case 'fr': return 'Essayer en tant qu\'invité (Sans compte)';
      case 'pt': return 'Experimentar como convidado (Sem conta)';
      case 'en': return 'Try as Guest (Without Account)';
      case 'tr':
      default: return 'Misafir Olarak Deneyin (Üyeliksiz)';
    }
  }

  String get forgotPassword {
    switch (currentLang) {
      case 'az': return 'Şifrəni unutmusunuz?';
      case 'de': return 'Passwort vergessen?';
      case 'el': return 'Ξεχάσατε τον κωδικό πρόσβασης;';
      case 'es': return '¿Olvidaste tu contraseña?';
      case 'fr': return 'Mot de passe oublié ?';
      case 'pt': return 'Esqueceu a senha?';
      case 'en': return 'Forgot Password';
      case 'tr':
      default: return 'Şifremi Unuttum';
    }
  }

  String get forgotPasswordDesc {
    switch (currentLang) {
      case 'az': return 'Hesabınızın e-poçt ünvanını daxil edin. Sizə şifrə sıfırlama keçidi göndərəcəyik.';
      case 'de': return 'Geben Sie Ihre E-Mail-Adresse ein. Wir senden Ihnen einen Link zum Zurücksetzen.';
      case 'el': return 'Εισάγετε το email σας. Θα σας στείλουμε ένα σύνδεσμο επαναφοράς.';
      case 'es': return 'Ingrese su correo electrónico. Le enviaremos un enlace de restablecimiento.';
      case 'fr': return 'Entrez votre adresse e-mail. Nous vous enverrons un lien de réinitialisation.';
      case 'pt': return 'Insira seu e-mail. Enviaremos um link de redefinição de senha.';
      case 'en': return 'Enter your account email. We will send you a password reset link.';
      case 'tr':
      default: return 'Hesabınıza ait e-posta adresini girin. Size bir şifre sıfırlama bağlantısı göndereceğiz.';
    }
  }

  String get emailAddress {
    switch (currentLang) {
      case 'az': return 'E-poçt ünvanı';
      case 'de': return 'E-Mail-Adresse';
      case 'el': return 'Διεύθυνση Email';
      case 'es': return 'Correo electrónico';
      case 'fr': return 'Adresse e-mail';
      case 'pt': return 'Endereço de e-mail';
      case 'en': return 'Email Address';
      case 'tr':
      default: return 'E-posta Adresi';
    }
  }

  String get passwordLabel {
    switch (currentLang) {
      case 'az': return 'Şifrə';
      case 'de': return 'Passwort';
      case 'el': return 'Κωδικός πρόσβασης';
      case 'es': return 'Contraseña';
      case 'fr': return 'Mot de passe';
      case 'pt': return 'Senha';
      case 'en': return 'Password';
      case 'tr':
      default: return 'Şifre';
    }
  }

  String get confirmPasswordLabel {
    switch (currentLang) {
      case 'az': return 'Şifrə təkrarı';
      case 'de': return 'Passwort bestätigen';
      case 'el': return 'Επιβεβαίωση κωδικού';
      case 'es': return 'Confirmar contraseña';
      case 'fr': return 'Confirmer le mot de passe';
      case 'pt': return 'Confirmar senha';
      case 'en': return 'Confirm Password';
      case 'tr':
      default: return 'Şifre Tekrarı';
    }
  }

  String get confirmPasswordHint {
    switch (currentLang) {
      case 'az': return 'Şifrənizi təsdiqləyin';
      case 'de': return 'Bestätigen Sie Ihr Passwort';
      case 'el': return 'Επιβεβαιώστε τον κωδικό σας';
      case 'es': return 'Confirma tu contraseña';
      case 'fr': return 'Confirmez votre mot de passe';
      case 'pt': return 'Confirme sua senha';
      case 'en': return 'Confirm your password';
      case 'tr':
      default: return 'Şifrenizi doğrulayın';
    }
  }

  String get fullNameLabel {
    switch (currentLang) {
      case 'az': return 'Adınız Soyadınız';
      case 'de': return 'Vor- und Nachname';
      case 'el': return 'Ονοματεπώνυμο';
      case 'es': return 'Nombre y apellido';
      case 'fr': return 'Nom et prénom';
      case 'pt': return 'Nome completo';
      case 'en': return 'Full Name';
      case 'tr':
      default: return 'Adınız Soyadınız';
    }
  }

  String get fullNameRequired {
    switch (currentLang) {
      case 'az': return 'Adınız Soyadınız tələb olunur.';
      case 'de': return 'Vollständiger Name ist erforderlich.';
      case 'el': return 'Το ονοματεπώνυμο είναι υποχρεωτικό.';
      case 'es': return 'El nombre completo es requerido.';
      case 'fr': return 'Le nom complet est requis.';
      case 'pt': return 'O nome completo é obrigatório.';
      case 'en': return 'Full name is required.';
      case 'tr':
      default: return 'Adınız Soyadınız zorunludur.';
    }
  }

  String get passwordRequired {
    switch (currentLang) {
      case 'az': return 'Şifrə tələb olunur.';
      case 'de': return 'Passwort ist erforderlich.';
      case 'el': return 'Ο κωδικός πρόσβασης είναι υποχρεωτικός.';
      case 'es': return 'La contraseña es requerida.';
      case 'fr': return 'Le mot de passe est requis.';
      case 'pt': return 'A senha é obrigatória.';
      case 'en': return 'Password is required.';
      case 'tr':
      default: return 'Şifre zorunludur.';
    }
  }

  String get confirmPasswordRequired {
    switch (currentLang) {
      case 'az': return 'Şifrə təkrarı tələb olunur.';
      case 'de': return 'Passwortbestätigung ist erforderlich.';
      case 'el': return 'Η επιβεβαίωση κωδικού είναι υποχρεωτική.';
      case 'es': return 'La confirmación de contraseña es requerida.';
      case 'fr': return 'La confirmation du mot de passe est requise.';
      case 'pt': return 'A confirmação de senha é obrigatória.';
      case 'en': return 'Password confirmation is required.';
      case 'tr':
      default: return 'Şifre tekrarı zorunludur.';
    }
  }

  String get passwordsDoNotMatch {
    switch (currentLang) {
      case 'az': return 'Şifrələr uyğun gəlmir.';
      case 'de': return 'Passwörter stimmen nicht überein.';
      case 'el': return 'Οι κωδικοί πρόσβασης δεν ταιριάζουν.';
      case 'es': return 'Las contraseñas no coinciden.';
      case 'fr': return 'Les mots de passe ne correspondent pas.';
      case 'pt': return 'As senhas não coincidem.';
      case 'en': return 'Passwords do not match.';
      case 'tr':
      default: return 'Şifreler birbiriyle eşleşmiyor.';
    }
  }

  String get emailRequired {
    switch (currentLang) {
      case 'az': return 'E-poçt ünvanı tələb olunur.';
      case 'de': return 'E-Mail-Adresse ist erforderlich.';
      case 'el': return 'Η διεύθυνση email είναι υποχρεωτική.';
      case 'es': return 'El correo electrónico es requerido.';
      case 'fr': return 'L\'adresse e-mail est requise.';
      case 'pt': return 'O e-mail é obrigatório.';
      case 'en': return 'Email address is required.';
      case 'tr':
      default: return 'E-posta adresi zorunludur.';
    }
  }

  String get enterValidEmail {
    switch (currentLang) {
      case 'az': return 'Zəhmət olmasa düzgün e-poçt ünvanı daxil edin.';
      case 'de': return 'Bitte geben Sie eine gültige E-Mail-Adresse ein.';
      case 'el': return 'Παρακαλώ εισάγετε μια έγκυρη διεύθυνση email.';
      case 'es': return 'Por favor ingrese un correo electrónico válido.';
      case 'fr': return 'Veuillez saisir une adresse e-mail valide.';
      case 'pt': return 'Por favor insira um e-mail válido.';
      case 'en': return 'Please enter a valid email address.';
      case 'tr':
      default: return 'Lütfen geçerli bir e-posta adresi girin.';
    }
  }

  String get passwordMinLength {
    switch (currentLang) {
      case 'az': return 'Şifrə ən azı 6 simvol olmalıdır.';
      case 'de': return 'Passwort muss mindestens 6 Zeichen lang sein.';
      case 'el': return 'Ο κωδικός πρέπει να έχει τουλάχιστον 6 χαρακτήρες.';
      case 'es': return 'La contraseña debe tener al menos 6 caracteres.';
      case 'fr': return 'Le mot de passe doit contenir au moins 6 caractères.';
      case 'pt': return 'A senha deve ter pelo menos 6 caracteres.';
      case 'en': return 'Password must be at least 6 characters.';
      case 'tr':
      default: return 'Şifre en az 6 karakter olmalıdır.';
    }
  }

  String get dontHaveAccount {
    switch (currentLang) {
      case 'az': return 'Hesabınız yoxdur?';
      case 'de': return 'Noch kein Konto?';
      case 'el': return 'Δεν έχετε λογαριασμό;';
      case 'es': return '¿No tienes una cuenta?';
      case 'fr': return 'Vous n\'avez pas de compte ?';
      case 'pt': return 'Não tem uma conta?';
      case 'en': return 'Don\'t have an account?';
      case 'tr':
      default: return 'Hesabınız yok mu?';
    }
  }

  String get alreadyHaveAccount {
    switch (currentLang) {
      case 'az': return 'Artıq hesabınız var?';
      case 'de': return 'Bereits ein Konto?';
      case 'el': return 'Έχετε ήδη λογαριασμό;';
      case 'es': return '¿Ya tienes una cuenta?';
      case 'fr': return 'Vous avez déjà un compte ?';
      case 'pt': return 'Já tem uma conta?';
      case 'en': return 'Already have an account?';
      case 'tr':
      default: return 'Zaten hesabınız var mı?';
    }
  }

  String get orDivider {
    switch (currentLang) {
      case 'az': return 'və ya';
      case 'de': return 'oder';
      case 'el': return 'ή';
      case 'es': return 'o';
      case 'fr': return 'ou';
      case 'pt': return 'ou';
      case 'en': return 'or';
      case 'tr':
      default: return 'veya';
    }
  }

  String get send {
    switch (currentLang) {
      case 'az': return 'Göndər';
      case 'de': return 'Senden';
      case 'el': return 'Αποστολή';
      case 'es': return 'Enviar';
      case 'fr': return 'Envoyer';
      case 'pt': return 'Enviar';
      case 'en': return 'Send';
      case 'tr':
      default: return 'Gönder';
    }
  }

  String get passwordResetSent {
    switch (currentLang) {
      case 'az': return 'Şifrə sıfırlama keçidi e-poçtunuza gönderildi! 📧';
      case 'de': return 'Link zum Zurücksetzen des Passworts gesendet! 📧';
      case 'el': return 'Ο σύνδεσμος επαναφοράς εστάλη στο email σας! 📧';
      case 'es': return '¡Enlace de restablecimiento enviado a su correo! 📧';
      case 'fr': return 'Lien de réinitialisation envoyé à votre e-mail ! 📧';
      case 'pt': return 'Link de redefinição de senha enviado! 📧';
      case 'en': return 'Password reset link sent to your email! 📧';
      case 'tr':
      default: return 'Şifre sıfırlama bağlantısı e-postanıza gönderildi! 📧';
    }
  }

  String get googleLoginSuccess {
    switch (currentLang) {
      case 'az': return 'Google hesabınızla giriş edildi. 👋';
      case 'de': return 'Mit Google angemeldet. 👋';
      case 'el': return 'Σύνδεση με Google επιτυχής. 👋';
      case 'es': return 'Sesión iniciada con Google. 👋';
      case 'fr': return 'Connecté avec Google. 👋';
      case 'pt': return 'Conectado com o Google. 👋';
      case 'en': return 'Signed in with Google. 👋';
      case 'tr':
      default: return 'Google hesabınızla giriş yapıldı. 👋';
    }
  }

  String get appleLoginSuccess {
    switch (currentLang) {
      case 'az': return 'Apple hesabınızla giriş edildi. 👋';
      case 'de': return 'Mit Apple angemeldet. 👋';
      case 'el': return 'Σύνδεση με Apple επιτυχής. 👋';
      case 'es': return 'Sesión iniciada con Apple. 👋';
      case 'fr': return 'Connecté avec Apple. 👋';
      case 'pt': return 'Conectado com a Apple. 👋';
      case 'en': return 'Signed in with Apple. 👋';
      case 'tr':
      default: return 'Apple hesabınızla giriş yapıldı. 👋';
    }
  }

  String get verificationEmailSent {
    switch (currentLang) {
      case 'az': return 'E-poçt ünvanınıza təsdiq keçidi gönderildi. Zəhmət olmasa təsdiqləyib daxil olun.';
      case 'de': return 'Bestätigungslink gesendet. Bitte E-Mail bestätigen und anmelden.';
      case 'el': return 'Εστάλη σύνδεσμος επιβεβαίωσης. Παρακαλώ επιβεβαιώστε το email σας.';
      case 'es': return 'Enlace de verificación enviado. Por favor verifique su correo.';
      case 'fr': return 'Lien de vérification envoyé. Veuillez vérifier votre e-mail.';
      case 'pt': return 'Link de verificação enviado. Por favor verifique seu e-mail.';
      case 'en': return 'Verification email sent. Please verify your email and sign in.';
      case 'tr':
      default: return 'E-posta adresinize onay bağlantısı gönderildi. Lütfen e-postanızı onaylayıp giriş yapın.';
    }
  }

  String get linkWithGoogle {
    switch (currentLang) {
      case 'az': return 'Google ilə bağla';
      case 'de': return 'Mit Google verknüpfen';
      case 'el': return 'Σύνδεση με Google';
      case 'es': return 'Vincular con Google';
      case 'fr': return 'Lier avec Google';
      case 'pt': return 'Vincular com Google';
      case 'en': return 'Link with Google';
      case 'tr':
      default: return 'Google ile Bağla';
    }
  }

  String get linkWithApple {
    switch (currentLang) {
      case 'az': return 'Apple ilə bağla';
      case 'de': return 'Mit Apple verknüpfen';
      case 'el': return 'Σύνδεση με Apple';
      case 'es': return 'Vincular con Apple';
      case 'fr': return 'Lier avec Apple';
      case 'pt': return 'Vincular com Apple';
      case 'en': return 'Link with Apple';
      case 'tr':
      default: return 'Apple ile Bağla';
    }
  }

  String get linkWithEmail {
    switch (currentLang) {
      case 'az': return 'E-poçt ilə bağla';
      case 'de': return 'Mit E-Mail verknüpfen';
      case 'el': return 'Σύνδεση με Email';
      case 'es': return 'Vincular con correo';
      case 'fr': return 'Lier avec e-mail';
      case 'pt': return 'Vincular com e-mail';
      case 'en': return 'Link with Email';
      case 'tr':
      default: return 'E-posta ile Bağla';
    }
  }

  String get connecting {
    switch (currentLang) {
      case 'az': return 'Qoşulur...';
      case 'de': return 'Verbinden...';
      case 'el': return 'Σύνδεση...';
      case 'es': return 'Conectando...';
      case 'fr': return 'Connexion...';
      case 'pt': return 'Conectando...';
      case 'en': return 'Connecting...';
      case 'tr':
      default: return 'Bağlanıyor...';
    }
  }
}

extension BuildContextL10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

