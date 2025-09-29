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
import '../../../../home/domain/usecases/get_accepted_documents_by_proof/entity.dart';
import '../../../../home/presenter/pages/select_group_document/stores/usecases/get_accepted_documents_by_proof/store.dart'
    as get_accepted_documents_by_proof;
import '../../../../home/presenter/pages/stores/usecases/get_document_by_file_id/store.dart'
    as get_document_by_file_id;
import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/entity.dart';
import 'required_documents_with_pendences_dto.dart';
import 'store.dart';
import 'store_state.dart';

class Page extends StatefulWidget {
  final RequiredDocumentsWithPendencesDto requiredDocumentsWithPendencesDto;
  const Page({Key? key, required this.requiredDocumentsWithPendencesDto})
      : super(key: key);

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  final store = Modular.get<Store>();

  late IconData icon;
  late String groupName;
  late String groupDocumentName;
  late ProofWithPendences proofs;
  late List<AcceptedDocument> acceptedDocuments;
  List<AcceptedDocument> nonRequiredAcceptedDocuments = [];
  List<AcceptedDocument> requiredAcceptedDocuments = [];
  List<AcceptedDocument> finalAcceptedDocuments = [];
  List<ScholarshipProofDocumentWithPendences> scholarshipProofDocuments = [];
  List<AcceptedDocument> acceptedDocument = [];
  late String documentNameEditing;

  late String takeAPhoto;
  late String selectFromCellphone;

  triple.Disposer? exceptionsObserver;
  String getLocalization(String attribute, {List<String>? params}) {
    return 'required_accepted_documents_$attribute'.i18n(params ?? []);
  }

