import 'app_i18n.dart';

class PtBrI18n implements AppI18n {
  const PtBrI18n();

  /// ------------------- App -------------------
  @override
  String get appTitle => 'e-Bolsa';

  @override
  String get appNameDev => 'e-BolsaDev';

  // New Request (Nova Solicitação) strings

  @override
  String get newScholarshipSubtitle => 'Editais Disponíveis';

  @override
  String get newScholarshipDescription =>
      'Selecione a cidade e unidade escolar para conferir as vagas disponíves.';

  @override
  String get newScholarshipShowExpired => 'Exibir encerrados';

  @override
  String get newScholarshipDialogDescription =>
      'Você está iniciando o formulário...';

  @override
  String get newScholarshipDialogCancel => 'Cancelar';

  @override
  String newScholarshipEadNoResultsMessage({
    required String year,
    required String city,
    required String unit,
  }) =>
      'Não existem editais e/ou períodos de inscrições abertos para o ano letivo de $year para a cidade de $city e unidade $unit.';

  @override
  String get finishAction => 'Finalizar';

  // Steps - Erros de domínio
  @override
  String get errorPersonNotFound => 'Usuário sem cadastro de pessoa associado';

  @override
  String get errorProcessPeriodInvalid =>
      'Período de processo inválido ou não encontrado';

  @override
  String get fieldRequired => 'Campo obrigatório';

  // Renewal strings

  @override
  String get renewalScholarshipTitle => 'Renovação de Bolsa';

  @override
  String get renewalScholarshipSubtitle => 'Processos para renovação';

  @override
  String get renewalScholarshipDescription =>
      'Abaixo estão os processos disponíveis para renovação';

  @override
  String get renewalScholarshipDetails => 'Detalhes do processo';

  @override
  String get renewalDetailDeadlinesTitle => 'Etapas e Prazos';

  @override
  String get renewalDetailDeadlinesSubtitle =>
      'Atente-se aos prazos para o processo seletivo de';

  @override
  String get renewalDetailCandidatesTitle => 'Candidatos';

  @override
  String get renewalDetailCandidatesSubtitle =>
      'Estes são os candidatos disponíveis para renovação';

  @override
  String get renewalDetailViewNotice => 'Ver edital';

  @override
  String get renewalDetailStartButton => 'Iniciar Renovação';

  @override
  String get processCardSchoolUnit => 'Unidade Escolar';

  // Housing step
  @override
  String get housingStepResidenceTitle => 'Local da sua residência';

  @override
  String get housingStepResidenceDescription =>
      'Comece informando o endereço onde você e sua família moram atualmente. Preencha os campos com atenção.';

  @override
  String get addressCepLabel => 'CEP';

  @override
  String get addressNumberLabel => 'Número';

  @override
  String get addressComplementLabel => 'Complemento (opcional)';

  @override
  String get addressLabel => 'Endereço';

  @override
  String get addressNeighborhoodLabel => 'Bairro';

  @override
  String get addressCityLabel => 'Cidade';

  @override
  String get addressStateLabel => 'Estado';

  @override
  String get housingAreaQuestion =>
      'O imóvel em que família reside localiza-se em área:';

  @override
  String get housingAreaUrban => 'Urbana';

  @override
  String get housingAreaRural => 'Rural';

  @override
  String get housingAreaVulnerability => 'Vulnerabilidade e risco';

  @override
  String get housingGroupQuestion => 'A moradia do grupo familiar é:';

  @override
  String get housingTypeAlugada => 'Alugada';

  @override
  String get housingTypeCedida => 'Cedida';

  @override
  String get housingTypeFinanciada => 'Financiada';

  @override
  String get housingTypePropria => 'Própria';

  /// Common errors
  @override
  String get errorNoInternet => 'Sem conexão com a internet.';

  @override
  String get errorTimeout => 'Tempo de conexão esgotado.';

  @override
  String get errorUnexpected => 'Erro inesperado. Tente novamente.';

  /// Common Messages
  @override
  String get tryAgain => 'Tente novamente';

  /// Shared labels (deduplicated)
  @override
  String get typeLabel => 'Tipo';
  @override
  String get attentionLabel => 'Atenção';
  @override
  String get confirmAction => 'Confirmar';
  @override
  String get continueAction => 'Continuar';
  @override
  String get noticesLabel => 'Editais';
  @override
  String get noticeLabel => 'Edital';
  @override
  String get homeLabel => 'Home';
  @override
  String get housingLabel => 'Moradia';
  @override
  String get occupationTitle => 'Ocupação';
  @override
  String get profileLabel => 'Perfil';
  @override
  String get scholarshipApplicationTitle => 'Solicitação de bolsa';
  @override
  String get scholarshipTypeLabel => 'Tipo de Bolsa';
  @override
  String get enrollmentTypeLabel => 'Tipo de Inscrição';
  @override
  String get installmentValueLabel => 'Valor da parcela';
  @override
  String get assetValueLabel => 'Valor do bem';
  @override
  String get valueDisplayLabel => 'Valor:';
  @override
  String get okAction => 'Ok';

  /// ------------------- Auth common -------------------
  @override
  String get authCpfLabel => 'CPF';

  @override
  String get authCpfHint => '000.000.000-00';

  @override
  String get authPhoneLabel => 'Celular';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authPasswordLabel => 'Senha';

  @override
  String get authForgotPasswordAction => 'Esqueceu sua senha?';

  @override
  String get authLoginAction => 'Entrar';

  @override
  String get authCreateAccountAction => 'Criar conta';

  /// ------------------- Login -------------------
  @override
  String get loginPasswordHint => 'Digite sua senha';

  /// ------------------- Create account -------------------
  @override
  String get createAccountPageTitle => '';

  @override
  String get createAccountHeader => 'Cadastro Responsável';

  @override
  String get createAccountDescription =>
      'Este cadastro deve ser preenchido com os dados do Responsável Legal.';

  @override
  String get createAccountFullNameLabel => 'Nome completo';

  @override
  String get createAccountFullNameHint => 'Como consta no documento';

  @override
  String get createAccountEmailHint => 'seu@email.com';

  @override
  String get createAccountPasswordHint => 'Mínimo 12 caracteres';

  @override
  String get createAccountConfirmPasswordLabel => 'Confirmar senha';

  @override
  String get createAccountConfirmPasswordHint => 'Repita sua senha';

  @override
  String get createAccountNextAction => 'Avançar';

  @override
  String get termsPageTitle => 'Termos de Uso';

