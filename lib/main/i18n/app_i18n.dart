import 'pt_br_i18n.dart';

abstract class AppI18n {
  static AppI18n current = const PtBrI18n();

  // App
  String get appTitle;
  String get appNameDev;
  String get appNameProd;

  // Common errors
  String get errorNoInternet;
  String get errorTimeout;
  String get errorUnexpected;

  // Common Messages
  String get tryAgain;

  // Auth common
  String get authCpfLabel;
  String get authCpfHint;
  String get authPhoneLabel;
  String get authEmailLabel;
  String get authPasswordLabel;
  String get authForgotPasswordAction;
  String get authLoginAction;
  String get authCreateAccountAction;

  // Login
  String get loginPasswordHint;
  String get accountNotConfirmedTitle;
  String get accountNotConfirmedDescription;
  String get accountNotConfirmedResendEmailButton;
  String get accountNotConfirmedDialogTitle;
  String get accountNotConfirmedDialogDescription;
  String get accountNotConfirmedDialogDoneButton;

  // Create account
  String get createAccountPageTitle;
  String get createAccountHeader;
  String get createAccountDescription;
  String get createAccountFullNameLabel;
  String get createAccountFullNameHint;
  String get createAccountEmailHint;
  String get createAccountPasswordHint;
  String get createAccountConfirmPasswordLabel;
  String get createAccountConfirmPasswordHint;
  String get createAccountNextAction;
  String get termsPageTitle;
  String get termsContent;
  String get termsReadAndAccept;
  String get termsAgreeUse;
  String get termsConfirm;
  String get createdAccountPageTitle;
  String get createdAccountSuccessTitle;
  String get createdAccountSuccessDescription;
  String get createdAccountDoneButton;
  String get createAccountDialogTitle;
  String get createAccountDialogDescription;
  String get createAccountDialogDoneButton;

  // Forgot password
  String get forgotPasswordHeader;
  String get forgotPasswordDescription;
  String get forgotPasswordHelpText;
  String get forgotPasswordConfirmAction;
  String get forgotPasswordSuccessTitle;
  String get forgotPasswordSuccessDescription;
  String get forgotPasswordBackToLoginAction;
  String get forgotPasswordDialogTitle;
  String get forgotPasswordDialogDescription;
  String get forgotPasswordDialogDoneButton;

  // Account validation messages
  String get invalidCredentials;
  String get loginAccessDenied;
  String get accountAlreadyExists;
  String get loginValidationCpfRequired;
  String get loginValidationInvalidCpf;
  String get loginValidationPasswordRequired;
  String get createAccountValidationInvalidCpf;
  String get createAccountValidationFullNameRequired;
  String get createAccountValidationInvalidEmail;
  String get createAccountValidationInvalidPhone;
  String get createAccountValidationPasswordMin;
  String get createAccountValidationPasswordMismatch;
  String get errorRateLimit;
  String get forgotPasswordValidationCpfRequired;

  // JWT
  String get jwtInvalidToken;
  String jwtDecodeError(Object error);

  // Notices terms
  String get noticesTermsTitle;
  String get noticesTermsDescription;
  String get noticesTermsLocationDeniedPermanently;
  String get noticesTermsLocationDenied;
  String get noticesTermsBottomSheetSearchHelp;
  String get noticesTermsBottomSheetNoResults;
  String get noticesTermsCloseAction;
  String get noticesTermsSearchHint;
  String get noticesTermsSelectYear;
  String get noticesTermsSelectCity;
  String get noticesTermsSelectUnit;
  String get noticesTermsIncompleteFiltersMessage;
  String get noticesTermsNoResultsTitle;
  String get noticesTermsNoResultsMessage;
  String get noticesTermsRegistrationPeriod;
  String get noticesTermsPublishedAtLabel;
  String get noticesTermsLevelLabel;
  String get noticesTermsModalityLabel;
  String get noticesTermsModalityLabel2;
  String get noticesTermsEnrollmentTypeLabel;
  String get noticesTermsViewNoticeAction;
  String get noticesTermsViewAdditiveTermAction;
  String get noticesTermsScholarshipApplication;
  String get noticesTermsScholarshipApplicationDescription;
  String get noticesTermsDocumentTitle;
  String get noticesTermsDocumentNoticeDescription;
  String get noticesTermsDocumentAdditiveTermDescription;
  String get noticesTermsFileNotFound;
  String get noticesStreamError;

  // Onboarding
  String get onboardingItem1Title;
  String get onboardingItem1Description;
  String get onboardingItem2Title;
  String get onboardingItem2Description;
  String get onboardingItem3Title;
  String get onboardingItem3Description;
  String get onboardingItem4Title;
  String get onboardingItem4Description;
  String get onboardingViewNoticesAction;
  String get onboardingNextAction;
  String get onboardingEnterAction;

  // Home
  String get homeWelcome;
  String get homeTitle;
  String get homeSubtitleEmptyProcess;
  String get homeSubtitleProcessInProgress;
  String get homeSubtitleProcessCompleted;
  String get homeRenewScholarshipButton;
  String get homeNewScholarshipButton;
  String get homeImportantTitle;
  String get homeImportantMessage;

  // Process result
  String get approved;
  String get disqualified;
  String get underReview;
  String get pending;

