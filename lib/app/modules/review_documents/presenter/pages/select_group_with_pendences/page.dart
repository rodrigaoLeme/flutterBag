import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart' as triple;

import '../../../../../core/icons/ebolsas_icons_icons.dart';
import '../../../../../core/widgets/alternative_rounded_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_scaffold.dart';
import '../../../../../core/widgets/group_card.dart';
import '../../stores/usecases/finish_sending_documents_with_pendences/store.dart'
    as finish_sending_documents_with_pendences;
import '../../stores/usecases/get_family_members_with_pendences_by_scholarship/store.dart'
    as get_family_members_with_pendences_by_scholarship;
import 'scholarship_with_pendences_dto.dart';
import 'store.dart';

class Page extends StatefulWidget {
  final ScholarshipWithPendencesDto scholarshipWithPendencesParams;

  const Page({Key? key, required this.scholarshipWithPendencesParams})
      : super(key: key);

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  final store = Modular.get<Store>();
  triple.Disposer? finishSendingDocumentsStatesObserver;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'Select_Group_With_Pendeces_Page');
    final params = widget.scholarshipWithPendencesParams;
    final scholarshipId = params.id;
    store.init(scholarshipId: scholarshipId);
    FirebaseAnalytics.instance.logEvent(name: 'Resend_Page');
    startObservingFinishSendingDocumentsStore();
  }

  void startObservingFinishSendingDocumentsStore() {
    finishSendingDocumentsStatesObserver =
        store.finishSendingDocumentsStore.observer(
      onError: (error) => showSnackBar(error.toString()),
      onState: (state) {
        final requestHasWorked = state.response;
        if (requestHasWorked) {
          Modular.to.pop(requestHasWorked);
        } else {
          showSnackBar('Não foi possível finalizar a revisão');
        }
      },
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    ));
  }

  @override
  void dispose() {
    finishSendingDocumentsStatesObserver?.call();
    store.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return triple.TripleBuilder<
        finish_sending_documents_with_pendences.Store,
        finish_sending_documents_with_pendences.StoreException,
        finish_sending_documents_with_pendences.Entity>(
      store: store.finishSendingDocumentsStore,
      builder: (context, tripleState) {
        if (tripleState.isLoading) {
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
                margin: const EdgeInsets.only(
                    top: 24, bottom: 32, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Verifique os grupos em destaque e reenvie os documentos solicitados.',
                      style: TextStyle(color: primaryColor, height: 1.3),
                      textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false),
                    ),
                  ],
                ),
              ),
              triple.ScopedBuilder<Store, String, StoreState>(
                store: store,
                onError: (context, error) => Center(
                  child: Text(error.toString()),
                ),
                onLoading: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
                onState: (context, storeState) {
                  return triple.ScopedBuilder<
                      get_family_members_with_pendences_by_scholarship.Store,
                      String,
                      get_family_members_with_pendences_by_scholarship.Entity>(
                    store: store.getFamilyMembersWithPendencesStore,
                    onLoading: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    onState: (context, state) => ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.familyMembers.length +
                          (store.hasFamilyGroupPendences ? 2 : 1),
                      itemBuilder: (context, index) {
                        final isfirstIndex = index == 0;
                        if (isfirstIndex && store.hasFamilyGroupPendences) {
                          return GroupCard.error(
                            leading: Icon(EbolsasIcons.icon_metro_home,
                                size: 20, color: primaryColor),
                            title: 'Grupo Familiar',
                            onTap: () {
                              store.selectFamilyGroup();
                              store.goToSelectGroupDocumentPage().then((value) {
                                store.checkFinishButton();
                              });
                            },
                          );
                        }
                        final isLastIndex = index ==
                            state.familyMembers.length +
                                (store.hasFamilyGroupPendences ? 1 : 0);
                        if (isLastIndex) {
                          return storeState.showFinishButtonResult
                              ? AlternativeRoundedButton(
                                  label: 'Finalizar',
                                  onTap: store.finishSendingDocuments,
                                )
                              : const AlternativeRoundedButton(
                                  label: 'Finalizar',
                                  onTap: null,
                                  labelColor: Colors.grey,
                                );
                        }
                        final actualFamilyMembersIndex =
                            index - (store.hasFamilyGroupPendences ? 1 : 0);
                        final familyMember =
                            state.familyMembers[actualFamilyMembersIndex];
                        return GroupCard.error(
                          leading:
                              Icon(Icons.person_rounded, color: primaryColor),
                          title: familyMember.name,
                          onTap: () {
                            store.selectFamilyMemberGroup(
                              familyMemberId: familyMember.id,
                              familyMemberName: familyMember.name,
                            );
                            store.goToSelectGroupDocumentPage().then((value) {
                              store.checkFinishButton();
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
      },
    );
  }
}