  @override
  String get termsContent => '''
  O “e-Bolsa” é uma aplicação gratuita oferecida pela Rede de Educação Adventista como ferramenta de requerimento de bolsa escolar, acessível aos representantes legais dos alunos ou ao próprio aluno maior de idade. 

  O uso do “e-Bolsa” está condicionado a aceitação dos **TERMOS DE USO**, que **contêm** todas as regras de utilização e conduta do usuário, e devem ser lidos previamente. 

  Se você não leu, ou não concorda com estes **TERMOS DE USO**, você não deve utilizar o “e-Bolsa”. 

  Estes termos de uso fazem parte da Política de Privacidade de Dados da Rede de Educação Adventista, disponível em: [Política de Privacidade]( https://portal.educacaoadventista.org.br/politica-de-privacidade)

  É assegurado à Rede de Educação Adventista modificar os **TERMOS DE USO** e a Política de Privacidade de Dados a qualquer momento. Uma vez alterados, a continuidade ao uso do “e-Bolsa” está condicionada a nova aceitação dos **TERMOS DE USO**. A não aceitação dos **TERMOS DE USO** modificados impedirá a continuidade do uso do “e-Bolsa”. 

  Estes **TERMOS** não caracterizam concessão de direitos a usuários ou a terceiros, mas como condições gerais de uso do site. 

  **Cláusula 1ª – Descrição do "e-Bolsa"**

  O "e-Bolsa" é uma aplicação que funciona como portal de abertura no requerimento da bolsa escolar, com o objetivo de atender na forma digital o preenchimento do formulário. O "e-Bolsa" permite ao usuário o exercício de seus direitos para revisar, atualizar e tomar conhecimento das informações pessoais que tenha compartilhado com a Rede de Educação Adventista. O uso do "e-Bolsa" é gratuito e seu gerenciamento é restrito a operadores autorizados. É um serviço aberto ao público em geral, mas nem por isso configura prestação de serviço. Toda informação exibida, exceto dados pessoais e a que venha a ser incluída ou alterada pelo usuário nos comentários ou em campos abertos é de propriedade exclusiva da Rede de Educação Adventista. Depende de autorização escrita da Rede de Educação Adventista a reprodução do conteúdo, mesmo que parcial. 
  
  O "e-Bolsa" é oferecido ao usuário NA FORMA EM QUE SE ENCONTRA e DE ACORDO COM A DISPONIBILIDADE, ficando a Rede de Educação Adventista isenta de qualquer responsabilidade e obrigação pela sua disponibilidade, bem como, se reserva o direito de modificar, suspender ou encerrar o "e-Bolsa". 

  **Cláusula 2ª – Responsabilidade por Uso**
  
  O usuário é o único responsável pelo uso que fizer do "e-Bolsa" e deve utilizar exclusivamente para este fim. A utilização deverá ser feita com observação das leis, normas e regulamentos vigentes, inclusive no que se refere aos direitos autorais, direitos da personalidade e de marcas registradas de propriedade da rede de Educação Adventista. 

  Ao efetuar o uso do "e-Bolsa" o usuário declara, sob as penas da lei, que possui capacidade jurídica para a aceitação dos termos do presente instrumento, e que, na falta de capacidade, absoluta ou relativa, está representado e/ou assistido por seus pais, tutores, curadores, representantes legais, ou equivalentes, que respondem por seus atos, nos termos da legislação vigente. 

  A violação da Política de Privacidade de Dados da Rede de Educação Adventista e destes **TERMOS DE USO** pode sujeitar o infrator às consequências legais, bem como a desautorização de uso. 

  O "e-Bolsa" poderá coletar dados dos usuários quando estes são fornecidos voluntariamente, conforme as diretrizes da Política de Privacidade de Dados da Rede de Educação Adventista. 

  O usuário poderá solicitar correção, exclusão ou ocultação de informações que lhe digam respeito do "e-Bolsa" por meio do próprio "e-Bolsa" quando disponível, ou ao Encarregado/data protection officer (DPO), conforme a Política de Privacidade de Dados da Rede de Educação Adventista. 

  **Cláusula 3ª – Informações Privativas do Usuário**

  No que se refere a dados pessoais, a Rede de Educação Adventista adota o critério denominado privacy by design segundo o qual, dados pessoais apenas e unicamente se prestam à atividade principal e são utilizados sob autorização. 

  Ao aceitar estes **TERMOS** o usuário concorda que a rede de Educação Adventista poderá registrar, catalogar, compartilhar em seu grupo institucional as informações fornecidas pelo usuário no "e-Bolsa", ou em cumprimento de ordem judicial ou disposição legal, inclusive em âmbito internacional. 

  A rede de Educação Adventista não utiliza seus dados de contato para enviar mensagens indesejadas (spam) ou materiais promocionais que não tenham sido previamente solicitados/aceitos, mas poderá entrar em contato quando estritamente necessário. 

  **Cláusula 4ª - Práticas de uso e armazenamento**

  A Rede de Educação Adventista do Sétimo Dia, como proprietária do "e-Bolsa", tem poderes amplos e absolutos sobre seu conteúdo, acessos, funcionamento, limitações de uso e seu encerramento. O conteúdo destes **TERMOS e da Política de Privacidade de Dados** continuam vigentes por tempo indeterminado mesmo quando o serviço "e-Bolsa" for interrompido. 

  **Cláusula 5ª - Conteúdo e Propriedade Intelectual do "e-Bolsa"**

  O conteúdo exibido no "e-Bolsa" é parte de informações de propriedade da Rede de Educação Adventista. 

  A Rede de Educação Adventista é proprietária do "e-Bolsa" e dos dados, códigos de sistemas, layout, informações técnicas, regulamentos, avisos e notificações. Por isso, nenhum destes itens poderão ser copiados, reproduzidos ou manipulados sem autorização. 

  Se o "e-Bolsa" oferece ao usuário um formulário para envio de informações e Upload de arquivos, este será o único responsável pela integridade, originalidade e legalidade do conteúdo que compartilhar. 

  **a) Conteúdo Proibido:** não será permitido nenhum conteúdo considerado **Ilegal, Obceno, Discriminatório, Fraudulento, Violento** ou que promova estes contexto. O usuário se compromete não incluir qualquer informação que viole estes termos, bem como notificar alguma a qualquer preposto ou autoridade conhecida da Rede de Educação Adventista a respeito de tais violações. 
  
  **INFORMAÇÕES PRIVADAS E CONFIDENCIAIS:** O usuário não poderá divulgar ou dar conhecimento a terceiros de informações pessoais e confidenciais de indivíduos, como números de documentos, filiação e outros. 

  **b) Conteúdo Ilegal:** Todo conteúdo contrário à lei e aos bons costumes é considerado mal-intencionado, e como tal, não deve ser publicado, sob pena de responsabilidade civil e criminal. 

  **c) Comércio e Propaganda:** É vedado o uso comercial ou com a finalidade de obter lucro. 

  **Cláusula 6ª – Disposições Finais**

  Para a solução de qualquer divergência legal entre usuários do "e-Bolsa" e a Rede de Educação Adventista, um Pedido de Consideração deverá ser formulado por escrito e encaminhado ao Encarregado - data protection officer (DPO) - conforme a Política de Privacidade de Dados da Rede de Educação Adventista quando for impossível fazê-lo pelo "e-Bolsa". 
  
  **Cláusula 7ª. - Foro**

  Para dirimir qualquer conflito pela via judicial, é competente o foro da sede da Rede de Educação Adventista em Brasília – DF. 
  ''';

  @override
  String get termsReadAndAccept => 'Li e aceito os termos';

  @override
  String get termsAgreeUse => 'Concordo com os termos de uso do e-Bolsa';

  @override
  String get createdAccountPageTitle => 'Conta Criada';

