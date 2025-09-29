import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../../../core/icons/ebolsas_icons_icons.dart';
import '../../../../core/widgets/alternative_rounded_button.dart';
import '../../../../core/widgets/background_icon.dart';
import '../../../../core/widgets/custom_step.dart';
import '../../../../core/widgets/custom_stepper.dart';
import '../../../design_system/design_system_page.dart';
import '../../domain/usecases/get_scholarship_by_period/entity.dart'
    as scholarship;
import '../declassificaton_messages.dart';

class BaseStepper extends StatelessWidget {
  final Widget child;
  const BaseStepper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: child,
    );
  }
}

class NotFinishedScholarshipStepper extends StatelessWidget {
  const NotFinishedScholarshipStepper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseStepper(
      child: CustomStepper(
        physics: const NeverScrollableScrollPhysics(),
        margin: EdgeInsets.zero,
        controlsBuilder: (context, details) => const SizedBox(),
        titleTextStyle: const TextStyle(fontSize: 16),
        steps: [
          CustomStep(
            //TODO(adbysantos) Ícone a ser mostrado quando o usuário ainda não finalizou o cadastro
            icon: Icon(EbolsasIcons.check,
                size: 40, color: Theme.of(context).disabledColor),
            title: const Text('Cadastro'),
            state: StepState.disabled,
          ),
          CustomStep(
            icon: Icon(EbolsasIcons.warning,
                size: 40, color: Theme.of(context).disabledColor),
            title: const Text('Envio de documentação'),
            state: StepState.disabled,
          ),
          _disabledReviewStep,
          _disabledAnalysisStep,
          _disabledResultStep,
        ],
      ),
    );
  }
}

class WaitingForCompletionStepper extends StatelessWidget {
  const WaitingForCompletionStepper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseStepper(
      child: CustomStepper(
        physics: const NeverScrollableScrollPhysics(),
        margin: EdgeInsets.zero,
        controlsBuilder: (context, details) => const SizedBox(),
        titleTextStyle: const TextStyle(fontSize: 16),
        steps: [
          const CustomStep(
            //TODO(adbysantos) Ícone a ser mostrado quando o usuário ainda não finalizou o cadastro
            icon: _clockIcon,
            title: Text(
              'Cadastro',
              style: _waitingTextStyle,
            ),
          ),
          CustomStep(
            icon: Icon(EbolsasIcons.warning,
                size: 40, color: Theme.of(context).disabledColor),
            title: const Text('Envio de documentação'),
            state: StepState.disabled,
          ),
          _disabledReviewStep,
          _disabledAnalysisStep,
          _disabledResultStep,
        ],
      ),
    );
  }
}

