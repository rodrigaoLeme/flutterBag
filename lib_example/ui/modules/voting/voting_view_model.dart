import 'dart:convert';

import 'package:collection/collection.dart';

import '../../../data/models/voting/remote_voting_model.dart';
import '../../helpers/extensions/string_extension.dart';

class VotingsViewModel {
  final List<VotingViewModel> votings;
  final List<DivisionGroup> divisionGroups;
  final List<VotingsSectionViewModel> sections;
  List<VotingsSectionViewModel> filteredSections = [];
  List<DivisionGroup> divisionGroupsFiltered = [];
  String votingFilter = '';
  VotingsViewModel({
    required this.votings,
    required this.divisionGroups,
    required this.sections,
  }) {
    filteredSections = sections;
    divisionGroupsFiltered = divisionGroups;
  }

  Map<String, List<VotingViewModel>> get groupedByDivision {
    final Map<String, List<VotingViewModel>> grouped = {};
    for (var voting in votings) {
      final key = voting.divisionAcronym ?? '';
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]?.add(voting);
    }
    return grouped;
  }

  void setCurrentFilter(DivisionGroup filter) {
    for (final item in divisionGroups) {
      if (item.divisionAcronym == filter.divisionAcronym) {
        item.setCurrent();
      }
    }

    if (selectedDivisionGroups.isEmpty) {
      clearFilter();
    } else {
      filteredSections = sections
          .where((element) =>
              selectedDivisionGroups.firstWhereOrNull(
                  (group) => group.divisionAcronym == element.title) !=
              null)
          .toList();
    }
  }

  void clearFilter() {
    for (final item in divisionGroups) {
      item.clearFilter();
    }
    filteredSections = sections;
  }

  List<DivisionGroup> get selectedDivisionGroups {
    return divisionGroups.where((element) => element.isSelected).toList();
  }

  List<VotingsSectionViewModel> get selectedSections {
    List<VotingsSectionViewModel> filterSection = [];
    if (selectedDivisionGroups.isEmpty) {
      filterSection = sections;
    } else {
      filterSection = sections
          .where((element) =>
              selectedDivisionGroups.firstWhereOrNull(
                  (division) => division.divisionAcronym == element.title) !=
              null)
          .toList();
    }
    for (var item in filterSection) {
      item.filterBy(votingFilter);
    }

    return filterSection;
  }

  int get selectedFilterCount {
    return divisionGroups
        .where((element) => element.isSelected)
        .toList()
        .length;
  }

  void filterBy(String filter) {
    if (filter == '') {
      divisionGroupsFiltered = divisionGroups;
    } else {
      divisionGroupsFiltered = divisionGroups
          .where((element) =>
              element.divisionAcronym
                  .toUpperCase()
                  .contains(filter.toUpperCase()) ||
              element.description.toUpperCase().contains(filter.toUpperCase()))
          .toList();
    }
  }

  void filterVotingBy(String filter) {
    votingFilter = filter;
  }
}

class DivisionGroup {
  final String divisionAcronym;
  final int count;
  final String description;
  bool isSelected;

  DivisionGroup({
    required this.divisionAcronym,
    required this.count,
    required this.description,
    required this.isSelected,
  });

  void setCurrent() {
    isSelected = !isSelected;
  }

  void clearFilter() {
    isSelected = false;
  }
}

class VotingViewModel {
  final String? externalId;
  final int? eventId;
  final int? divisionId;
  final String? divisionAcronym;
  final String? divisionDescription;
  final String? positionName;
  final int? order;
  final String? personName;
  final String? personPhotoUrl;
  final String? profilePicture;
  final String? photoUrl;

  VotingViewModel({
    required this.externalId,
    required this.eventId,
    required this.divisionId,
    required this.divisionAcronym,
    required this.divisionDescription,
    required this.positionName,
    required this.order,
    required this.personName,
    required this.personPhotoUrl,
    required this.profilePicture,
    required this.photoUrl,
  });

  String get personInitial {
    if (personName!.isEmpty) return '';
    final words = personName!.trim().split(' ');
    final firstInitial = words.first[0].toUpperCase();
    final lastInitial = words.length > 1 ? words.last[0].toUpperCase() : '';

    return '$firstInitial$lastInitial';
  }

  List<int> get byteImage {
    try {
      return const Base64Decoder()
          .convert((profilePicture ?? '').split(',').last);
    } catch (_) {
      return [];
    }
  }
}

class VotingsSectionViewModel {
  final String title;
  final List<VotingViewModel> itens;
  List<VotingViewModel> itensFiltered;

  VotingsSectionViewModel({
    required this.title,
    required this.itens,
  }) : itensFiltered = itens;

  void filterBy(String text) {
    if (text == '') {
      itensFiltered = itens;
    } else {
      final query = text.toLowerCase();
      itensFiltered = itens
          .where(
            (element) => (element.personName?.toLowerCase().contains(query) ==
                    true ||
                element.positionName?.toLowerCase().contains(query) == true),
          )
          .toList();
    }
  }
}

class VotingsViewModelFactory {
  static Future<VotingsViewModel> make({VotingResultModel? model}) async {
    final List<VotingViewModel> votings = model?.votings != null
        ? await Future.wait<VotingViewModel>(
            model!.votings!.map(
              (element) async => VotingViewModel(
                externalId: element.externalId,
                eventId: element.eventId,
                divisionId: element.divisionId,
                divisionAcronym: element.divisionAcronym,
                divisionDescription:
                    await element.divisionDescription?.translate(),
                positionName: await element.positionName?.translate(),
                order: element.order,
                personName: element.personName,
                personPhotoUrl: element.personPhotoUrl,
                profilePicture: element.profilePicture,
                photoUrl: element.photoUrl,
              ),
            ),
          )
        : [];

    final Map<String, int> divisionCounts = {};
    for (var voting in votings) {
      final key = voting.divisionAcronym ?? '';
      divisionCounts[key] = (divisionCounts[key] ?? 0) + 1;
    }

    final divisionGroups = divisionCounts.entries
        .map(
          (entry) => DivisionGroup(
            divisionAcronym: entry.key,
            count: entry.value,
            description: votings
                    .firstWhereOrNull(
                        (element) => element.divisionAcronym == entry.key)
                    ?.divisionDescription ??
                '',
            isSelected: false,
          ),
        )
        .toList();

    return VotingsViewModel(
      votings: votings,
      divisionGroups: divisionGroups,
      sections: VotingsViewModelFactory.makeSections(votings),
    );
  }

  static List<VotingsSectionViewModel> makeSections(
      List<VotingViewModel> votings) {
    final Map<String, List<VotingViewModel>> groupedByDate = {};
    for (final voting in votings) {
      if (voting.divisionAcronym != null) {
        final String divisionAcronym = voting.divisionAcronym!;
        groupedByDate.putIfAbsent(divisionAcronym, () => []);
        groupedByDate[divisionAcronym]!.add(voting);
      }
    }

    return groupedByDate.entries.map((entry) {
      return VotingsSectionViewModel(
        title: entry.key,
        itens: entry.value,
      );
    }).toList();
  }
}
