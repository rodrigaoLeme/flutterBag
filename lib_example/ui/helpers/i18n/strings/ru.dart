import './translation.dart';

class Ru implements Translation {
  // ACCOUNT
  @override
  String get login => 'Авторизоваться';
  @override
  String get confirmEmail => 'Подтвердите свой адрес электронной почты';
  @override
  String get email => 'Электронная почта';
  @override
  String get token => 'Токен';
  @override
  String get accept => 'Принимать';
  @override
  String get reload => 'Перезагрузить';
  @override
  String get entityLabel => 'Сущность';
  @override
  String get register => 'Зарегистрироваться';
  @override
  String get enterYourDetails => 'Основные данные';
  @override
  String get setAPassword => 'Установить пароль';
  @override
  String get password => 'Пароль';
  @override
  String get confirmPassword => 'Подтвердите свой пароль';
  @override
  String get noAccount => 'У вас нет учетной записи?';
  @override
  String get registerNow => 'Зарегистрируйтесь сейчас';
  @override
  String get previousPassword => 'Прошлое';
  @override
  String get updatedPassword => 'Обновлен пароль';
  @override
  String get passwordUpdatedSuccessfully => 'Ваш пароль успешно обновлен.';
  @override
  String get passwordNotMatch => 'Пароли не совпадают.';
  @override
  String get codeBaseInvalid => 'Неверный базовый код.';
  @override
  String get incorrectPassword => 'Неверный пароль';

  // MESSAGES
  @override
  String get msgEmailInUse => 'Электронная почта уже используется.';
  @override
  String get msgInvalidCredentials =>
      'Неправильный email или пароль. Попробуйте еще раз.';
  @override
  String get msgInvalidField => 'Неверный адрес электронной почты';
  @override
  String get msgRequiredField => 'Обязательное поле';
  @override
  String get msgUnexpectedError =>
      'Не удалось загрузить информацию. Попробуйте снова в ближайшее время.';
  @override
  String get have8Characters =>
      'Ваш пароль должен быть длиной не менее 8 символов.';
  @override
  String get savedChanges => 'Сохраненные изменения';
  @override
  String get updatedSuccessfully => 'Ваши изменения успешно обновлены.';
  @override
  String get wantToReport => 'Хотите сообщить?';
  @override
  String get wantToReportSubtitle =>
      'Вы уверены, что хотите пожаловаться на публикацию?';
  @override
  String get report => 'Отчет';

  //BUTTON
  @override
  String get close => 'Закрывать';
  @override
  String get next => 'Следующий';
  @override
  String get save => 'Сохранять';
  @override
  String get share => 'Делиться';
  @override
  String get cancel => 'Отмена';
  @override
  String get logout => 'Выйти';
  @override
  String get deleteAccount => 'Удалить аккаунт';
  @override
  String get yes => 'Да';
  @override
  String get proceed => 'Продолжать';
  @override
  String get finalizeRegistration => 'Завершить регистрацию';
  @override
  String get seeAllMembers => 'Посмотреть всех участников';
  @override
  String get backToProfile => 'Вернуться в профиль';
  @override
  String get editProfile => 'Редактировать профиль';
  @override
  String get changePhoto => 'Изменить фотографию';
  @override
  String get saveEditions => 'Сохранить изменения';
  @override
  String get link => 'связь';
  @override
  String get openLink => 'Открыть ссылку';
  @override
  String get uploadPhotoButton => 'Загрузить фотo';
  @override
  String get publishContent => 'Публикация контента';
  @override
  String get openPdf => 'Открыть PDF-файл';

  // SHARED
  @override
  String get wait => 'Ждать...';
  @override
  String get navigationTitle => 'Добро пожаловать';
  @override
  String get sendFeedback => 'Отправить отзыв';
  @override
  String get noConnectionsAvailable => '';