  // Enrollment Status
  String get withoutRegistration;
  String get registered;
  String get inProcess;

  // Process Card
  String get schoolUnit;
  String get course;
  String get processCode;
  String get viewButton;
  String get result;
  String get enrollmentStatus;
  String get administrativeRegion;
  String get processCardNotice;
  String get processCardNoticeSentence;
  String get processCardAddendumSentence;
  String get processCardLevel;
  String get processCardScholarshipType;
  String get processCardProcessType;
  String get processCardStep;
  String get processCardCandidateSingular;
  String get processCardCandidatePlural;
  String get processCardParticipatingEducationalUnits;
  String get processCardDetaiButton;
  String get processCardApplyForAScholarshipButton;

  // Process Card Banners
  String get processCardBannerAttention;
  String get processCardBannerPendindDocumentsSingular;
  String get processCardBannerPendindDocumentsPlural;

  // Process Steps
  String get processStepsInitial;
  String get processStepsSecond;
  String get processStepsThird;
  String get processStepsVerification;
  String get processStepsFifth;
  String get processStepsCompleted;

  // Processes Type
  String get newProcess;
  String get renewProcess;

  // End Drawer
  String get endDrawerTitle;
  String get endDrawerHomeLabel;
  String get endDrawerNoticesLabel;
  String get endDrawerProfileLabel;
  String get endDrawerLogoutLabel;

  // Nav Bar
  String get navBarHomeLabel;
  String get navBarNoticesLabel;
  String get navBarProfileLabel;

  // PDF Viewer
  String get pdfViewerErrorToLoadArchive;

  // Profile Page
  String get profileMyDataTitle;
  String get profileMyDataSubtitle;
  String get profileMyDataName;
  String get profileMyDataEmail;
  String get profileMyDataPhone;
  String get profileMyDataSaveButton;
  String get profileSaveSuccessTitle;
  String get profileSaveSuccessDescription;
  String get profileSaveSuccessDoneButton;
  String get profileEmailChangedTitle;
  String get profileEmailChangedDescription;
  String get profileEmailChangedDoneButton;
  String get profileSaveSuccess;
  String get profileChangePasswordTitle;
  String get profileChangePasswordSubtitle;
  String get profileChangePasswordNewPassword;
  String get profileChangePasswordConfirmNewPassword;
  String get profileChangePasswordButton;

  // New Request (Nova Solicitação) strings
  String get newScholarshipTitle;
  String get newScholarshipSubtitle;
  String get newScholarshipDescription;
  String get newScholarshipShowExpired;
  String get newScholarshipDialogTitle;
  String get newScholarshipDialogDescription;
  String get newScholarshipDialogCancel;
  String get newScholarshipDialogContinue;
  String get finishAction;

  // Housing step
  String get housingStepResidenceTitle;
  String get housingStepResidenceDescription;
  String get addressCepLabel;
  String get addressNumberLabel;
  String get addressComplementLabel;
  String get addressLabel;
  String get addressNeighborhoodLabel;
  String get addressCityLabel;
  String get addressStateLabel;
  String get housingTitle;
  String get housingAreaQuestion;
  String get housingAreaUrban;
  String get housingAreaRural;
  String get housingAreaVulnerability;
  String get housingGroupQuestion;
  String get housingTypeHint;
  String get housingTypeAlugada;
  String get housingTypeCedida;
  String get housingTypeFinanciada;
  String get housingTypePropria;
  String get addFamilyMember;
  String get peopleHomeLabel;
  String get familyStepDescriptionPrefix;
  String get familyStepDescriptionEmphasis;
  String get familyStepDescriptionSuffix;

  // Family info bottom sheet
  String get familyInfoGroupTitle;
  String get familyInfoGroupDescription;
  String get familyInfoIncomeTitle;
  String get familyInfoIncomeDescription;
  String get familyInfoKinshipTitle;
  String get familyInfoKinshipDescription;
  String get familyInfoCloseButton;

  // Member registration (family) step
  String get memberRegistrationAppBarTitle;
  String get memberRegistrationTitle;
  String get memberRegistrationDescription;
  String get personalDataTitle;
  String get dobLabel;
  String get genderLabel;
  String get responsibleLabel;
  String get maritalStatusLabel;
  String get receivesPensionQuestion;
  String get isRetiredQuestion;
  String get willApplyScholarshipQuestion;
  String get nationalityLabel;
  String get naturalizedQuestion;
  String get concessionBannerTitle;
  String get concessionBannerMessage;
  String get hasCINQuestion;
  String get rgLabel;
  String get issuingOrgLabel;
  String get hasCadunicoQuestion;
  String get nisLabel;
  String get hasChronicDiseaseQuestion;
  String get diseaseTypeLabel;
  String get pcdLabel;
  String get irpfConditionLabel;
  String get irpfDeclarante;
  String get irpfIsento;
  String get declaredThisYearQuestion;
  String get hasWorkCardQuestion;
  String get ruralWorkerQuestion;
  String get dataComplementTitle;
  String get complementFieldsPlaceholder;
  String get documentsTitle;
  String get documentsPlaceholder;
  String get concludeAction;
  String get answerYes;
  String get answerNo;
}
