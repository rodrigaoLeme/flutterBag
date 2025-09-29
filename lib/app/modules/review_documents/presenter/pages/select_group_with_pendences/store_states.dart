part of 'store.dart';

abstract class StoreState {
  final ScholarshipWithPendencesDto scholarshipWithPendencesDto;
  final GroupWithPendencesDto groupWithPendencesDto;
  final String scholarshipReviewId;
  final bool showFinishButtonResult;

  const StoreState({
    required this.scholarshipWithPendencesDto,
    required this.groupWithPendencesDto,
    required this.scholarshipReviewId,
    required this.showFinishButtonResult,
  });

  StoreState copyWith({
    ScholarshipWithPendencesDto? scholarshipWithPendencesDto,
    GroupWithPendencesDto? groupWithPendencesDto,
    String? scholarshipReviewId,
    bool showFinishButtonResult,
  });
}

class Set extends StoreState {
  const Set({
    ScholarshipWithPendencesDto? scholarshipWithPendencesParams,
    GroupWithPendencesDto? groupWithPendencesDto,
    String? scholarshipReviewId,
    bool? showFinishButtonResult,
  }) : super(
          scholarshipWithPendencesDto: scholarshipWithPendencesParams ?? const ScholarshipWithPendencesDto(id: ''),
          groupWithPendencesDto: groupWithPendencesDto ??
              const GroupWithPendencesDto(
                getProofsWithPendencesParams: proofReferenceParamsEmpty,
                groupName: '',
                groupIcon: EbolsasIcons.icon_metro_home,
                scholarshipReviewId: '',
              ),
          scholarshipReviewId: scholarshipReviewId ?? '',
          showFinishButtonResult: showFinishButtonResult ?? false,
        );

  @override
  Set copyWith({ScholarshipWithPendencesDto? scholarshipWithPendencesDto, GroupWithPendencesDto? groupWithPendencesDto, String? scholarshipReviewId, bool? showFinishButtonResult}) {
    return Set(
      scholarshipWithPendencesParams: scholarshipWithPendencesDto ?? this.scholarshipWithPendencesDto,
      groupWithPendencesDto: groupWithPendencesDto ?? this.groupWithPendencesDto,
      scholarshipReviewId: scholarshipReviewId ?? this.scholarshipReviewId,
      showFinishButtonResult: showFinishButtonResult ?? this.showFinishButtonResult,
    );
  }
}

