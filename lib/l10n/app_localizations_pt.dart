// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Assistente Doméstico';

  @override
  String get languageSelection => 'Seleção de Idioma';

  @override
  String get languageSelectionSubtitle => 'Alterar idioma do aplicativo';

  @override
  String get currencySelection => 'Moeda';

  @override
  String get currencySelectionSubtitle =>
      'Selecionar moeda para telas de orçamento e finanças';

  @override
  String get preferencesAndSettings => 'Preferências e Configurações';

  @override
  String get notificationSettings => 'Configurações de Notificação';

  @override
  String get notificationSettingsSubtitle =>
      'Gerenciar notificações do sistema';

  @override
  String get about => 'Sobre';

  @override
  String get aboutSubtitle => 'Assistente Doméstico v1.1.0 (Firebase Ativo)';

  @override
  String get developerLabel => 'Desenvolvedor: Samed Kalaycı';

  @override
  String get aboutDescription => 'Descrição: Organização inteligente da casa.';

  @override
  String get allRightsReserved =>
      '© 2026 Assistente Doméstico. Todos os direitos reservados.';

  @override
  String get privacyPolicy => 'Política de Privacidade e Termos';

  @override
  String get privacyPolicySubtitle => 'Revisar informações legais e condições';

  @override
  String get signOut => 'Sair';

  @override
  String get signOutSubtitle => 'Sair da conta com segurança';

  @override
  String get deleteAccount => 'Excluir Conta';

  @override
  String get deleteAccountSubtitle => 'Excluir conta e dados permanentemente';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get turkish => 'Turco';

  @override
  String get english => 'Inglês';

  @override
  String get german => 'Alemão';

  @override
  String get spanish => 'Espanhol';

  @override
  String get french => 'Francês';

  @override
  String get azerbaijani => 'Azerbaijano';

  @override
  String get greek => 'Grego';

  @override
  String get portuguese => 'Português';

  @override
  String get navHome => 'Início';

  @override
  String get navInventory => 'Inventário';

  @override
  String get navShopping => 'Compras';

  @override
  String get navFinance => 'Finanças';

  @override
  String get navProfile => 'Perfil';

  @override
  String get shoppingListTitle => 'Lista de Compras';

  @override
  String get toBuyTab => 'A Comprar';

  @override
  String get purchasedTab => 'Comprados';

  @override
  String get clearCompleted => 'Limpar';

  @override
  String get newProductHint => 'Adicionar novo item...';

  @override
  String itemsCount(int count) {
    return '$count Itens';
  }

  @override
  String get addShoppingItemTitle => 'Adicionar Item à Lista';

  @override
  String get productNameLabel => 'Nome do Item';

  @override
  String get productNameHint => 'Ex: Leite, Pão, Ovos...';

  @override
  String get addToListBtn => 'Adicionar à Lista';

  @override
  String itemAddedToast(String name) {
    return '\"$name\" adicionado à lista! 🛒';
  }

  @override
  String get emptyShoppingList => 'Sua lista de compras está vazia.';

  @override
  String get financeOverviewTab => 'Visão Geral';

  @override
  String get householdWalletTab => 'Carteira da Casa';

  @override
  String get accountsTab => 'Contas';

  @override
  String get viewSummary => 'Ver Resumo';

  @override
  String get incomeExpenseBalance => 'Balanço Receita/Despesa';

  @override
  String get totalIncome => 'Receita Total';

  @override
  String get totalExpense => 'Despesa Total';

  @override
  String get personalExpenses => 'Despesas Pessoais';

  @override
  String get noAccountYet => 'Nenhuma conta adicionada ainda.';

  @override
  String get paymentSchedule => 'Agenda de Pagamentos';

  @override
  String get realizedPayments => 'Realizados';

  @override
  String get accountScheduleHeader => 'Conta / Agenda';

  @override
  String get monthlyFreeBudget => 'Orçamento Livre Restante';

  @override
  String get quickAddExpense => 'Adicionar Despesa Rápida';

  @override
  String greetingUser(String name) {
    return 'Olá, $name';
  }

  @override
  String get quickAdd => 'Adicionar Rápido';

  @override
  String get expiringSoonTitle => 'Vencimentos Próximos';

  @override
  String get warrantiesExpiringTitle => 'Garantias a Vencer';

  @override
  String get shoppingSummaryTitle => 'Resumo de Compras';

  @override
  String get viewAll => 'Ver Tudo';

  @override
  String urgentExpirationsCount(int count) {
    return '$count Itens Urgentes';
  }

  @override
  String urgentWarrantiesCount(int count) {
    return '$count Garantias Urgentes';
  }

  @override
  String get inventoryTitle => 'Inventário da Casa';

  @override
  String get expirationTab => 'Validade';

  @override
  String get warrantyTab => 'Garantias';

  @override
  String get vaultTab => 'Cofre';

  @override
  String get addExpirationItem => 'Adicionar Item';

  @override
  String get addWarrantyItem => 'Adicionar Garantia';

  @override
  String get periodicMaintenance => 'Agenda de Manutenção';

  @override
  String get homeGuideWifi => 'Guia da Casa e Wi-Fi';

  @override
  String get digitalVaultSubtitle =>
      'Documentos importantes e contatos de emergência são criptografados.';

  @override
  String get myHomeAndFamily => 'Minha Casa e Família';

  @override
  String get inviteCode => 'Código de Convite';

  @override
  String get familyMembers => 'Membros da Família';

  @override
  String get proMember => 'Membro PRO';

  @override
  String get proHouseOwner => 'Proprietário PRO';

  @override
  String get houseOwner => 'Proprietário da Casa';

  @override
  String get legalSection => 'Legal';

  @override
  String get legalAndInfo => 'Legal & Info';

  @override
  String get accountActions => 'Ações da Conta';

  @override
  String get removeAdsTitle => 'Remover Anúncios';

  @override
  String memberCount(int count) {
    return '$count Membro';
  }

  @override
  String get removeAdsSubtitle =>
      'Sem anúncios para sempre com um pagamento único!';

  @override
  String get removeAdsActive => 'Versão Sem Anúncios Ativa ✅';

  @override
  String get specialPriceOffer => 'Preço Especial! Pelo preço de um café.';

  @override
  String get buyNow => 'Comprar Agora';

  @override
  String get restorePurchases => 'Restaurar Compras';

  @override
  String get introPopupTitle => 'Use o App Sem Anúncios!';

  @override
  String get introPopupDesc =>
      'Remova permanentemente todos os anúncios por um valor único baixo.';

  @override
  String get skipForNow => 'Pular por enquanto';

  @override
  String get shoppingListSubtitle =>
      'Acompanhe facilmente os itens a comprar e comprados.';

  @override
  String get clearCompletedConfirmTitle => 'Limpar comprados';

  @override
  String get clearCompletedConfirmDesc =>
      'Todos os itens comprados serão removidos da lista. Continuar?';

  @override
  String get emptyShoppingListDesc =>
      'Você pode adicionar produtos necessários como pão, leite ou frutas no campo acima.';

  @override
  String get allPurchasedMessage => 'Todos os itens comprados! 🎉';

  @override
  String get delete => 'Excluir';

  @override
  String get accountTypeCash => 'Dinheiro';

  @override
  String get accountTypeBank => 'Banco';

  @override
  String get accountTypeCreditCard => 'Cartão de Crédito';

  @override
  String get accountTypeDebtCredit => 'Conta (Dívida/Crédito)';

  @override
  String statementCutoff(String day) {
    return 'Fechamento da fatura: $day';
  }

  @override
  String get planBudget => 'Planejar Orçamento';

  @override
  String get categoryBudgets => 'Orçamentos por Categoria';

  @override
  String get noBudgetsSet => 'Você ainda não definiu metas de orçamento.';

  @override
  String get limitExceeded => 'Limite excedido!';

  @override
  String get noExpensesPeriod => 'Nenhuma despesa neste período.';

  @override
  String get expenseHistory => 'Histórico de Despesas';

  @override
  String get noRecordsFound => 'Nenhum registro encontrado.';

  @override
  String get financeManagementPro => 'Gestão Financeira PRO';

  @override
  String get financeProDesc =>
      'Faça upgrade para PRO para controlar todas as receitas, despesas e contas bancárias.';

  @override
  String get expirationTitle => 'Datas de Validade';

  @override
  String get freshnessSubtitle =>
      'Acompanhe o estado dos itens no seu inventário.';

  @override
  String get searchProductLocationHint => 'Buscar nome do produto ou local...';

  @override
  String get clearExpired => 'Limpar Itens Vencidos';

  @override
  String get noProductsYet => 'Nenhum Produto Ainda';

  @override
  String get noProductsFound => 'Nenhum Produto Encontrado';

  @override
  String get addFirstProductDesc =>
      'Pressione \"Adicionar Produto\" para começar.';

  @override
  String get noMatchingProductsDesc =>
      'Nenhum produto atende aos critérios de busca.';

  @override
  String get clearFilters => 'Limpar Filtros';

  @override
  String get expirationDateLabel => 'Data de Validade';

  @override
  String get trashAndShopping => 'Descartar e Adicionar às Compras';

  @override
  String get warrantyTrackingTitle => 'Rastreamento de Garantias';

  @override
  String get warrantySubtitle =>
      'Acompanhe os períodos de garantia dos seus dispositivos.';

  @override
  String get searchDeviceBrandHint => 'Buscar dispositivo, marca ou loja...';

  @override
  String get noWarrantyRecordsYet => 'Nenhum Registro de Garantia Ainda';

  @override
  String get noWarrantyRecordsFound => 'Nenhum Registro de Garantia Encontrado';

  @override
  String get addFirstWarrantyDesc =>
      'Pressione \"Adicionar Garantia\" para começar.';

  @override
  String get noMatchingWarrantiesDesc =>
      'Nenhum registro atende aos critérios de busca.';

  @override
  String get documentsAndWarranties => 'Documentos e Garantias';

  @override
  String get serviceAndEmergencyNumbers => 'Serviços e Números de Emergência';

  @override
  String get uploadDocument => 'Enviar Documento';

  @override
  String get noDocumentsTitle => 'Nenhum Documento Encontrado';

  @override
  String get noDocumentsDesc =>
      'Guarde documentos com segurança no Cofre Digital.';

  @override
  String get uploadFirstDocument => 'Enviar Primeiro Documento';

  @override
  String get addNumber => 'Adicionar Número';

  @override
  String get noEmergencyContactsTitle => 'Nenhum Número Salvo';

  @override
  String get noEmergencyContactsDesc => 'Adicione contatos de emergência.';

  @override
  String get addFirstNumber => 'Adicionar Primeiro Número';

  @override
  String get call => 'Ligar';

  @override
  String get copy => 'Copiar';

  @override
  String get newMaintenanceTask => 'Nova Tarefa de Manutenção';

  @override
  String get maintenanceTitleLabel => 'Nome da Manutenção';

  @override
  String get maintenanceTitleHint => 'Ex: Manutenção da aquecedor';

  @override
  String get descriptionLabel => 'Descrição / Detalhes';

  @override
  String get descriptionHint => 'Ex: Lavar filtros, chamar técnico.';

  @override
  String get scheduledDateLabel => 'Data Agendada';

  @override
  String get saveTask => 'Salvar Tarefa';

  @override
  String get addHomeInfo => '+ Adicionar Info da Casa';

  @override
  String get noGuideTitle => 'Nenhuma Info de Guia';

  @override
  String get noGuideDesc =>
      'Compartilhe senhas de Wi-Fi e informações da casa.';

  @override
  String get deleteItem => 'Excluir';

  @override
  String get deleteConfirmDesc => 'será excluído permanentemente.';

  @override
  String get addWarranty => 'Adicionar Garantia';

  @override
  String get addMaintenanceTask => 'Adicionar Manutenção';

  @override
  String get noMaintenanceTasksTitle => 'Nenhuma Tarefa de Manutenção';

  @override
  String get noMaintenanceTasksDesc =>
      'Adicione tarefas para receber lembretes a tempo.';

  @override
  String get addFirstMaintenanceTask =>
      'Adicionar Primeira Tarefa de Manutenção';

  @override
  String get consentByContinuing => 'Ao continuar, você concorda com nossos ';

  @override
  String get consentTermsAndPrivacy =>
      'Termos de Uso e Política de Privacidade';

  @override
  String get consentAcceptSuffix => '.';

  @override
  String get registerConsentPrefix => 'Li e aceito os ';

  @override
  String get registerConsentSuffix => '.';

  @override
  String get registerConsentError =>
      'Você deve aceitar os termos para continuar.';

  @override
  String get addProduct => 'Adicionar Produto';

  @override
  String get perMonthSuffix => '/ este mês';

  @override
  String get freeBudgetDescription =>
      'O valor restante da renda líquida mensal após a dedução das despesas fixas.';

  @override
  String get viewDetails => 'Ver detalhes';

  @override
  String get everythingLooksGood => 'Tudo parece estar bem na sua casa.';

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
  String get statusToday => 'Último dia hoje';

  @override
  String daysLeft(int count) {
    return '$count Dias restantes';
  }

  @override
  String get budgetPlanDescription =>
      'Defina suas metas de gastos mensais. Você pode deixar as categorias indesejadas em branco.';

  @override
  String get categoryDiningOut => 'Comer fora';

  @override
  String get categoryKitchenGrocery => 'Cuzinha & Supermercado';

  @override
  String get categoryHomeBills => 'Casa & Contas';

  @override
  String get categoryShoppingPersonal => 'Compras & Pessoal';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryEntertainmentSubscriptions =>
      'Entretenimento & Assinaturas';

  @override
  String get categoryOther => 'Outro';

  @override
  String get saveBudgets => 'Salvar Metas';

  @override
  String get limitAmountHint => 'Limite (₺)';

  @override
  String get financialStatus => 'Estado Financeiro';

  @override
  String get periodYearly => 'Anual';

  @override
  String get periodMonthly => 'Mensal';

  @override
  String get periodWeekly => 'Semanal';

  @override
  String get periodDaily => 'Diário';

  @override
  String get netStatus => 'Estado Líquido';

  @override
  String get yearlyNetStatus => 'Estado Líquido Anual';

  @override
  String get monthlyNetStatus => 'Estado Líquido Mensal';

  @override
  String get weeklyNetStatus => 'Estado Líquido Semanal';

  @override
  String get dailyNetStatus => 'Estado Líquido Diário';

  @override
  String get upcomingPendingTransactions => 'Próximas Transações Pendentes';

  @override
  String get recentTransactions => 'Transações Recientes';

  @override
  String get futureIncome => 'Receita Futura';

  @override
  String get upcomingPayment => 'Próximo Pagamento';

  @override
  String get noTransactionsPeriod => 'Nenhuma transação neste período.';

  @override
  String get budgetPlanUpdated => 'Metas de orçamento atualizadas!';

  @override
  String get linkAccountTitle => 'Vincular Sua Conta';

  @override
  String get guestModeDesc =>
      'Você está no modo convidado. Torne sua conta permanente sem perder seus dados.';

  @override
  String get guestModeBottomSheetDesc =>
      'Você está no modo convidado. Selecione um método de login para criar uma conta permanente e não perder seus dados.';

  @override
  String get connectionOptions => 'Opções de Conexão';

  @override
  String get userRoleLabel => 'Usuário';

  @override
  String get anonymousSession => 'Sessão Anônima';

  @override
  String get notMemberOfFamilyYet => 'Ainda não está conectado a uma família';

  @override
  String get notMemberOfHomeYet => 'Ainda não está conectado a uma casa';

  @override
  String get noHomeSyncDesc =>
      'Crie uma casa ou entre em uma existente com um código de convite para sincronizar seus itens e listas de compras.';

  @override
  String get createHome => 'Criar Casa';

  @override
  String get enterCode => 'Digitar Código';

  @override
  String get createOrJoinHome => 'Criar ou Entrar em uma Casa';

  @override
  String get createNewHomeTitle => 'Criar Nova Casa / Família';

  @override
  String get createNewHomeDesc =>
      'Dê um nome à sua casa. Você pode criá-la gratuitamente assistindo a 1 anúncio curto.';

  @override
  String get homeNameLabel => 'Nome da Casa / Família';

  @override
  String get homeNameHint => 'Ex: Família Silva';

  @override
  String get homeNameRequired => 'O nome da casa é obrigatório.';

  @override
  String get roleInHomeLabel => 'Seu Papel na Casa';

  @override
  String get roleHouseOwner => '👑 Proprietário da Casa';

  @override
  String get roleMother => '👨‍👩‍👧 Mãe';

  @override
  String get roleFather => '👨‍👩‍👦 Pai';

  @override
  String get roleChild => '👶 Filho/a';

  @override
  String get roleRoommate => '🏠 Colega de Quarto';

  @override
  String get roleOtherResident => '🐾 Outro / Residente';

  @override
  String get noUpcomingExpirationsMessage =>
      'Nenhum produto com data de validade próxima. 👍';

  @override
  String get expirationProductItem => 'Produto com Data de Validade';

  @override
  String get expirationProductSubtitle =>
      'Rastrear alimentos/medicamentos na geladeira ou despensa';

  @override
  String get warrantyDocumentItem =>
      'Adicionar Documento / Arquivo de Garantia';

  @override
  String get warrantyDocumentSubtitle =>
      'Documentos de garantia de produtos e arquivos de eletrodomésticos';

  @override
  String get enterQuickExpense => 'Adicionar Despesa Rápida';

  @override
  String get amountLabel => 'Valor';

  @override
  String get amountRequired => 'Por favor, insira um valor';

  @override
  String get validAmountRequired => 'Por favor, insira um valor válido';

  @override
  String get shortDescriptionLabel => 'Descrição Curta';

  @override
  String get shortDescriptionHint => 'Ex: Café, Mercado, etc.';

  @override
  String get descriptionRequired => 'Insira uma descrição';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get addToPaymentSchedule => 'Adicionar à Agenda de Pagamentos';

  @override
  String get editPaymentSchedule => 'Editar Agenda de Pagamentos';

  @override
  String get billExpenseOption => 'Fatura / Despesa';

  @override
  String get incomeCollectionOption => 'Receita / Cobrança';

  @override
  String get scheduleTitleLabel => 'Título (Ex: Conta de Luz, Aluguel)';

  @override
  String get titleRequired => 'Por favor, insira um título';

  @override
  String get dateLabel => 'Data';

  @override
  String get bankAccountNameOptional =>
      'Banco Associado / Nome da Conta (Opcional)';

  @override
  String get markAsPaid => 'Marcar como Pago';

  @override
  String get repeatMonthly => 'Repetir Mensalmente';

  @override
  String get oneTimePaymentNotice => 'Pagamento único.';

  @override
  String get addToScheduleBtn => 'Adicionar à Agenda';

  @override
  String get addNewDocumentTitle => 'Adicionar Novo Documento / Arquivo';

  @override
  String get editDocumentTitle => 'Editar Documento';

  @override
  String get documentTitleLabel => 'Título do Documento';

  @override
  String get documentTitleHint => 'Ex: Escritura, Contrato de Aluguel';

  @override
  String get notesDescriptionLabel => 'Descrição / Notas';

  @override
  String get notesDescriptionHint => 'Ex: Guardado na 2ª gaveta do arquivo.';

  @override
  String get addFileImage => 'Adicionar Arquivo / Imagem';

  @override
  String get selectPhotoDocument => 'Selecionar Foto / Documento';

  @override
  String get saveDocumentBtn => 'Salvar Documento';

  @override
  String get addNewContactTitle => 'Adicionar Novo Contato / Serviço Útil';

  @override
  String get editContactTitle => 'Editar Número';

  @override
  String get namePersonLabel => 'Nome / Pessoa de Contato';

  @override
  String get namePersonHint => 'Ex: Encanador João, Administração do Prédio';

  @override
  String get titleCategoryLabel => 'Título / Categoria';

  @override
  String get titleCategoryHint => 'Ex: Encanamento, Eletricidade, Chaveiro';

  @override
  String get phoneNumberLabel => 'Número de Telefone';

  @override
  String get phoneNumberHint => 'Ex: +55 11 91234 5678';

  @override
  String get saveNumberBtn => 'Salvar Número';

  @override
  String get summary => 'Resumo';

  @override
  String get creditCardExpenses => 'Despesas com Cartão de Crédito';

  @override
  String get cashExpenses => 'Despesas em Dinheiro';

  @override
  String get quickExpenses => 'Despesas Rápidas';

  @override
  String get pleaseSelectDocumentOrPhoto =>
      'Por favor, selecione um documento ou foto.';

  @override
  String get editWarranty => 'Editar Registo de Garantia';

  @override
  String get productDeviceName => 'Nome do Produto / Dispositivo';

  @override
  String get productDeviceNameHint => 'ex: Frigorífico, Portátil...';

  @override
  String get brand => 'Marca';

  @override
  String get brandHint => 'ex: Samsung, Apple...';

  @override
  String get store => 'Loja de Compra';

  @override
  String get storeHint => 'ex: Fnac, Amazon...';

  @override
  String get purchaseDate => 'Data de Compra';

  @override
  String get warrantyEndDate => 'Data de Fim da Garantia';

  @override
  String get hasInvoice => 'Fatura / Documento Disponível';

  @override
  String get icon => 'Ícone';

  @override
  String get optionalNotes => 'Notas (Opcional)';

  @override
  String get optionalNotesHint => 'Informação adicional...';

  @override
  String get invoiceNumberOptional => 'Número da Fatura (Opcional)';

  @override
  String get invoiceNumberHint => 'ex: AMZ-2024-12345';

  @override
  String get changeInvoiceFile => 'Alterar Ficheiro da Fatura';

  @override
  String get uploadInvoiceFile => '📸 Carregar Imagem da Fatura / PDF';

  @override
  String get saveChanges => 'Guardar Alterações';

  @override
  String get productNameRequired => 'O nome do produto é obrigatório.';

  @override
  String get brandRequired => 'A marca é obrigatória.';

  @override
  String get storeRequired => 'O nome da loja é obrigatório.';

  @override
  String get selectPurchaseDateWarning =>
      'Por favor, selecione a data de compra.';

  @override
  String get selectWarrantyEndDateWarning =>
      'Por favor, selecione a data de fim da garantia.';

  @override
  String get selectDateHint => 'Selecionar Data';

  @override
  String get addNewHomeInfo => 'Adicionar Nova Informação da Casa';

  @override
  String get editHomeInfo => 'Editar Informação da Casa';

  @override
  String get categorySelection => 'Seleção de Categoria';

  @override
  String get guideTitle => 'Título do Guia';

  @override
  String get guideTitleHint =>
      'ex: Contrato do Gás, Válvula de Água, Palavra-passe Wi-Fi';

  @override
  String get importantValueLabel =>
      'Informação Importante / Valor (Clique para Copiar)';

  @override
  String get importantValueHint => 'ex: N.º Cliente: 123456, Pass: xyz';

  @override
  String get detailedNotesLabel => 'Descrição / Nota Detalhada';

  @override
  String get detailedNotesHint =>
      'ex: O contador fica no armário da varanda à direita.';

  @override
  String get updateInfoBtn => 'Atualizar Informação';

  @override
  String get categoryWifi => '📶 Wi-Fi e Rede';

  @override
  String get categoryInstallation => '⚡ Instalação e Serviços';

  @override
  String get categoryPasswords => '🔑 Palavras-passe e Códigos';

  @override
  String get categoryGeneralHome => 'ℹ️ Informação Geral da Casa';

  @override
  String get themeSelection => 'Seleção do Tema';

  @override
  String get themeSelectionSubtitle =>
      'Escolha a aparência da aplicação (Sistema / Claro / Escuro)';

  @override
  String get themeSystem => 'Sistema (Predefinido)';

  @override
  String get themeLight => 'Tema Claro';

  @override
  String get themeDark => 'Tema Escuro';

  @override
  String get editHomeNameTitle => 'Editar Nome da Casa';

  @override
  String get editHomeNameLabel => 'Nome da Casa';

  @override
  String get editHomeNameHint => 'ex: Casa Silva';

  @override
  String get homeNameUpdatedToast => 'Nome da casa atualizado com sucesso! 🏠';

  @override
  String get customRoleOption => '✏️ Função Personalizada...';

  @override
  String get customRoleHint => 'Escreva a função...';

  @override
  String get aboutDeveloper => 'Desenvolvedor: Samed Kalaycı';

  @override
  String get aboutCopyright =>
      '© 2026 Ev Asistanı. Todos os direitos reservados.';
}