  void initLocalizedStrings() {
    takeAPhoto = getLocalization('take_a_photo');
    selectFromCellphone = getLocalization('select_from_cellphone');
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'Required_Documents_With_Pendences_Page');
    store.init(
        scholarshipReviewId:
            widget.requiredDocumentsWithPendencesDto.scholarshipReviewId);
    icon = widget.requiredDocumentsWithPendencesDto.icon;
    groupName = widget.requiredDocumentsWithPendencesDto.groupName;
    groupDocumentName =
        widget.requiredDocumentsWithPendencesDto.groupDocumentName;
    proofs = widget.requiredDocumentsWithPendencesDto.proofs;
    initLocalizedStrings();
    for (final result in proofs.entityProofConfig.proofItemConfigs) {
      for (final resultAcept in result.proofDocumentConfigs) {
        if (resultAcept.active) {
          AcceptedDocument acept = AcceptedDocument(
            id: resultAcept.documentId,
            name: resultAcept.document.name,
            isDeclaration: resultAcept.document.isDeclaration,
            proofItemConfigId: resultAcept.proofItemConfigId,
          );
          acceptedDocument.add(acept);
        }
      }
    }
    groupNonRequiredDocs(
        widget.requiredDocumentsWithPendencesDto.acceptedDocuments);
    initScholarshipDocuments(
        widget.requiredDocumentsWithPendencesDto.scholarshipProofDocuments);
    exceptionsObserver = store.observer(onError: showSnackBar);
  }

  void groupNonRequiredDocs(List<AcceptedDocument> acceptedDocuments) {
    nonRequiredAcceptedDocuments.clear();
    nonRequiredAcceptedDocuments.clear();
    requiredAcceptedDocuments.clear();
    finalAcceptedDocuments.clear();
    for (final acceptedDocument in acceptedDocuments) {
      if (true) {
        requiredAcceptedDocuments.add(acceptedDocument);
      }
      // else {
      //   nonRequiredAcceptedDocuments.add(acceptedDocument);
      // }
    }
    finalAcceptedDocuments.addAll(requiredAcceptedDocuments);
  }

  void initScholarshipDocuments(
      List<ScholarshipProofDocumentWithPendences>
          newScholarshipProofDocuments) {
    scholarshipProofDocuments.clear();
    scholarshipProofDocuments.addAll(newScholarshipProofDocuments);
  }

  bool get successfullySentDocuments =>
      store.sendProofDocumentStore.error == null;

  bool get isEdit => widget.requiredDocumentsWithPendencesDto.isEdit;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    exceptionsObserver?.call();
    super.dispose();
  }

  bool lockDocumentOpening = false;

  Future<void> getProofs() async {
    store.setLoading(true, force: true);
    await store.getProofsStore(
        widget.requiredDocumentsWithPendencesDto.getProofsWithPendencesParams);
    proofs = store.getProofsStore.state.proofs.firstWhere(((element) =>
        element.id == widget.requiredDocumentsWithPendencesDto.proofId));
    final proof = store.getProofsStore.state.proofs.firstWhere(((element) =>
        element.id == widget.requiredDocumentsWithPendencesDto.proofId));
    initScholarshipDocuments(proof.scholarshipProofDocuments);
    await store.getAcceptedDocumentsByProofStore(
        get_accepted_documents_by_proof.Params(proof.id));
    final documents =
        store.getAcceptedDocumentsByProofStore.state.acceptedDocuments;
    groupNonRequiredDocs(documents);
    store.update(store.state, force: true);
    store.setLoading(false, force: true);
  }

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
            child: triple.ScopedBuilder<Store, String, StoreState>(
                store: store,
                onLoading: (context) =>
                    const Center(child: CircularProgressIndicator()),
                onState: (stateContext, state) {
                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 24),
                    physics: const ClampingScrollPhysics(),
                    itemCount: scholarshipProofDocuments.length,
                    itemBuilder: (context, index) {
                      final scholarshipProofDocument =
                          proofs.scholarshipProofDocuments[index];
                      final scholarshipProofDocumentId =
                          scholarshipProofDocument.id;
                      AcceptedDocument? document;
                      var documentId = '';
                      if (isEdit) {
                        documentId = scholarshipProofDocumentId;
                      }
                      if (state.documentId.isNotEmpty) {
                        for (final acceptedDocument
                            in nonRequiredAcceptedDocuments) {
                          if (state.documentId == acceptedDocument.id) {
                            document = acceptedDocument;
                            documentId = state.documentId;
                            break;
                          }
                        }
                      }
                      final files = store.state.files;
                      AcceptedDocumentFileViewModel? fileViewModel;
                      for (final file in files) {
                        if (file.fileId == scholarshipProofDocument.fileId) {
                          fileViewModel = file;
                          break;
                        }
                      }

                      final bool isComplementarDocument = (proofs
                              .scholarshipProofDocuments
                              .first
                              .scholarshipProofDocumentReviews
                              .first
                              .newRequirement &&
                          proofs.scholarshipProofDocuments.first.fileId ==
                              null);
                      final String complementarDocumentString = (proofs
                                  .scholarshipProofDocuments
                                  .first
                                  .scholarshipProofDocumentReviews
                                  .first
                                  .newRequirement &&
                              proofs.scholarshipProofDocuments.first.fileId ==
                                  null)
                          ? 'Enviar'
                          : 'Reenviar';

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        child: ExpansionSubGroupCardV2(
                          isExpanded: state is Editing &&
                              state.editingScholarshipProofDocumentId ==
                                  scholarshipProofDocumentId,
                          subGroupCard: SubGroupCard.builder(
                              isError: !proofs.scholarshipProofDocuments[index]
                                  .scholarshipProofDocumentReviews.first.resend,
                              //!scholarshipProofDocument.scholarshipProofDocumentReviews.first.resend,
                              title: acceptedDocument
                                  .firstWhere(
                                      (doc) =>
                                          doc.id ==
                                          proofs
                                              .scholarshipProofDocuments[index]
                                              .documentId,
                                      orElse: () => AcceptedDocument.empty())
                                  .name,
                              onTap: () async {
                                final state = store.state;

                                if (state is EditingAdding &&
                                    scholarshipProofDocumentId ==
                                        state
                                            .editingScholarshipProofDocumentId) {
                                  return store.exitEditingMode();
                                }

                                final files = state.files;

                                if (scholarshipProofDocument.fileId != null) {
                                  //if (document == null) return;
                                  final hasAlreadyGottenThisDocumentFile =
                                      files.any((element) =>
                                          element.fileId ==
                                          scholarshipProofDocument.fileId);
                                  if (!hasAlreadyGottenThisDocumentFile) {
                                    final fileId =
                                        scholarshipProofDocument.fileId!;
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
                                }
                                if (state is! ConfirmEditing ||
                                    state.editingScholarshipProofDocumentId !=
                                        scholarshipProofDocumentId) {
                                  store.showResendOption(
                                    ConfirmEditing(
                                      documentId: documentId,
                                      scholarshipProofDocumentId:
                                          scholarshipProofDocumentId,
                                      editingScholarshipProofDocumentId:
                                          scholarshipProofDocumentId,
                                      stateBeforeEditing: state is Editing
                                          ? state.stateBeforeEditing
                                          : state,
                                      files: state.files,
                                      selectedAcceptedDocumentName: 'TROCAR 1',
                                      //scholarshipProofDocument.name,
                                      originalAcceptedDocumentId: documentId,
                                      scholarshipReviewId:
                                          state.scholarshipReviewId,
                                    ),
                                  );
                                } else {
                                  store.exitEditingMode();
                                }
                              }),
                          content: Container(
                              margin: state is Editing &&
                                      state.editingScholarshipProofDocumentId ==
                                          scholarshipProofDocumentId
                                  ? const EdgeInsets.symmetric(vertical: 10)
                                  : EdgeInsets.zero,
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
                                            final scholarshipProofDocument =
                                                scholarshipProofDocuments
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        state
                                                            .scholarshipProofDocumentId);
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
                                                message:
                                                    (isComplementarDocument)
                                                        ? 'enviar'
                                                        : 'substituir',
                                                onTapYes: (context) async {
                                                  Navigator.pop(context);
                                                  final selectedIndex =
                                                      await showAcceptedDocuments(
                                                          context,
                                                          acceptedDocument,
                                                          state.documentId,
                                                          proofs
                                                              .scholarshipProofDocuments[
                                                                  index]
                                                              .proofItemConfigId);
                                                  if (selectedIndex == null)
                                                    return;
                                                  final selectedDocument =
                                                      acceptedDocument[
                                                          selectedIndex];
                                                  if (selectedDocument
                                                      .isDeclaration) {
                                                    await showCustomModalBottomSheet(
                                                        context: context,
                                                        content:
                                                            (context) =>
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                      .fromLTRB(
                                                                      32,
                                                                      32,
                                                                      32,
                                                                      32),
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
                                                                              FontWeight.bold,
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
                                                                ));
                                                  }
                                                  store.startSendingOneDocument(
                                                    EditingSet(
                                                      documentId:
                                                          selectedDocument.id,
                                                      scholarshipProofDocumentId:
                                                          scholarshipProofDocumentId,
                                                      editingScholarshipProofDocumentId:
                                                          state
                                                              .editingScholarshipProofDocumentId,
                                                      stateBeforeEditing: state
                                                          .stateBeforeEditing,
                                                      files: state.files,
                                                      selectedAcceptedDocumentName:
                                                          'TROCAR 2',
                                                      //scholarshipProofDocument.name,
                                                      originalAcceptedDocumentId:
                                                          state
                                                              .originalAcceptedDocumentId,
                                                      scholarshipReviewId: state
                                                          .scholarshipReviewId,
                                                    ),
                                                  );
                                                },
                                                onTapNo: (context) {
                                                  Navigator.maybePop(context);
                                                });
                                          },
                                        ),
                                      ],
                                    )
                                  : state is Adding
                                      ? Column(
                                          children: [
                                            const SizedBox(height: 12),
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
                                                            : Image.file(
                                                                file,
                                                                cacheHeight: 60,
                                                                cacheWidth: 60,
                                                                height: 60,
                                                                width: 60,
                                                              ),
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
                                                        child: const Icon(Icons
                                                            .zoom_in_rounded),
                                                      ),
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
                                                if (state is EditingAddingPdf) {
                                                  final path =
                                                      state.photoPaths[0];
                                                  final file = File(path);
                                                  await store.sendPdf(
                                                      pdfFile: file,
                                                      documentHasDeclarationToShow:
                                                          document?.isDeclaration ??
                                                              false);
                                                } else {
                                                  await store.sendPhotos(
                                                      documentId:
                                                          state.documentId,
                                                      scholarshipProofDocumentId:
                                                          state
                                                              .scholarshipProofDocumentId);
                                                }
                                                if (store.error == null &&
                                                    store.sendProofDocumentStore
                                                            .error ==
                                                        null) {
                                                  getProofs();
                                                  showSuccessfulAttachmentDialog(
                                                      context: stateContext);
                                                }
                                              },
                                              label: 'Enviar',
                                              labelColor: primaryColor,
                                            )
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
                                                  /*onTap: () async {
                                                      await store.takePhoto(
                                                          scholarshipProofDocumentId: scholarshipProofDocumentId, documentId: documentId);*/
                                                  // if (successfullySentDocuments) {
                                                  //   showSuccessfulAttachmentDialog(context: context);
                                                  // }
                                                  onTap: () async {
                                                    await store.takeDocumentScanner(
                                                        documentId: documentId,
                                                        scholarshipProofDocumentId:
                                                            scholarshipProofDocumentId,
                                                        context: context);
                                                  },
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
                                          : const SizedBox()),
                          trailingWhenExpanded: const Icon(
                            Icons.close,
                            color: Color(0xFFB1F3D4),
                          ),
                        ),
                      );

                      //return null;
                      // if (index == finalAcceptedDocuments.length + 1) {
                      //   return const SizedBox(height: 20);
                      // }
                      // final proof = proofs.scholarshipProofDocuments[index - 1];
                      // final scholarshipProofDocument =
                      //     scholarshipProofDocuments.firstWhere(
                      //   (element) =>
                      //       element.proofItemConfigId ==
                      //       proof.proofItemConfigId,
                      // );
                      // final scholarshipProofDocumentId =
                      //     scholarshipProofDocument.id;
                      // final documentId = proof.id;
                      // final files = store.state.files;
                      // AcceptedDocumentFileViewModel? fileViewModel;
                      // for (final file in files) {
                      //   if (file.fileId == scholarshipProofDocument.fileId) {
                      //     fileViewModel = file;
                      //     break;
                      //   }
                      // }
                      // return Container(
                      //   key: Key(proof.id),
                      //   margin: const EdgeInsets.symmetric(horizontal: 32),
                      //   child: (scholarshipProofDocument.fileId == null ||
                      //               scholarshipProofDocument.fileId!.isEmpty) ||
                      //           (state is Editing &&
                      //               state.editingScholarshipProofDocumentId ==
                      //                   scholarshipProofDocumentId &&
                      //               state is! ConfirmEditing)
                      //       ? ExpansionSubGroupCardV2(
                      //           content: Container(
                      //             margin:
                      //                 const EdgeInsets.symmetric(vertical: 10),
                      //             child: state is Adding &&
                      //                     state.scholarshipProofDocumentId ==
                      //                         scholarshipProofDocumentId
                      //                 ? Column(
                      //                     mainAxisSize: MainAxisSize.min,
                      //                     children: [
                      //                       GridView.builder(
                      //                         shrinkWrap: true,
                      //                         gridDelegate:
                      //                             const SliverGridDelegateWithMaxCrossAxisExtent(
                      //                                 maxCrossAxisExtent: 75),
                      //                         itemCount:
                      //                             state.photoPaths.length,
                      //                         itemBuilder: (context, index) {
                      //                           final path =
                      //                               state.photoPaths[index];
                      //                           final file = File(path);
                      //                           return Stack(
                      //                             children: [
                      //                               Container(
                      //                                 margin:
                      //                                     const EdgeInsets.all(
                      //                                         7),
                      //                                 child: ClipRRect(
                      //                                   borderRadius:
                      //                                       BorderRadius
                      //                                           .circular(6),
                      //                                   child: (state
                      //                                           is EditingAddingPdf)
                      //                                       ? const Icon(
                      //                                           Icons
                      //                                               .picture_as_pdf_rounded,
                      //                                           color:
                      //                                               Colors.red)
                      //                                       : Image.file(
                      //                                           file,
                      //                                           cacheHeight: 60,
                      //                                           cacheWidth: 60,
                      //                                           height: 60,
                      //                                           width: 60,
                      //                                         ),
                      //                                 ),
                      //                               ),
                      //                               Align(
                      //                                 alignment:
                      //                                     Alignment.center,
                      //                                 child: GestureDetector(
                      //                                   onTap: () {
                      //                                     if (state
                      //                                         is EditingAddingPdf) {
                      //                                       OpenDocument
                      //                                           .openDocument(
                      //                                               filePath:
                      //                                                   path);
                      //                                       return;
                      //                                     }
                      //                                     store
                      //                                         .openPhotoFromFile(
                      //                                             file: file);
                      //                                   },
                      //                                   child: const Icon(
                      //                                     Icons.zoom_in_rounded,
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                               Align(
                      //                                 alignment:
                      //                                     Alignment.topRight,
                      //                                 child: Container(
                      //                                   padding:
                      //                                       const EdgeInsets
                      //                                           .all(3),
                      //                                   decoration: BoxDecoration(
                      //                                       shape:
                      //                                           BoxShape.circle,
                      //                                       color:
                      //                                           primaryColor),
                      //                                   child: GestureDetector(
                      //                                     onTap: () {
                      //                                       if (state
                      //                                           is EditingAddingPdf) {
                      //                                         store.deletePdf();
                      //                                         return;
                      //                                       }
                      //                                       store
                      //                                           .deleteOnePhoto(
                      //                                               index:
                      //                                                   index);
                      //                                     },
                      //                                     child: const Icon(
                      //                                       Icons.close,
                      //                                       color: Colors.white,
                      //                                       size: 14,
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                             ],
                      //                           );
                      //                         },
                      //                       ),
                      //                       CustomTextButton(
                      //                         onTap: () async {
                      //                           if (state is EditingAddingPdf) {
                      //                             final path =
                      //                                 state.photoPaths[0];
                      //                             final File file = File(path);
                      //                             await store.sendPdf(
                      //                                 pdfFile: file,
                      //                                 documentHasDeclarationToShow:
                      //                                     false); // Verificar depois
                      //                           } else {
                      //                             await store.sendPhotos(
                      //                                 documentId:
                      //                                     state.documentId,
                      //                                 scholarshipProofDocumentId:
                      //                                     state
                      //                                         .scholarshipProofDocumentId);
                      //                           }
                      //                           if (store.error == null &&
                      //                               store.sendProofDocumentStore
                      //                                       .error ==
                      //                                   null) {
                      //                             getProofs();
                      //                             showSuccessfulAttachmentDialog(
                      //                                 context: stateContext);
                      //                           }
                      //                         },
                      //                         label: 'Enviar',
                      //                         labelColor: primaryColor,
                      //                       ),
                      //                     ],
                      //                   )
                      //                 : Column(
                      //                     mainAxisSize: MainAxisSize.min,
                      //                     children: [
                      //                       DottedBorderButton(
                      //                         leading: Icon(
                      //                             Icons.camera_alt_rounded,
                      //                             color: primaryColor,
                      //                             size: 20),
                      //                         label: takeAPhoto,
                      //                         labelColor: primaryColor,
                      //                         /*onTap: () async {
                      //                           await store.takePhoto(
                      //                               documentId: documentId,
                      //                               scholarshipProofDocumentId: scholarshipProofDocumentId,
                      //                               isRequiredDocument: true);
                      //                           // if (successfullySentDocuments) {
                      //                           //   showSuccessfulAttachmentDialog(context: context);
                      //                           // }
                      //                         },*/
                      //                         onTap: () async {
                      //                           await store.takeDocumentScanner(
                      //                               documentId: documentId,
                      //                               scholarshipProofDocumentId:
                      //                                   scholarshipProofDocumentId,
                      //                               isRequiredDocument: true,
                      //                               context: context);
                      //                         },
                      //                       ),
                      //                       const SizedBox(height: 14),
                      //                       DottedBorderButton(
                      //                         leading: Icon(
                      //                             Icons.attachment_rounded,
                      //                             color: primaryColor,
                      //                             size: 20),
                      //                         label: selectFromCellphone,
                      //                         labelColor: primaryColor,
                      //                         onTap: () {
                      //                           store.setNewAcceptedDocumentValues(
                      //                               documentId: documentId,
                      //                               scholarshipProofDocumentId:
                      //                                   scholarshipProofDocumentId);
                      //                           store.initAddingFromCellphone();
                      //                         },
                      //                       ),
                      //                     ],
                      //                   ),
                      //           ),
                      //           isExpanded: true,
                      //           subGroupCard: SubGroupCard.initial(
                      //             title:
                      //                 proofs.entityProofConfig.entityProof.name,
                      //             onTap: () async {},
                      //           ),
                      //         )
                      //       : ExpansionSubGroupCardV2(
                      //           isExpanded: state is ConfirmEditing &&
                      //               state.editingScholarshipProofDocumentId ==
                      //                   scholarshipProofDocumentId,
                      //           subGroupCard: SubGroupCard.builder(
                      //               isError: !scholarshipProofDocument
                      //                   .scholarshipProofDocumentReviews
                      //                   .first
                      //                   .resend,
                      //               title: proofs
                      //                   .entityProofConfig.entityProof.name,
                      //               onTap: () async {
                      //                 final state = store.state;
                      //                 final files = state.files;

                      //                 if (scholarshipProofDocument.fileId !=
                      //                     null) {
                      //                   final hasAlreadyGottenThisDocumentFile =
                      //                       files.any((element) =>
                      //                           element.fileId ==
                      //                           scholarshipProofDocument
                      //                               .fileId);
                      //                   if (!hasAlreadyGottenThisDocumentFile) {
                      //                     final fileId =
                      //                         scholarshipProofDocument.fileId!;
                      //                     final result =
                      //                         store.getDocumentByFileIdStore(
                      //                             get_document_by_file_id
                      //                                 .Params(fileId: fileId));
                      //                     result.then((value) {
                      //                       final file = store
                      //                           .getDocumentByFileIdStore
                      //                           .state
                      //                           .acceptedDocumentFile;
                      //                       final fileUrl = file.url;
                      //                       final fileName = file.name;
                      //                       final filesList = store.state.files;
                      //                       final newFileList = [
                      //                         ...filesList,
                      //                         AcceptedDocumentFileViewModel(
                      //                             fileId: fileId,
                      //                             fileUrl: fileUrl,
                      //                             fileName: fileName)
                      //                       ];
                      //                       store.update(store.state
                      //                           .copyWith(files: newFileList));
                      //                     });
                      //                   }
                      //                 }
                      //                 if (state is! ConfirmEditing ||
                      //                     state.editingScholarshipProofDocumentId !=
                      //                         scholarshipProofDocumentId) {
                      //                   store.showResendOption(
                      //                     ConfirmEditing(
                      //                         documentId: documentId,
                      //                         scholarshipProofDocumentId:
                      //                             scholarshipProofDocumentId,
                      //                         editingScholarshipProofDocumentId:
                      //                             scholarshipProofDocumentId,
                      //                         stateBeforeEditing:
                      //                             state is Editing
                      //                                 ? state.stateBeforeEditing
                      //                                 : state,
                      //                         files: state.files,
                      //                         selectedAcceptedDocumentName:
                      //                             'TROCAR 3',
                      //                         //scholarshipProofDocument.name,
                      //                         originalAcceptedDocumentId:
                      //                             documentId,
                      //                         scholarshipReviewId:
                      //                             state.scholarshipReviewId),
                      //                   );
                      //                 } else {
                      //                   store.exitEditingMode();
                      //                 }
                      //               }),
                      //           content: Column(
                      //             children: [
                      //               const SizedBox(height: 12),
                      //               fileViewModel != null
                      //                   ? StatefulBuilder(
                      //                       builder: (context, setState) =>
                      //                           GestureDetector(
                      //                         onTap: lockDocumentOpening
                      //                             ? null
                      //                             : () {
                      //                                 setState(() {
                      //                                   lockDocumentOpening =
                      //                                       true;
                      //                                 });
                      //                                 final url = fileViewModel!
                      //                                     .fileUrl;
                      //                                 canLaunchUrlString(url)
                      //                                     .then((canLaunch) {
                      //                                   if (canLaunch) {
                      //                                     launchUrlString(url,
                      //                                         mode: Platform
                      //                                                 .isAndroid
                      //                                             ? LaunchMode
                      //                                                 .externalApplication
                      //                                             : Platform
                      //                                                     .isIOS
                      //                                                 ? LaunchMode
                      //                                                     .inAppWebView
                      //                                                 : LaunchMode
                      //                                                     .platformDefault);
                      //                                   } else {
                      //                                     showSnackBar(
                      //                                         'Não foi possível abrir o documento');
                      //                                   }
                      //                                 }).whenComplete(() {
                      //                                   setState(() {
                      //                                     lockDocumentOpening =
                      //                                         false;
                      //                                   });
                      //                                 });
                      //                               },
                      //                         child: Container(
                      //                           padding:
                      //                               const EdgeInsets.all(8),
                      //                           decoration: BoxDecoration(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(8),
                      //                             border: Border.all(
                      //                                 color: const Color(
                      //                                     0xFFF6F6F6)),
                      //                           ),
                      //                           child: Row(
                      //                             mainAxisAlignment:
                      //                                 MainAxisAlignment.start,
                      //                             children: [
                      //                               const Icon(
                      //                                   Icons.picture_as_pdf,
                      //                                   color: Colors.red),
                      //                               const SizedBox(width: 5),
                      //                               Expanded(
                      //                                 child: Text(
                      //                                   fileViewModel!.fileName,
                      //                                   overflow: TextOverflow
                      //                                       .ellipsis,
                      //                                 ),
                      //                               ),
                      //                               const Icon(Icons
                      //                                   .fullscreen_rounded),
                      //                             ],
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     )
                      //                   : const CircularProgressIndicator(),
                      //               TextButton(
                      //                 child: const Text('Substituir'),
                      //                 onPressed: () {
                      //                   if (state is ConfirmEditing) {
                      //                     showResendNewDocumentDialog(
                      //                         context: context,
                      //                         onTapYes: (context) async {
                      //                           Navigator.maybePop(context);
                      //                           store.startSendingOneDocument(
                      //                             EditingSet(
                      //                               documentId: documentId,
                      //                               scholarshipProofDocumentId:
                      //                                   scholarshipProofDocumentId,
                      //                               editingScholarshipProofDocumentId:
                      //                                   state
                      //                                       .editingScholarshipProofDocumentId,
                      //                               stateBeforeEditing: state
                      //                                   .stateBeforeEditing,
                      //                               files: state.files,
                      //                               selectedAcceptedDocumentName:
                      //                                   proofs.entityProofConfig
                      //                                       .entityProof.name,
                      //                               originalAcceptedDocumentId:
                      //                                   state
                      //                                       .originalAcceptedDocumentId,
                      //                               scholarshipReviewId: state
                      //                                   .scholarshipReviewId,
                      //                             ),
                      //                           );
                      //                         },
                      //                         onTapNo: (context) {
                      //                           Navigator.maybePop(context);
                      //                         });
                      //                   }
                      //                 },
                      //               ),
                      //             ],
                      //           ),
                      //           trailingWhenExpanded: const Icon(
                      //             Icons.close,
                      //             color: Color(0xFFB1F3D4),
                      //           ),
                      //         ),
                      // );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  Future<int?> showAcceptedDocuments(
    BuildContext context,
    List<AcceptedDocument> acceptedDocuments,
    String? currentlySelectedAcceptedDocumentId,
    String proofItemConfigId,
  ) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final List<AcceptedDocument> newAcceptedDocuments = acceptedDocuments
        .where((doc) => doc.proofItemConfigId == proofItemConfigId)
        .toList();
    return showCustomModalBottomSheet<int>(
      context: context,
      hasScrollIcon: true,
      content: (context) => Container(
        padding: const EdgeInsets.fromLTRB(32, 30, 32, 26),
        child: ListView.separated(
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemCount: newAcceptedDocuments.length,
          itemBuilder: (context, index) {
            return ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              title: Text(newAcceptedDocuments[index].name,
                  maxLines: 4, textAlign: TextAlign.center
                  //overflow: TextOverflow.ellipsis,
                  ),
              selected: newAcceptedDocuments[index].id ==
                  currentlySelectedAcceptedDocumentId,
              selectedColor: Colors.white,
              selectedTileColor: primaryColor,
              tileColor: const Color(0xFFF1FAFF),
              textColor: primaryColor,
              onTap: () {
                final originalIndex = acceptedDocuments.indexWhere(
                  (doc) =>
                      doc.id == newAcceptedDocuments[index].id &&
                      doc.proofItemConfigId ==
                          newAcceptedDocuments[index].proofItemConfigId,
                );
                newAcceptedDocuments[index];
                Modular.to.pop(originalIndex);
              },
            );
          },
        ),
      ),
    );
  }
}

