import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main/i18n/app_i18n.dart';
import '../../../main/routes/auth_routes.dart';
import '../../components/components.dart';
import '../../helpers/themes/themes.dart';
import 'auth_presenter.dart';
import 'auth_view_model.dart';

class TermsPage extends StatefulWidget {
  final CreateAccountPresenter presenter;

  const TermsPage({super.key, required this.presenter});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool _acceptedTerms = false;
  bool _agreeEBolsa = false;
  late StreamSubscription<AuthViewModel?> _viewModelSubscription;

  bool get _canConfirm => _acceptedTerms && _agreeEBolsa;

  final ScrollController _myScrollController = ScrollController();

  final MarkdownBody _termosTexto = MarkdownBody(
    data: AppI18n.current.termsContent,
    onTapLink: (text, href, title) async {
      if (href != null) {
        final uri = Uri.parse(href);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    },
    styleSheet: MarkdownStyleSheet(
      strong: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  @override
  void initState() {
    super.initState();
    _viewModelSubscription = widget.presenter.viewModel.listen((vm) {
      if (vm == null) return;
      if (vm.isSuccess) {
        Modular.to.navigate(AuthRoutes.createdAccount);
      }
    });
  }

  @override
  void dispose() {
    _viewModelSubscription.cancel();
    super.dispose();
  }

  void _onConfirm() {
    FocusScope.of(context).unfocus();
    widget.presenter.confirmAccount();
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: StreamBuilder<AuthViewModel?>(
            stream: widget.presenter.viewModel,
            initialData: const AuthViewModel.initial(),
            builder: (context, snapshot) {
              final vm = snapshot.data ?? const AuthViewModel.initial();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
                    child: Text(
                      appStrings.termsPageTitle,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        platform: TargetPlatform.android,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Scrollbar(
                          controller: _myScrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _myScrollController,
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                            child: _termosTexto,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (vm.errorMessage != null)
                          EbolsaErrorBanner(message: vm.errorMessage!),
                        EbolsaCheckboxItem(
                          value: _acceptedTerms,
                          label: appStrings.termsReadAndAccept,
                          enabled: !vm.isLoading,
                          onChanged: (v) =>
                              setState(() => _acceptedTerms = v ?? false),
                        ),
                        EbolsaCheckboxItem(
                          value: _agreeEBolsa,
                          label: appStrings.termsAgreeUse,
                          enabled: !vm.isLoading,
                          onChanged: (v) =>
                              setState(() => _agreeEBolsa = v ?? false),
                        ),
                        const SizedBox(height: 24),
                        EbolsaLoadingButton(
                          onPressed: _canConfirm ? _onConfirm : null,
                          isLoading: vm.isLoading,
                          label: appStrings.termsConfirm,
                        ),
                      ],
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