  @override
  String get createdAccountSuccessTitle => 'Sua conta foi criada com sucesso!';

  @override
  String get createdAccountSuccessDescription => '''
  Enviamos um e-mail de confirmação para o e-mail cadastrado.

  Verifique sua caixa de entrada e também a pasta de spam ou lixo eletrônico e **clique no link de confirmação para ativar sua conta.**

  Você precisa confirmar seu e-mail para acessar o sistema.
  ''';

  @override
  String get createdAccountDoneButton => 'Ok, Entendi';

  @override
  String get createAccountDialogDescription =>
      'Este cadastro inicial é exclusivo para o Responsável Legal (requerente); não utilize os dados do candidato/aluno nesta tela.\n\nSe já possui um acesso de anos anteriores, clique em "Entrar" na página inicial, e, se não lembrar a senha, use a opção "Esqueceu sua senha?" na tela de Login.';

  @override
  String get createAccountDialogDoneButton => 'Estou ciente';

  /// ------------------- Forgot password -------------------
  @override
  String get forgotPasswordHeader => 'Redefinir Senha';

  @override
  String get forgotPasswordDescription =>
      'Insira seu CPF para redefinir sua senha:';

  @override
  String get forgotPasswordHelpText =>
      'Enviaremos um link para o e-mail cadastrado neste CPF para que você '
      'possa redefinir sua senha. Esse link irá expirar em três horas.';

  @override
  String get forgotPasswordSuccessTitle => 'E-mail enviado!';

  @override
  String get forgotPasswordSuccessDescription =>
      'Verifique sua caixa de entrada e siga as instruções para redefinir '
      'sua senha.';

  @override
  String get forgotPasswordBackToLoginAction => 'Voltar para o login';

  @override
  String get forgotPasswordDialogTitle => 'Recuperação de senha';

  @override
  String get forgotPasswordDialogDescription =>
      '''Enviamos um link de recuperação para o e-mail cadastrado neste CPF. Acesse sua caixa de entrada para criar uma nova senha.\n\nPara sua segurança, ele expira em 3 horas.\n''';

  /// ------------------- Domain and validation messages -------------------
  @override
  String get invalidCredentials => 'Usuário ou senha inválidos.';

  @override
  String get loginAccessDenied =>
      'Acesso ao serviço de autenticação negado. Tente novamente mais tarde.';

  @override
  String get accountAlreadyExists =>
      'Já existe uma conta com esse e-mail ou CPF.';

  @override
  String get loginValidationCpfRequired => 'Informe seu CPF';

  @override
  String get loginValidationInvalidCpf => 'CPF inválido';

  @override
  String get loginValidationPasswordRequired => 'Informe sua senha';

  @override
  String get createAccountValidationInvalidCpf => 'CPF inválido.';

  @override
  String get createAccountValidationFullNameRequired =>
      'Informe seu nome completo.';

  @override
  String get createAccountValidationInvalidEmail => 'E-mail inválido.';

  @override
  String get createAccountValidationInvalidPhone =>
      'Informe um número de celular válido.';

  @override
  String get createAccountValidationPasswordMin =>
      'A senha deve ter no mínimo 12 caracteres.';

  @override
  String get createAccountValidationPasswordMismatch =>
      'As senhas não conferem.';

  @override
  String get errorRateLimit => 'Excesso de requisições.';

  @override
  String get forgotPasswordValidationCpfRequired =>
      'Informe seu CPF cadastrado.';

  @override
  String get accountNotConfirmedTitle => 'Seu e-mail não foi confirmado!';

  @override
  String get accountNotConfirmedDescription =>
      '''Para acessar o sistema clique no link que enviamos para sua caixa de entrada.\n\n**Caso não tenha recebido nossa mensagem**, atualize seu e-mail e clique em Reenviar''';

  @override
  String get accountNotConfirmedResendEmailButton => 'Reenviar E-mail';

  @override
  String get accountNotConfirmedDialogTitle => 'Verifique seu e-mail';

  @override
  String get accountNotConfirmedDialogDescription =>
      'Enviamos um e-mail de confirmação para você. Acesse sua caixa de entrada e clique no link para ativar sua conta e começar a usar o sistema.';

  /// ------------------- JWT -------------------
  @override
  String get jwtInvalidToken => 'Token inválido.';
  @override
  String jwtDecodeError(Object error) => 'Erro ao decodificar JWT: $error';

  /// ------------------- NOTICES -------------------

  @override
  String get noticesTermsTitle => 'Editais e Termos Aditivos';

  @override
  String get noticesTermsDescription =>
      'Selecione o ano, a cidade e unidade escolar para conferir os Editais e Termos Aditivos';

  @override
  String get noticesTermsLocationDeniedPermanently =>
      'A localizacao foi negada permanentemente. Ative nas configuracoes para melhorar os resultados.';

  @override
  String get noticesTermsLocationDenied =>
      'A localizacao foi negada. Voce pode continuar selecionando os filtros manualmente.';

  @override
  String get noticesTermsBottomSheetSearchHelp =>
      'Digite para filtrar e toque para selecionar';

  @override
  String get noticesTermsBottomSheetNoResults => 'Nenhum resultado encontrado';

  @override
  String get noticesTermsCloseAction => 'Fechar';

  @override
  String get noticesTermsSearchHint => 'Pesquisar';

  @override
  String get noticesTermsSelectYear => 'Selecione o ano';

  @override
  String get noticesTermsSelectCity => 'Selecione a cidade';

  @override
  String get noticesTermsSelectUnit => 'Selecione a unidade';

  @override
  String get noticesTermsEadLabel => 'EAD - Ensino Superior';

  @override
  String get noticesTermsIncompleteFiltersMessage =>
      'Preencha Ano letivo, Cidade e Unidade escolar para visualizar os editais.';

  @override
  String get noticesTermsNoResultsTitle => 'Sem editais abertos';

  @override
  String get noticesTermsNoResultsMessage =>
      'Não encontramos editais para os filtros selecionados. Tente outro ano, cidade ou unidade.';

  @override
  String get noticesTermsRegistrationPeriod => 'Período de Incrição';

  @override
  String get noticesTermsPublishedAtLabel => 'Data de Publicação';

  @override
  String get noticesTermsLevelLabel => 'Nível de Ensino';

  @override
  String get noticesTermsModalityLabel => 'Modalidade';

  @override
  String get noticesTermsViewNoticeAction => 'Ver Edital';

  @override
  String get noticesTermsViewAdditiveTermAction => 'Ver Termo Aditivo';

  @override
  String get noticesTermsScholarshipApplicationDescription =>
      'Você está iniciando o formulário de solicitação para a bolsa. Solicitaremos informações pessoais dos membros da sua família para compor sua análise.\n\nGarantimos que seus dados estão protegidos e serão usados apenas para a análise da bolsa';

  @override
  String get noticesTermsDocumentTitle => 'Documento';

  @override
  String get noticesTermsDocumentNoticeDescription => 'Visualização do edital';

  @override
  String get noticesTermsDocumentAdditiveTermDescription =>
      'Visualização do termo aditivo';

  @override
  String get noticesTermsFileNotFound => 'Arquivo não encontrado.';

