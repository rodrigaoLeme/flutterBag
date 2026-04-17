import './translation.dart';

class Fr implements Translation {
  // ACCOUNT
  @override
  String get login => 'Se connecter';
  @override
  String get confirmEmail => 'Confirmez votre email';
  @override
  String get email => 'E-mail';
  @override
  String get token => 'Jeton';
  @override
  String get accept => 'Accepter';
  @override
  String get reload => 'Recharger';
  @override
  String get entityLabel => 'Entité';
  @override
  String get register => 'Registre';
  @override
  String get enterYourDetails => 'Données principales';
  @override
  String get setAPassword => 'Définir un mot de passe';
  @override
  String get password => 'Mot de passe';
  @override
  String get confirmPassword => 'Confirmez votre mot de passe';
  @override
  String get noAccount => 'Vous n`avez pas de compte?';
  @override
  String get registerNow => 'Inscrivez-vous maintenant';
  @override
  String get previousPassword => 'Mot de passe précédent';
  @override
  String get updatedPassword => 'Mot de passe mis à jour';
  @override
  String get passwordUpdatedSuccessfully =>
      'Votre mot de passe a été mis à jour avec succès';
  @override
  String get passwordNotMatch => 'Les mots de passe ne correspondent pas';
  @override
  String get codeBaseInvalid => 'Code de base non valide.';
  @override
  String get incorrectPassword => 'Mot de passe invalide';

  // MESSAGES
  @override
  String get msgEmailInUse => 'L`e-mail est déjà utilisé';
  @override
  String get msgInvalidCredentials =>
      'Adresse e-mail ou mot de passe incorrect. Veuillez réessayer';
  @override
  String get msgInvalidField => 'E-mail invalide';
  @override
  String get msgRequiredField => 'Champ obligatoire';
  @override
  String get msgUnexpectedError =>
      'Échec du chargement des informations. Veuillez réessayer bientôt';
  @override
  String get have8Characters =>
      'Votre mot de passe doit comporter au moins 8 caractères';
  @override
  String get savedChanges => 'Modifications enregistrées';
  @override
  String get updatedSuccessfully =>
      'Vos modifications ont été mises à jour avec succès';
  @override
  String get wantToReport => 'Voulez-vous signaler?';
  @override
  String get wantToReportSubtitle =>
      'Êtes-vous sûr de vouloir signaler la publication?';
  @override
  String get report => 'Rapport';

  //BUTTON
  @override
  String get close => 'Fermer';
  @override
  String get next => 'Suivant';
  @override
  String get save => 'Sauvegarder';
  @override
  String get share => 'Partager';
  @override
  String get cancel => 'Annuler';
  @override
  String get logout => 'Se déconnecter';
  @override
  String get deleteAccount => 'Supprimer le compte';
  @override
  String get yes => 'Oui';
  @override
  String get proceed => 'Continuer';
  @override
  String get finalizeRegistration => 'Finaliser l`inscription';
  @override
  String get seeAllMembers => 'Voir tous les membres';
  @override
  String get backToProfile => 'Retour au profil';
  @override
  String get editProfile => 'Modifier le profil';
  @override
  String get changePhoto => 'Changer de photo';
  @override
  String get saveEditions => 'Enregistrer les modifications';
  @override
  String get link => 'lien';
  @override
  String get openLink => 'Ouvrir le lien';
  @override
  String get uploadPhotoButton => 'Télécharger une photo';
  @override
  String get publishContent => 'Publier du contenu';
  @override
  String get openPdf => 'Ouvrir le PDF';

  // SHARED
  @override
  String get wait => 'Attendez...';
  @override
  String get navigationTitle => 'Bienvenu';
  @override
  String get sendFeedback => 'Envoyer des commentaires';
  @override
  String get noConnectionsAvailable => '';

