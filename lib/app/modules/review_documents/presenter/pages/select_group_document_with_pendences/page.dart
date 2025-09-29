import 'dart:developer';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart' as triple;
import 'package:localization/localization.dart';
import 'package:open_document/open_document.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/widgets/alternative_rounded_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_scaffold.dart';
import '../../../../../core/widgets/custom_text_button.dart';
import '../../../../../core/widgets/dotted_border_button.dart';
import '../../../../../core/widgets/expansion_sub_group_card.dart';
import '../../../../../core/widgets/show_custom_modal_bottom_sheet.dart';
import '../../../../../core/widgets/show_resend_new_document_dialog.dart';
import '../../../../../core/widgets/show_successful_attachment_dialog.dart';
import '../../../../../core/widgets/sub_group_card.dart';
import '../../../../home/presenter/pages/select_group_document/stores/usecases/get_accepted_documents_by_proof/store.dart'
    as accepted_documents;
import '../../../../home/presenter/pages/select_group_document/stores/usecases/get_accepted_documents_by_proof/store.dart'
    as get_accepted_documents_by_proof;
import '../../../../home/presenter/pages/stores/usecases/get_document_by_file_id/store.dart'
    as get_document_by_file_id;
import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/entity.dart';
import '../../stores/usecases/get_proofs_with_pendences_by_family_params/store.dart'
    as get_proofs_with_pendences_by_family_member;
import '../required_documents_with_pendences/required_documents_with_pendences_dto.dart';
import 'group_with_pendences_dto.dart';
import 'store.dart';
import 'store_state.dart';

class Page extends StatefulWidget {
  final GroupWithPendencesDto groupWithPendencesDto;
  const Page({Key? key, required this.groupWithPendencesDto}) : super(key: key);

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  final store = Modular.get<Store>();
  late IconData icon;
  late String groupName;
  triple.Disposer? exceptionsObserver;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(
        screenName: 'Select_Group_Document_With_Pendeces_Page');
    initLocalizedStrings();

    icon = widget.groupWithPendencesDto.groupIcon;
    groupName = widget.groupWithPendencesDto.groupName;