  @override
  String get noticesStreamError => 'Erro inesperado. Tente novamente';

  /// ------------------- Onboarding -------------------

  @override
  String get onboardingItem1Description =>
      'Com o E-bolsa você solicita pedido de bolsa para qualquer unidade escolar da rede Adventista no Brasil!';

  @override
  String get onboardingItem2Title => '1º Passo';

  @override
  String get onboardingItem2Description =>
      'Para concorrer a uma bolsa cadastre as  informações socioeconômicas da  família e do(s) candidatos.';

  @override
  String get onboardingItem3Title => '2º Passo';

  @override
  String get onboardingItem3Description =>
      'Envie os documentos da família e do candidato solicitados pelo edital.';

  @override
  String get onboardingItem4Title => 'Vamos começar!';

  @override
  String get onboardingItem4Description => '';

  @override
  String get onboardingViewNoticesAction => 'Ver Editais';

  @override
  String get onboardingNextAction => 'Próximo';

  /// ------------------- Home -------------------
  @override
  String get homeWelcome => 'Olá,';

  @override
  String get homeTitle => 'Processos';

  @override
  String get homeSubtitleEmptyProcess =>
      'Continue a solicitação iniciada ou crie uma nova solicitação para o ano de';

  @override
  String get homeSubtitleProcessInProgress =>
      'Confira abaixo seus processos e solicitações de bolsa. Clique em um item para ver detalhes ou inicie uma nova solicitação para';

  @override
  String get homeSubtitleProcessCompleted =>
      'Veja os processos que você participou em';

  @override
  String get homeRenewScholarshipButton => 'Renovar Bolsa';

  @override
  String get homeImportantTitle => 'Importante';

  @override
  String get homeImportantMessage => '''
A bolsa de estudo terá validade para o ano letivo de 2026, com a renovação anual através de seleção. A concessão de bolsa de estudo estará sujeita à disponibilidade de vagas na unidade escolar solicitada e ao perfil socioeconômico compatível às exigências da Lei Complementar nº 187/2021.''';

  /// ------------------- Process Result -------------------
  @override
  String get approved => 'Aprovado';

  @override
  String get disqualified => 'Desclassificado';

  @override
  String get underReview => 'Em Análise';

  @override
  String get pending => 'Pendente';

  /// ------------------- Enrollment Status -------------------
  @override
  String get withoutRegistration => 'Sem Matrícula';

  @override
  String get registered => 'Matriculado';

  @override
  String get inProcess => 'Em Processo';

  /// ------------------- Process Card  -------------------
  @override
  String get schoolUnit => 'Unidade Escolar';

  @override
  String get course => 'Curso';

  @override
  String get processCode => 'Processo';

  @override
  String get viewButton => 'Visualizar';

  @override
  String get result => 'Resultado';

  @override
  String get enrollmentStatus => 'Status Matrícula';

  @override
  String get administrativeRegion => 'Região Administrativa';

  @override
  String get processCardNotice => 'Edital';

  @override
  String get processCardAddendumSentence => 'Termo Aditivo';

  @override
  String get processCardLevel => 'Nível';

  @override
  String get processCardScholarshipType => 'Tipo de Bolsa';

  @override
  String get processCardProcessType => 'Tipo de Inscrição';

  @override
  String get processCardStep => 'Etapa';

  @override
  String get processCardCandidatePlural => 'Candidatos';

  @override
  String get processCardParticipatingEducationalUnits =>
      'Unidades Educacionais Participantes';

  @override
  String get processCardDetaiButton => 'Detalhe';

  @override
  String get processCardApplyForAScholarshipButton => 'Solicitar Bolsa';

  /// ------------------- Process Card Banners  -------------------

  @override
  String get processCardBannerRegisterEnd => 'Data limite para inscrição';

  @override
  String get processCardBannerPendindDocumentsSingular => 'Documento Pendente';

  @override
  String get processCardBannerPendindDocumentsPlural => 'Documentos Pendentes';

  /// ------------------- Process Detail  -------------------
  @override
  String get processDetailTitle => 'Detalhe';

  @override
  String get processDetailDeadlines => 'Prazos';

  @override
  String get processDetailCandidates => 'Candidatos';

  @override
  String get processDetailNoticesAndTerms => 'Editais e Termos Aditivos';

  @override
  String get processDetailDeclarationModels => 'Modelos de declaração';

  @override
  String get processDetailCancelSubscription => 'Cancelar solicitação de bolsa';

  /// ------------------- Process Steps  -------------------

  @override
  String get processDeadLinesTitle => 'Prazos';

  @override
  String get processDeadlinesSubtitle =>
      'Fique atento aos prazos do seu processo';

  @override
  String get processDeadlinesRegisterStart => 'Início das Inscrições';

  @override
  String get processDeadlinesRegisterEnd => 'Término das Inscrições';

  @override
  String get processDeadlinesDocumentationUpload =>
      'Término envio dos documentos';

  @override
  String get processDeadlinesDocumentationReturn =>
      'Término correção dos documentos';

  @override
  String get processDeadlinesResultRelease =>
      'Início divulgação dos resultados';

  /// ------------------- Process Steps  -------------------
  @override
  String get processStepsInitial => 'Iniciado';

  @override
  String get processStepsSecond => 'Cadastro';

  @override
  String get processStepsThird => 'Documentação';

  @override
  String get processStepsVerification => 'Conferência';

  @override
  String get processStepsFifth => 'Em Análise';

  @override
  String get processStepsCompleted => 'Concluído';

  /// ------------------- Processes Type -------------------
  @override
  String get newProcess => 'Nova Solicitação';

  @override
  String get renewProcess => 'Renovação';

  /// ------------------- Result Status -------------------
  @override
  String get resultStatusAnalysis => 'Em análise';

  @override
  String get resultStatusApproved50 => 'Deferido 50%';

  @override
  String get resultStatusApproved100 => 'Deferido 100%';

  @override
  String get resultStatusRejected => 'Indeferido';

  @override
  String get resultStatusDisqualified => 'Desclassificado';

  @override
  String get resultStatusWaitingList => 'Lista de Espera';

  /// ------------------- Registration Status -------------------
  @override
  String get registrationStatusNoRegistration => 'Sem Matrícula';

  @override
  String get registrationStatusReserveSpot => 'Reserva de Vaga';

  @override
  String get registrationStatusRegistered => 'Matriculado';

  @override
  String get registrationStatusCompleted => 'Finalizado';

  @override
  String get registrationStatusLocked => 'Trancado';

  @override
  String get registrationStatusWithdrawal => 'Desistência';

  @override
  String get registrationStatusCanceled => 'Cancelado';

  @override
  String get registrationStatusAwaitingApproval => 'Aguardando Aprovação';

  @override
  String get registrationStatusTransferred => 'Transferido';

  /// ------------------- Process Candidates -------------------
  @override
  String get processCandidatesTitle => 'Candidatos';

  @override
  String get processCandidatesSubtitle =>
      'Confira abaixo os candidatos à bolsa';

  /// ------------------- Process Notices and Terms -------------------
  @override
  String get processTermsAndNoticesTitle => 'Editais e Termos Aditivos';

