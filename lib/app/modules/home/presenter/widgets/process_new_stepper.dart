import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../core/constants/scholarship_status.dart';
import '../../domain/usecases/get_authorized_especial_users/entity.dart'
    as authorized_user;
import '../../domain/usecases/get_process_periods/entity.dart';
import '../../domain/usecases/get_scholarship_by_period/entity.dart'
    as scholarship;
import '../stores/usecases/get_authorized_especial_users/store.dart'
    as authorized;
import 'scholarship_stepper.dart';

class ProcessNewStepper extends StatelessWidget {
  final scholarship.Entity processNewScholarship;
  final Process processNew;
  final void Function() onTapSendDocuments;
  final void Function() onDateTimeError;
  final void Function() onTapResendDocuments;
  const ProcessNewStepper(
      {Key? key,
      required this.processNewScholarship,
      required this.processNew,
      required this.onTapSendDocuments,
      required this.onDateTimeError,
      required this.onTapResendDocuments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (processNewScholarship.scholarshipStatus) {
      case ScholarshipStatus.notFinished:
        return const NotFinishedScholarshipStepper();
      case ScholarshipStatus.applied:
        if (processNewScholarship.completedStep == 5) {
          if (processNewScholarship.digitalProcess) {
            final documentationUploadDeadline =
                processNew.documentationUploadDeadline;
            if (documentationUploadDeadline == null ||
                documentationUploadDeadline.isEmpty) {
              onDateTimeError();
              return const SizedBox();
            }

            final DateTime? deadline =
                DateTime.tryParse(documentationUploadDeadline);
            if (deadline == null) {
              onDateTimeError();
              return const SizedBox();
            }

            final store = Modular.get<authorized.Store>();

            // Chamada da store com os parâmetros
            store.call(authorized.Params(
              userId: processNewScholarship.userId,
              processPeriodId: processNewScholarship.processPeriodId,
            ));

            return ScopedBuilder<authorized.Store, authorized.UsecaseException,
                authorized_user.Entity>(
              store: store,
              onLoading: (_) =>
                  const Center(child: CircularProgressIndicator()),
              onError: (_, error) {
                return SendDocumentationScholarshipStepper(
                  documentationUploadDeadline: deadline,
                  onTapSendDocuments: onTapSendDocuments,
                  isAuthorizedToSendAfterDeadline: false, // fallback se erro
                  declassification: processNewScholarship.declassificationType,
                );
              },
              onState: (_, entity) {
                final isAuthorized = entity.id.isNotEmpty;
                return SendDocumentationScholarshipStepper(
                  documentationUploadDeadline: deadline,
                  onTapSendDocuments: onTapSendDocuments,
                  isAuthorizedToSendAfterDeadline: isAuthorized,
                  declassification: processNewScholarship.declassificationType,
                );
              },
            );
          } else {
            return ManualSendDocumentationStepper(
              declassification: processNewScholarship.declassificationType,
            );
          }
        }
        return const WaitingForCompletionStepper();
      case ScholarshipStatus.documentation:
        if (processNewScholarship.reviewStatus == 1) {
          if (processNewScholarship.digitalProcess) {
            final documentationReturnUploadDeadline =
                processNew.documentationReturnUploadDeadLine;
            if (documentationReturnUploadDeadline == null ||
                documentationReturnUploadDeadline.isEmpty) {
              onDateTimeError();
              return const SizedBox();
            }

            final DateTime? deadline =
                DateTime.tryParse(documentationReturnUploadDeadline);
            if (deadline == null) {
              onDateTimeError();
              return const SizedBox();
            }

            final store = Modular.get<authorized.Store>();

            // Chamada da store com os parâmetros
            store.call(authorized.Params(
              userId: processNewScholarship.userId,
              processPeriodId: processNewScholarship.processPeriodId,
            ));

            return ScopedBuilder<authorized.Store, authorized.UsecaseException,
                authorized_user.Entity>(
              store: store,
              onLoading: (_) =>
                  const Center(child: CircularProgressIndicator()),
              onError: (_, error) {
                return ErrorScholarshipStepper(
                  documentationUploadDeadline: deadline,
                  onTapResendDocuments: onTapResendDocuments,
                  declassification: processNewScholarship.declassificationType,
                  onTapHistoryReview: () {
                    //TODO(adbysantos): Função "Histórico de revisão"
                  },
                  isAuthorizedToSendAfterDeadline: false, // fallback se erro
                );
              },
              onState: (_, entity) {
                final isAuthorized = entity.id.isNotEmpty;
                return ErrorScholarshipStepper(
                  documentationUploadDeadline: deadline,
                  onTapResendDocuments: onTapResendDocuments,
                  isAuthorizedToSendAfterDeadline: isAuthorized,
                  declassification: processNewScholarship.declassificationType,
                  onTapHistoryReview: () {
                    //TODO(adbysantos): Função "Histórico de revisão"
                  },
                );
              },
            );
            // return ErrorScholarshipStepper(
            //   onTapHistoryReview: () {
            //     //TODO(adbysantos): Função "Histórico de revisão"
            //   },
            //   onTapResendDocuments: onTapResendDocuments,
            //   documentationUploadDeadline:
            //       documentationReturnUploadDeadlineDateTime,
            // );
          }
          return ManualErrorScholarshipStepper(
            onTapHistoryReview: () {
              //TODO(adbysantos): Função "Histórico de revisão"
            },
          );
        }
        return ReviewingScholarshipStepper(
          declassification: processNewScholarship.declassificationType,
        );
      case ScholarshipStatus.reviewed:
        return ReviewedScholarshipStepper(
          declassification: processNewScholarship.declassificationType,
        );
      case ScholarshipStatus.analysis:
        return AnalysisScholarshipStepper(
          declassification: processNewScholarship.declassificationType,
        );
      case ScholarshipStatus.result:
        return ResultScholarshipStepper(
          resultReleaseDate: processNew.resultRelease,
          onDateTimeError: onDateTimeError,
          processNewScholarship: processNewScholarship,
        );
      default:
        log('ScholarshipStatus: ${processNewScholarship.scholarshipStatus}');
        return const DefaultScholarshipStepper();
    }
  }
}