  //PAGES
  @override
  String get nutrition => 'Nutrition';
  @override
  String get profile => 'Profil';
  @override
  String get personalData => 'Données personnelles';
  @override
  String get wanToDeleteAccount => 'Voulez-vous supprimer votre compte?';
  @override
  String get confirmAccountDeletion =>
      'Confirmez la suppression de votre compte dans l`application';
  @override
  String get enterBase => 'Maintenant, entrez dans votre base';
  @override
  String get name => 'Nom';
  @override
  String get phone => 'Téléphone';
  @override
  String get gender => 'Sexe';
  @override
  String get relationship => 'Relation';
  @override
  String get anErrorHasOccurred => 'Quelque chose s`est mal passé';
  @override
  String get youAreOffline => 'Il semble que vous soyez hors ligne';
  @override
  String get checkInternetAccess =>
      'Vérifiez si l`appareil dispose d`un accès Internet';
  @override
  String get successTitle => 'Succès';
  @override
  String get notificationTitle => 'Notifications';
  @override
  String get markReadNotification => 'Marquer comme lu';
  @override
  String get newMission => 'Nouvelle mission';
  @override
  String get newMissionAvailable =>
      'Une nouvelle mission est disponible. Cliquez pour la découvrir';
  @override
  String get notificationInputTitle =>
      'Vous n`avez pas encore de notifications';
  @override
  String get notificationInputSubtitle =>
      'Lorsque vous avez des notifications, elles apparaîtront ici';
  @override
  String get missionTitle => 'Missions';
  @override
  String get yourMissions => 'Vos missions';
  @override
  String get levelLabel => 'Niveau';
  @override
  String get dataLabel => 'Date';
  @override
  String get statusLabel => 'Statut';
  @override
  String get baseMembers => 'Membres de votre base';
  @override
  String get myProfile => 'Mon profil';
  @override
  String get baseMembersTitle => 'Membres de base';
  @override
  String get baseTitle => 'Base';
  @override
  String get searchbase => 'Tapez ce que vous recherchez';
  @override
  String get logOffAccount => 'Se déconnecter du compte';
  @override
  String get messageLogOffAcount =>
      'Êtes-vous sûr de vouloir vous déconnecter de votre compte?';
  @override
  String get toGoOut => 'Pour sortir';
  @override
  String get addPublication => 'Ajouter une publication';
  @override
  String get address => 'Adresse';
  @override
  String get shepherd => 'Pasteur responsable';
  @override
  String get baseLabel => 'Base';
  @override
  String get changePassword => 'Changer le mot de passe';
  @override
  String get dateBirth => 'Date de naissance';
  @override
  String get loginRequired => 'Connexion requise';
  @override
  String get needToLogin => 'Vous devez vous connecter';
  @override
  String get loginRequiredSubtitle =>
      'Pour voir cette fonctionnalité, vous devez vous connecter. Cliquez sur le bouton ci-dessous et profitez de l`accès à toutes les fonctionnalités!';
  @override
  String get searchMission => 'Recherche de quête';
  @override
  String get toDoLogin => 'Se connecter';
  @override
  String get findBase => 'Trouver une base';
  @override
  String get addAdmin => 'Ajouter un administrateur';
  @override
  String get removeAdmin => 'Supprimer l`administrateur';
  @override
  String get fileSending => 'Téléchargement de fichiers';
  @override
  String get uploadPhoto => 'Téléchargez votre photo ici';
  @override
  String get camera => 'Caméra';
  @override
  String get gallery => 'Galerie';
  @override
  String get basicInformation => 'Informations de base';
  @override
  String get contentType => 'Type de contenu';
  @override
  String get publicationContent => 'Contenu de la publication';
  @override
  String get attachPhotosToPost => 'Joindre des photos à la publication';
  @override
  String get photosAllowed =>
      'Jusqu’à 5 photos sont autorisées pour la publication.';
  @override
  String get femaleSex => 'Féminin';
  @override
  String get maleSex => 'Masculin';
  @override
  String get titlePost => 'Titre';
  @override
  String get subtitlePost => 'Sous-titre (si existant)';
  @override
  String get descriptionPost => 'Entrez le texte du contenu';
  @override
  String get publishedContent => 'Contenu publié';
  @override
  String get publishedContentDescription =>
      'Votre contenu a été publié avec succès. Accédez-y !';
  @override
  String get viewContent => 'Voir le contenu';
  @override
  String get addTags => 'Insérer les hashtags du contenu';
  @override
  String get typeLink => 'Lien externe (site web, vidéo, podcast)';
  @override
  String get typePDF => 'Fichier PDF';
  @override
  String get typeInternText => 'Texte interne';
  @override
  String get selectTypePost => 'Sélectionner le type de contenu';
  @override
  String get searchMembers => 'Rechercher un membre';
  @override
  String get changeNameBase => 'Changer le nom de la base de données';
  @override
  String get editBase => 'Modifier la base';
  @override
  String get addAdminUser => 'Administrateur ajouté à l’utilisateur';
  @override
  String get selectDate => 'Sélectionner une date';
  @override
  String get searchDate => 'Entrez la date';
  @override
  String get select => 'Sélectionner';
  @override
  String get dateInitial => 'Date de début';
  @override
  String get dateFinal => 'Date de fin';
  @override
  String get statusConclued => 'Terminé';
  @override
  String get statusPending => 'En attente';
  @override
  String get statusToDo => 'À faire';
  @override
  String get okLabel => 'Ok';
  @override
  String get registrationSuccessful => 'Inscription réussie';
  @override
  String get registrationCompletedSuccessfully =>
      'Votre inscription a été complétée avec succès. Vous pouvez maintenant vous connecter pour accéder à l’application';
  @override
  String get errorSaveTitleAlert => 'Erreur lors de l’enregistrement';
  @override
  String get errorSaveDescriptionAlert =>
      'Une erreur est survenue lors de l’enregistrement de vos modifications. Veuillez réessayer';
  @override
  String get dataLastDay => 'Dernier jour';
  @override
  String get dataLastSevenDays => '7 derniers jours';
  @override
  String get dataLastFourteenDays => '14 derniers jours';
  @override
  String get dataLastThirtyDays => '30 derniers jours';
  @override
  String get dataPersonalized => 'Date personnalisée';
  @override
  String get spiritualLabel => 'Spirituel';
  @override
  String get seeAllButon => 'Voir tout';
  @override
  String get exhibitionsLabel => 'Expositions';
  @override
  String get foodLabel => 'Alimentation';
  @override
  String get addFriends => 'Ajouter des amis';
  @override
  String get emergencyLabel => 'Urgence';
  @override
  String get hotelsLabel => 'Hôtels';
  @override
  String get publicTransportLabel => 'Transports en commun';
  @override
  String get myAgendaLabel => 'MON PLANNING';
  @override
  String get favoritesLabel => 'FAVORIS';
  @override
  String get filtersLabel => 'FILTRE';
  @override
  String get allLabel => 'TOUT';
  @override
  String get newsLabel => 'Actualités';
  @override
  String get votingResultsLabel => 'Résultats du vote';
  @override
  String get menuLabel => 'MENU';
  @override
  String get ticketLabel => 'Billet';
  @override
  String get votingLabel => 'Vote';
  @override
  String get eventsAvailable => 'Événements disponibles';
  @override
  String get detailsLabel => 'Détails';
  @override
  String get descriptionLabel => 'Description';
  @override
  String get downloadLabel => 'Télécharger';
  @override
  String get agendaLabel => 'Agenda';
  @override
  String get messageErrorLabel => 'Quelque chose s’est mal passé';
  @override
  String get messageErrorSubtitle =>
      'Il semble que vous soyez hors ligne.\nVérifiez si l’appareil a accès à Internet';
  @override
  String get tryAgainLabel => 'Réessayer';
  @override
  String get somethingWrongTitle => 'Problème détecté';
  @override
  String get somethingWrongSubtitle =>
      'Oups ! Une erreur est survenue.\nVeuillez réessayer plus tard';
  @override
  String get invalidURL => 'URL invalide';
  @override
  String get faqLabel => 'FAQ';
  @override
  String get supportLabel => 'Support';
  @override
  String get scheduleLabel => 'Programme';
  @override
  String get stayTunedLabel => 'Restez connectés !';
  @override
  String get programmingNotAvailable =>
      'Ajoutez un élément en favori\n dans le programme principal et il\n sera ajouté à votre\n programme';
  @override
  String get scheduleNotAvailableYetLabel => 'Programme non encore disponible';
  @override
  String get liveLabel => 'EN DIRECT';
  @override
  String get allTinyLabel => 'tout';
  @override
  String get myScheduleTiny => 'mon planning';
  @override
  String get attendeesLabel => 'Participants';
  @override
  String get votingInformationLabel => 'Informations sur le vote';
  @override
  String get documentsLabel => 'Documents';
  @override
  String get brochuresLabel => 'Brochures';
  @override
  String get businessLabel => 'Entreprise';
  @override
  String get typeMessageLabel => 'Saisir le message';
  @override
  String get emergencyInformationLabel => 'Informations d’urgence';
  @override
  String get emergencyNumberLabel => 'Numéro d’urgence';
  @override
  String get editingProfileLabel => 'Édition du profil';
  @override
  String get changeImageLabel => 'Modifier la photo';
  @override
  String get linkedInLabel => 'LinkedIn';
  @override
  String get socialMediaLabel => 'Réseaux sociaux';
  @override
  String get participantsLabel => 'Participants';
  @override
  String get resourcesLabel => 'Ressources';
  @override
  String get guidelinesLabel => 'Lignes directrices';
  @override
  String get detailsCapital => 'DÉTAILS';
  @override
  String get resourcesCapital => 'RESSOURCES';
  @override
  String get directionsLabel => 'Itinéraire';
  @override
  String get restaurantsLabel => 'RESTAURANTS';
  @override
  String get favoriteRestaurantLabel => 'Restaurants favoris';
  @override
  String get externalLabel => 'EXTERNE';
  @override
  String get internalLabel => 'INTERNE';
  @override
  String get getLineLabel => 'Faire la queue';
  @override
  String get speakingLabel => 'Intervenant';
  @override
  String get mapsLabel => 'Cartes';
  @override
  String get home => 'Accueil';
  @override
  String get map => 'Carte';
  @override
  String get more => 'Plus';
  @override
  String get locationLabel => 'Emplacement';
  @override
  String get notificationsLabel => 'Notifications';
  @override
  String get savedRestaurantsLabel => 'Restaurants enregistrés';
  @override
  String get musicLabel => 'Musique';
  @override
  String get prayerRoomLabel => 'Salle de prière';
  @override
  String get devotionalLabel => 'Dévotion';
  @override
  String get clearAllLabel => 'Tout effacer';
  @override
  String get applyLabel => 'Appliquer';
  @override
  String get filterByLabel => 'Filtrer par';
  @override
  String get filterByInstitutionsLabel => 'Filtrer par institutions';
  @override
  String get newElectedLabel => 'Nouveaux élus';
  @override
  String get addPhoneLabel => 'Ajouter un numéro de téléphone';
  @override
  String get receiveSMSLabel =>
      'Souhaitez-vous recevoir des SMS en cas d’urgence ?';
  @override
  String get emergencyCapital => 'URGENCE';
  @override
  String get exitPlanCapital => 'PLAN D’ÉVACUATION';
  @override
  String get phoneNumberLabel => 'Numéro de téléphone';
  @override
  String get labeQuickAccess => 'Accès rapide';
  @override
  String get languageLabel => 'Langue';
  @override
  String get infoLabel => 'Informations';
  @override
  String get foodService => 'Service de restauration';
  @override
  String get partnerships => 'Partenariats';
  @override
  String get votes => 'Votes';
  @override
  String get spiritual => 'Spirituel';
  @override
  String get docsLabel => 'Docs';
  @override
  String get liveTinyLabel => 'Direct';
  @override
  String get mySchedule => 'Mon planning';
  @override
  String get noEventFound => 'Aucun événement trouvé';
  @override
  String get eventsAvailableSoon =>
      'Les événements enregistrés seront bientôt disponibles';
  @override
  String get backLabel => 'Retour';
  @override
  String get biographyLabel => 'Biographie';
  @override
  String get translationChanelLabel => 'Traduction';
  @override
  String get ticketPurchaseLabel => 'Achat de billet';
  @override
  String get nextLiveLabel => 'Prochain direct';
  @override
  String get previousLabel => 'Passé';
  @override
  String get liveBroadcastLabel => 'Diffusion en direct';
  @override
  String get morningLabel => 'MATIN';
  @override
  String get afternoonLabel => 'APRÈS-MIDI';
  @override
  String get diningHall => 'Salle à manger GC';
  @override
  String get localRestaurant => 'Restaurants locaux';
  @override
  String get searchLabel => 'Recherche par question';
  @override
  String get searchExhibitor => 'Recherche par exposant';
  @override
  String get searchVoting => 'Rechercher par entité, poste ou nom';
  @override
  String get searchMusic => 'Srecherche par musique';
  @override
  String get searchDocuments => 'Recherche par documents';
  @override
  String get messageEmpty => 'Plus d`informations à venir';
  @override
  String get messageEmptyExhibitor =>
      'Oups! Il n`y a pas encore d`exposant\n de ce type dans les environs';
  @override
  String get messageEmptySupport =>
      'Oups! Il n`y a pas encore de question\n de ce genre ici';
  @override
  String get messageEmptyVoting => 'Oups! Il n`y en a pas encore\n par ici';
  @override
  String get messageEmptySchedule =>
      'Oups! Aucun horaire n`est\n encore disponible.\n Plus d`informations seront\n bientôt disponibles';
  @override
  String get messageEmptyMySchedule =>
      'Ajoutez un élément en favori dans le\n programme principal et il sera ajouté\n à votre programme';
  @override
  String get messageEmptyDocument =>
      'Oups! Il n`y a pas encore de tels\n documents ici.';
  @override
  String get spiritualContent => 'Contenu spirituel';
  @override
  String get mediaLabel => 'Médias';
  @override
  String get copiedLabel => 'Lien copié dans le presse-papiers';
  @override
  String get couldNotOpen => 'Impossible d`ouvrir l`application Maps';
  @override
  String get messageEmptyResources =>
      'Oups! Aucune fonctionnalité disponible pour le moment.\n Plus d`informations à venir';
  @override
  String get messageEmptyNotification =>
      'Oups ! Aucune notification disponible pour le moment. Plus d\'informations à venir';
  @override
  String get messageEmptyBrochures =>
      'Oups ! Aucune brochure disponible pour le moment. Plus d\'informations à venir';
  @override
  String get messageEmptyDocs =>
      'Oups ! Aucun document disponible pour le moment. Plus d\'informations à venir';
  @override
  String get messageEmptyLive =>
      'Oups ! Il n\'y a pas encore de diffusion en direct disponible ici';
  @override
  String get messageEmptyDevotional =>
      'Oups ! Aucun dévotionnel disponible pour le moment.\nPlus d’informations bientôt';
  @override
  String get messageEmptyMusics =>
      'Oups ! Aucune musique disponible pour le moment. Plus d\'informations à venir';
  @override
  String get messageEmptyPrayerRoom =>
      'Oups ! Aucune information disponible pour le moment. Plus d\'informations à venir';
  @override
  String get messageEmptyExhibitors =>
      'Oups ! Aucun exposant disponible pour le moment. Plus d\'informations à venir';
  @override
  String get messageEmptyFaq =>
      'Oups ! Aucune FAQ disponible pour le moment. Plus d\'informations à venir';
  @override
  String get messageEmptyTranslationChannel =>
      'Oups ! Aucune information sur la traduction disponible pour le moment. Plus d\'informations à venir';
  @override
  String get messageEmptyExternalFood =>
      'Oups ! Aucun restaurant local disponible pour le moment. Plus d\'informations à venir';
  @override
  String get messageEmptyInternalFood =>
      'Oups ! Aucune information sur le réfectoire GC disponible pour le moment. Plus d\'informations à venir';
  @override
  String get messageEmptyNews =>
      'Oups ! Aucune actualité disponible pour le moment. Plus d\'informations à venir';
  @override
  String get messageEmptyVotings =>
      'Oups ! Aucun résultat de vote disponible pour le moment. Plus d\'informations à venir';
  @override
  String get messageEmptyFilterFood =>
      'Oups ! Il n’y a pas encore de restaurants locaux\npour ce filtre';
  @override
  String get messageEmptyFilterExhibitor =>
      'Aucune exposition correspondante trouvée';
  @override
  String get exhibitionLabel => 'Exposition';
  @override
  String get succesDownload => 'Document téléchargé avec succès !';
  @override
  String get errorDownload => 'Erreur lors du téléchargement du document';
  @override
  String get errorSharing => 'Erreur lors du partage du document';
  @override
  String get transportLabel => 'Transport';
  @override
  String get accessibilityLabel => 'Accessibilité';
  @override
  String get messageEmptyTransportation =>
      'Oups ! Aucune information\nsur le transport pour le moment.\nPlus d’infos bientôt';
  @override
  String get messageEmptyAccessibility =>
      'Oups ! Aucune information\nsur l’accessibilité pour le moment.\nPlus d’infos bientôt';
  @override
  String get comingLabel => 'à venir ensuite';
  @override
  String get messageEmptySocialMedia =>
      'Oups ! Aucune présence sur les réseaux sociaux pour le moment. Plus d’informations bientôt';
  @override
  String get bulletinLabel => 'Bulletin Quotidien de la Session de la CG';
  @override
  String get noResults => 'Aucun résultat trouvé';
  @override
  String get nightLabel => 'NUIT';
  @override
  String get futureLabel => 'AVENIR';
  @override
  String get selectLanguage =>
      'Sélectionnez la langue\nque vous souhaitez utiliser';
  @override
  String get otherEvents => 'Autres événements';
  @override
  String get worship => 'Culte';
  @override
  String get couldNotLink => 'Impossible d`ouvrir le lien. Veuillez réessayer.';
  @override
  String get labelAs => 'à';
  @override
  String get categories => 'Catégories';
  @override
  String get eveningLabel => 'soirée';
}
