import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../core/constants/process_type.dart';
import '../../../../core/constants/scholarship_status.dart';
import '../../domain/usecases/get_authorized_especial_users/entity.dart'
    as authorized_user;
import '../../domain/usecases/get_process_periods/entity.dart'
    as process_period;
import '../../domain/usecases/get_process_periods/entity.dart';
import '../../domain/usecases/get_scholarship_by_period/entity.dart'
    as scholarship;
import '../stores/usecases/get_authorized_especial_users/store.dart'
    as authorized;
import 'scholarship_stepper.dart';

class ProcessRenewalStepper extends StatelessWidget {
  final scholarship.Entity renewalScholarship;
  final Process processRenewal;
  final void Function() onTapSendDocuments;
  final void Function() onDateTimeError;
  final void Function() onTapResendDocuments;
  final void Function() onTapHistoryReview;
  final process_period.Process processPeriod;

  const ProcessRenewalStepper({
    Key? key,
    required this.renewalScholarship,
    required this.processRenewal,
    required this.onTapSendDocuments,
    required this.onDateTimeError,
    required this.onTapResendDocuments,
    required this.onTapHistoryReview,
    required this.processPeriod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (renewalScholarship.scholarshipStatus) {
      case ScholarshipStatus.notFinished:
        return const NotFinishedScholarshipStepper();
      case ScholarshipStatus.applied:
        if (renewalScholarship.completedStep == 5) {
          if (renewalScholarship.digitalProcess) {
            final documentationUploadDeadline =
                processRenewal.documentationUploadDeadline;
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
              userId: renewalScholarship.userId,
              processPeriodId: renewalScholarship.processPeriodId,
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
                  declassification: renewalScholarship.declassificationType,
                );
              },
              onState: (_, entity) {
                final isAuthorized = entity.id.isNotEmpty;
                return SendDocumentationScholarshipStepper(
                  documentationUploadDeadline: deadline,
                  onTapSendDocuments: onTapSendDocuments,
                  isAuthorizedToSendAfterDeadline: isAuthorized,
                  declassification: renewalScholarship.declassificationType,
                );
              },
            );
          } else {
            return ManualSendDocumentationStepper(
              declassification: renewalScholarship.declassificationType,
            );
          }
        }
        return const WaitingForCompletionStepper();
      case ScholarshipStatus.documentation:
        if (renewalScholarship.reviewStatus == 1) {
          if (renewalScholarship.digitalProcess) {
            final documentationReturnUploadDeadline =
                processRenewal.documentationReturnUploadDeadLine;
            if (documentationReturnUploadDeadline == null ||
                documentationReturnUploadDeadline.isEmpty) {
              onDateTimeError();
              return const SizedBox();
            }

            final supplementaryDocumentDeadlineOnUtc =
                processRenewal.supplementaryDocumentDeadlineOnUtc;
            if (supplementaryDocumentDeadlineOnUtc == null ||
                supplementaryDocumentDeadlineOnUtc.isEmpty) {
              onDateTimeError();
              return const SizedBox();
            }

            final DateTime? deadline =
                DateTime.tryParse(documentationReturnUploadDeadline);
            if (deadline == null) {
              onDateTimeError();
              return const SizedBox();
            }

            final DateTime? supplementaryDeadline =
                DateTime.tryParse(supplementaryDocumentDeadlineOnUtc);
            if (supplementaryDeadline == null) {
              onDateTimeError();
              return const SizedBox();
            }

            final store = Modular.get<authorized.Store>();

            // Chamada da store com os parâmetros
            store.call(authorized.Params(
              userId: renewalScholarship.userId,
              processPeriodId: renewalScholarship.processPeriodId,
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
                  onTapHistoryReview: () {
                    //TODO(adbysantos): Função "Histórico de revisão"
                  },
                  isAuthorizedToSendAfterDeadline: false, // fallback se erro
                  declassification: renewalScholarship.declassificationType,
                  supplementaryDocumentDeadlineOnUtc: supplementaryDeadline,
                  lastReviewType: renewalScholarship.lastReviewType,
                );
              },
              onState: (_, entity) {
                final isAuthorized = entity.id.isNotEmpty;
                return ErrorScholarshipStepper(
                  documentationUploadDeadline: deadline,
                  onTapResendDocuments: onTapResendDocuments,
                  isAuthorizedToSendAfterDeadline: isAuthorized,
                  declassification: renewalScholarship.declassificationType,
                  supplementaryDocumentDeadlineOnUtc: supplementaryDeadline,
                  lastReviewType: renewalScholarship.lastReviewType,
                  onTapHistoryReview: () {
                    //TODO(adbysantos): Função "Histórico de revisão"
                  },
                );
              },
            );
          }
          return ManualErrorScholarshipStepper(
              onTapHistoryReview: onTapHistoryReview);
        }
        return ReviewingScholarshipStepper(
          declassification: renewalScholarship.declassificationType,
        );
      case ScholarshipStatus.reviewed:
        return ReviewedScholarshipStepper(
          declassification: renewalScholarship.declassificationType,
        );
      // case ScholarshipStatus.analysis:
      //   return AnalysisScholarshipStepper(
      //     declassification: renewalScholarship.declassificationType,
      //   );
      case ScholarshipStatus.analysis:
      case ScholarshipStatus.result:
        return ResultScholarshipStepper(
          resultReleaseDate: processRenewal.resultRelease,
          onDateTimeError: onDateTimeError,
          processNewScholarship: renewalScholarship,
          processPeriod: processPeriod,
          tipoProcesso: ProcessType.renewal,
        );
      default:
        log('ScholarshipStatus: ${renewalScholarship.scholarshipStatus}');
        return const DefaultScholarshipStepper();
    }
  }
}
