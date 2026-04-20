import '../../../../../core/constants/review_type.dart';
import '../../../../../core/constants/scholarship_status.dart';
import '../../../domain/usecases/get_scholarship_by_period/entity.dart';
import '../../../domain/usecases/get_scholarship_by_period/exceptions.dart';

class Mapper {
  Entity fromMapToEntity(dynamic result) {
    if (result == null || result is! Map) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa. Formato da resposta inesperado.');
    }
    final digitalProcess = result['digitalProcess'];
    if (digitalProcess == null) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo digitalProcess é nulo');
    }
    if (digitalProcess is! bool) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo digitalProcess é do tipo ${digitalProcess.runtimeType}');
    }

    final scholarshipStatusField = result['scholarshipStatus'];
    if (scholarshipStatusField == null) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo scholarshipStatus é nulo');
    }
    late final ScholarshipStatus scholarshipStatus;
    try {
      scholarshipStatus =
          ScholarshipStatus.values.elementAt(scholarshipStatusField);
    } catch (e) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo scholarshipStatus é inesperado ($scholarshipStatusField)');
    }

    int? lastReviewStatus;
    ReviewType? lastReviewType;
    final scholarshipReviews = <ScholarshipReview>[];
    //TODO(adbysantos): Qual ScholarshipStatus define a necessidade do ReviewStatus do último ScholarshipReview
    //Utilizando o segundo
    if (scholarshipStatus == ScholarshipStatus.documentation) {
      if (!result.keys.contains('scholarshipReviews')) {
        throw MapperException(
            message:
                'Não foi possível recuperar a bolsa: Campo scholarshipReviews não encontrado');
      }

      final reviews = result['scholarshipReviews'];
      if (reviews is! List) {
        throw MapperException(
            message:
                'Não foi possível recuperar a bolsa: Campo scholarshipReviews é inesperado (${reviews.runtimeType})');
      }
      if (reviews.isEmpty) {
        //TODO(adbysantos): Definir o valor padrão quando a lista é vazia mas o status é "em revisão"
        lastReviewStatus = 2;
        //throw MapperException(message: 'Não foi possível recuperar a bolsa: Campo scholarshipReviews é vazio');
      } else {
        reviews.sort(((a, b) {
          final firstCreatedAt = a['createdOnUtc'];
          final secondCreatedAt = b['createdOnUtc'];
          if (firstCreatedAt is! String) {
            throw MapperException(
                message:
                    'Não foi possível recuperar a bolsa: Campo createdOnUtc é inesperado (${firstCreatedAt.runtimeType})');
          }
          if (firstCreatedAt.isEmpty) {
            throw MapperException(
                message:
                    'Não foi possível recuperar a bolsa: Campo createdOnUtc é vazio');
          }
          if (secondCreatedAt is! String) {
            throw MapperException(
                message:
                    'Não foi possível recuperar a bolsa: Campo createdOnUtc é inesperado (${secondCreatedAt.runtimeType})');
          }
          if (secondCreatedAt.isEmpty) {
            throw MapperException(
                message:
                    'Não foi possível recuperar a bolsa: Campo createdOnUtc é vazio');
          }
          final firstCreatedAtDateTime = DateTime.tryParse(firstCreatedAt);
          if (firstCreatedAtDateTime == null) {
            throw MapperException(
                message:
                    'Não foi possível recuperar a bolsa: DateTime.tryParse do campo createdOnUtc é nulo');
          }
          final secondCreatedAtDateTime = DateTime.tryParse(secondCreatedAt);
          if (secondCreatedAtDateTime == null) {
            throw MapperException(
                message:
                    'Não foi possível recuperar a bolsa: DateTime.tryParse do campo createdOnUtc é nulo');
          }

          return firstCreatedAtDateTime.compareTo(secondCreatedAtDateTime);
        }));

        for (final review in reviews) {
          ReviewType? reviewType;
          if (!review.keys.contains('reviewType')) {
            throw MapperException(
                message:
                    'Não foi possível recuperar a bolsa: Campo reviewType não encontrado');
          }

          final reviewTypeField = review['reviewType'];

          try {
            reviewType = ReviewType.values.elementAt(reviewTypeField);
          } catch (e) {
            throw MapperException(
                message:
                    'Não foi possível recuperar a bolsa: Campo reviewType é inesperado ($scholarshipStatusField)');
          }
          final scholarshipReview = ScholarshipReview(
              dateTime: review['createdOnUtc'], reviewType: reviewType);
          scholarshipReviews.add(scholarshipReview);
        }

        final lastReview = reviews.last;

        if (lastReview is! Map) {
          throw MapperException(
              message:
                  'Não foi possível recuperar a bolsa: Campo review é inesperado (${lastReview.runtimeType})');
        }
        if (lastReview.isEmpty) {
          throw MapperException(
              message:
                  'Não foi possível recuperar a bolsa: Campo review é vazio');
        }

        if (!lastReview.keys.contains('reviewStatus')) {
          throw MapperException(
              message:
                  'Não foi possível recuperar a bolsa: Campo reviewStatus não encontrado');
        }

        final lastReviewStatusData = lastReview['reviewStatus'];

        if (lastReviewStatusData is! int) {
          throw MapperException(
              message:
                  'Não foi possível recuperar a bolsa: Campo reviewStatus é inesperado (${lastReviewStatusData.runtimeType})');
        }

        if (lastReviewStatusData < 0 || lastReviewStatusData > 5) {
          throw MapperException(
              message:
                  'Não foi possível recuperar a bolsa: reviewStatus tem valor inesperado ($lastReviewStatusData)');
        }

        lastReviewStatus = lastReviewStatusData;

        if (!lastReview.keys.contains('reviewType')) {
          throw MapperException(
              message:
                  'Não foi possível recuperar a bolsa: Campo reviewType não encontrado');
        }

        final reviewTypeField = lastReview['reviewType'];

        try {
          lastReviewType = ReviewType.values.elementAt(reviewTypeField);
        } catch (e) {
          throw MapperException(
              message:
                  'Não foi possível recuperar a bolsa: Campo reviewType é inesperado ($scholarshipStatusField)');
        }
      }
    }
    if (!result.keys.contains('completedStep')) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo completedStep não encontrado');
    }

    final completedStep = result['completedStep'];

    if (completedStep is! int) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo completedStep é inesperado (${completedStep.runtimeType})');
    }
    if (completedStep < 0) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo completedStep tem valor inesperado ($completedStep)');
    }

    if (!result.keys.contains('id')) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo id não encontrado');
    }

    final id = result['id'];

    if (id is! String) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo id é inesperado (${id.runtimeType})');
    }
    if (id.isEmpty) {
      throw MapperException(
          message: 'Não foi possível recuperar a bolsa: Campo id é vazio');
    }

    if (!result.keys.contains('userId')) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo userId não encontrado');
    }

    final userId = result['userId'];

    if (userId is! String) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo userId é inesperado (${userId.runtimeType})');
    }
    if (userId.isEmpty) {
      throw MapperException(
          message: 'Não foi possível recuperar a bolsa: Campo userId é vazio');
    }

    if (!result.keys.contains('processPeriodId')) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo processPeriodId não encontrado');
    }

    final processPeriodId = result['processPeriodId'];

    if (processPeriodId is! String) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo processPeriodId é inesperado (${processPeriodId.runtimeType})');
    }
    if (processPeriodId.isEmpty) {
      throw MapperException(
          message: 'Não foi possível recuperar a bolsa: Campo userId é vazio');
    }

    if (!result.keys.contains('declassificationType')) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo declassificationType não encontrado');
    }

    final declassificationType = result['declassificationType'];

    if (declassificationType is! int) {
      throw MapperException(
          message:
              'Não foi possível recuperar a bolsa: Campo declassificationType é inesperado (${declassificationType.runtimeType})');
    }

    return Entity(
      digitalProcess: digitalProcess,
      scholarshipStatus: scholarshipStatus,
      reviewStatus: lastReviewStatus ?? -1,
      completedStep: completedStep,
      id: id,
      lastReviewType: lastReviewType ?? ReviewType.attendant,
      scholarshipReviews: scholarshipReviews,
      userId: userId,
      processPeriodId: processPeriodId,
      declassificationType: declassificationType,
    );
  }

  const Mapper();
}
