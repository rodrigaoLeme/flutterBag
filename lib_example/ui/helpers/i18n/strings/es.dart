import './translation.dart';

class Es implements Translation {
  // ACCOUNT
  @override
  String get login => 'Login';
  @override
  String get confirmEmail => 'Confirme tu email';
  @override
  String get email => 'Email';
  @override
  String get token => 'Token';
  @override
  String get accept => 'Aceptar';
  @override
  String get reload => 'Recargar';
  @override
  String get entityLabel => 'Entidad';
  @override
  String get register => 'Registro';
  @override
  String get enterYourDetails => 'Datos Principales';
  @override
  String get setAPassword => 'Establecer una contraseña';
  @override
  String get password => 'Contraseña';
  @override
  String get confirmPassword => 'Confirma tu contraseña';
  @override
  String get noAccount => 'No tienes una cuenta?';
  @override
  String get registerNow => 'Regístrate ahora';
  @override
  String get previousPassword => 'Contraseña anterior';
  @override
  String get updatedPassword => 'Contraseña actualizada';
  @override
  String get passwordUpdatedSuccessfully =>
      'Su contraseña se ha actualizado correctamente';
  @override
  String get passwordNotMatch => 'Las contraseñas no coinciden';
  @override
  String get codeBaseInvalid => 'Código no válido';
  @override
  String get incorrectPassword => 'Contraseña no válida';

  // MESSAGES
  @override
  String get msgEmailInUse => 'El correo electrónico ya está en uso';
  @override
  String get msgInvalidCredentials =>
      'Correo electrónico o contraseña incorrectos. Por favor, inténtalo de nuevo';
  @override
  String get msgInvalidField => 'Correo electrónico no válido';
  @override
  String get msgRequiredField => 'Campo obligatorio';
  @override
  String get msgUnexpectedError =>
      'Error al cargar la información. Por favor, inténtelo de nuevo pronto';
  @override
  String get have8Characters =>
      'Su contraseña debe tener al menos 8 caracteres';
  @override
  String get savedChanges => 'Cambios guardados';
  @override
  String get updatedSuccessfully => 'Tus cambios se actualizaron exitosamente';
  @override
  String get wantToReport => 'Quieres denunciar?';
  @override
  String get wantToReportSubtitle =>
      '¿Estás seguro de que quieres denunciar la publicación?';
  @override
  String get report => 'Denunciar';

  //BUTTON
  @override
  String get close => 'Cerrar';
  @override
  String get next => 'Siguiente';
  @override
  String get save => 'Salvar';
  @override
  String get share => 'Compartir';
  @override
  String get cancel => 'Cancelar';
  @override
  String get logout => 'Finalizar la sesión';
  @override
  String get deleteAccount => 'Eliminar cuenta';
  @override
  String get yes => 'Si';
  @override
  String get proceed => 'Continuar';
  @override
  String get finalizeRegistration => 'Finalizar registro';
  @override
  String get seeAllMembers => 'Ver todos los miembros';
  @override
  String get backToProfile => 'Volver al perfil';
  @override
  String get editProfile => 'Editar perfil';
  @override
  String get changePhoto => 'Cambiar foto';
  @override
  String get saveEditions => 'Guardar cambios';
  @override
  String get link => 'enlace';
  @override
  String get openLink => 'Abrir enlace';
  @override
  String get uploadPhotoButton => 'Cargar foto';
  @override
  String get publishContent => 'Publicar contenido';
  @override
  String get openPdf => 'Abrir Pdf';

  // SHARED
  @override
  String get wait => 'Esperar...';
  @override
  String get navigationTitle => 'Bienvenido';
  @override
  String get sendFeedback => 'Enviar comentarios';
  @override
  String get noConnectionsAvailable => '';

