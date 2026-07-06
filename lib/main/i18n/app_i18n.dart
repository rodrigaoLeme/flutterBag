import 'pt_br_i18n.dart';

abstract class AppI18n {
  static AppI18n current = const PtBrI18n();

  // App
  String get appTitle;
  String get appNameDev;

  // Common errors
  String get errorNoInternet;
  String get errorTimeout;
  String get errorUnexpected;

  // Common Messages
  String get tryAgain;

  // Shared labels (deduplicated)
  String get typeLabel;
  String get attentionLabel;
  String get confirmAction;
  String get continueAction;
  String get noticesLabel;
  String get noticeLabel;
  String get homeLabel;
  String get housingLabel;
  String get occupationTitle;
  String get profileLabel;
  String get scholarshipApplicationTitle;
  String get scholarshipTypeLabel;
  String get enrollmentTypeLabel;
  String get installmentValueLabel;
  String get assetValueLabel;
  String get valueDisplayLabel;
  String get okAction;

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
  String get createdAccountPageTitle;
  String get createdAccountSuccessTitle;
  String get createdAccountSuccessDescription;
  String get createdAccountDoneButton;
  String get createAccountDialogDescription;
  String get createAccountDialogDoneButton;

  // Forgot password
  String get forgotPasswordHeader;
  String get forgotPasswordDescription;
  String get forgotPasswordHelpText;
  String get forgotPasswordSuccessTitle;
  String get forgotPasswordSuccessDescription;
  String get forgotPasswordBackToLoginAction;
  String get forgotPasswordDialogTitle;
  String get forgotPasswordDialogDescription;

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
  String get noticesTermsViewNoticeAction;
  String get noticesTermsViewAdditiveTermAction;
  String get noticesTermsScholarshipApplicationDescription;
  String get noticesTermsDocumentTitle;
  String get noticesTermsDocumentNoticeDescription;
  String get noticesTermsDocumentAdditiveTermDescription;
  String get noticesTermsFileNotFound;
  String get noticesStreamError;

  // Onboarding
  String get onboardingItem1Description;
  String get onboardingItem2Title;
  String get onboardingItem2Description;
  String get onboardingItem3Title;
  String get onboardingItem3Description;
  String get onboardingItem4Title;
  String get onboardingItem4Description;
  String get onboardingViewNoticesAction;
  String get onboardingNextAction;

  // Home
  String get homeWelcome;
  String get homeTitle;
  String get homeSubtitleEmptyProcess;
  String get homeSubtitleProcessInProgress;
  String get homeSubtitleProcessCompleted;
  String get homeRenewScholarshipButton;
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
  String get processCardAddendumSentence;
  String get processCardLevel;
  String get processCardScholarshipType;
  String get processCardProcessType;
  String get processCardStep;
  String get processCardCandidatePlural;
  String get processCardParticipatingEducationalUnits;
  String get processCardDetaiButton;
  String get processCardApplyForAScholarshipButton;

  // Process Card Banners
  String get processCardBannerRegisterEnd;
  String get processCardBannerPendindDocumentsSingular;
  String get processCardBannerPendindDocumentsPlural;

  // Process Detail
  String get processDetailTitle;
  String get processDetailDeadlines;
  String get processDetailCandidates;
  String get processDetailNoticesAndTerms;
  String get processDetailDeclarationModels;
  String get processDetailCancelSubscription;

  // Process Deadlines
  String get processDeadLinesTitle;
  String get processDeadlinesSubtitle;
  String get processDeadlinesRegisterStart;
  String get processDeadlinesRegisterEnd;
  String get processDeadlinesDocumentationUpload;
  String get processDeadlinesDocumentationReturn;
  String get processDeadlinesResultRelease;

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

  // Result Status
  String get resultStatusAnalysis;
  String get resultStatusApproved50;
  String get resultStatusApproved100;
  String get resultStatusRejected;
  String get resultStatusDisqualified;
  String get resultStatusWaitingList;

  // Registration Status
  String get registrationStatusNoRegistration;
  String get registrationStatusReserveSpot;
  String get registrationStatusRegistered;
  String get registrationStatusCompleted;
  String get registrationStatusLocked;
  String get registrationStatusWithdrawal;
  String get registrationStatusCanceled;
  String get registrationStatusAwaitingApproval;
  String get registrationStatusTransferred;

  // Process Candidates
  String get processCandidatesTitle;
  String get processCandidatesSubtitle;

  // Process Notices and Terms
  String get processTermsAndNoticesTitle;
  String get processTermsAndNoticesSubtitle;

  // Templates (declaration models)
  String get processDeclarationModelsTitle;
  String get processDeclarationModelsSubtitle;