  @override
  String get processTermsAndNoticesSubtitle =>
      'Fique atento aos editais e termos aditivos referentes ao seu Processo de Bolsa';

  /// ------------------- Templates (declaration models) -------------------
  @override
  String get processDeclarationModelsTitle => 'Modelos de Declaração';

  @override
  String get processDeclarationModelsSubtitle =>
      'Seguem abaixo as declarações necessárias de acordo com o preenchimento do seu cadastro.';

  /// ------------------- Danger Zone - Cancel Subscription -------------------
  @override
  String get processCancelDialogTitle => 'Cancelar pedido de bolsa?';

  @override
  String get processCancelDialogDescription =>
      'Se você cancelar agora, todos os dados preenchidos serão perdidos e este processo será fechado. Para tentar novamente no futuro, será necessário começar uma nova solicitação.';

  @override
  String get processCancelDialogConfirm => 'Sim, cancelar';

  @override
  String get processCancelDialogDeny => 'Não';

  @override
  String get processCancelReasonDialogTitle => 'Motivo do Cancelamento';

  @override
  String get processCancelReasonDialogHint => 'Motivo do Cancelamento';

  @override
  String get processCancelReasonDialogConfirm => 'Confirmar';

  /// ------------------- End Drawer -------------------
  @override
  String get endDrawerTitle => 'Navegação';

  @override
  String get endDrawerLogoutLabel => 'Sair';

  /// ------------------- Nav Bar -------------------

  @override
  String get addFamilyMember => 'Adicionar membro familiar';
  @override
  String get peopleHomeLabel => 'Pessoas da sua casa';
  @override
  String get familyStepDescriptionPrefix =>
      'Agora, registre cada pessoas que vive na residência, ';
  @override
  String get familyStepDescriptionEmphasis =>
      'incluindo você e quem vai estudar.';
  @override
  String get familyStepDescriptionSuffix =>
      ' É importante listar todos os membros da família.';

  @override
  String get candidateStepTitle => 'Candidato';

  @override
  String get candidateStepDescriptionPrefix => 'Nesta etapa, adicione ';

  @override
  String get candidateStepDescriptionEmphasis => 'todos';

  @override
  String get candidateStepDescriptionSuffix =>
      ' os candidatos que você deseja que participe do processo seletivo. Lembrando que os mesmos precisam compor o grupo familiar.';

  @override
  String get addCandidate => 'Adicionar candidato';

  @override
  String get noCandidatesRegistered => 'Nenhum candidato registrado ainda.';

  @override
  String get selectCandidateLabel => 'Selecione o candidato';

  @override
  String get guardianRelationshipLabel =>
      'Relação do responsável com candidato';

  @override
  String get unitOfInterestLabel => 'Unidade de interesse';

  @override
  String intendedCourseLabel(int year) => 'Curso/Série pretendido em $year';

  @override
  String get guardianRelationshipFather => 'Sou pai';

  @override
  String get guardianRelationshipMother => 'Sou mãe';

  @override
  String get guardianRelationshipGuardianship => 'Tenho guarda judicial';

  @override
  String get addCandidateAction => 'Adicionar';

  @override
  String get candidateDeleteDialogTitle => 'Confirmação';

  @override
  String candidateDeleteDialogMessage(String name) =>
      'Tem certeza que deseja excluir "$name" como candidato?';

  @override
  String get candidateMissingDialogIntro =>
      'Todos os candidatos devem estar devidamente cadastrados nessa etapa. Os seguintes candidatos abaixo não foram cadastrados:';

  @override
  String get candidateAwareDialogBullet1 =>
      'As informações prestadas poderão ser cruzadas pela Receita Federal do Brasil.';

  @override
  String get candidateAwareDialogBullet2 =>
      'A bolsa não será cumulativa com nenhum outro benefício.';

  @override
  String get zipCodeNotFound => 'CEP não encontrado';

  @override
  String get zipCodeInvalid => 'CEP inválido ou não encontrado';

  @override
  String get enrollmentStep1ValidationError =>
      'Preencha todos os campos obrigatórios';

  /// ------------------- Nav Bar -------------------
  @override
  String get pdfViewerErrorToLoadArchive => 'Não foi possível carregar o PDF.';

  // Family info bottom sheet
  @override
  String get familyInfoGroupTitle => 'Grupo Familiar';
  @override
  String get familyInfoGroupDescription =>
      'São todas as pessoas que moram na sua casa e dividem a renda ou as despesas (conforme a Lei 187/2021).';
  @override
  String get familyInfoIncomeTitle => 'Valor da Renda Bruta Mensal';
  @override
  String get familyInfoIncomeDescription =>
      'É a soma de tudo o que a família ganha (salário, bicos, pensões ou aluguéis) antes de qualquer desconto.';
  @override
  String get familyInfoKinshipTitle => 'Parentesco';
  @override
  String get familyInfoKinshipDescription =>
      'Indique o que cada pessoa da casa é para você (exemplo: filho, esposa, irmão ou neto).';

  // Member registration (family) step
  @override
  String get memberRegistrationAppBarTitle => 'Cadastro membro familiar';

  @override
  String get memberRegistrationTitle => 'Cadastro individual';

  @override
  String get memberRegistrationDescription =>
      'Abaixo informe os dados pessoais do membro da familia';

  @override
  String get personalDataTitle => 'Dados Pessoais';

  @override
  String get occupationStepDescription =>
      'Agora nos informe algumas informações referente a ocupação e renda do membro familiar';

  @override
  String get childSupportIncomeQuestion =>
      'Recebe pensão alimentícia? (Sendo judicial ou não, informar quanto recebe)';

  @override
  String get privatePensionQuestion => 'Recebe Previdência Privada?';

  @override
  String get inssBenefitQuestion => 'Recebe outro beneficio/auxilio do INSS?';

  @override
  String get childSupportInfoDialogBody1 =>
      'Caso você receba a pensão em seu nome, mas esse benefício seja para outro(s) integrante(s) do grupo familiar, gentileza informar esse valor no cadastro dele(s).';

  @override
  String get childSupportInfoDialogBody2 =>
      'Caso receba um único valor de pensão para mais de um integrante do grupo familiar, divida essa quantia pelo número de pessoas beneficiadas por ela, e informe a parte (valor) correspondente no cadastro de cada um deles. (Ex.: Recebe R\$ 900,00 reais de pensão para 3 filhos, informe R\$ 300,00 reais no cadastro de cada um deles.)';

  @override
  String get childSupportInfoDialogBody3 =>
      'Insira o valor da pensão apenas para os membros da família que recebem este benefício.';

  @override
  String get childSupportInfoDialogBody4 =>
      'O comprovante de recebimento da pensão será gerado individualmente para todos aqueles que selecionarem a opção “sim”. Caso você possua um único comprovante ou única declaração deste valor, insira o mesmo documento para todos os beneficiários.';

  @override
  String get inssBenefitInfoDialogBody1 =>
      'Em caso de “Aposentado e/ou Pensionista” ou “Beneficiário(a) de Prestação Continuada (BPC)”, insira o valor recebido em ocupações.';

