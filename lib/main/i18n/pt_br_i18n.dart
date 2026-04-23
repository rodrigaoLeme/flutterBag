import 'app_i18n.dart';

class PtBrI18n implements AppI18n {
  const PtBrI18n();

  @override
  String get appTitle => 'e-Bolsa';

  @override
  String get appNameDev => 'e-BolsaDev';

  @override
  String get appNameProd => 'e-Bolsa';

  @override
  String get errorNoInternet => 'Sem conexão com a internet.';

  @override
  String get errorTimeout => 'Tempo de conexão esgotado.';

  @override
  String get errorUnexpected => 'Erro inesperado. Tente novamente.';

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

  @override
  String get loginPasswordHint => 'Digite sua senha';

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
  String get createAccountPasswordHint => 'Mínimo 8 caracteres';

  @override
  String get createAccountConfirmPasswordLabel => 'Confirmar senha';

  @override
  String get createAccountConfirmPasswordHint => 'Repita sua senha';

  @override
  String get createAccountNextAction => 'Avançar';

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
  String get invalidCredentials => 'CPF/CNPJ, e-mail ou senha incorretos.';

  @override
  String get accountAlreadyExists =>
      'Já existe uma conta com esse e-mail ou CPF.';

  @override
  String get loginValidationCpfRequired => 'Informe seu CPF';

  @override
  String get loginValidationPasswordRequired => 'Informe sua senha.';

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
      'A senha deve ter no mínimo 8 caracteres.';

  @override
  String get createAccountValidationPasswordMismatch =>
      'As senhas não conferem.';

  @override
  String get forgotPasswordValidationCpfRequired =>
      'Informe seu CPF cadastrado.';

  @override
  String get jwtInvalidToken => 'Token inválido.';

  @override
  String jwtDecodeError(Object error) => 'Erro ao decodificar JWT: $error';
}