  // Danger Zone - Cancel Subscription
  String get processCancelDialogTitle;
  String get processCancelDialogDescription;
  String get processCancelDialogConfirm;
  String get processCancelDialogDeny;
  String get processCancelReasonDialogTitle;
  String get processCancelReasonDialogHint;
  String get processCancelReasonDialogConfirm;

  // End Drawer
  String get endDrawerTitle;
  String get endDrawerLogoutLabel;

  // Nav Bar

  // PDF Viewer
  String get pdfViewerErrorToLoadArchive;

  // Profile Page
  String get profileMyDataTitle;
  String get profileMyDataSubtitle;
  String get profileMyDataName;
  String get profileMyDataPhone;
  String get profileMyDataSaveButton;
  String get profileSaveSuccessTitle;
  String get profileSaveSuccessDescription;
  String get profileEmailChangedDescription;
  String get profileEmailChangedDoneButton;
  String get profileSaveSuccess;
  String get profileChangePasswordTitle;
  String get profileChangePasswordSubtitle;
  String get profileChangePasswordNewPassword;
  String get profileChangePasswordConfirmNewPassword;

  // New Request (Nova Solicitação) strings
  String get newScholarshipSubtitle;
  String get newScholarshipDescription;
  String get newScholarshipShowExpired;
  String get newScholarshipDialogDescription;
  String get newScholarshipDialogCancel;
  String get finishAction;

  // Steps - Erros de domínio
  String get errorPersonNotFound;
  String get errorProcessPeriodInvalid;
  String get fieldRequired;

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
  String get housingAreaQuestion;
  String get housingAreaUrban;
  String get housingAreaRural;
  String get housingAreaVulnerability;
  String get housingGroupQuestion;
  String get housingTypeAlugada;
  String get housingTypeCedida;
  String get housingTypeFinanciada;
  String get housingTypePropria;
  String get addFamilyMember;
  String get peopleHomeLabel;
  String get familyStepDescriptionPrefix;
  String get familyStepDescriptionEmphasis;
  String get familyStepDescriptionSuffix;
  String get candidateStepTitle;
  String get candidateStepDescriptionPrefix;
  String get candidateStepDescriptionEmphasis;
  String get candidateStepDescriptionSuffix;
  String get addCandidate;
  String get noCandidatesRegistered;
  String get selectCandidateLabel;
  String get guardianRelationshipLabel;
  String get unitOfInterestLabel;
  String intendedCourseLabel(int year);
  String get guardianRelationshipFather;
  String get guardianRelationshipMother;
  String get guardianRelationshipGuardianship;
  String get addCandidateAction;
  String get candidateDeleteDialogTitle;
  String candidateDeleteDialogMessage(String name);
  String get candidateMissingDialogIntro;
  String get candidateAwareDialogBullet1;
  String get candidateAwareDialogBullet2;
  String get zipCodeNotFound;
  String get zipCodeInvalid;
  String get enrollmentStep1ValidationError;

  // Family info bottom sheet
  String get familyInfoGroupTitle;
  String get familyInfoGroupDescription;
  String get familyInfoIncomeTitle;
  String get familyInfoIncomeDescription;
  String get familyInfoKinshipTitle;
  String get familyInfoKinshipDescription;