  //PAGES
  @override
  String get nutrition => 'Nutrición';
  @override
  String get profile => 'Perfil';
  @override
  String get personalData => 'Datos personales';
  @override
  String get wanToDeleteAccount => '¿Quieres eliminar tu cuenta?';
  @override
  String get confirmAccountDeletion =>
      'Confirma la eliminación de tu cuenta en la aplicación';
  @override
  String get enterBase => 'Ahora ingresa a tu base';
  @override
  String get name => 'Nombre';
  @override
  String get phone => 'Teléfono';
  @override
  String get gender => 'Sexo';
  @override
  String get relationship => 'Relacionamiento';
  @override
  String get anErrorHasOccurred => 'Algo salió mal';
  @override
  String get youAreOffline => 'Parece que estás desconectado';
  @override
  String get checkInternetAccess =>
      'Compruebe si el dispositivo tiene acceso a Internet';
  @override
  String get successTitle => 'Éxito';
  @override
  String get notificationTitle => 'Notificaciones';
  @override
  String get markReadNotification => 'Marcar como leído';
  @override
  String get newMission => 'Nueva misión';
  @override
  String get newMissionAvailable =>
      'Tienes una nueva misión disponible. Haga clic para comprobarlo';
  @override
  String get notificationInputTitle => 'Aún no tienes notificaciones';
  @override
  String get notificationInputSubtitle =>
      'QCuando tengas notificaciones, aparecerán aquí';
  @override
  String get missionTitle => 'Misiones';
  @override
  String get yourMissions => 'Tus Misiones';
  @override
  String get levelLabel => 'Nivel';
  @override
  String get dataLabel => 'Fecha';
  @override
  String get statusLabel => 'Estado';
  @override
  String get baseMembers => 'Miembros de tu base';
  @override
  String get myProfile => 'Mi Perfil';
  @override
  String get baseMembersTitle => 'Miembros de la base';
  @override
  String get baseTitle => 'Base';
  @override
  String get searchbase => 'Escribe lo que buscas';
  @override
  String get logOffAccount => 'Cerrar sesión en la cuenta';
  @override
  String get messageLogOffAcount =>
      '¿Está seguro de que desea cerrar sesión en su cuenta?';
  @override
  String get toGoOut => 'Salir';
  @override
  String get addPublication => 'Agregar publicación';
  @override
  String get address => 'Dirección';
  @override
  String get shepherd => 'Pastor encargado';
  @override
  String get baseLabel => 'Base';
  @override
  String get changePassword => 'Cambiar la contraseña';
  @override
  String get dateBirth => 'Fecha de nacimiento';
  @override
  String get loginRequired => 'Se requiere iniciar sesión';
  @override
  String get needToLogin => 'Necesitas iniciar sesión';
  @override
  String get loginRequiredSubtitle =>
      'Para ver esta funcionalidad, debe iniciar sesión. ¡Haga clic en el botón a continuación y disfrute del acceso a todos los recursos!';
  @override
  String get searchMission => 'Búsqueda de misiones';
  @override
  String get toDoLogin => 'Acceso';
  @override
  String get findBase => 'Encuentra una base';
  @override
  String get addAdmin => 'Agregar administrador';
  @override
  String get removeAdmin => 'Eliminar administrador';
  @override
  String get fileSending => 'Enviar archivo';
  @override
  String get uploadPhoto => 'Sube tu foto aquí';
  @override
  String get camera => 'Cámara';
  @override
  String get gallery => 'Galería';
  @override
  String get basicInformation => 'Información básica';
  @override
  String get contentType => 'Tipo de contenido';
  @override
  String get publicationContent => 'Contenido de la publicación';
  @override
  String get attachPhotosToPost => 'Adjuntar fotos a la publicación';
  @override
  String get photosAllowed =>
      'Se permiten hasta 5 fotografías para su publicación.';
  @override
  String get femaleSex => 'Femenino';
  @override
  String get maleSex => 'Masculino';
  @override
  String get titlePost => 'Título';
  @override
  String get subtitlePost => 'Subtítulo (si lo hay)';
  @override
  String get descriptionPost => 'Insertar texto de contenido';
  @override
  String get publishedContent => 'Contenido publicado';
  @override
  String get publishedContentDescription =>
      'Su contenido ha sido publicado exitosamente. ¡Accede a él!';
  @override
  String get viewContent => 'Ver contenido';
  @override
  String get addTags => 'Insertar hashtags de contenido';
  @override
  String get typeLink => 'Enlace externo (sitio web, vídeo, podcast)';
  @override
  String get typePDF => 'Archivo PDF';
  @override
  String get typeInternText => 'Texto Interno';
  @override
  String get selectTypePost => 'Seleccionar tipo de contenido';
  @override
  String get searchMembers => 'Buscar un miembro';
  @override
  String get changeNameBase => 'Cambiar nombre base';
  @override
  String get editBase => 'Editar base';
  @override
  String get addAdminUser => 'Administrador agregado al usuario';
  @override
  String get selectDate => 'Seleccionar fecha';
  @override
  String get searchDate => 'Ingrese la fecha';
  @override
  String get select => 'Seleccionar';
  @override
  String get dateInitial => 'Fecha de inicio';
  @override
  String get dateFinal => 'Fecha de finalización';
  @override
  String get statusConclued => 'Terminado';
  @override
  String get statusPending => 'Pendiente';
  @override
  String get statusToDo => 'Por hacer';
  @override
  String get okLabel => 'Ok';
  @override
  String get registrationSuccessful => 'Registro completado con éxito';
  @override
  String get registrationCompletedSuccessfully =>
      'Su registro se ha completado con éxito. Ahora puedes iniciar sesión para acceder a la aplicación';
  @override
  String get errorSaveTitleAlert => 'Error al guardar cambios';
  @override
  String get errorSaveDescriptionAlert =>
      'Hubo un error al guardar los cambios. Por favor, inténtalo de nuevo';
  @override
  String get dataLastDay => 'Último día';
  @override
  String get dataLastSevenDays => 'Últimos 7 días';
  @override
  String get dataLastFourteenDays => 'Últimos 14 días';
  @override
  String get dataLastThirtyDays => 'Últimos 30 días';
  @override
  String get dataPersonalized => 'Fecha personalizada';
  @override
  String get spiritualLabel => 'Espiritual';
  @override
  String get seeAllButon => 'Ver todo';
  @override
  String get exhibitionsLabel => 'Expositores';
  @override
  String get foodLabel => 'Restaurante';
  @override
  String get addFriends => 'Agregar amigos';
  @override
  String get emergencyLabel => 'Emergencia';
  @override
  String get hotelsLabel => 'Hoteles';
  @override
  String get publicTransportLabel => 'Transporte público';
  @override
  String get myAgendaLabel => 'MI AGENDA';
  @override
  String get favoritesLabel => 'FAVORITOS';
  @override
  String get filtersLabel => 'FILTROS';
  @override
  String get allLabel => 'TODOS';
  @override
  String get newsLabel => 'Noticias';
  @override
  String get votingResultsLabel => 'Resultados de la votacion';
  @override
  String get menuLabel => 'MENÚ';
  @override
  String get ticketLabel => 'Boleto';
  @override
  String get votingLabel => 'Votación';
  @override
  String get eventsAvailable => 'Eventos disponibles';
  @override
  String get detailsLabel => 'Detalles';
  @override
  String get descriptionLabel => 'Descripción';
  @override
  String get downloadLabel => 'Descargar';
  @override
  String get agendaLabel => 'Agenda';
  @override
  String get messageErrorLabel => 'Algo salió mal';
  @override
  String get messageErrorSubtitle =>
      'Parece que estás desconectado.\nPor favor, verifica si el dispositivo tiene acceso a Internet';
  @override
  String get tryAgainLabel => 'Intentar otra vez';
  @override
  String get somethingWrongTitle => 'Ocurre algo';
  @override
  String get somethingWrongSubtitle =>
      '¡Uy! Algo salió mal. Inténtalo de\nnuevo más tarde';
  @override
  String get invalidURL => 'URL no válida';
  @override
  String get faqLabel => 'Preguntas frecuentes';
  @override
  String get supportLabel => 'Apoyo';
  @override
  String get scheduleLabel => 'Agenda';
  @override
  String get stayTunedLabel => '¡Manténganse al tanto!';
  @override
  String get programmingNotAvailable =>
      'Marca como favorito un\n elemento en el horario principal\n y se añadirá a tu\n horario';
  @override
  String get scheduleNotAvailableYetLabel => 'Horario no disponible todavía';
  @override
  String get liveLabel => 'EN VIVO';
  @override
  String get allTinyLabel => 'todos';
  @override
  String get myScheduleTiny => 'mi agenda';
  @override
  String get attendeesLabel => 'Asistentes';
  @override
  String get votingInformationLabel => 'Información para votar';
  @override
  String get documentsLabel => 'Documentos';
  @override
  String get brochuresLabel => 'Folletos';
  @override
  String get businessLabel => 'Negocio';
  @override
  String get typeMessageLabel => 'Escribe mensaje';
  @override
  String get emergencyInformationLabel => 'Información de emergencia';
  @override
  String get emergencyNumberLabel => 'Número de emergencia';
  @override
  String get editingProfileLabel => 'Editando perfil';
  @override
  String get changeImageLabel => 'Editar imagem de perfil';
  @override
  String get linkedInLabel => 'LinkedIn';
  @override
  String get socialMediaLabel => 'Redes sociales';
  @override
  String get participantsLabel => 'Participantes';
  @override
  String get resourcesLabel => 'Recursos';
  @override
  String get guidelinesLabel => 'Pautas';
  @override
  String get detailsCapital => 'DETALLES';
  @override
  String get resourcesCapital => 'RECURSOS';
  @override
  String get directionsLabel => 'Dirección';
  @override
  String get restaurantsLabel => 'RESTAURANTES';
  @override
  String get favoriteRestaurantLabel => 'Restaurantes favoritos';
  @override
  String get externalLabel => 'EXTERNO';
  @override
  String get internalLabel => 'INTERNO';
  @override
  String get getLineLabel => 'Ser elegido en línea';
  @override
  String get speakingLabel => 'Discurso';
  @override
  String get mapsLabel => 'Mapas';
  @override
  String get home => 'Home';
  @override
  String get map => 'Mapa';
  @override
  String get more => 'Más';
  @override
  String get locationLabel => 'Ubicación';
  @override
  String get notificationsLabel => 'Notificaciones';
  @override
  String get savedRestaurantsLabel => 'Restaurantes guardados';
  @override
  String get musicLabel => 'Música';
  @override
  String get prayerRoomLabel => 'Sala de oración';
  @override
  String get devotionalLabel => 'Devocional';
  @override
  String get clearAllLabel => 'Borrar todo';
  @override
  String get applyLabel => 'Aplicar';
  @override
  String get filterByLabel => 'Filtrar por';
  @override
  String get filterByInstitutionsLabel => 'Filtrar por instituciones';
  @override
  String get newElectedLabel => 'Nuevos Electos';
  @override
  String get addPhoneLabel => 'Añadir número de teléfono';
  @override
  String get receiveSMSLabel => '¿Quieres recibir SMS para emergencias?';
  @override
  String get emergencyCapital => 'EMERGENCIA';
  @override
  String get exitPlanCapital => 'PLAN DE SALIDA';
  @override
  String get phoneNumberLabel => 'Número de teléfono';
  @override
  String get labeQuickAccess => 'Acceso rápido';
  @override
  String get languageLabel => 'Idioma';
  @override
  String get infoLabel => 'Información';
  @override
  String get foodService => 'Servicio de comida';
  @override
  String get partnerships => 'Asociaciones';
  @override
  String get votes => 'Votos';
  @override
  String get spiritual => 'Espiritual';
  @override
  String get docsLabel => 'Docs';
  @override
  String get liveTinyLabel => 'En vivo';
  @override
  String get mySchedule => 'Mi agenda';
  @override
  String get noEventFound => 'No se encontraron eventos';
  @override
  String get eventsAvailableSoon =>
      'Em breve os eventos cadastrados estarão disponiveis';
  @override
  String get backLabel => 'Volver';
  @override
  String get biographyLabel => 'Biografía';
  @override
  String get translationChanelLabel => 'Traducción';
  @override
  String get ticketPurchaseLabel => 'Compra de entradas';
  @override
  String get nextLiveLabel => 'Próximo en vivo';
  @override
  String get previousLabel => 'Anterior';
  @override
  String get liveBroadcastLabel => 'Transmisión en vivo';
  @override
  String get morningLabel => 'MAÑANA';
  @override
  String get afternoonLabel => 'TARDE';
  @override
  String get diningHall => 'Comedor GC';
  @override
  String get localRestaurant => 'Restaurantes locales';
  @override
  String get searchLabel => 'Buscar';
  @override
  String get searchExhibitor => 'Buscar por expositor';
  @override
  String get searchVoting => 'Buscar por entidad, cargo o nombre';
  @override
  String get searchMusic => 'Buscar por música';
  @override
  String get searchDocuments => 'Buscar por documentos';
  @override
  String get messageEmpty => 'Más información próximamente';
  @override
  String get messageEmptyExhibitor =>
      '¡Uy! No hay ningún expositor así\n por aquí todavía';
  @override
  String get messageEmptySupport =>
      '¡Uy! No hay ninguna pregunta así\n por aquí todavía';
  @override
  String get messageEmptyVoting =>
      '¡Uy! No hay nada parecido\n por aquí todavía';
  @override
  String get messageEmptySchedule =>
      '¡Ups! Aún no hay horario\n disponible.\n Pronto habrá más\n información disponible';
  @override
  String get messageEmptyMySchedule =>
      'Marca como favorito un elemento\n en el horario principal y se añadirá\n a tu horario';
  @override
  String get messageEmptyDocument =>
      '¡Uy! Aún no hay documentos\n similares por aquí';
  @override
  String get spiritualContent => 'Contenido espiritual';
  @override
  String get mediaLabel => 'Medios de comunicación';
  @override
  String get copiedLabel => 'Enlace copiado al portapapeles';
  @override
  String get couldNotOpen => 'No se pudo abrir la aplicación de mapas';
  @override
  String get messageEmptyResources =>
      '¡Uy! Aún no hay funciones disponibles.\n Más información próximamente';
  @override
  String get messageEmptyNotification =>
      '¡Ups! Aún no hay notificaciones disponibles. Más información pronto';
  @override
  String get messageEmptyBrochures =>
      '¡Ups! Aún no hay folletos disponibles. Más información pronto';
  @override
  String get messageEmptyDocs =>
      '¡Ups! Aún no hay documentos disponibles. Más información pronto';
  @override
  String get messageEmptyLive =>
      '¡Ups! Aún no hay transmisiones en vivo por aquí';
  @override
  String get messageEmptyDevotional =>
      '¡Ups! Aún no hay devocional disponible.\nMás información próximamente';
  @override
  String get messageEmptyMusics =>
      '¡Ups! Aún no hay música disponible. Más información pronto';
  @override
  String get messageEmptyPrayerRoom =>
      '¡Ups! Aún no hay información disponible. Más información pronto';
  @override
  String get messageEmptyExhibitors =>
      '¡Ups! Aún no hay expositores disponibles. Más información pronto';
  @override
  String get messageEmptyFaq =>
      '¡Ups! Aún no hay preguntas frecuentes disponibles. Más información pronto';
  @override
  String get messageEmptyTranslationChannel =>
      '¡Ups! Aún no hay información de traducción disponible. Más información pronto';
  @override
  String get messageEmptyExternalFood =>
      '¡Ups! Aún no hay restaurantes locales disponibles. Más información pronto';
  @override
  String get messageEmptyInternalFood =>
      '¡Ups! Aún no hay información sobre el comedor GC. Más información pronto';
  @override
  String get messageEmptyNews =>
      '¡Ups! Aún no hay noticias disponibles. Más información pronto';
  @override
  String get messageEmptyVotings =>
      '¡Ups! Aún no hay resultados de votación disponibles. Más información pronto';
  @override
  String get messageEmptyFilterFood =>
      '¡Ups! Aún no hay restaurantes locales\npara este filtro';
  @override
  String get messageEmptyFilterExhibitor =>
      'No se encontró ninguna exposición correspondiente.';
  @override
  String get exhibitionLabel => 'Exhibición';
  @override
  String get succesDownload => '¡Documento descargado con éxito!';
  @override
  String get errorDownload => 'Error al descargar el documento';
  @override
  String get errorSharing => 'Error al compartir el documento';
  @override
  String get transportLabel => 'Transporte';
  @override
  String get accessibilityLabel => 'Accesibilidad';
  @override
  String get messageEmptyTransportation =>
      '¡Ups! Aún no hay\ninformación de transporte disponible.\nMás información pronto';
  @override
  String get messageEmptyAccessibility =>
      '¡Ups! Aún no hay\ninformación de accesibilidad disponible.\nMás información pronto';
  @override
  String get comingLabel => 'próximamente';
  @override
  String get messageEmptySocialMedia =>
      '¡Ups! Aún no hay redes sociales disponibles. Más información próximamente';
  @override
  String get bulletinLabel => 'Boletín Diario de la Sesión de la CG';
  @override
  String get noResults => 'No se encontraron resultados';
  @override
  String get nightLabel => 'NOCHE';
  @override
  String get futureLabel => 'FUTURO';
  @override
  String get selectLanguage => 'Seleccione el idioma\nque desea utilizar';
  @override
  String get otherEvents => 'Otros eventos';
  @override
  String get worship => 'Culto';
  @override
  String get couldNotLink => 'No se pudo abrir el enlace. Inténtalo de nuevo.';
  @override
  String get labelAs => 'a las';
  @override
  String get categories => 'Categorías';
  @override
  String get eveningLabel => 'noche';
}