// Future<int?> showAcceptedDocuments(
//     BuildContext context,
//     List<AcceptedDocument> acceptedDocuments,
//     String? currentlySelectedAcceptedDocumentId) {
//   final primaryColor = Theme.of(context).colorScheme.primary;
//   return showCustomModalBottomSheet<int>(
//     context: context,
//     hasScrollIcon: true,
//     content: (context) => Container(
//       padding: const EdgeInsets.fromLTRB(32, 30, 32, 26),
//       child: ListView.separated(
//         separatorBuilder: (_, __) => const SizedBox(height: 16),
//         itemCount: acceptedDocuments.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(24)),
//             title: Text(acceptedDocuments[index].name,
//                 maxLines: 4, textAlign: TextAlign.center
//                 //overflow: TextOverflow.ellipsis,
//                 ),
//             selected: acceptedDocuments[index].id ==
//                 currentlySelectedAcceptedDocumentId,
//             selectedColor: Colors.white,
//             selectedTileColor: primaryColor,
//             tileColor: const Color(0xFFF1FAFF),
//             textColor: primaryColor,
//             onTap: () {
//               acceptedDocuments[index];
//               Modular.to.pop(index);
//             },
//           );
//         },
//       ),
//     ),
//   );
// }
//}

//TODO(adbysantos): Fazer componentização da bottom sheet de declaração
const declaration =
    'Declaro a veracidade e autenticidade do documento inserido/anexado e das informações prestadas por mim nesta declaração, ciente de que em caso de omissão ou falsidade estarei sujeito às sanções legais e até mesmo ao cancelamento da bolsa (Lei Complementar nº 187/2021).';
