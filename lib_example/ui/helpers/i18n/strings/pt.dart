import './translation.dart';

class Pt implements Translation {
  // ACCOUNT
  @override
  String get login => 'Login';
  @override
  String get confirmEmail => 'Confirme seu email';
  @override
  String get email => 'Email';
  @override
  String get token => 'Token';
  @override
  String get accept => 'Aceitar';
  @override
  String get reload => 'Recarregar';
  @override
  String get entityLabel => 'Entidade';
  @override
  String get register => 'Cadastro';
  @override
  String get enterYourDetails => 'Dados Principais';
  @override
  String get setAPassword => 'Defina uma senha';
  @override
  String get password => 'Senha';
  @override
  String get confirmPassword => 'Confirme sua senha';
  @override
  String get noAccount => 'Não tem conta?';
  @override
  String get registerNow => 'Cadastre-se agora';
  @override
  String get previousPassword => 'Senha anterior';
  @override
  String get updatedPassword => 'Senha atualizada';
  @override
  String get passwordUpdatedSuccessfully =>
      'Sua senha foi atualizada com sucesso.';
  @override
  String get passwordNotMatch => 'As senhas não coincidem.';
  @override
  String get codeBaseInvalid => 'Código da base inválido.';
  @override
  String get incorrectPassword => 'Senha inválida';

  // MESSAGES
  @override
  String get msgEmailInUse => 'O e-mail já está em uso.';
  @override
  String get msgInvalidCredentials =>
      'E-mail ou senha incorretos. Por favor, tente novamente.';
  @override
  String get msgInvalidField => 'E-mail inválido';
  @override
  String get msgRequiredField => 'Campo obrigatório';
  @override
  String get msgUnexpectedError =>
      'Falha ao carregar informações. Por favor, tente novamente em breve.';
  @override
  String get have8Characters =>
      'Sua senha deve possuir no mínimo 8 caracteres.';
  @override
  String get savedChanges => 'Alterações salvas';
  @override
  String get updatedSuccessfully =>
      'Suas alterações foram atualizados com sucesso.';
  @override
  String get wantToReport => 'Deseja denunciar?';
  @override
  String get wantToReportSubtitle =>
      'Tem certeza que deseja denunciar  a publicação?';
  @override
  String get report => 'Denunciar';

  //BUTTON
  @override
  String get close => 'Fechar';
  @override
  String get next => 'Próximo';
  @override
  String get save => 'Salvar';
  @override
  String get share => 'Compartilhar';
  @override
  String get cancel => 'Cancelar';
  @override
  String get logout => 'Sair';
  @override
  String get deleteAccount => 'Excluir conta';
  @override
  String get yes => 'Sim';
  @override
  String get proceed => 'Continuar';
  @override
  String get finalizeRegistration => 'Finalizar Cadastro';
  @override
  String get seeAllMembers => 'Ver todos os membros';
  @override
  String get backToProfile => 'Voltar para o perfil';
  @override
  String get editProfile => 'Edit profile';
  @override
  String get changePhoto => 'Alterar foto';
  @override
  String get saveEditions => 'Salvar alterações';
  @override
  String get link => 'link';
  @override
  String get openLink => 'Abrir link';
  @override
  String get uploadPhotoButton => 'Carregar foto';
  @override
  String get publishContent => 'Publicar conteúdo';
  @override
  String get openPdf => 'Abrir Pdf';

  // SHARED
  @override
  String get wait => 'Espere...';
  @override
  String get navigationTitle => 'Bem-vindo';
  @override
  String get sendFeedback => 'Enviar comentários';
  @override
  String get noConnectionsAvailable => '';

