import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart' as triple;
import 'package:localization/localization.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_rounded_button.dart';
import '../../../../../core/widgets/custom_scaffold.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../design_system/design_system_page.dart';
import 'stores/usecases/forgot_password/store.dart' as forgot_password;
import 'package:firebase_analytics/firebase_analytics.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final store = Modular.get<forgot_password.Store>();

  final idMask = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  String id = '';
  String? idError;
  late final FocusNode idNode;

  late final String globalUserId;
  late final String h1;
  late final String h2;
  late final String userIdLabel;
  late final String sendLabel;
  late final String emptyIdExceptionMessage;

  String getLocalization(String attribute, {List<String>? params}) {
    return 'forgot_password_$attribute'.i18n(params ?? []);
  }

  void initLocalizedStrings() {
    globalUserId = 'global_id'.i18n();
    h1 = getLocalization('h1');
    h2 = getLocalization('h2', params: [globalUserId]);
    userIdLabel = getLocalization('user_id', params: [globalUserId]);
    sendLabel = getLocalization('send');
    emptyIdExceptionMessage = getLocalization('empty_id_exception_message');
  }

  @override
  void initState() {
    super.initState();
    idNode = FocusNode()..requestFocus();
    FirebaseAnalytics.instance.logEvent(name: 'Forgot_Password');
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'Forgot_Password');
    initLocalizedStrings();
  }

  void validateId() {
    idError = id.isEmpty ? emptyIdExceptionMessage : null;
  }

  bool get isButtonEnabled => CPFValidator.isValid(id);

  void sendNewPasswordRequest() {
    if (idError == null) {
      store(forgot_password.Params(id: idMask.getUnmaskedText()));
    }
  }

  @override
  void dispose() {
    store.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final disabledColor = Theme.of(context).disabledColor;
    return triple.ScopedBuilder<forgot_password.Store, forgot_password.UsecaseException, forgot_password.Entity>(
      store: store,
      onError: (context, exception) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(exception.toString()),
        ),
      ),
      onLoading: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
      onState: (context, state) => CustomScaffold(
        appBar: const CustomAppBar(),
        body: state.obfuscatedEmail.isNotEmpty
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Email enviado para:',
                    ),
                    Text(
                      state.obfuscatedEmail,
                      style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 33),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      h1,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        h2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF6B6B6B),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    CustomTextField(
                      focusNode: idNode,
                      onChanged: (value) {
                        id = value;
                        setState(validateId);
                      },
                      label: userIdLabel,
                      labelColor: accentColor,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        idMask,
                      ],
                      errorText: idError,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    CustomRoundedButton(
                      backgroundColor: isButtonEnabled ? primaryColor : disabledColor,
                      label: sendLabel,
                      labelColor: secondaryColor,
                      onTap: isButtonEnabled
                          ? () {
                              sendNewPasswordRequest();
                            }
                          : null,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
