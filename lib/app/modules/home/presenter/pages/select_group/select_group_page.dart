import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart' as triple;
import 'package:flutter_triple/flutter_triple.dart';
import 'package:localization/localization.dart';

import '../../../../../core/icons/ebolsas_icons_icons.dart';
import '../../../../../core/widgets/alternative_rounded_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_scaffold.dart';
import '../../../../../core/widgets/group_card.dart';
import '../../../domain/usecases/get_proofs_by_family_params/params.dart';
import '../group_params.dart';
import 'select_group_controller.dart';
import 'stores/usecases/finish_sending_documents/store.dart'
    as finish_sending_documents;
import 'stores/usecases/get_family_members_by_scholarship/store.dart'
    as get_family_members_by_scholarship;

class SelectGroupPage extends StatefulWidget {
  const SelectGroupPage({Key? key}) : super(key: key);

  @override
  State<SelectGroupPage> createState() => _SelectGroupPageState();
}

class _SelectGroupPageState extends State<SelectGroupPage> {
  final controller = Modular.get<SelectGroupController>();
  triple.Disposer? finishSendingDocumentsStatesObserver;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'Selected_Group_Page');
    getFamilyMembersByScholarship().then((value) {
      checkFinishButton();
    });
    initLocalizedStrings();
    startObservingFinishSendingDocumentsStore();
  }

  void startObservingFinishSendingDocumentsStore() {
    finishSendingDocumentsStatesObserver =
        controller.finishSendingDocumentsStore.observer(
      onError: (error) {
        showSnackBar(error.toString());
      },
      onState: (state) {
        final requestHasWorked = state.response;
        if (requestHasWorked) {
          Modular.to.pop(requestHasWorked);
        }
      },
    );
  }

  @override
  void dispose() {
    finishSendingDocumentsStatesObserver?.call();
    super.dispose();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void checkFinishButton() {
    controller.showFinishButtonResult = controller.showFinishButton();
    controller.getFamilyMembers
        .update(controller.getFamilyMembers.state, force: true);
  }

  late String description;
  late String unableToFindFamilyMembers;
  late String familyGroupLabel;

  String getLocalization(String attribute, {List<String>? params}) {
    return 'select_group_$attribute'.i18n(params ?? []);
  }

  void initLocalizedStrings() {
    description = getLocalization('description');
    unableToFindFamilyMembers =
        getLocalization('unable_to_find_family_members');
    familyGroupLabel = getLocalization('family_group_label');
  }

  Future<void> getFamilyMembersByScholarship() =>
      controller.getFamilyMembersByScholarship();
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return TripleBuilder<
            finish_sending_documents.Store,
            finish_sending_documents.UsecaseException,
            finish_sending_documents.Entity>(
        store: controller.finishSendingDocumentsStore,
        builder: (context, state) {
          if (state.isLoading) {
            return const CustomScaffold(
              body: SizedBox.expand(
                  child: Center(child: CircularProgressIndicator())),
            );
          }
          return CustomScaffold(
            appBar: const CustomAppBar(),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 24, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        description,
                        style: const TextStyle(
                            color: Color(0xFF6B6B6B), height: 1.3),
                        textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false),
                      ),
                    ],
                  ),
                ),
                triple.ScopedBuilder<
                    get_family_members_by_scholarship.Store,
                    get_family_members_by_scholarship.UsecaseException,
                    get_family_members_by_scholarship.Entity>(
                  store: controller.getFamilyMembers,
                  onError: (context, error) => Center(
                    child: Text(error?.message ?? unableToFindFamilyMembers),
                  ),
                  onLoading: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  onState: (context, state) {
                    return FutureBuilder(
                      future: controller.showFinishButtonResult,
                      builder: (context, snapshot) => snapshot
                                  .connectionState ==
                              ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: state.familyMembers.length + 2,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return GroupCard.initial(
                                    leading: Icon(EbolsasIcons.icon_metro_home,
                                        size: 20, color: primaryColor),
                                    title: familyGroupLabel,
                                    onTap: () {
                                      controller.selectGroup(
                                        GroupParams(
                                            proofParams: FamilyGroupParams(
                                              scholarshipId: controller
                                                  .scholarshipParams.id,
                                            ),
                                            icon: EbolsasIcons.icon_metro_home,
                                            groupName: 'Grupo Familiar'),
                                      );
                                      Modular.to
                                          .pushNamed('select_group_document')
                                          .then((value) {
                                        checkFinishButton();
                                      });
                                    },
                                  );
                                }
                                if (index == state.familyMembers.length + 1) {
                                  return FutureBuilder(
                                    future: controller.showFinishButtonResult,
                                    builder: (context, snapshot) {
                                      if (snapshot.data == true) {
                                        return AlternativeRoundedButton(
                                          label: 'Finalizar',
                                          onTap:
                                              controller.finishSendingDocuments,
                                        );
                                      }
                                      return const AlternativeRoundedButton(
                                          label: 'Finalizar',
                                          onTap: null,
                                          labelColor: Colors.grey);
                                    },
                                  );
                                }
                                final familyMember =
                                    state.familyMembers[index - 1];
                                return GroupCard.initial(
                                  leading: Icon(Icons.person_rounded,
                                      color: primaryColor),
                                  title: familyMember.name,
                                  onTap: () {
                                    controller.selectGroup(
                                      GroupParams(
                                        proofParams: FamilyMemberParams(
                                            scholarshipId:
                                                controller.scholarshipParams.id,
                                            familyMemberId: familyMember.id),
                                        icon: Icons.person_rounded,
                                        groupName: familyMember.name,
                                      ),
                                    );
                                    Modular.to
                                        .pushNamed('select_group_document')
                                        .then((value) {
                                      checkFinishButton();
                                    });
                                  },
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 24),
                            ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}