  @override
  String get inssBenefitInfoDialogBody2 =>
      'Caso contrário, poderá ser adicionado aqui o valor correspondente à: Auxílio-Doença, Auxílio-Acidente, Auxílio-Reclusão, Auxílio-Doença da Aeronauta Gestante, Benefício ao Trabalhador Portuário Avulso, Salário-Maternidade, Salário Família, Seguro-Defeso Pescador Artesanal ou outro.';

  @override
  String get familyMembersSubStepNavTitle => 'Membro familiar';

  @override
  String get otherIncomeSubStepNavTitle => 'Outras Rendas';

  @override
  String get otherIncomeStepTitle => 'Outros informações familiares';

  @override
  String get otherIncomeStepDescription =>
      'Além do salário, informe outros recebimentos da família e o valor médio de mercado dos seus bens e propriedades.';

  @override
  String get otherIncomeMemberStepDescription =>
      'Agora, forneça algumas informações sobre outras fontes de renda do membro familiar.';

  @override
  String get otherIncomeSourcesInfoTitle => 'Outras fontes de renda';

  @override
  String get otherIncomeSourcesInfoDescription =>
      'Informe se possui outras fontes de renda além do salário, como: renda de aluguel, pensão alimentícia, previdência privada, investimentos bancários, entre outros. Informe o valor mensal de cada uma ou selecione a opção “Nenhuma”, caso não possua.';

  @override
  String otherIncomeHasOtherSourceQuestion(String name) =>
      '$name possui alguma outra fonte de renda?';

  @override
  String get saveMemberAction => 'Salvar Membro';

  @override
  String get otherIncomeSourcePageAppBarTitle => 'Outras Fontes de Renda';

  @override
  String get selectIncomeTypeLabel => 'Selecione o tipo de renda';

  @override
  String get addIncomeSourceAction => 'Adicionar fonte de renda';
  @override
  String get addOtherIncomeSource => 'Adicionar outra fonte de renda';

  @override
  String get otherIncomeAverageAlertDescription =>
      'Se essa renda não é recebida todos os meses, informe a média mensal, dividindo o valor total recebido pela quantidade de meses correspondente.';

  @override
  String get otherIncomeSelectedDetailsPrefix =>
      'Detalhes da renda extra selecionada: ';

  @override
  String get otherIncomeMonthlyAverageLabel => 'Média mensal da renda em R\$';

  @override
  String get otherIncomeValueLabel => 'Valor da renda em R\$';

  @override
  String get descriptionLabel => 'Descrição';

  @override
  String get otherIncomeNoneConfirmationAppBarTitle => 'Informação de renda';

  @override
  String get otherIncomeNoneConfirmationTitle =>
      'Confirme que não possui outras fontes de renda';

  @override
  String get otherIncomeNoneConfirmationDescriptionPrefix =>
      'Confirme que este membro familiar não recebe nenhuma das fontes de renda listadas abaixo. Se este membro possuir alguma dessas rendas, clique em ';

  @override
  String get otherIncomeNoneConfirmationCancelHighlight => 'Cancelar';

  @override
  String get otherIncomeNoneConfirmationDescriptionMiddle =>
      ' para retornar e marcar ';

  @override
  String get otherIncomeNoneConfirmationYesHighlight => '‘Sim’';

  @override
  String get otherIncomeNoneConfirmationDescriptionSuffix =>
      ' na pergunta de renda extra da tela anterior.';

  @override
  String get otherIncomeNoneDeclarationLabel =>
      'Declaro que não possuo outras fontes de renda';

  @override
  String get otherIncomeNoSourcesDeclaredMessage =>
      'Declaro que este membro familiar não possui outras fontes de renda';

  @override
  String get undoAction => 'Desfazer';

  @override
  String get rentedPropertyIncomeQuestion =>
      'Recebe valor de imóvel alugado ou arrendado?';

  @override
  String get financialHelpQuestion => 'Recebe ajuda financeira?';

  @override
  String get financialHelpNone => 'Nenhum';

  @override
  String get financialHelpFamily => 'Familiar';

  @override
  String get financialHelpOther => 'Outro';

  @override
  String get governmentProgramQuestion =>
      'A família é beneficiária de algum programa do Governo?';

  @override
  String get informValueInReaisLabel => 'Informe o valor em R\$';

  @override
  String get financialHelpFromWhomLabel => 'De quem?';

  @override
  String get informGovernmentProgramLabel =>
      'Qual programa (Informe todos os programas)';

  @override
  String get assetsRelationSubStepNavTitle => 'Relação de bens';

  @override
  String get ownsPropertyQuestion => 'Possui imóvel próprio?';

  @override
  String get ownsFinancialInvestmentQuestion =>
      'Possui investimento financeiro?';

  @override
  String get ownsVehicleQuestion => 'Possui veículo?';

  @override
  String get ownsVehicleSubtitle =>
      '(Carro - Caminhonete/caminhoneta - Caminhão/carreta - Motocicleta - Embarcação - Aeronave)';

  @override
  String get addPropertyAction => '+ Adicionar imóvel';

  @override
  String get ownPropertyPageTitle => 'Imóvel próprio';

  @override
  String get ownPropertyPageDescription =>
      'Informe alguns dados referente ao imóvel próprio';

  @override
  String get savePropertyAction => 'Salvar imóvel';

  @override
  String get propertyFinancingValueLabel => 'Valor do financiamento:';

  @override
  String get propertyAssetValueDisplayLabel => 'Valor do bem:';

  @override
  String get addInvestmentAction => '+ Adicionar investimento';

  @override
  String get financialInvestmentPageTitle => 'Investimento';

  @override
  String get financialInvestmentPageDescription =>
      'Informe alguns dados referente ao investimento';

  @override
  String get saveInvestmentAction => 'Salvar investimento';

  @override
  String get addVehicleAction => '+ Adicionar veículo';

  @override
  String get vehiclePageTitle => 'Veículo';

  @override
  String get vehiclePageDescription =>
      'Informe alguns dados referente ao veículo';

  @override
  String get vehicleBrandLabel => 'Marca';

  @override
  String get vehicleModelLabel => 'Modelo';

  @override
  String get vehicleYearLabel => 'Ano de fabricação';

  @override
  String get vehicleFinancingInstallmentLabel =>
      'Financiamento - Valor parcela';

  @override
  String get saveVehicleAction => 'Salvar veículo';

  @override
  String get vehicleYearDisplayLabel => 'Ano de Fabricação:';

  @override
  String get vehicleInstallmentDisplayLabel => 'Valor da parcela:';

  @override
  String get summarySubStepNavTitle => 'Resumo';

  @override
  String get summaryStepDescription =>
      'Abaixo você consegue ver como é feito o calculo de renda per capita da sua família a partir da renda informada.';

  @override
  String get grossFamilyIncomeLabel => 'Renda Bruta Familiar';

  @override
  String get incomeDependentsLabel => 'Dependentes da renda';

  @override
  String get perCapitaIncomeLabel => 'Renda per capita';

  @override
  String get minimumWageLabel => 'Salário mínimo';

  @override
  String get perCapitaTimesMinimumWageLabel =>
      'Renda per capita X Salário Mínimo';