  // Member registration (family) step
  String get memberRegistrationAppBarTitle;
  String get memberRegistrationTitle;
  String get memberRegistrationDescription;
  String get personalDataTitle;
  String get occupationStepDescription;
  String get childSupportIncomeQuestion;
  String get privatePensionQuestion;
  String get inssBenefitQuestion;
  String get childSupportInfoDialogBody1;
  String get childSupportInfoDialogBody2;
  String get childSupportInfoDialogBody3;
  String get childSupportInfoDialogBody4;
  String get inssBenefitInfoDialogBody1;
  String get inssBenefitInfoDialogBody2;
  String get familyMembersSubStepNavTitle;
  String get otherIncomeSubStepNavTitle;
  String get otherIncomeStepTitle;
  String get otherIncomeStepDescription;
  String get rentedPropertyIncomeQuestion;
  String get financialHelpQuestion;
  String get financialHelpNone;
  String get financialHelpFamily;
  String get financialHelpOther;
  String get governmentProgramQuestion;
  String get informValueInReaisLabel;
  String get financialHelpFromWhomLabel;
  String get informGovernmentProgramLabel;
  String get assetsRelationSubStepNavTitle;
  String get ownsPropertyQuestion;
  String get ownsFinancialInvestmentQuestion;
  String get ownsVehicleQuestion;
  String get ownsVehicleSubtitle;
  String get addPropertyAction;
  String get ownPropertyPageTitle;
  String get ownPropertyPageDescription;
  String get savePropertyAction;
  String get propertyFinancingValueLabel;
  String get propertyAssetValueDisplayLabel;
  String get addInvestmentAction;
  String get financialInvestmentPageTitle;
  String get financialInvestmentPageDescription;
  String get saveInvestmentAction;
  String get addVehicleAction;
  String get vehiclePageTitle;
  String get vehiclePageDescription;
  String get vehicleBrandLabel;
  String get vehicleModelLabel;
  String get vehicleYearLabel;
  String get vehicleFinancingInstallmentLabel;
  String get saveVehicleAction;
  String get vehicleYearDisplayLabel;
  String get vehicleInstallmentDisplayLabel;
  String get summarySubStepNavTitle;
  String get summaryStepDescription;
  String get grossFamilyIncomeLabel;
  String get incomeDependentsLabel;
  String get perCapitaIncomeLabel;
  String get minimumWageLabel;
  String get perCapitaTimesMinimumWageLabel;
  String get salaryRatioSuffix;
  String get summaryAdvanceDialogBody1;
  String get summaryAdvanceDialogBody2;
  String get summaryAdvanceDialogQuestion;
  String get summaryAdvanceDialogConfirm;
  String get expensesStepTitle;
  String get expensesStepDescription;
  String get expensesFoodSubStepNavTitle;
  String get expenseFoodValueLabel;
  String get expenseFoodHelper;
  String get expensesHealthSubStepNavTitle;
  String get expenseHealthPlanValueLabel;
  String get expenseHealthPlanHelper;
  String get expenseChronicDiseaseValueLabel;
  String get expenseChronicDiseaseHelper;
  String get expenseChronicDiseaseDialogBody;
  String get expenseOtherHealthServicesValueLabel;
  String get expenseOtherHealthServicesSpecifyLabel;
  String get expensesEducationSubStepNavTitle;
  String get expenseHasEducationCostsQuestion;
  String get expenseSchoolTransportQuestion;
  String get expenseSchoolTransportNaoUtiliza;
  String get expenseSchoolTransportPagoFretado;
  String get expenseSchoolTransportProprioCombustivel;
  String get expenseSchoolTransportPublico;
  String get expenseEducationValueLabel;
  String get addEducationExpenseAction;
  String get educationExpensePageDescription;
  String get expenseEducationTypeBasic;
  String get expenseEducationTypeHigher;
  String get expenseEducationTypeLanguage;
  String get expenseEducationTypeOther;
  String get expenseEducationForWhomLabel;
  String get expenseEducationInstitutionLabel;
  String get expenseEducationMonthlyValueLabel;
  String get saveEducationExpenseAction;
  String get expenseEducationForWhomDisplayLabel;
  String get expenseEducationWhereDisplayLabel;
  String get expenseEducationCostsRequiredError;
  String get expenseSchoolTransportRequiredError;
  String get expensesAutomobileSubStepNavTitle;
  String get expenseIpvaLabel;
  String get expenseCarInsuranceLabel;
  String get expenseVehicleFinancingLabel;
  String get expensesLoansSubStepNavTitle;
  String get expenseBankLoansLabel;
  String get expenseBankLoansHelper;
  String get expenseLoansOtherServicesLabel;
  String get expenseLoansOtherServicesHelper;
  String get expenseLoansOtherServicesDescribeLabel;
  String get expenseRentValueLabel;
  String get expenseFinancingValueLabel;
  String get expenseIptuValueLabel;
  String get expenseIptuHelper;
  String get expenseCondoValueLabel;
  String get expenseElectricityValueLabel;
  String get expenseWaterValueLabel;
  String get expenseGasValueLabel;
  String get expensePhoneInternetValueLabel;
  String get expensePhoneInternetHelper;
  String get familyConfirmDialogTitle;
  String get familyConfirmDialogBodyEmphasis1;
  String get familyConfirmDialogBodyMiddle;
  String get familyConfirmDialogBodyEmphasis2;
  String get familyConfirmDialogBodySuffix;
  String get familyConfirmDialogMembersIntro;
  String get familyConfirmDialogQuestion;
  String get familyConfirmDialogReview;
  String get familyConfirmDialogContinue;
  String get scholarshipCandidateTag;
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
  String get documentsStepTitle;
  String get documentsStepDescription;
  String documentsDeadlineLabel(String date);
  String documentsProgressLabel(int uploaded, int total);
  String get documentsSendAllAction;
  String get concludeAction;
  String get answerYes;
  String get answerNo;
}