    final scholarshipReviewId =
        widget.groupWithPendencesDto.scholarshipReviewId;
    final getProofsWithPendencesParams =
        widget.groupWithPendencesDto.getProofsWithPendencesParams;
    store.init(
        scholarshipReviewId: scholarshipReviewId,
        getProofsWithPendencesParams: getProofsWithPendencesParams);
    exceptionsObserver = store.observer(
      onError: (exception) => showSnackBar(exception),
    );
  }

  @override
  void dispose() {
    exceptionsObserver?.call();
    store.reset();
    super.dispose();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  late String emptyProofList;
  late String takeAPhoto;
  late String selectFromCellphone;
  late String noAcceptedDocuments;
  late String unableToFindAcceptedDocuments;
  late String acceptedDocumentsException;
  late String emptyAcceptedDocumentsList;
  late String acceptTermLabel;

  String getLocalization(String attribute, {List<String>? params}) {
    return 'select_group_document_$attribute'.i18n(params ?? []);
  }

  void initLocalizedStrings() {
    emptyProofList = getLocalization('empty_proof_list');
    takeAPhoto = getLocalization('take_a_photo');
    selectFromCellphone = getLocalization('select_from_cellphone');
    noAcceptedDocuments = getLocalization('no_accepted_documents');
    unableToFindAcceptedDocuments =
        getLocalization('unable_to_find_accepted_documents');
    acceptedDocumentsException =
        getLocalization('accepted_documents_exception');
    emptyAcceptedDocumentsList =
        getLocalization('empty_accepted_documents_list');
    acceptTermLabel = getLocalization('accept_term_label');
  }

  bool get successfullySentDocuments =>
      store.sendProofDocumentWithPendencesStore.error == null;

  bool lockDocumentOpening = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return CustomScaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 32, top: 24, right: 32),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 23,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    groupName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: triple.ScopedBuilder<
                get_proofs_with_pendences_by_family_member.Store,
                String,
                get_proofs_with_pendences_by_family_member.Entity>(
              store: store.getProofsWithPendencesStore,
              onError: (context, error) =>
                  Center(child: Text(error.toString())),
              onLoading: (context) =>
                  const Center(child: CircularProgressIndicator()),
              onState: (context, state) {
                final acceptedDocumentsStore =
                    store.getAcceptedDocumentsByProofStore;
                final proofs = state.proofs;
                if (proofs.isEmpty) {
                  return Text(
                    emptyProofList,
                    style: const TextStyle(fontSize: 16),
                  );
                }
                return triple.ScopedBuilder<Store, String, StoreState>(
                  store: store,
                  onLoading: (_) =>
                      const Center(child: CircularProgressIndicator()),
                  onState: (stateContext, state) {
                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 24),
                      physics: const ClampingScrollPhysics(),
                      itemCount: proofs.length + 1,
                      itemBuilder: (context, index) {
                        if (index == proofs.length) {
                          return const SizedBox(height: 20);
                        }
                        final proof = proofs[index];
                        final files = store.state.files;
                        final bool isComplementarDocument = (proof
                                .scholarshipProofDocuments
                                .first
                                .scholarshipProofDocumentReviews
                                .first
                                .newRequirement &&
                            proof.scholarshipProofDocuments.first.fileId ==
                                null);
                        final String complementarDocumentString = (proof
                                    .scholarshipProofDocuments
                                    .first
                                    .scholarshipProofDocumentReviews
                                    .first
                                    .newRequirement &&
                                proof.scholarshipProofDocuments.first.fileId ==
                                    null)
                            ? 'Enviar'
                            : 'Reenviar';
                        AcceptedDocumentFileViewModel? fileViewModel;
                        for (final file in files) {
                          if (file.fileId ==
                              proof.scholarshipProofDocuments.first.fileId) {
                            fileViewModel = file;
                            break;
                          }
                        }
                        final docs = proof.scholarshipProofDocuments;
                        final hasNoResend = docs.length == 1
                            ? !docs.first.scholarshipProofDocumentReviews.first
                                .resend
                            : docs.any((doc) =>
                                doc.scholarshipProofDocumentReviews
                                    .isNotEmpty &&
                                !doc.scholarshipProofDocumentReviews.first
                                    .resend);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          child: ExpansionSubGroupCardV2(
                            key: Key(proof.id),
                            isExpanded: state is Editing &&
                                state.selectedProofId == proof.id,
                            subGroupCard: SubGroupCard.builder(
                                isError: hasNoResend,
                                onTap: () async {
                                  if ((state is EditingSet ||
                                          state is EditingAdding ||
                                          state is EditingAddingPdf) &&
                                      proof.id == state.selectedProofId) {
                                    return store.exitEditingMode();
                                  }
                                  final fileId = proof
                                      .scholarshipProofDocuments.first.fileId;
                                  if (fileId != null) {
                                    final result =
                                        store.getDocumentByFileIdStore(
                                            get_document_by_file_id.Params(
                                                fileId: fileId));
                                    result.then((value) {
                                      final file = store
                                          .getDocumentByFileIdStore
                                          .state
                                          .acceptedDocumentFile;
                                      final fileUrl = file.url;
                                      final fileName = file.name;
                                      final filesList = store.state.files;
                                      final newFileList = [
                                        ...filesList,
                                        AcceptedDocumentFileViewModel(
                                            fileId: fileId,
                                            fileUrl: fileUrl,
                                            fileName: fileName)
                                      ];
                                      store.update(store.state
                                          .copyWith(files: newFileList));
                                    });
                                  }
                                  if (state is! ConfirmEditing ||
                                      state.selectedProofId != proof.id) {
                                    if (proof.scholarshipProofDocuments.length >
                                        2) {
                                      return acceptedDocumentsStore(
                                              accepted_documents.Params(
                                                  proof.id))
                                          .then((value) {
                                        final acceptedDocuments =
                                            acceptedDocumentsStore
                                                .state.acceptedDocuments;
                                        if (acceptedDocumentsStore.error !=
                                            null) {
                                          log('Durante edição, exceção ocorreu na busca de comprovantes aceitos');
                                        }
                                        if (acceptedDocuments.isEmpty) {
                                          log('Durante edição, lista de comprovantes aceitos é vazia');
                                        }
                                        final requiredDocumentsWithPendencesDto =
                                            RequiredDocumentsWithPendencesDto(
                                          icon: icon,
                                          groupName: groupName,
                                          groupDocumentName: proof
                                              .entityProofConfig
                                              .entityProof
                                              .name,
                                          scholarshipProofDocuments:
                                              proof.scholarshipProofDocuments,
                                          acceptedDocuments:
                                              acceptedDocumentsStore
                                                  .state.acceptedDocuments,
                                          isEdit: true,
                                          proofId: proof.id,
                                          getProofsWithPendencesParams: widget
                                              .groupWithPendencesDto
                                              .getProofsWithPendencesParams,
                                          scholarshipReviewId:
                                              state.scholarshipReviewId,
                                          proofs: proof,
                                        );
                                        return store
                                            .goToRequiredAcceptedDocumentsPage(
                                                requiredDocumentsWithPendencesDto:
                                                    requiredDocumentsWithPendencesDto);
                                      });
                                    }
                                    if (proof
                                        .scholarshipProofDocuments.isEmpty) {
                                      log('Durante edição, lista de comprovantes é vazia');
                                      return;
                                    }

                                    final scholarshipProofDocument =
                                        proof.scholarshipProofDocuments.first;
                                    final scholarshipProofDocumentId =
                                        scholarshipProofDocument.id;
                                    final documentId =
                                        scholarshipProofDocument.documentId ??
                                            "0";
                                    const scholarshipProofDocumentName =
                                        'TROCAR 1';
                                    //scholarshipProofDocument.name;

                                    StoreState stateBeforeEditing;
                                    if (state is Editing) {
                                      stateBeforeEditing =
                                          (state).stateBeforeEditing;
                                    } else {
                                      stateBeforeEditing = Initial(
                                        getProofsWithPendencesParams:
                                            state.getProofsWithPendencesParams,
                                        scholarshipReviewId:
                                            state.scholarshipReviewId,
                                      );
                                    }

                                    store.showResendOption(ConfirmEditing(
                                      getProofsWithPendencesParams:
                                          state.getProofsWithPendencesParams,
                                      scholarshipReviewId:
                                          state.scholarshipReviewId,
                                      selectedProofId: proof.id,
                                      selectedScholarshipProofDocumentId:
                                          scholarshipProofDocumentId,
                                      selectedAcceptedDocumentId: documentId,
                                      stateBeforeEditing: stateBeforeEditing,
                                      files: state.files,
                                      selectedAcceptedDocumentName:
                                          scholarshipProofDocumentName,
                                      originalAcceptedDocumentId: documentId,
                                    ));
                                  } else {
                                    store.exitEditingMode();
                                  }
                                },
                                title:
                                    proof.entityProofConfig.entityProof.name),
                            content: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: state is ConfirmEditing
                                  ? Column(
                                      children: [
                                        if (fileViewModel != null)
                                          StatefulBuilder(
                                            builder: (context, setState) =>
                                                GestureDetector(
                                              onTap: lockDocumentOpening
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        lockDocumentOpening =
                                                            true;
                                                      });
                                                      final url = fileViewModel!
                                                          .fileUrl;
                                                      canLaunchUrlString(url)
                                                          .then((canLaunch) {
                                                        if (canLaunch) {
                                                          launchUrlString(url,
                                                              mode: Platform
                                                                      .isAndroid
                                                                  ? LaunchMode
                                                                      .externalApplication
                                                                  : Platform
                                                                          .isIOS
                                                                      ? LaunchMode
                                                                          .inAppWebView
                                                                      : LaunchMode
                                                                          .platformDefault);
                                                        } else {
                                                          showSnackBar(
                                                              'Não foi possível abrir o documento');
                                                        }
                                                      }).whenComplete(() {
                                                        setState(() {
                                                          lockDocumentOpening =
                                                              false;
                                                        });
                                                      });
                                                    },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xFFF6F6F6)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                        Icons.picture_as_pdf,
                                                        color: Colors.red),
                                                    const SizedBox(width: 5),
                                                    Expanded(
                                                      child: Text(
                                                        fileViewModel!.fileName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    const Icon(Icons
                                                        .fullscreen_rounded),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        Builder(
                                          builder: (context) {
                                            //final scholarshipProofDocument = proof.scholarshipProofDocuments
                                            //    .firstWhere((element) => element.documentId == state.selectedAcceptedDocumentId);
                                            final scholarshipProofDocument =
                                                proof.scholarshipProofDocuments
                                                    .first;
                                            return Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  10, 10, 10, 0),
                                              child: Column(
                                                children: [
                                                  RichText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      text: 'Observação: ',
                                                      children: [
                                                        TextSpan(
                                                          text: scholarshipProofDocument
                                                              .scholarshipProofDocumentReviews
                                                              .first
                                                              .observation,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ],
                                                      style: const TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  CustomTextButton(
                                                      onTap: () {
                                                        showCustomModalBottomSheet(
                                                          context: context,
                                                          content: (context) =>
                                                              Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    32,
                                                                    30,
                                                                    32,
                                                                    26),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Observação: ',
                                                                    children: [
                                                                      TextSpan(
                                                                        text: scholarshipProofDocument
                                                                            .scholarshipProofDocumentReviews
                                                                            .first
                                                                            .observation,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xFF6B6B6B),
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 24),
                                                                AlternativeRoundedButton(
                                                                  label:
                                                                      'Estou ciente',
                                                                  onTap: () {
                                                                    Navigator
                                                                        .maybePop(
                                                                            context);
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      label: 'Ler mais',
                                                      labelColor: const Color(
                                                          0xFF04A0F9),
                                                      fontSize: 12),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            complementarDocumentString,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          onPressed: () {
                                            showResendNewDocumentDialog(
                                              context: context,
                                              message: (isComplementarDocument)
                                                  ? 'enviar'
                                                  : 'substituir',
                                              onTapYes: (context) async {
                                                Navigator.maybePop(context);
                                                final selectedProofId =
                                                    proof.id;
                                                acceptedDocumentsStore(
                                                    get_accepted_documents_by_proof
                                                        .Params(
                                                  proofs[index]
                                                      .scholarshipProofDocuments
                                                      .first
                                                      .proofItemConfigId,
                                                )).then((value) async {
                                                  if (acceptedDocumentsStore
                                                          .error !=
                                                      null) {
                                                    return store
                                                        .exceptionOccuredWhenGettingAcceptedDocuments();
                                                  }
                                                  final acceptedDocuments =
                                                      acceptedDocumentsStore
                                                          .state
                                                          .acceptedDocuments;
                                                  if (acceptedDocuments
                                                      .isEmpty) {
                                                    return showSnackBar(
                                                        noAcceptedDocuments);
                                                  }
                                                  if (acceptedDocuments
                                                          .length ==
                                                      1) {
                                                    selectedAcceptedDocumentIndex =
                                                        0;
                                                    final proofDocument =
                                                        acceptedDocuments[
                                                            selectedAcceptedDocumentIndex!];
                                                    final proofDocumentId =
                                                        proofDocument.id;
                                                    final scholarshipProofDocumentId = proof
                                                        .scholarshipProofDocuments
                                                        .firstWhere((element) =>
                                                            element
                                                                .proofItemConfigId ==
                                                            proofDocument
                                                                .proofItemConfigId)
                                                        .id;
                                                    final proofDocumentName =
                                                        proofDocument.name;

                                                    if (proofDocument
                                                        .isDeclaration) {
                                                      await showCustomModalBottomSheet(
                                                        context: context,
                                                        content: (context) =>
                                                            Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .fromLTRB(32,
                                                                  32, 32, 32),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const Text(
                                                                declaration,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 24),
                                                              AlternativeRoundedButton(
                                                                label:
                                                                    'Estou ciente',
                                                                onTap: () {
                                                                  Navigator
                                                                      .maybePop(
                                                                          context);
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }

                                                    store
                                                        .startSendingOneDocument(
                                                            EditingSet(
                                                      getProofsWithPendencesParams:
                                                          state
                                                              .getProofsWithPendencesParams,
                                                      scholarshipReviewId: state
                                                          .scholarshipReviewId,
                                                      selectedProofId:
                                                          selectedProofId,
                                                      selectedScholarshipProofDocumentId:
                                                          scholarshipProofDocumentId,
                                                      selectedAcceptedDocumentId:
                                                          proofDocumentId,
                                                      stateBeforeEditing: state
                                                          .stateBeforeEditing,
                                                      files: state.files,
                                                      selectedAcceptedDocumentName:
                                                          proofDocumentName,
                                                      originalAcceptedDocumentId:
                                                          state
                                                              .originalAcceptedDocumentId,
                                                    ));
                                                    return;
                                                  }
                                                  return showAcceptedDocuments(
                                                          context,
                                                          acceptedDocumentsStore)
                                                      .then((newIndex) async {
                                                    if (newIndex == null) {
                                                      return;
                                                    }
                                                    selectedAcceptedDocumentIndex =
                                                        newIndex;

                                                    if (acceptedDocuments
                                                            .length <=
                                                        selectedAcceptedDocumentIndex!) {
                                                      showSnackBar(
                                                          unableToFindAcceptedDocuments);
                                                      return;
                                                    }

                                                    final proofDocument =
                                                        acceptedDocuments[
                                                            selectedAcceptedDocumentIndex!];
                                                    final proofDocumentId =
                                                        proofDocument.id;
                                                    final proofDocumentName =
                                                        proofDocument.name;
                                                    final scholarshipProofDocumentId = proof
                                                        .scholarshipProofDocuments
                                                        .firstWhere((element) =>
                                                            element
                                                                .proofItemConfigId ==
                                                            proofDocument
                                                                .proofItemConfigId)
                                                        .id;

                                                    if (proofDocument
                                                        .isDeclaration) {
                                                      await showCustomModalBottomSheet(
                                                        context: context,
                                                        content: (context) =>
                                                            Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .fromLTRB(32,
                                                                  32, 32, 32),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const Text(
                                                                declaration,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 24),
                                                              AlternativeRoundedButton(
                                                                label:
                                                                    'Estou ciente',
                                                                onTap: () {
                                                                  Navigator
                                                                      .maybePop(
                                                                          context);
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }

                                                    store
                                                        .startSendingOneDocument(
                                                            EditingSet(
                                                      scholarshipReviewId: state
                                                          .scholarshipReviewId,
                                                      getProofsWithPendencesParams:
                                                          state
                                                              .getProofsWithPendencesParams,
                                                      selectedProofId:
                                                          selectedProofId,
                                                      selectedScholarshipProofDocumentId:
                                                          scholarshipProofDocumentId,
                                                      selectedAcceptedDocumentId:
                                                          proofDocumentId,
                                                      stateBeforeEditing: state
                                                          .stateBeforeEditing,
                                                      files: state.files,
                                                      selectedAcceptedDocumentName:
                                                          proofDocumentName,
                                                      originalAcceptedDocumentId:
                                                          state
                                                              .originalAcceptedDocumentId,
                                                    ));
                                                  });
                                                });
                                              },
                                              onTapNo: (context) {
                                                Navigator.maybePop(context);
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  : state is Adding
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (fileViewModel != null)
                                              StatefulBuilder(
                                                builder: (context, setState) =>
                                                    GestureDetector(
                                                  onTap: lockDocumentOpening
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            lockDocumentOpening =
                                                                true;
                                                          });
                                                          final url =
                                                              fileViewModel!
                                                                  .fileUrl;
                                                          canLaunchUrlString(
                                                                  url)
                                                              .then(
                                                                  (canLaunch) {
                                                            if (canLaunch) {
                                                              launchUrlString(
                                                                  url,
                                                                  mode: Platform
                                                                          .isAndroid
                                                                      ? LaunchMode
                                                                          .externalApplication
                                                                      : Platform
                                                                              .isIOS
                                                                          ? LaunchMode
                                                                              .inAppWebView
                                                                          : LaunchMode
                                                                              .platformDefault);
                                                            } else {
                                                              showSnackBar(
                                                                  'Não foi possível abrir o documento');
                                                            }
                                                          }).whenComplete(() {
                                                            setState(() {
                                                              lockDocumentOpening =
                                                                  false;
                                                            });
                                                          });
                                                        },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xFFF6F6F6)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .picture_as_pdf,
                                                            color: Colors.red),
                                                        const SizedBox(
                                                            width: 5),
                                                        Expanded(
                                                          child: Text(
                                                            fileViewModel!
                                                                .fileName,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        const Icon(Icons
                                                            .fullscreen_rounded),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            Builder(
                                              builder: (context) {
                                                if (state is! Editing)
                                                  return const SizedBox();
                                                final scholarshipProofDocuments =
                                                    proof
                                                        .scholarshipProofDocuments;
                                                final ScholarshipProofDocumentWithPendences
                                                    scholarshipProofDocument;
                                                if (scholarshipProofDocuments
                                                    .first
                                                    .scholarshipProofDocumentReviews
                                                    .first
                                                    .newRequirement) {
                                                  scholarshipProofDocument =
                                                      scholarshipProofDocuments
                                                          .first;
                                                } else {
                                                  scholarshipProofDocument =
                                                      scholarshipProofDocuments
                                                          .firstWhere((element) =>
                                                              element
                                                                  .documentId ==
                                                              (state as Editing)
                                                                  .originalAcceptedDocumentId);
                                                }
                                                return Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 10, 0),
                                                  child: Column(
                                                    children: [
                                                      RichText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        text: TextSpan(
                                                          text: 'Observação: ',
                                                          children: [
                                                            TextSpan(
                                                              text: scholarshipProofDocument
                                                                  .scholarshipProofDocumentReviews
                                                                  .first
                                                                  .observation,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ],
                                                          style: const TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      CustomTextButton(
                                                          onTap: () {
                                                            showCustomModalBottomSheet(
                                                              context: context,
                                                              content:
                                                                  (context) =>
                                                                      Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        32,
                                                                        30,
                                                                        32,
                                                                        26),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        text:
                                                                            'Observação: ',
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                scholarshipProofDocument.scholarshipProofDocumentReviews.first.observation,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Color(0xFF6B6B6B),
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            24),
                                                                    AlternativeRoundedButton(
                                                                      label:
                                                                          'Estou ciente',
                                                                      onTap:
                                                                          () {
                                                                        Navigator.maybePop(
                                                                            context);
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          label: 'Ler mais',
                                                          labelColor:
                                                              const Color(
                                                                  0xFF04A0F9),
                                                          fontSize: 12),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                            GridView.builder(
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent: 75),
                                              itemCount:
                                                  state.photoPaths.length,
                                              itemBuilder: (context, index) {
                                                final path =
                                                    state.photoPaths[index];
                                                final file = File(path);
                                                return Stack(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              7),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        child: (state
                                                                is EditingAddingPdf)
                                                            ? const Icon(
                                                                Icons
                                                                    .picture_as_pdf_rounded,
                                                                color:
                                                                    Colors.red)
                                                            : Image.file(file,
                                                                cacheHeight: 60,
                                                                cacheWidth: 60,
                                                                height: 60,
                                                                width: 60),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            if (state
                                                                is EditingAddingPdf) {
                                                              OpenDocument
                                                                  .openDocument(
                                                                      filePath:
                                                                          path);
                                                              return;
                                                            }
                                                            store
                                                                .openPhotoFromFile(
                                                                    file: file);
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .zoom_in_rounded,
                                                          )),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                primaryColor),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            if (state
                                                                is EditingAddingPdf) {
                                                              store.deletePdf();
                                                              return;
                                                            }
                                                            store
                                                                .deleteOnePhoto(
                                                                    index:
                                                                        index);
                                                          },
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                            size: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            CustomTextButton(
                                                onTap: () async {
                                                  if (state
                                                      is EditingAddingPdf) {
                                                    final pdfPaths =
                                                        state.photoPaths;
                                                    if (pdfPaths.isEmpty) {
                                                      store.setError(
                                                          'Você não selecionou um .pdf ou o caminho não foi armazenado');
                                                      return;
                                                    }
                                                    if (pdfPaths.length > 1) {
                                                      store.setError(
                                                          'Mais de um .pdf foi registrado');
                                                    }
                                                    final path = pdfPaths.first;
                                                    final File file =
                                                        File(path);
                                                    await store.sendPdf(
                                                        pdfFile: file);
                                                  } else {
                                                    await store.sendPhotos();
                                                  }
                                                  if (store.error != null ||
                                                      store.getProofsWithPendencesStore
                                                              .error !=
                                                          null) return;
                                                  showSuccessfulAttachmentDialog(
                                                      context: stateContext);
                                                },
                                                label: 'Enviar',
                                                labelColor: primaryColor),
                                          ],
                                        )
                                      : state is Set
                                          ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                DottedBorderButton(
                                                  leading: Icon(
                                                      Icons.camera_alt_rounded,
                                                      color: primaryColor,
                                                      size: 20),
                                                  label: takeAPhoto,
                                                  labelColor: primaryColor,
                                                  //onTap: store.takePhoto,
                                                  onTap: () =>
                                                      store.takeDocumentScanner(
                                                          context),
                                                ),
                                                const SizedBox(height: 14),
                                                DottedBorderButton(
                                                  leading: Icon(
                                                      Icons.attachment_rounded,
                                                      color: primaryColor,
                                                      size: 20),
                                                  label: selectFromCellphone,
                                                  labelColor: primaryColor,
                                                  onTap: store
                                                      .initAddingFromCellphone,
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int? selectedProofIndex;

  int? selectedAcceptedDocumentIndex;

  Future<int?> showAcceptedDocuments(BuildContext context,
      get_accepted_documents_by_proof.Store acceptedDocumentsStore) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    //acceptedDocumentsStore(accepted_documents.Params(proofId));
    return showCustomModalBottomSheet<int>(
      context: context,
      hasScrollIcon: true,
      content: (context) => Container(
        padding: const EdgeInsets.fromLTRB(32, 30, 32, 26),
        child: triple.ScopedBuilder<
                get_accepted_documents_by_proof.Store,
                get_accepted_documents_by_proof.UsecaseException,
                get_accepted_documents_by_proof.Entity>(
            store: acceptedDocumentsStore,
            onLoading: (context) =>
                const Center(child: CircularProgressIndicator()),
            onError: (context, error) => Center(
                child: Text(error?.message ?? acceptedDocumentsException)),
            onState: (context, state) {
              final acceptedDocuments = state.acceptedDocuments;
              if (acceptedDocuments.isEmpty) {
                return Center(child: Text(emptyAcceptedDocumentsList));
              }
              return ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemCount: acceptedDocuments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    title: Text(acceptedDocuments[index].name,
                        maxLines: 3, textAlign: TextAlign.center
                        //overflow: TextOverflow.ellipsis,
                        ),
                    selected: selectedAcceptedDocumentIndex == index,
                    selectedColor: Colors.white,
                    selectedTileColor: primaryColor,
                    tileColor: const Color(0xFFF1FAFF),
                    textColor: primaryColor,
                    onTap: () {
                      Modular.to.pop(index);
                    },
                  );
                },
              );
            }),
      ),
    );
  }
}

const declaration =
    'Declaro a veracidade e autenticidade do documento inserido/anexado e das informações prestadas por mim nesta declaração, ciente de que em caso de omissão ou falsidade estarei sujeito às sanções legais e até mesmo ao cancelamento da bolsa (Lei Complementar nº 187/2021).';
