import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

extension FinanceL10nExtension on AppLocalizations {
  String get paymentType {
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
    switch (localeName) {
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
}

