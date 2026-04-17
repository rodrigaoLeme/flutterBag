import '../helpers.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
  emailInUse,
  offLineMode,
  invalidEmail,
  invalidPassword,
  codeInvalid,
  notFound,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return R.string.msgRequiredField; //CAMPO OBRIGATORIO
      case UIError.invalidField:
        return R.string.incorrectPassword; //senha invalida.
      case UIError.invalidCredentials:
        return R.string
            .msgInvalidCredentials; //'E-mail ou senha incorretos. Por favor, tente novamente.';
      case UIError.emailInUse:
        return R.string.msgEmailInUse; //O e-mail já está em uso.
      case UIError.offLineMode:
        return R.string.noConnectionsAvailable; //""
      case UIError.invalidEmail:
        return R.string.msgInvalidField; //E-mail inválido
      case UIError.invalidPassword:
        return R.string.passwordNotMatch; //As senhas não coincidem
      case UIError.codeInvalid:
        return R.string.codeBaseInvalid; //Código da base inválido.
      default:
        return R.string
            .msgUnexpectedError; //'Falha ao carregar informações. Por favor, tente novamente em breve.';
    }
  }
}