class SendDocumentationScholarshipStepper extends StatelessWidget {
  final DateTime documentationUploadDeadline;
  final bool isAuthorizedToSendAfterDeadline;
  final int declassification;
  final void Function() onTapSendDocuments;
  const SendDocumentationScholarshipStepper({
    Key? key,
    required this.onTapSendDocuments,
    required this.documentationUploadDeadline,
    required this.isAuthorizedToSendAfterDeadline,
    required this.declassification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? child;

    final now = DateTime.now();

    final formatter = DateFormat('yyyy-MM-dd');

    final formattedNow = DateTime.parse(formatter.format(now));
    final formattedDeadline =
        DateTime.parse(formatter.format(documentationUploadDeadline));

    final bool isInsideDeadline = formattedDeadline.isAfter(formattedNow) ||
        formattedDeadline.isAtSameMomentAs(formattedNow);

    if (declassification > 0 && !isAuthorizedToSendAfterDeadline) {
      child = Text(
          DeclassificatonMessages.shared
              .checkDeclassificationType(declassification, ''),
          style: (declassification > 0) ? _errorTextStyle : _successTextStyle);
    } else if (isInsideDeadline || isAuthorizedToSendAfterDeadline) {
      child = AlternativeRoundedButton(
        label: 'Iniciar Envio',
        onTap: onTapSendDocuments,
        backgroundColor: const Color(0xFFDFF2FC),
      );
    } else {
      child = Text('Período de envio expirou',
          style:
              TextStyle(color: Theme.of(context).disabledColor, fontSize: 16));
    }

    return BaseStepper(
      child: CustomStepper(
        currentStep: 1,
        margin: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (context, details) => const SizedBox(),
        titleTextStyle: const TextStyle(fontSize: 16),
        steps: [
          const CustomStep(
            title: Text('Cadastro', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          CustomStep(
            icon: const Icon(EbolsasIcons.warning,
                size: 40, color: Color(0xFFFFC547)),
            title: const Text('Envio de documentação',
                style: TextStyle(
                    color: Color(0xFFFFC547), fontWeight: FontWeight.bold)),
            isComplete: true,
            content: child,
          ),
          _disabledReviewStep,
          _disabledAnalysisStep,
          _disabledResultStep,
        ],
      ),
    );
  }
}

class ManualSendDocumentationStepper extends StatelessWidget {
  final int declassification;
  const ManualSendDocumentationStepper({
    Key? key,
    required this.declassification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseStepper(
      child: CustomStepper(
        currentStep: 1,
        margin: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (context, details) => const SizedBox(),
        titleTextStyle: const TextStyle(fontSize: 16),
        steps: [
          const CustomStep(
            title: Text('Cadastro', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          CustomStep(
            icon: (declassification == 0)
                ? const Icon(EbolsasIcons.warning,
                    size: 40, color: Color(0xFFFFC547))
                : _warningIcon,
            title: Text(
                DeclassificatonMessages.shared.checkDeclassificationType(
                    declassification, 'Envio de documentação'),
                style: (declassification > 0)
                    ? _errorTextStyle
                    : const TextStyle(
                        color: Color(0xFFFFC547), fontWeight: FontWeight.bold)),
            isComplete: true,
          ),
          const CustomStep(
            icon: BackgroundIcon(icon: Icon(EbolsasIcons.revisao_de_doc)),
            title: Text('Revisão da documentação'),
            state: StepState.disabled,
          ),
          _disabledAnalysisStep,
          _disabledResultStep,
        ],
      ),
    );
  }
}

class ReviewingScholarshipStepper extends StatelessWidget {
  final int declassification;
  const ReviewingScholarshipStepper({
    Key? key,
    required this.declassification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseStepper(
      child: CustomStepper(
        currentStep: 2,
        margin: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (context, details) => const SizedBox(),
        titleTextStyle: const TextStyle(fontSize: 16),
        steps: [
          const CustomStep(
            title: Text('Cadastro', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          const CustomStep(
            title: Text('Envio de documentação', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          CustomStep(
            icon: (declassification == 0) ? _clockIcon : _warningIcon,
            title: Text(
                DeclassificatonMessages.shared.checkDeclassificationType(
                    declassification, 'Revisão da documentação'),
                style: (declassification > 0)
                    ? _errorTextStyle
                    : _waitingTextStyle),
            isComplete: true,
          ),
          _disabledAnalysisStep,
          _disabledResultStep,
        ],
      ),
    );
  }
}

class ErrorScholarshipStepper extends StatelessWidget {
  final void Function() onTapHistoryReview;
  final void Function() onTapResendDocuments;
  final DateTime documentationUploadDeadline;
  final bool isAuthorizedToSendAfterDeadline;
  final int declassification;
  const ErrorScholarshipStepper({
    Key? key,
    required this.onTapHistoryReview,
    required this.onTapResendDocuments,
    required this.documentationUploadDeadline,
    required this.isAuthorizedToSendAfterDeadline,
    required this.declassification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    final now = DateTime.now();

    final formatter = DateFormat('yyyy-MM-dd');

    final formattedNow = DateTime.parse(formatter.format(now));
    final formattedDeadline =
        DateTime.parse(formatter.format(documentationUploadDeadline));
    final bool isInsideDeadline = formattedDeadline.isAfter(formattedNow) ||
        formattedDeadline.isAtSameMomentAs(formattedNow);

    if (declassification > 0 && !isAuthorizedToSendAfterDeadline) {
      children.addAll([
        Text(
            DeclassificatonMessages.shared
                .checkDeclassificationType(declassification, ''),
            style:
                (declassification > 0) ? _errorTextStyle : _successTextStyle),
        const SizedBox(height: 12),
      ]);
    } else if (isInsideDeadline || isAuthorizedToSendAfterDeadline) {
      children.addAll([
        AlternativeRoundedButton(
          label: 'Reenviar documentos',
          onTap: onTapResendDocuments,
        ),
        const SizedBox(height: 12),
      ]);
    } else {
      children.addAll([const Text('Erro')]);
    }

    return BaseStepper(
      child: CustomStepper(
        currentStep: 2,
        margin: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (context, details) => const SizedBox(),
        titleTextStyle: const TextStyle(fontSize: 16),
        steps: [
          const CustomStep(
            title: Text('Cadastro', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          const CustomStep(
            title: Text('Envio de documentação', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          CustomStep(
            icon: Icon(EbolsasIcons.question_mark,
                color: Theme.of(context).colorScheme.error, size: 40),
            title: Text('Revisão da documentação',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
          _disabledAnalysisStep,
          _disabledResultStep,
        ],
      ),
    );
  }
}

class ManualErrorScholarshipStepper extends StatelessWidget {
  final void Function() onTapHistoryReview;
  const ManualErrorScholarshipStepper(
      {Key? key, required this.onTapHistoryReview})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    return BaseStepper(
      child: CustomStepper(
        currentStep: 2,
        margin: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (context, details) => const SizedBox(),
        titleTextStyle: const TextStyle(fontSize: 16),
        steps: [
          const CustomStep(
            title: Text('Cadastro', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          const CustomStep(
            title: Text('Envio de documentação', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          CustomStep(
            icon: Icon(EbolsasIcons.question_mark,
                color: Theme.of(context).colorScheme.error, size: 40),
            title: Text('Revisão da documentação',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
          _disabledAnalysisStep,
          _disabledResultStep,
        ],
      ),
    );
  }
}

class ReviewedScholarshipStepper extends StatelessWidget {
  final int declassification;
  const ReviewedScholarshipStepper({
    Key? key,
    required this.declassification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseStepper(
      child: CustomStepper(
        margin: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (context, details) => const SizedBox(),
        titleTextStyle: const TextStyle(fontSize: 16),
        steps: [
          const CustomStep(
            title: Text('Cadastro', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          const CustomStep(
            title: Text('Envio de documentação', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          const CustomStep(
            title: Text('Revisão da documentação', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          CustomStep(
            icon: (declassification == 0) ? _clockIcon : _warningIcon,
            title: Text(
                DeclassificatonMessages.shared.checkDeclassificationType(
                    declassification, 'Avaliação socioeconômica'),
                style: (declassification > 0)
                    ? _errorTextStyle
                    : _waitingTextStyle),
            isComplete: true,
          ),
          _disabledResultStep,
        ],
      ),
    );
  }
}

class AnalysisScholarshipStepper extends StatelessWidget {
  final int declassification;
  const AnalysisScholarshipStepper({
    Key? key,
    required this.declassification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseStepper(
      child: CustomStepper(
        margin: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (context, details) => const SizedBox(),
        titleTextStyle: const TextStyle(fontSize: 16),
        steps: [
          const CustomStep(
            title: Text('Cadastro', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          const CustomStep(
            title: Text('Envio de documentação', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          const CustomStep(
            title: Text('Revisão da documentação', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          const CustomStep(
            title: Text('Avaliação socioeconômica', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
          ),
          CustomStep(
            icon: (declassification == 0) ? _clockIcon : _warningIcon,
            title: Text(
                DeclassificatonMessages.shared
                    .checkDeclassificationType(declassification, 'Resultado'),
                style: (declassification > 0)
                    ? _errorTextStyle
                    : _waitingTextStyle),
            isComplete: true,
          ),
        ],
      ),
    );
  }
}

class ResultScholarshipStepper extends StatelessWidget {
  final String resultReleaseDate;
  final void Function() onDateTimeError;
  final scholarship.Entity processNewScholarship;

  const ResultScholarshipStepper({
    Key? key,
    required this.resultReleaseDate,
    required this.onDateTimeError,
    required this.processNewScholarship,
  }) : super(key: key);

  Widget getContent() {
    if (resultReleaseDate.isEmpty) {
      onDateTimeError();
      return const SizedBox();
    }
    DateTime? resultReleaseDateDateTime = DateTime.tryParse(resultReleaseDate);
    return resultReleaseDateDateTime == null
        ? () {
            onDateTimeError();
            return const SizedBox();
          }()
        : const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  width: 300,
                  child: Text(
                    'Consulte o portal do e-Bolsa para visualizar o resultado.',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF0079b6),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))
              //AlternativeRoundedButton(label: 'Mostrar resultado', onTap: () {}),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return BaseStepper(
      child: CustomStepper(
        margin: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (context, details) => const SizedBox(),
        titleTextStyle: const TextStyle(fontSize: 16),
        currentStep: 4,
        steps: [
          const CustomStep(
            title: Text('Cadastro', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          const CustomStep(
            title: Text('Envio de documentação', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          const CustomStep(
            title: Text('Revisão da documentação', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          const CustomStep(
            title: Text('Avaliação socioeconômica', style: _successTextStyle),
            icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
            isComplete: true,
          ),
          CustomStep(
            icon: const BackgroundIcon(
                icon:
                    Icon(EbolsasIcons.resultado, color: Colors.white, size: 40),
                backgroundColor: Color(0xFFFFC547)),
            title: GestureDetector(
              onTap: () {
                print(processNewScholarship);
                Modular.to.pushNamed('/document/result');
              },
              child: const Text(
                'Resultado',
                style: TextStyle(color: Color(0xFFFFC547)),
              ),
            ),
            isActive: true,
            content: const SizedBox(),
          )
        ],
      ),
    );
  }
}

class DefaultScholarshipStepper extends StatelessWidget {
  const DefaultScholarshipStepper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseStepper(
      child: CustomStepper(
        margin: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (context, details) => const SizedBox(),
        titleTextStyle: const TextStyle(fontSize: 16),
        steps: [
          CustomStep(
            title: Text('Cadastro',
                style: TextStyle(color: Theme.of(context).disabledColor)),
            icon: Icon(EbolsasIcons.check,
                color: Theme.of(context).disabledColor, size: 40),
            isComplete: true,
          ),
          CustomStep(
            icon: Icon(EbolsasIcons.warning,
                size: 40, color: Theme.of(context).disabledColor),
            title: const Text('Envio de documentação'),
            state: StepState.disabled,
          ),
          _disabledReviewStep,
          _disabledAnalysisStep,
          _disabledResultStep,
        ],
      ),
    );
  }
}

const _disabledAnalysisStep = CustomStep(
  icon: BackgroundIcon(icon: Icon(EbolsasIcons.avaliacao_socioconomica)),
  title: Text('Avaliação socioeconômica'),
  state: StepState.disabled,
);

const _disabledResultStep = CustomStep(
  icon: BackgroundIcon(icon: Icon(EbolsasIcons.resultado)),
  title: Text('Resultado'),
  state: StepState.disabled,
);

const _disabledReviewStep = CustomStep(
  icon: BackgroundIcon(icon: Icon(EbolsasIcons.revisao_de_doc)),
  title: Text('Revisão da documentação'),
  state: StepState.disabled,
);

const _waitingProcessColor = Color(0xFF04A0F9);
const _errorProcessColor = Color.fromARGB(255, 215, 6, 6);

const _clockIcon =
    Icon(EbolsasIcons.clock, color: _waitingProcessColor, size: 40);

const _warningIcon =
    Icon(EbolsasIcons.warning, color: _errorProcessColor, size: 40);

const _waitingTextStyle = TextStyle(color: _waitingProcessColor);

const _successTextStyle = TextStyle(color: successColor);

const _errorTextStyle = TextStyle(color: _errorProcessColor);
