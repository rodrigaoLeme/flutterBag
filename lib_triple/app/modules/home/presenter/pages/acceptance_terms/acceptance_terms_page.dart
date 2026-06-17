import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart' as triple;
import 'package:localization/localization.dart';

import '../../../../../core/widgets/alternative_rounded_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_scaffold.dart';
import '../select_group/stores/usecases/finish_sending_documents/store.dart'
    as finish_sending_documents;
import 'acceptance_terms_controller.dart';

class AcceptanceTermsPage extends StatefulWidget {
  const AcceptanceTermsPage({Key? key}) : super(key: key);

  @override
  State<AcceptanceTermsPage> createState() => _AcceptanceTermsPageState();
}

class _AcceptanceTermsPageState extends State<AcceptanceTermsPage> {
  final controller = Modular.get<AcceptanceTermsController>();
  bool _acceptedTerms = false;
  triple.Disposer? _finishObserver;

  @override
  void initState() {
    super.initState();
    _startObservingFinish();
  }

  void _startObservingFinish() {
    _finishObserver = controller.finishSendingDocumentsStore.observer(
      onError: (error) => _showSnackBar(error.toString()),
      onState: (state) {
        if (state.response) {
          Modular.to.pop(true);
        }
      },
    );
  }

  @override
  void dispose() {
    _finishObserver?.call();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onBack() async {
    await controller.revertToStepFour();
    Modular.to.pop(false);
  }

  void _onFinalize() {
    _showPasswordModal();
  }

  void _showPasswordModal() {
    final passwordController = TextEditingController();
    bool obscure = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text('acceptance_terms_password_modal_title'.i18n()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('acceptance_terms_password_modal_description'.i18n()),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: 'acceptance_terms_password_label'.i18n(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () => setModalState(() => obscure = !obscure),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                passwordController.dispose();
                Navigator.of(context).pop();
              },
              child: Text('acceptance_terms_password_cancel'.i18n()),
            ),
            triple.ScopedBuilder<
                finish_sending_documents.Store,
                finish_sending_documents.UsecaseException,
                finish_sending_documents.Entity>(
              store: controller.finishSendingDocumentsStore,
              onLoading: (_) => const CircularProgressIndicator(),
              onState: (context, state) => TextButton(
                onPressed: () {
                  final password = passwordController.text.trim();
                  if (password.isEmpty) return;
                  Navigator.of(context).pop();
                  controller.finish(
                    password: password,
                    acceptedTerms: _acceptedTerms,
                  );
                },
                child: Text('acceptance_terms_password_confirm'.i18n()),
              ),
              onError: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: Text('acceptance_terms_title'.i18n()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _onBack,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'acceptance_terms_content'.i18n(),
                    style: const TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          // Checkbox + botões fixos no rodapé
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (v) =>
                          setState(() => _acceptedTerms = v ?? false),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _acceptedTerms = !_acceptedTerms),
                        child: Text(
                          'acceptance_terms_checkbox_label'.i18n(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AlternativeRoundedButton(
                        label: 'acceptance_terms_back_button'.i18n(),
                        onTap: _onBack,
                        labelColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AlternativeRoundedButton(
                        label: 'acceptance_terms_finalize_button'.i18n(),
                        onTap: _acceptedTerms ? _onFinalize : null,
                        labelColor: _acceptedTerms ? null : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
