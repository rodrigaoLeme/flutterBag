import 'app_i18n.dart';

class PtBrI18n implements AppI18n {
  const PtBrI18n();

  /// ------------------- App -------------------
  @override
  String get appTitle => 'e-Bolsa';

  @override
  String get appNameDev => 'e-BolsaDev';

  @override
  String get appNameProd => 'e-Bolsa';

  /// Common errors
  @override
  String get errorNoInternet => 'Sem conexão com a internet.';

  @override
  String get errorTimeout => 'Tempo de conexão esgotado.';

  @override
  String get errorUnexpected => 'Erro inesperado. Tente novamente.';

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
  String get termsConfirm => 'Confirmar';

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
  String get createAccountDialogTitle => 'Atenção!';

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
  String get forgotPasswordConfirmAction => 'Confirmar';

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

  @override
  String get forgotPasswordDialogDoneButton => 'Ok';

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

  @override
  String get accountNotConfirmedDialogDoneButton => 'Ok';

  /// ------------------- JWT -------------------
  @override
  String get jwtInvalidToken => 'Token inválido.';
  @override
  String jwtDecodeError(Object error) => 'Erro ao decodificar JWT: $error';

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
  String get noticesTermsIncompleteFiltersMessage =>
      'Preencha Ano letivo, Cidade e Unidade escolar para visualizar os editais.';

  @override
  String get noticesTermsNoResultsMessage =>
      'Nao encontramos editais para os filtros selecionados. Tente outro ano, cidade ou unidade.';

  @override
  String get noticesTermsPublishedAtLabel => 'Data de Publicação';

  @override
  String get noticesTermsModalityLabel => 'Modalidade';

  @override
  String get noticesTermsEnrollmentTypeLabel => 'Tipo de Inscrição';

  @override
  String get noticesTermsViewNoticeAction => 'Ver Edital';

  @override
  String get noticesTermsViewAdditiveTermAction => 'Ver Termo Aditivo';

  @override
  String get noticesTermsDocumentTitle => 'Documento';

  @override
  String get noticesTermsDocumentNoticeDescription => 'Visualizacao do edital';

  @override
  String get noticesTermsDocumentAdditiveTermDescription =>
      'Visualizacao do termo aditivo';

  @override
  String get noticesTermsDocumentDevMessage =>
      'Visualizacao de documento em desenvolvimento.\n\nNesta area sera exibido PDF ou WebView.';

  /// ------------------- Onboarding -------------------
  @override
  String get onboardingItem1Title => 'e-Bolsa';

  @override
  String get onboardingItem1Description =>
      'Com o E-bolsa você solicita pedido de bolsa para qualquer unidade escolar da rede Adventista no Brasil!';

  @override
  String get onboardingItem2Title => '1º Passo';

  @override
  String get onboardingItem2Description =>
      'Para concorrer a um bolsa cadastre as  informações socioeconômicas da  família e do(s) candidatos.';

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

  @override
  String get onboardingEnterAction => 'Entrar';
}