  //PAGES
  @override
  String get nutrition => 'Nutrição';
  @override
  String get profile => 'Profile';
  @override
  String get personalData => 'Dados pessoais';
  @override
  String get wanToDeleteAccount => 'Deseja excluir sua conta?';
  @override
  String get confirmAccountDeletion =>
      'Confirme a exclusão de sua conta no aplicativo';
  @override
  String get enterBase => 'Agora, digite sua base';
  @override
  String get name => 'Nome';
  @override
  String get phone => 'Telefone';
  @override
  String get gender => 'Sexo';
  @override
  String get relationship => 'Relacionamento';
  @override
  String get anErrorHasOccurred => 'Algo deu errado';
  @override
  String get youAreOffline => 'Parece que você está offline';
  @override
  String get checkInternetAccess =>
      'Verifique se o dispositivo tem acesso à internet';
  @override
  String get successTitle => 'Sucesso';
  @override
  String get notificationTitle => 'Notificações';
  @override
  String get markReadNotification => 'Marcar como lidas';
  @override
  String get newMission => 'Nova missão';
  @override
  String get newMissionAvailable =>
      'Você possui uma nova missão disponível. Clique para conferir';
  @override
  String get notificationInputTitle => 'Você ainda não possui notificações';
  @override
  String get notificationInputSubtitle =>
      'Quando você tiver notificações, elas irão aparecer aqui';
  @override
  String get missionTitle => 'Missões';
  @override
  String get yourMissions => 'Suas missões';
  @override
  String get levelLabel => 'Nível';
  @override
  String get dataLabel => 'Data';
  @override
  String get statusLabel => 'Status';
  @override
  String get baseMembers => 'Membros da sua base';
  @override
  String get myProfile => 'Meu Perfil';
  @override
  String get baseMembersTitle => 'Membros da base';
  @override
  String get baseTitle => 'Base';
  @override
  String get searchbase => 'Digite o que você procura';
  @override
  String get logOffAccount => 'Sair da conta';
  @override
  String get messageLogOffAcount =>
      'Tem certeza de que deseja sair da sua conta?';
  @override
  String get toGoOut => 'Sair';
  @override
  String get addPublication => 'Adicionar publicação';
  @override
  String get address => 'Endereço';
  @override
  String get shepherd => 'Pastor responsável';
  @override
  String get baseLabel => 'Base';
  @override
  String get changePassword => 'Alterar senha';
  @override
  String get dateBirth => 'Data de Nascimento';
  @override
  String get loginRequired => 'Login necessário';
  @override
  String get needToLogin => ' Você precisa fazer login';
  @override
  String get loginRequiredSubtitle =>
      'Para visualizar essa funcionalidade, é preciso fazer login. Clique no botão abaixo e aproveite para ter acesso a todos os recursos!';
  @override
  String get searchMission => 'Busca de missões';
  @override
  String get toDoLogin => 'Fazer login';
  @override
  String get findBase => 'Encontre uma base';
  @override
  String get addAdmin => 'Adicionar admin';
  @override
  String get removeAdmin => 'Remover admin';
  @override
  String get fileSending => 'Envio de arquivo';
  @override
  String get uploadPhoto => 'Carregue a sua foto aqui';
  @override
  String get camera => 'Câmera';
  @override
  String get gallery => 'Galeria';
  @override
  String get basicInformation => 'Informações básicas';
  @override
  String get contentType => 'Tipo de conteúdo';
  @override
  String get publicationContent => 'Conteúdo da publicação';
  @override
  String get attachPhotosToPost => 'Anexar fotos para a publicação';
  @override
  String get photosAllowed => 'São permitidas até 5 fotos para a publicação';
  @override
  String get femaleSex => 'Feminino';
  @override
  String get maleSex => 'Masculino';
  @override
  String get titlePost => 'Título';
  @override
  String get subtitlePost => 'Subtítulo (se tiver)';
  @override
  String get descriptionPost => 'Coloque o texto do conteúdo';
  @override
  String get publishedContent => 'Conteúdo publicado';
  @override
  String get publishedContentDescription =>
      'Seu conteúdo foi publicado com sucesso. Acesse ele!';
  @override
  String get viewContent => 'Ver conteúdo';
  @override
  String get addTags => 'Coloque as hashtags do conteúdo';
  @override
  String get typeLink => 'Link externo (site, vídeo, podcast)';
  @override
  String get typePDF => 'Arquivo PDF';
  @override
  String get typeInternText => 'Texto Interno';
  @override
  String get selectTypePost => 'Selecione o tipo de conteúdo';
  @override
  String get searchMembers => 'Encontre um membro';
  @override
  String get changeNameBase => 'Alterar nome da base';
  @override
  String get editBase => 'Editar base';
  @override
  String get addAdminUser => 'Admin adicionado ao usuário';
  @override
  String get selectDate => 'Selecione a data';
  @override
  String get searchDate => 'Digite a data';
  @override
  String get select => 'Selecionar';
  @override
  String get dateInitial => 'Data inicial';
  @override
  String get dateFinal => 'Data final';
  @override
  String get statusConclued => 'Concluídas';
  @override
  String get statusPending => 'Pendentes';
  @override
  String get statusToDo => 'A fazer';
  @override
  String get okLabel => 'Ok';
  @override
  String get registrationSuccessful => 'Cadastro realizado com sucesso';
  @override
  String get registrationCompletedSuccessfully =>
      'Seu cadastro foi finalizado com sucesso. Agora, você pode fazer login para ter acesso ao app';
  @override
  String get errorSaveTitleAlert => 'Erro ao salvar alterações';
  @override
  String get errorSaveDescriptionAlert =>
      'Houve algum erro ao salvar suas alterações. Por favor, tente novamente';
  @override
  String get dataLastDay => 'Último dia';
  @override
  String get dataLastSevenDays => 'Últimos 7 dias';
  @override
  String get dataLastFourteenDays => 'Últimos 14 dias';
  @override
  String get dataLastThirtyDays => 'Últimos 30 dias';
  @override
  String get dataPersonalized => 'Data personalizada';
  @override
  String get spiritualLabel => 'Espiritual';
  @override
  String get seeAllButon => 'Ver tudo';
  @override
  String get exhibitionsLabel => 'Exposições';
  @override
  String get foodLabel => 'Restaurantes';
  @override
  String get addFriends => 'Adicionar amigos';
  @override
  String get emergencyLabel => 'Emergência';
  @override
  String get hotelsLabel => 'Hotéis';
  @override
  String get publicTransportLabel => 'Transporte Público';
  @override
  String get myAgendaLabel => 'MINHA AGENDA';
  @override
  String get favoritesLabel => 'FAVORITOS';
  @override
  String get filtersLabel => 'FILTRO';
  @override
  String get allLabel => 'TODOS';
  @override
  String get newsLabel => 'Notícias';
  @override
  String get votingResultsLabel => 'Resultados da votação';
  @override
  String get menuLabel => 'MENU';
  @override
  String get ticketLabel => 'Bilhete';
  @override
  String get votingLabel => 'Votação';
  @override
  String get eventsAvailable => 'Eventos disponíveis';
  @override
  String get detailsLabel => 'Detalhes';
  @override
  String get descriptionLabel => 'Descrição';
  @override
  String get downloadLabel => 'Download';
  @override
  String get agendaLabel => 'Agenda';
  @override
  String get messageErrorLabel => 'Algo deu errado';
  @override
  String get messageErrorSubtitle =>
      'Parece que você está offline.\nVerifique se o dispositivo tem acesso à Internet';
  @override
  String get tryAgainLabel => 'Tente novamente';
  @override
  String get somethingWrongTitle => 'Algo errado';
  @override
  String get somethingWrongSubtitle =>
      'Oops! Algo deu errado. Tente\nnovamente mais tarde';
  @override
  String get invalidURL => 'URL inválida';
  @override
  String get faqLabel => 'FAQ';
  @override
  String get supportLabel => 'Suporte';
  @override
  String get scheduleLabel => 'Agenda';
  @override
  String get stayTunedLabel => 'Fique atento!';
  @override
  String get programmingNotAvailable =>
      'Favorite um item na\n programação principal e ele\n será adicionado à sua\n programação';
  @override
  String get scheduleNotAvailableYetLabel => 'Agenda ainda não disponível';
  @override
  String get liveLabel => 'LIVE';
  @override
  String get allTinyLabel => 'todos';
  @override
  String get myScheduleTiny => 'minha agenda';
  @override
  String get attendeesLabel => 'Atendentes';
  @override
  String get votingInformationLabel => 'Informações sobre votação';
  @override
  String get documentsLabel => 'Documentos';
  @override
  String get brochuresLabel => 'Folhetos';
  @override
  String get businessLabel => 'Negócios';
  @override
  String get typeMessageLabel => 'Digite a mensagem';
  @override
  String get emergencyInformationLabel => 'Informações de emergência';
  @override
  String get emergencyNumberLabel => 'Número de emergência';
  @override
  String get editingProfileLabel => 'Editar perfil';
  @override
  String get changeImageLabel => 'Editar foto de perfil';
  @override
  String get linkedInLabel => 'LinkedIn';
  @override
  String get socialMediaLabel => 'Mídias sociais';
  @override
  String get participantsLabel => 'Participantes';
  @override
  String get resourcesLabel => 'Recursos';
  @override
  String get guidelinesLabel => 'Diretrizes';
  @override
  String get detailsCapital => 'DETALHES';
  @override
  String get resourcesCapital => 'RECURSOS';
  @override
  String get directionsLabel => 'Instruções';
  @override
  String get restaurantsLabel => 'RESTAURANTES';
  @override
  String get favoriteRestaurantLabel => 'Restaurantes favoritos';
  @override
  String get externalLabel => 'EXTERNO';
  @override
  String get internalLabel => 'INTERNO';
  @override
  String get getLineLabel => 'Entre na fila';
  @override
  String get speakingLabel => 'Falando';
  @override
  String get mapsLabel => 'Mapas';
  @override
  String get home => 'Home';
  @override
  String get map => 'Mapa';
  @override
  String get more => 'Mais';
  @override
  String get locationLabel => 'Localização';
  @override
  String get notificationsLabel => 'Notificações';
  @override
  String get savedRestaurantsLabel => 'Restaurantes salvos';
  @override
  String get musicLabel => 'Música';
  @override
  String get prayerRoomLabel => 'Sala de Oração';
  @override
  String get devotionalLabel => 'Devocional';
  @override
  String get clearAllLabel => 'Limpar tudo';
  @override
  String get applyLabel => 'Aplicar';
  @override
  String get filterByLabel => 'Filtrar por';
  @override
  String get filterByInstitutionsLabel => 'Filtrar por instituições';
  @override
  String get newElectedLabel => 'Novos Eleitos';
  @override
  String get addPhoneLabel => 'Adicionar número de telefone';
  @override
  String get receiveSMSLabel => 'Você gostaria de receber SMS para emergências';
  @override
  String get emergencyCapital => 'EMERGÊNCIA';
  @override
  String get exitPlanCapital => 'PLANO DE SAÍDA';
  @override
  String get phoneNumberLabel => 'Número de telefone';
  @override
  String get labeQuickAccess => 'Acesso rápido';
  @override
  String get languageLabel => 'Linguagem';
  @override
  String get infoLabel => 'Informação';
  @override
  String get foodService => 'Serviço de alimentação';
  @override
  String get partnerships => 'Parcerias';
  @override
  String get votes => 'Votação';
  @override
  String get spiritual => 'Espiritual';
  @override
  String get docsLabel => 'Docs';
  @override
  String get liveTinyLabel => 'Live';
  @override
  String get mySchedule => 'Minha agenda';
  @override
  String get noEventFound => 'Nenhum evento encontrado';
  @override
  String get eventsAvailableSoon =>
      'Em breve os eventos cadastrados estarão disponiveis';
  @override
  String get backLabel => 'Voltar';
  @override
  String get biographyLabel => 'Biografia';
  @override
  String get translationChanelLabel => 'Tradução';
  @override
  String get ticketPurchaseLabel => 'Compra de ingressos';
  @override
  String get nextLiveLabel => 'Próximo ao vivo';
  @override
  String get previousLabel => 'Passada';
  @override
  String get liveBroadcastLabel => 'Transmissão ao vivo';
  @override
  String get morningLabel => 'MANHÃ';
  @override
  String get afternoonLabel => 'TARDE';
  @override
  String get diningHall => 'Refeitório GC';
  @override
  String get localRestaurant => 'Restaurantes locais';
  @override
  String get searchLabel => 'Pesquisar';
  @override
  String get searchExhibitor => 'Pesquise por expositor';
  @override
  String get searchVoting => 'Pesquisar por entidade, cargo ou nome';
  @override
  String get searchMusic => 'Pesquisar música';
  @override
  String get searchDocuments => 'Pesquisar por documentos';
  @override
  String get messageEmpty => 'Mais informações em breve';
  @override
  String get messageEmptyExhibitor =>
      'Ops! Ainda não existe nenhum\n expositor por aqui';
  @override
  String get messageEmptySupport =>
      'Ops! Ainda não existe essa\n pergunta por aqui';
  @override
  String get messageEmptyVoting =>
      'Ops! Ainda não existe nada\n parecido por aqui';
  @override
  String get messageEmptySchedule =>
      'Ops! Ainda não há uma\n programação disponível.\n Mais informações estarão\n disponíveis em breve';
  @override
  String get messageEmptyMySchedule =>
      'Favorite um item na programação\n principal e ele será adicionado\n à sua programação';
  @override
  String get messageEmptyDocument =>
      'Ops! Ainda não existe nenhum documento\n assim por aqui';
  @override
  String get spiritualContent => 'Conteúdo espiritual';
  @override
  String get mediaLabel => 'Mídia';
  @override
  String get copiedLabel => 'Link copiado para a área de transferência';
  @override
  String get couldNotOpen => 'Não foi possível abrir o aplicativo de mapas';
  @override
  String get messageEmptyResources =>
      'Ops! Nenhum recurso disponível ainda.\n Mais informações em breve';
  @override
  String get messageEmptyNotification =>
      'Ops! Nenhuma notificação disponível ainda. Mais informações em breve';
  @override
  String get messageEmptyBrochures =>
      'Ops! Ainda não há folhetos disponíveis.\n Mais informações em breve';
  @override
  String get messageEmptyDocs =>
      'Ops! Nenhum documento disponível ainda. Mais informações em breve';
  @override
  String get messageEmptyLive =>
      'Ops! Nenhuma transmissão ao vivo disponível por aqui ainda';
  @override
  String get messageEmptyDevotional =>
      'Ops! Nenhum devocional disponível ainda.\nMais informações em breve';
  @override
  String get messageEmptyMusics =>
      'Ops! Nenhuma música disponível ainda.\n Mais informações em breve';
  @override
  String get messageEmptyPrayerRoom =>
      'Ops! Nenhuma informação disponível ainda.\n Mais informações em breve';
  @override
  String get messageEmptyExhibitors =>
      'Ops! Nenhum expositor disponível ainda.\n Mais informações em breve';
  @override
  String get messageEmptyFaq =>
      'Ops! Nenhuma FAQ disponível ainda.\n Mais informações em breve';
  @override
  String get messageEmptyTranslationChannel =>
      'Ops! Nenhuma informação\n de tradução disponível ainda.\n Mais informações em breve';
  @override
  String get messageEmptyExternalFood =>
      'Ops! Nenhum restaurante\n local disponível ainda.\n Mais informações em breve';
  @override
  String get messageEmptyInternalFood =>
      'Ops! Nenhuma informação sobre o \nRefeitório GC disponível ainda.\n Mais informações em breve';
  @override
  String get messageEmptyNews =>
      'Ops! Nenhuma notícia disponível ainda.\n Mais informações em breve';
  @override
  String get messageEmptyVotings =>
      'Ops! Nenhum resultado de votação disponível ainda.\n Mais informações em breve';
  @override
  String get messageEmptyFilterFood =>
      'Ops! Ainda não há restaurantes locais\npara este filtro';
  @override
  String get messageEmptyFilterExhibitor =>
      'Nenhuma exposição correspondente encontrada';
  @override
  String get exhibitionLabel => 'Exposição';
  @override
  String get succesDownload => 'Documento baixado com sucesso!';
  @override
  String get errorDownload => 'Erro ao baixar o documento';
  @override
  String get errorSharing => 'Erro ao compartilhar o documento';
  @override
  String get transportLabel => 'Transporte';
  @override
  String get accessibilityLabel => 'Acessibilidade';
  @override
  String get messageEmptyTransportation =>
      'Ops! Nenhuma informação\nde transporte disponível ainda.\nMais informações em breve';
  @override
  String get messageEmptyAccessibility =>
      'Ops! Nenhuma informação\nde acessibilidade disponível ainda.\nMais informações em breve';
  @override
  String get comingLabel => 'chegando a seguir';
  @override
  String get messageEmptySocialMedia =>
      'Ops! Nenhuma rede social disponível ainda. Mais informações em breve';
  @override
  String get bulletinLabel => 'Boletim Diário da Sessão da CG';
  @override
  String get noResults => 'Nenhum resultado encontrado';
  @override
  String get nightLabel => 'NOITE';
  @override
  String get futureLabel => 'FUTURO';
  @override
  String get selectLanguage => 'Selecione o idioma\nque você deseja usar';
  @override
  String get otherEvents => 'Outros eventos';
  @override
  String get worship => 'Adoração';
  @override
  String get couldNotLink => 'Não foi possível abrir o link. Tente novamente.';
  @override
  String get labelAs => 'ás';
  @override
  String get categories => 'Categorias';
  @override
  String get eveningLabel => 'noite';
}
