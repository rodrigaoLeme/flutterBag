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
  String get accountAlreadyExists;
  String get loginValidationCpfRequired;
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
  String get noticesTermsNoResultsMessage;
  String get noticesTermsPublishedAtLabel;
  String get noticesTermsModalityLabel;
  String get noticesTermsEnrollmentTypeLabel;
  String get noticesTermsViewNoticeAction;
  String get noticesTermsViewAdditiveTermAction;
  String get noticesTermsDocumentTitle;
  String get noticesTermsDocumentNoticeDescription;
  String get noticesTermsDocumentAdditiveTermDescription;
  String get noticesTermsDocumentDevMessage;
}