  @override
  String get salaryRatioSuffix => 'salários';

  @override
  String get summaryAdvanceDialogBody1 =>
      'Ao voltar para a etapa anterior, seus documentos enviados não serão salvos.';

  @override
  String get summaryAdvanceDialogBody2 =>
      'Lembre-se que o prazo final é "Data". Sem a conclusão do envio completo dos documentos na etapa 6, poderá ser desclassificado.';

  @override
  String get summaryAdvanceDialogQuestion => 'Tem certeza que deseja voltar?';

  @override
  String get summaryAdvanceDialogConfirm => 'Estou ciente, voltar';

  @override
  String get expensesStepTitle => 'Gastos mensais da família';

  @override
  String get expensesStepDescription =>
      'Para conhecermos melhor a sua realidade, informe os gastos mensais da família.';

  @override
  String get expensesFoodSubStepNavTitle => 'Alimentação';

  @override
  String get expenseFoodValueLabel => 'Valor alimentação média mensal';

  @override
  String get expenseFoodHelper => '(Supermercado, feira, padaria...)';

  @override
  String get expensesHealthSubStepNavTitle => 'Saúde';

  @override
  String get expenseHealthPlanValueLabel =>
      'Valor convênio médico/plano de saúde';

  @override
  String get expenseHealthPlanHelper =>
      'Total de todos os integrantes da família';

  @override
  String get expenseChronicDiseaseValueLabel => 'Valor doença crônica';

  @override
  String get expenseChronicDiseaseHelper =>
      'Total das despesas gastas com doenças crônica';

  @override
  String get expenseChronicDiseaseDialogBody =>
      'Será necessário apresentar cópia do laudo e/ou parecer médico, de até 180 dias, onde descreva a enfermidade e mencione que é uma doença crônica, e cópia das Notas Fiscais dos medicamentos do último mês.';

  @override
  String get expenseOtherHealthServicesValueLabel => 'Valor outros serviços';

  @override
  String get expenseOtherHealthServicesSpecifyLabel =>
      'Especifique o valor a cima';

  @override
  String get expensesEducationSubStepNavTitle => 'Educação';

  @override
  String get expenseHasEducationCostsQuestion =>
      'Possui gastos com educação básica, superior, cursos de idiomas ou outros? *';

  @override
  String get expenseSchoolTransportQuestion =>
      'Despesas com Transporte Escolar: *';

  @override
  String get expenseSchoolTransportNaoUtiliza => 'Não Utiliza';

  @override
  String get expenseSchoolTransportPagoFretado => 'Pago/Fretado';

  @override
  String get expenseSchoolTransportProprioCombustivel =>
      'Próprio (Combustível)';

  @override
  String get expenseSchoolTransportPublico => 'Público';

  @override
  String get expenseEducationValueLabel => 'Valor gasto R\$';

  @override
  String get addEducationExpenseAction => '+ Adicionar gasto';

  @override
  String get educationExpensePageDescription =>
      'Informe alguns dados referente ao educação.';

  @override
  String get expenseEducationTypeBasic => 'Mensalidade Educação Básica';

  @override
  String get expenseEducationTypeHigher => 'Mensalidade Ensino Superior';

  @override
  String get expenseEducationTypeLanguage => 'Cursos de Idiomas';

  @override
  String get expenseEducationTypeOther => 'Outras despesas';

  @override
  String get expenseEducationForWhomLabel => 'Para quem?';

  @override
  String get expenseEducationInstitutionLabel => 'Onde? (Instituição)';

  @override
  String get expenseEducationMonthlyValueLabel => 'Valor mensal';

  @override
  String get saveEducationExpenseAction => 'Salvar';

  @override
  String get expenseEducationForWhomDisplayLabel => 'Para quem:';

  @override
  String get expenseEducationWhereDisplayLabel => 'Onde:';

  @override
  String get expenseEducationCostsRequiredError => 'Este campo é obrigatório';

  @override
  String get expenseSchoolTransportRequiredError =>
      'Informe o tipo do despesa com transporte escolar';

  @override
  String get expensesAutomobileSubStepNavTitle => 'Automóvel';

  @override
  String get expenseIpvaLabel => 'IPVA';

  @override
  String get expenseCarInsuranceLabel => 'Seguro do carro';

  @override
  String get expenseVehicleFinancingLabel => 'Financiamento veiculo';

  @override
  String get expensesLoansSubStepNavTitle => 'Empréstimos';

  @override
  String get expenseBankLoansLabel => 'Financiamentos bancários / Empréstimos';

  @override
  String get expenseBankLoansHelper => 'Valor pago mensalmente';

  @override
  String get expenseLoansOtherServicesLabel => 'Outros serviços';

  @override
  String get expenseLoansOtherServicesHelper => 'Especificar';

  @override
  String get expenseLoansOtherServicesDescribeLabel =>
      'Descreva o tipo de gasto';

  @override
  String get expenseRentValueLabel => 'Valor aluguel do imóvel';

  @override
  String get expenseFinancingValueLabel => 'Valor financiamento imóvel';

  @override
  String get expenseIptuValueLabel => 'Valor IPTU';

  @override
  String get expenseIptuHelper => 'Informar o valor total dividido por doze';

  @override
  String get expenseCondoValueLabel => 'Valor do condomínio';

  @override
  String get expenseElectricityValueLabel => 'Valor energia elétrica';

  @override
  String get expenseWaterValueLabel => 'Valor água';

  @override
  String get expenseGasValueLabel => 'Valor gás encanado';

  @override
  String get expensePhoneInternetValueLabel =>
      'Valor telefone + internet + celulares';

  @override
  String get expensePhoneInternetHelper => 'Informe o valor total';

  @override
  String get familyConfirmDialogTitle => 'Atenção!';

  @override
  String get familyConfirmDialogBodyEmphasis1 => 'Todos os membros';

  @override
  String get familyConfirmDialogBodyMiddle => ' do grupo familiar ';

  @override
  String get familyConfirmDialogBodyEmphasis2 =>
      'devem estar devidamente cadastrados';

  @override
  String get familyConfirmDialogBodySuffix =>
      ', pois apenas membros do grupo familiar estarão aptos para serem candidatos.';

  @override
  String get familyConfirmDialogMembersIntro =>
      'Os seguintes membros familiares foram adicionados:';

  @override
  String get familyConfirmDialogQuestion => 'Deseja continuar com cadastro?';

  @override
  String get familyConfirmDialogReview => 'Revisar informações';

  @override
  String get familyConfirmDialogContinue => 'Sim, continuar';

  @override
  String get scholarshipCandidateTag => 'Candidato a Bolsa';

  @override
  String get dobLabel => 'Dt. de Nascimento';

  @override
  String get genderLabel => 'Gênero';

  @override
  String get responsibleLabel => 'Responsável';

  @override
  String get maritalStatusLabel => 'Estado Civil';

  @override
  String get receivesPensionQuestion => 'Recebe pensão?';

  @override
  String get isRetiredQuestion => 'É aposentado(a)?';

  @override
  String get willApplyScholarshipQuestion => 'Será candidato a bolsa?';

  @override
  String get nationalityLabel => 'Nacionalidade';