  //PAGES
  @override
  String get nutrition => 'Питание';
  @override
  String get profile => 'Профиль';
  @override
  String get personalData => 'Персональные данные';
  @override
  String get wanToDeleteAccount => 'Вы хотите удалить свой аккаунт?';
  @override
  String get confirmAccountDeletion =>
      'Подтвердите удаление своей учетной записи в приложении.';
  @override
  String get enterBase => 'Теперь введите свою базу.';
  @override
  String get name => 'Имя';
  @override
  String get phone => 'Телефон';
  @override
  String get gender => 'Секс';
  @override
  String get relationship => 'Отношение';
  @override
  String get anErrorHasOccurred => 'Что-то пошло не так';
  @override
  String get youAreOffline => 'Похоже, вы не в сети';
  @override
  String get checkInternetAccess =>
      'Проверьте, есть ли у устройства доступ в Интернет.';
  @override
  String get successTitle => 'Успех';
  @override
  String get notificationTitle => 'Уведомления';
  @override
  String get markReadNotification => 'Отметить как прочитанное';
  @override
  String get newMission => 'Новая миссия';
  @override
  String get newMissionAvailable =>
      'У вас есть новая доступная миссия. Нажмите, чтобы проверить ее.';
  @override
  String get notificationInputTitle => 'У вас пока нет уведомлений';
  @override
  String get notificationInputSubtitle =>
      'Если у вас есть уведомления, они будут отображаться здесь.';
  @override
  String get missionTitle => 'Миссии';
  @override
  String get yourMissions => 'Ваши миссии';
  @override
  String get levelLabel => 'Уровень';
  @override
  String get dataLabel => 'Дата';
  @override
  String get statusLabel => 'Статус';
  @override
  String get baseMembers => 'Члены вашей базы';
  @override
  String get myProfile => 'Мой профиль';
  @override
  String get baseMembersTitle => 'Члены базы';
  @override
  String get baseTitle => 'база';
  @override
  String get searchbase => 'Введите то, что вы ищете';
  @override
  String get logOffAccount => 'Выйти из аккаунта';
  @override
  String get messageLogOffAcount =>
      'Вы уверены, что хотите выйти из своей учетной записи?';
  @override
  String get toGoOut => 'Чтобы выйти';
  @override
  String get addPublication => 'Добавить публикацию';
  @override
  String get address => 'Адрес';
  @override
  String get shepherd => 'Ответственный пастор';
  @override
  String get baseLabel => 'База';
  @override
  String get changePassword => 'Изменить пароль';
  @override
  String get dateBirth => 'Дата рождения';
  @override
  String get loginRequired => 'Требуется вход';
  @override
  String get needToLogin => 'Вам необходимо войти в систему';
  @override
  String get loginRequiredSubtitle =>
      'Для просмотра этой функции вам необходимо войти в систему. Нажмите кнопку ниже и получите доступ ко всем функциям!';
  @override
  String get searchMission => 'Поиск квеста';
  @override
  String get toDoLogin => 'Авторизоваться';
  @override
  String get findBase => 'Найти базу';
  @override
  String get addAdmin => 'Добавить администратора';
  @override
  String get removeAdmin => 'Удалить администратора';
  @override
  String get fileSending => 'Загрузка файла';
  @override
  String get uploadPhoto => 'Загрузите свое фото здесь';
  @override
  String get camera => 'Камера';
  @override
  String get gallery => 'Галерея';
  @override
  String get basicInformation => 'Основная информация';
  @override
  String get contentType => 'Тип контента';
  @override
  String get publicationContent => 'Содержание публикации';
  @override
  String get attachPhotosToPost => 'Прикрепите фотографии к посту';
  @override
  String get photosAllowed => 'К публикации допускается до 5 фотографий.';
  @override
  String get femaleSex => 'Женский';
  @override
  String get maleSex => 'Мужской род';
  @override
  String get titlePost => 'Заголовок';
  @override
  String get subtitlePost => 'Подзаголовок (если есть)';
  @override
  String get descriptionPost => 'Введите текст содержания';
  @override
  String get publishedContent => 'Опубликованное содержаниеt';
  @override
  String get publishedContentDescription =>
      'Ваш контент успешно опубликован. Получите к нему доступ!';
  @override
  String get viewContent => 'Посмотреть контент';
  @override
  String get addTags => 'Вставьте хэштеги контента';
  @override
  String get typeLink => 'Внешняя ссылка (сайт, видео, подкаст)';
  @override
  String get typePDF => 'PDF-файл';
  @override
  String get typeInternText => 'Внутренний текст';
  @override
  String get selectTypePost => 'Выберите тип контента';
  @override
  String get searchMembers => 'Найти участника';
  @override
  String get changeNameBase => 'Изменить имя базы данных';
  @override
  String get editBase => 'Редактировать базу';
  @override
  String get addAdminUser => 'Администратор добавлен к пользователю';
  @override
  String get selectDate => 'Выберите дату';
  @override
  String get searchDate => 'Введите дату';
  @override
  String get select => 'Выбирать';
  @override
  String get dateInitial => 'Дата начала';
  @override
  String get dateFinal => 'Дата окончания';
  @override
  String get statusConclued => 'Завершенный';
  @override
  String get statusPending => 'Подвески';
  @override
  String get statusToDo => 'Делать';
  @override
  String get okLabel => 'Хорошо';
  @override
  String get registrationSuccessful => 'Регистрация завершена успешно';
  @override
  String get registrationCompletedSuccessfully =>
      'Ваша регистрация успешно завершена. Теперь вы можете войти в систему, чтобы получить доступ к приложению.';
  @override
  String get errorSaveTitleAlert => 'Ошибка сохранения изменений.';
  @override
  String get errorSaveDescriptionAlert =>
      'Произошла ошибка при сохранении изменений. Попробуйте еще раз.';
  @override
  String get dataLastDay => 'Последний день';
  @override
  String get dataLastSevenDays => 'Последние 7 дней';
  @override
  String get dataLastFourteenDays => 'Последние 14 дней';
  @override
  String get dataLastThirtyDays => 'Последние 30 дней';
  @override
  String get dataPersonalized => 'Пользовательская дата';
  @override
  String get spiritualLabel => 'Духовный';
  @override
  String get seeAllButon => 'Посмотреть все';
  @override
  String get exhibitionsLabel => 'Выставки';
  @override
  String get foodLabel => 'Еда';
  @override
  String get addFriends => 'Добавить друзей';
  @override
  String get emergencyLabel => 'Чрезвычайная ситуация';
  @override
  String get hotelsLabel => 'Отели';
  @override
  String get publicTransportLabel => 'Общественный транспорт';
  @override
  String get myAgendaLabel => 'МОЕ РАСПИСАНИЕ';
  @override
  String get favoritesLabel => 'ИЗБРАННОЕ';
  @override
  String get filtersLabel => 'ФИЛЬТР';
  @override
  String get allLabel => 'ВСЕ';
  @override
  String get newsLabel => 'Новости';
  @override
  String get votingResultsLabel => 'Результаты голосования';
  @override
  String get menuLabel => 'МЕНЮ';
  @override
  String get ticketLabel => 'Билет';
  @override
  String get votingLabel => 'Голосование';
  @override
  String get eventsAvailable => 'Доступные события';
  @override
  String get detailsLabel => 'Подробности';
  @override
  String get descriptionLabel => 'Описание';
  @override
  String get downloadLabel => 'Скачать';
  @override
  String get agendaLabel => 'Повестка дня';
  @override
  String get messageErrorLabel => 'Что-то пошло не так';
  @override
  String get messageErrorSubtitle =>
      'Похоже, вы не в сети.\nПроверьте, есть ли у устройства доступ в Интернет.';
  @override
  String get tryAgainLabel => 'Попробуйте еще раз';
  @override
  String get somethingWrongTitle => 'Что-то не так';
  @override
  String get somethingWrongSubtitle =>
      'Упс! Что-то пошло не так. Попробуйте\nеще раз позже.';
  @override
  String get invalidURL => 'Недействительный URL';
  @override
  String get faqLabel => 'Часто задаваемые вопросы';
  @override
  String get supportLabel => 'Поддерживать';
  @override
  String get scheduleLabel => 'Расписание';
  @override
  String get stayTunedLabel => 'Следите за обновлениями!';
  @override
  String get programmingNotAvailable =>
      'Добавьте элемент в избранное\n в основном расписании, и он\n появится в вашем\n расписании.';
  @override
  String get scheduleNotAvailableYetLabel => 'Расписание пока недоступно';
  @override
  String get liveLabel => 'ЖИТЬ';
  @override
  String get allTinyLabel => 'все';
  @override
  String get myScheduleTiny => 'мое расписание';
  @override
  String get attendeesLabel => 'Участники';
  @override
  String get votingInformationLabel => 'Информация для голосования';
  @override
  String get documentsLabel => 'Документы';
  @override
  String get brochuresLabel => 'Брошюры';
  @override
  String get businessLabel => 'Бизнес';
  @override
  String get typeMessageLabel => 'Введите сообщение';
  @override
  String get emergencyInformationLabel => 'Экстренная информация';
  @override
  String get emergencyNumberLabel => 'Номер службы экстренной помощи';
  @override
  String get editingProfileLabel => 'Редактирование профиля';
  @override
  String get changeImageLabel => 'Редактирование профиля';
  @override
  String get linkedInLabel => 'LinkedIn';
  @override
  String get socialMediaLabel => 'Социальные сети';
  @override
  String get participantsLabel => 'Участники';
  @override
  String get resourcesLabel => 'Ресурсы';
  @override
  String get guidelinesLabel => 'Рекомендации';
  @override
  String get detailsCapital => 'ПОДРОБНОСТИ';
  @override
  String get resourcesCapital => 'РЕСУРСЫ';
  @override
  String get directionsLabel => 'Направления';
  @override
  String get restaurantsLabel => 'РЕСТОРАНЫ';
  @override
  String get favoriteRestaurantLabel => 'Любимые рестораны';
  @override
  String get externalLabel => 'ВНЕШНИЙ';
  @override
  String get internalLabel => 'ВНУТРЕННИЙ';
  @override
  String get getLineLabel => 'Встаньте в очередь';
  @override
  String get speakingLabel => 'Говорящий';
  @override
  String get mapsLabel => 'Карты';
  @override
  String get home => 'Дом';
  @override
  String get map => 'Карта';
  @override
  String get more => 'Более';
  @override
  String get locationLabel => 'Расположение';
  @override
  String get notificationsLabel => 'Уведомления';
  @override
  String get savedRestaurantsLabel => 'Сохраненные рестораны';
  @override
  String get musicLabel => 'Музыка';
  @override
  String get prayerRoomLabel => 'Молитвенная комната';
  @override
  String get devotionalLabel => 'Преданный';
  @override
  String get clearAllLabel => 'Очистить все';
  @override
  String get applyLabel => 'Применять';
  @override
  String get filterByLabel => 'Фильтровать по';
  @override
  String get filterByInstitutionsLabel => 'Фильтровать по учреждениям';
  @override
  String get newElectedLabel => 'Новые избранные';
  @override
  String get addPhoneLabel => 'Добавить номер телефона';
  @override
  String get receiveSMSLabel =>
      'Хотите ли вы получать СМС-сообщения в экстренных случаях?';
  @override
  String get emergencyCapital => 'ЧРЕЗВЫЧАЙНАЯ СИТУАЦИЯ';
  @override
  String get exitPlanCapital => 'ПЛАН ВЫХОДА';
  @override
  String get phoneNumberLabel => 'Номер телефона';
  @override
  String get labeQuickAccess => 'Быстрый доступ';
  @override
  String get languageLabel => 'Язык';
  @override
  String get infoLabel => 'Информация';
  @override
  String get foodService => 'Общественное питание';
  @override
  String get partnerships => 'Партнерство';
  @override
  String get votes => 'Голоса';
  @override
  String get spiritual => 'Духовный';
  @override
  String get docsLabel => 'Документы';
  @override
  String get liveTinyLabel => 'Жить';
  @override
  String get mySchedule => 'Мое расписание';
  @override
  String get noEventFound => 'События не найдены';
  @override
  String get eventsAvailableSoon =>
      'Зарегистрированные события будут доступны в ближайшее время';
  @override
  String get backLabel => 'Назад';
  @override
  String get biographyLabel => 'Биография';
  @override
  String get translationChanelLabel => 'Перевод';
  @override
  String get ticketPurchaseLabel => 'Покупка билетов';
  @override
  String get nextLiveLabel => 'Следующий эфир';
  @override
  String get previousLabel => 'Предыдущий';
  @override
  String get liveBroadcastLabel => 'Прямая трансляция';
  @override
  String get morningLabel => 'УТРО';
  @override
  String get afternoonLabel => 'ПОЛДЕНЬ';
  @override
  String get diningHall => 'ГК Столовая';
  @override
  String get localRestaurant => 'Местные рестораны';
  @override
  String get searchLabel => 'Поиск по вопросу';
  @override
  String get searchExhibitor => 'Поиск по экспоненту';
  @override
  String get searchVoting => 'Поиск по сущности, должности или имени';
  @override
  String get searchMusic => 'Поиск по музыке';
  @override
  String get searchDocuments => 'Поиск по документам';
  @override
  String get messageEmpty => 'Дополнительная информация скоро появится';
  @override
  String get messageEmptyExhibitor =>
      'Упс! Пока что такого экспонента\n здесь нет.';
  @override
  String get messageEmptySupport => 'Упс! Такого вопроса здесь\n пока нет';
  @override
  String get messageEmptyVoting => 'Упс! Пока такого\n здесь нет';
  @override
  String get messageEmptySchedule =>
      'Упс! Расписание пока отсутствует.\n Более подробная информация\n будет доступна в ближайшее время';
  @override
  String get messageEmptyMySchedule =>
      'Добавьте элемент в избранное в\n основном расписании, и он появится\n в вашем расписании';
  @override
  String get messageEmptyDocument => 'Упс! Таких документов\n здесь пока нет';
  @override
  String get spiritualContent => 'Духовное содержание';
  @override
  String get mediaLabel => 'СМИ';
  @override
  String get copiedLabel => 'Ссылка скопирована в буфер обмена';
  @override
  String get couldNotOpen => 'Не удалось открыть приложение «Карты»';
  @override
  String get messageEmptyResources =>
      'Упс! Пока нет доступных функций. \nСкоро будет больше информации';
  @override
  String get messageEmptyNotification =>
      'Упс! Уведомления пока недоступны. Скоро появится больше информации';
  @override
  String get messageEmptyBrochures =>
      'Упс! Брошюры пока недоступны. Скоро появится больше информации';
  @override
  String get messageEmptyDocs =>
      'Упс! Документы пока недоступны. Скоро появится больше информации';
  @override
  String get messageEmptyLive => 'Упс! Пока нет прямых трансляций поблизости';
  @override
  String get messageEmptyDevotional =>
      'Упс! Духовное наставление пока недоступно.\nДополнительная информация скоро появится';
  @override
  String get messageEmptyMusics =>
      'Упс! Музыка пока недоступна. Скоро появится больше информации';
  @override
  String get messageEmptyPrayerRoom =>
      'Упс! Информация пока недоступна. Скоро появится больше информации';
  @override
  String get messageEmptyExhibitors =>
      'Упс! Экспоненты пока недоступны. Скоро появится больше информации';
  @override
  String get messageEmptyFaq =>
      'Упс! Часто задаваемые вопросы пока недоступны. Скоро появится больше информации';
  @override
  String get messageEmptyTranslationChannel =>
      'Упс! Информация о переводе пока недоступна. Скоро появится больше информации';
  @override
  String get messageEmptyExternalFood =>
      'Упс! Местные рестораны пока недоступны. Скоро появится больше информации';
  @override
  String get messageEmptyInternalFood =>
      'Упс! Информация о столовой GC пока недоступна. Скоро появится больше информации';
  @override
  String get messageEmptyNews =>
      'Упс! Новости пока недоступны. Скоро появится больше информации';
  @override
  String get messageEmptyVotings =>
      'Упс! Результаты голосования пока недоступны. Скоро появится больше информации';
  @override
  String get messageEmptyFilterFood =>
      'Упс! Пока нет местных\nресторанов для этого фильтра';
  @override
  String get messageEmptyFilterExhibitor => 'Подходящей выставки не найдено';
  @override
  String get exhibitionLabel => 'Выставка';
  @override
  String get succesDownload => 'Документ успешно загружен!';
  @override
  String get errorDownload => 'Ошибка при загрузке документа';
  @override
  String get errorSharing => 'Ошибка при попытке поделиться документом';
  @override
  String get transportLabel => 'Транспорт';
  @override
  String get accessibilityLabel => 'Доступность';
  @override
  String get messageEmptyTransportation =>
      'Упс! Информация о транспорте\nпока недоступна.\nСкоро будет больше данных';
  @override
  String get messageEmptyAccessibility =>
      'Упс! Информация о доступности\nпока недоступна.\nСкоро будет больше данных';
  @override
  String get comingLabel => 'будет следующим';
  @override
  String get messageEmptySocialMedia =>
      'Упс! Социальные сети пока недоступны. Скоро будет больше информации';
  @override
  String get bulletinLabel => 'Ежедневный бюллетень сессии ГК';
  @override
  String get noResults => 'Результаты не найдены';
  @override
  String get nightLabel => 'НОЧЬ';
  @override
  String get futureLabel => 'БУДУЩЕЕ';
  @override
  String get selectLanguage => 'Выберите язык, который\nвы хотите использовать';
  @override
  String get otherEvents => 'Другие события';
  @override
  String get worship => 'Поклонение';
  @override
  String get couldNotLink => 'Не удалось открыть ссылку. Попробуйте ещё раз.';
  @override
  String get labelAs => 'в';
  @override
  String get categories => 'Категории';
  @override
  String get eveningLabel => 'вечер';
}
