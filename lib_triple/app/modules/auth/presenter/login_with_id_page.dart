import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:localization/localization.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:upgrader/upgrader.dart';

import '../../../core/widgets/custom_rounded_button.dart';
import '../../../core/widgets/custom_text_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../domain/usecases/login_with_id/params.dart';
import 'store/login_with_id_store.dart';
import 'store/login_with_id_store_error.dart';
import 'store/login_with_id_store_state.dart';

class LoginWithIdPage extends StatefulWidget {
  const LoginWithIdPage({Key? key}) : super(key: key);

  @override
  State<LoginWithIdPage> createState() => _LoginWithIdPageState();
}

class _LoginWithIdPageState extends State<LoginWithIdPage> {
  final LoginWithIdStore store = Modular.get();
  final idMask = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  late final FocusNode idNode;
  late final FocusNode passwordNode;
  late final FocusNode enterButtonNode;

  late final String globalUserId;
  late final String appName;
  late final String userIdLabel;
  late final String passwordLabel;
  late final String forgotPasswordLabel;
  late final String enterButtonLabel;
  late final String emptyIdExceptionMessage;
  late final String emptyPasswordExceptionMessage;

  String getLocalization(String attribute, {List<String>? params}) {
    return 'login_with_id_$attribute'.i18n(params ?? []);
  }

  void initLocalizedStrings() {
    globalUserId = 'global_id'.i18n();
    appName = getLocalization('app_name');
    userIdLabel = getLocalization('user_id', params: [globalUserId]);
    passwordLabel = getLocalization('password');
    forgotPasswordLabel = getLocalization('forgot_password');
    enterButtonLabel = getLocalization('enter');
    emptyIdExceptionMessage = getLocalization('empty_id_exception_message');
    emptyPasswordExceptionMessage =
        getLocalization('empty_password_exception_message');
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.logEvent(name: 'Login_Page');
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'Login_Page');
    idNode = FocusNode()..requestFocus();
    passwordNode = FocusNode();
    enterButtonNode = FocusNode();

    initLocalizedStrings();

    const storage = FlutterSecureStorage();

    debugPrint("Init email: ${storage.read(key: "EBOLSA-EMAILADDRESS")}");
    debugPrint("Init device: ${storage.read(key: "EBOLSA-DEVICE-CODE")}");

    store.observer(onError: (error) {
      setState(() {
        idError = error.idFieldError;
        passwordError = error.passwordFieldError;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.authError ?? 'Não foi possível entrar no app')));
    });
  }

  @override
  void dispose() {
    idNode.dispose();
    passwordNode.dispose();
    enterButtonNode.dispose();
    super.dispose();
  }

  String id = '';
  String password = '';

  String? idError;
  String? passwordError;

  void validatePassword() {
    passwordError = password.isEmpty ? emptyPasswordExceptionMessage : null;
  }

  void validateId() {
    idError = id.isEmpty ? emptyIdExceptionMessage : null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final secondaryColor = colorScheme.secondary;
    final mediaQuery = MediaQuery.of(context);
    final isKeyboardOpened = mediaQuery.viewInsets.bottom > 0.0;
    final size = mediaQuery.size;

    final smallSizedBoxHeight = size.height * 0.02;
    final midSizedBoxHeight = size.height * 0.04;
    final largeSizedBoxHeight = size.height * 0.06;

    return UpgradeAlert(
      dialogStyle: Platform.isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      upgrader: Upgrader(durationUntilAlertAgain: Duration.zero),
      showIgnore: false,
      showLater: false,
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/app/core/temporary_assets/logo_v4.png',
                cacheHeight: 720,
                cacheWidth: 720,
                width: 80,
                height: 80,
              ),
              SizedBox(
                  height: smallSizedBoxHeight -
                      (isKeyboardOpened ? (smallSizedBoxHeight * 1) : 0.0)),
              Text(
                appName,
                style: TextStyle(
                  fontSize: 32,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                  height: largeSizedBoxHeight -
                      (isKeyboardOpened ? (largeSizedBoxHeight * 1) : 0.0)),
              StatefulBuilder(
                builder: (context, setState) => CustomTextField(
                  focusNode: idNode,
                  onChanged: (value) {
                    id = value;
                    setState(validateId);
                  },
                  label: userIdLabel,
                  labelColor: primaryColor,
                  onEditingComplete: passwordNode.requestFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [idMask],
                  errorText: idError,
                ),
              ),
              SizedBox(
                  height: midSizedBoxHeight -
                      (isKeyboardOpened ? (midSizedBoxHeight * 0.75) : 0.0)),
              StatefulBuilder(
                builder: (context, setState) => CustomTextField(
                  focusNode: passwordNode,
                  onChanged: (value) {
                    password = value;
                    setState(validatePassword);
                  },
                  label: passwordLabel,
                  labelColor: primaryColor,
                  isSecret: true,
                  onEditingComplete: enterButtonNode.requestFocus,
                  errorText: passwordError,
                ),
              ),
              SizedBox(
                  height: midSizedBoxHeight -
                      (isKeyboardOpened ? (midSizedBoxHeight * 1) : 0.0)),
              CustomTextButton(
                onTap: () {
                  Modular.to.pushNamed('forgot_password');
                },
                label: forgotPasswordLabel,
                labelColor: primaryColor,
              ),
              SizedBox(
                  height: midSizedBoxHeight -
                      (isKeyboardOpened ? (midSizedBoxHeight * 1) : 0)),
              TripleBuilder<LoginWithIdStore, LoginWithIdStoreError,
                      LoginWithIdStoreState>(
                  store: store,
                  builder: (context, tripleStore) {
                    return CustomRoundedButton(
                      focusNode: enterButtonNode,
                      backgroundColor: primaryColor,
                      label: enterButtonLabel,
                      labelColor: secondaryColor,
                      onTap: () async {
                        idNode.unfocus();
                        passwordNode.unfocus();
                        await store.login(LoginWithIdParams(
                            idMask.getUnmaskedText(), password.trim()));
                      },
                    );
                  }),
              if (kDebugMode && !isKeyboardOpened)
                ElevatedButton(
                  onPressed: () {
                    Modular.to.pushNamed('../ds');
                  },
                  child: const Text('Go to design system'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