  @override
  String get naturalizedQuestion => 'É naturalizado como Brasileiro?';

  @override
  String get concessionBannerTitle => 'Concessão de bolsa';

  @override
  String get concessionBannerMessage =>
      'De acordo com a Lei Complementar nº 187/2021 a bolsa de estudo é voltada para brasileiros natos ou naturalizados. Se você nasceu em outro país, precisará enviar o documento que comprova sua naturalização brasileira para concorrer ao benefício mediante a exigência do dispositivo legal citado.';

  @override
  String get hasCINQuestion => 'Possui nova Carteira de Identidade (CIN)?';

  @override
  String get rgLabel => 'RG/RNE';

  @override
  String get issuingOrgLabel => 'Órgão Emissor';

  @override
  String get hasCadunicoQuestion => 'Possui Cadúnico?';

  @override
  String get nisLabel => 'N° do NIS (Cadúnico)';

  @override
  String get hasChronicDiseaseQuestion => 'Possui Doença Crônica?';

  @override
  String get diseaseTypeLabel => 'Tipo de doença';

  @override
  String get pcdLabel => 'Portador de Deficiência - PcD?';

  @override
  String get irpfConditionLabel => 'Condição para IRPF';

  @override
  String get irpfDeclarante => 'Declarante';

  @override
  String get irpfIsento => 'Isento';

  @override
  String get declaredThisYearQuestion => 'Declarou esse ano?';

  @override
  String get hasWorkCardQuestion => 'Tem carteira de trabalho?';

  @override
  String get ruralWorkerQuestion => 'Trabalhador rural?';

  @override
  String get dataComplementTitle => 'Múltiplas ocupações';

  @override
  String get complementFieldsPlaceholder =>
      'Lembre-se de que uma pessoa pode ter múltiplas ocupações: como dois empregos, ser aposentada e ainda trabalhar, ser estudante e aprendiz, ou assalariada e sócia de uma empresa. Certifique-se de registrar todas as informações relevantes.';

  @override
  String get documentsTitle => 'Documentos';

  @override
  String get documentsPlaceholder => 'Campos para anexar documentos...';

  @override
  String get documentsStepTitle => 'Envio de Documentos';

  @override
  String get documentsStepDescription =>
      'Envie os documentos gerais da família e os documentos específicos de cada membro individualmente';

  @override
  String documentsDeadlineLabel(String date) => 'Prazo para envio: $date';

  @override
  String documentsProgressLabel(int uploaded, int total) =>
      '$uploaded de $total';

  @override
  String get documentsSendAllAction => 'Enviar Documentos';

  @override
  String get documentsBackDialogBody =>
      'Existem documentos enviados, caso opte por voltar, todos os documentos já enviados até o momento serão removidos, sendo necessário reenviá-los.';

  @override
  String get documentsBackDialogQuestion => 'Tem certeza que deseja voltar?';

  @override
  String get documentsBackDialogConfirm => 'Sim, estou ciente.';

  @override
  String get documentsHomeDialogBodyPrefix =>
      'É crucial que você finalize seu processo até o dia ';

  @override
  String get documentsHomeDialogBodySuffix =>
      ', caso contrário seu processo será desclassificado.';

  @override
  String get documentsHomeDialogConfirm => 'Ok, estou ciente.';

  @override
  String get documentSendAction => 'Enviar';

  @override
  String get documentEditAction => 'Editar';

  @override
  String get documentsBackToDocumentsAction => 'Voltar para Tela de Documentos';

  @override
  String get documentAddressProofLabel => 'Comprovante de Endereço';

  @override
  String get documentPhoneInternetProofLabel =>
      'Comprovante de Telefone, Internet ou Celular';

  @override
  String get documentPublicTransportProofLabel =>
      'Comprovante de Transporte Público';

  @override
  String get documentWaterBillLabel => 'Conta de Água';

  @override
  String get documentElectricityBillLabel => 'Conta de Energia Elétrica';

  @override
  String get documentRentedPropertyDeclarationLabel =>
      'Declaração Imóvel Alugado';

  @override
  String get documentProofSubmitAppBarTitle => 'Envio de Comprovante';

  @override
  String get documentAddressProofDescription =>
      'Envie um dos documentos abaixo que esteja em nome de algum membro do grupo familiar referente ao último mês.';

  @override
  String get documentTypeSelectorPlaceholder =>
      'Selecione um tipo de documento';

  @override
  String get documentTypeSelectorTitle => 'Tipo de documento';

  @override
  String get documentTypeInternet => 'Internet';

  @override
  String get documentTypeElectricity => 'Energia Elétrica';

  @override
  String get documentTypeCableTv => 'TV a Cabo';

  @override
  String get documentTypePipedGas => 'Gás Encanado';

  @override
  String get documentTypeWaterLastMonth => 'Água do último mês';

  @override
  String get documentTypeLandline => 'Telefone Fixo';

  @override
  String get documentProofElectricityValueLabel => 'Valor energia elétrica';

  @override
  String get documentProofValueLabel => 'Valor';

  @override
  String get documentProofPermissionDialogBody =>
      'Para enviar o comprovante, permita o acesso à câmera e aos arquivos do dispositivo.';

  @override
  String get documentProofPermissionSettingsAction => 'Abrir configurações';

  @override
  String get documentProofPickSourceTitle =>
      'Como deseja enviar o comprovante?';

  @override
  String get documentProofPickFromFiles => 'Documentos';

  @override
  String get documentProofPickFromGallery => 'Fototeca';

  @override
  String get concludeAction => 'Concluir';

  @override
  String get answerYes => 'Sim';

  @override
  String get answerNo => 'Não';

  /// ------------------- Profile -------------------
  @override
  String get profileMyDataTitle => 'Meus dados';

  @override
  String get profileMyDataSubtitle =>
      'Confira suas informações de contato e identificação.';

  @override
  String get profileMyDataName => 'Nome';

  @override
  String get profileMyDataPhone => 'Telefone';

  @override
  String get profileMyDataSaveButton => 'Salvar alterações';

  @override
  String get profileSaveSuccessTitle => 'Sucesso';

  @override
  String get profileSaveSuccessDescription =>
      'O telefone foi alterado com sucesso.';

  @override
  String get profileEmailChangedDescription =>
      'O seu e-mail foi alterado com sucesso.\n\nEnviamos um e-mail de confirmação para o e-mail cadastrado.\n\nVerifique sua caixa de entrada e também a pasta de spam ou lixo eletrônico e clique no link de confirmação para ativar sua conta.\n\nVocê precisa confirmar seu e-mail para acessar o sistema.';

  @override
  String get profileEmailChangedDoneButton => 'Estou ciente!';

  @override
  String get profileSaveSuccess => 'Alterações realizadas com sucesso.';

  @override
  String get profileChangePasswordTitle => 'Alterar senha';

  @override
  String get profileChangePasswordSubtitle =>
      'Mantenha sua conta segura. Se precisar, você pode criar uma nova senha de acesso clicando abaixo.';

  @override
  String get profileChangePasswordNewPassword => 'Nova senha';

  @override
  String get profileChangePasswordConfirmNewPassword => 'Confirme nova senha';
}
