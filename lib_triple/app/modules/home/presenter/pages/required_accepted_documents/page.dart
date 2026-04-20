import 'dart:developer';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:localization/localization.dart';
import 'package:open_document/open_document.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/icons/ebolsas_icons_icons.dart';
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
import '../../../domain/usecases/get_accepted_documents_by_proof/entity.dart';
import '../../../domain/usecases/get_proofs_by_family_params/entity.dart';
import '../select_group_document/stores/usecases/get_accepted_documents_by_proof/store.dart'
    as accepted_documents;
import '../stores/usecases/get_document_by_file_id/store.dart'
    as get_document_by_file_id;
import 'controller.dart';
import 'states.dart';

class Page extends StatefulWidget {
  const Page({Key? key}) : super(key: key);

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  final controller = Modular.get<Controller>();

  late IconData icon;
  late String groupName;
  late String groupDocumentName;
  late Proof proof;
  late List<AcceptedDocument> acceptedDocuments;
  List<AcceptedDocument> nonRequiredAcceptedDocuments = [];
  List<AcceptedDocument> requiredAcceptedDocuments = [];
  List<AcceptedDocument> finalAcceptedDocuments = [];
  List<ScholarshipProofDocument> scholarshipProofDocuments = [];
  List<AcceptedDocument> acceptedDocument = [];
  late String documentNameEditing;

  late String takeAPhoto;
  late String selectFromCellphone;

  Disposer? exceptionsObserver;
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
        .setCurrentScreen(screenName: 'Required_Accepeted_Documents_Page');
    icon = controller.groupDocumentParams.icon ?? EbolsasIcons.icon_metro_home;
    groupName = controller.groupDocumentParams.groupName ?? 'NCA';
    groupDocumentName =
        controller.groupDocumentParams.groupDocumentName ?? 'NCA';
    proof = controller.groupDocumentParams.proof!;
    initLocalizedStrings();
    // ignore: unused_local_variable
    for (final result in proof.entityProofConfig.proofItemConfigs) {
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
    groupNonRequiredDocs(acceptedDocument);
    initScholarshipDocuments(
        controller.groupDocumentParams.scholarshipProofDocuments ?? []);
    exceptionsObserver = controller.observer(onError: showSnackBar);
  }

  void groupNonRequiredDocs(List<AcceptedDocument> acceptedDocuments) {
    nonRequiredAcceptedDocuments.clear();
    nonRequiredAcceptedDocuments.clear();
    requiredAcceptedDocuments.clear();
    finalAcceptedDocuments.clear();
    for (final acceptedDocument in acceptedDocuments) {
      if (false) {
        requiredAcceptedDocuments.add(acceptedDocument);
      } else {
        nonRequiredAcceptedDocuments.add(acceptedDocument);
      }
    }
    finalAcceptedDocuments.addAll(nonRequiredAcceptedDocuments);
  }

  void initScholarshipDocuments(
      List<ScholarshipProofDocument> newScholarshipProofDocuments) {
    scholarshipProofDocuments.clear();
    scholarshipProofDocuments.addAll(newScholarshipProofDocuments);
  }

  bool get successfullySentDocuments =>
      controller.sendProofDocumentStore.error == null;

  bool get isEdit => controller.groupDocumentParams.isEdit;

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
    controller.setLoading(true, force: true);
    if (controller.params.proofParams == null) {
      return log(
        'Proof Params está nulo',
      );
    }
    await controller.getProofsStore(controller.params.proofParams!);
    final proof = controller.getProofsStore.state.proofs.firstWhere(
        ((element) => element.id == controller.groupDocumentParams.proofId));
    initScholarshipDocuments(proof.scholarshipProofDocuments);
    await controller
        .getAcceptedDocumentsByProofStore(accepted_documents.Params(proof.id));
    final documents =
        controller.getAcceptedDocumentsByProofStore.state.acceptedDocuments;
    groupNonRequiredDocs(documents);
    controller.update(controller.state, force: true);
    controller.setLoading(false, force: true);
  }

  @override
  Widget build(BuildContext context) {
    final documents = proof.scholarshipProofDocuments;
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
              child: ScopedBuilder<Controller, String, StoreState>(
                  store: controller,
                  onLoading: (context) =>
                      const Center(child: CircularProgressIndicator()),
                  onState: (stateContext, state) {
                    return ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 24),
                        physics: const ClampingScrollPhysics(),
                        itemCount: scholarshipProofDocuments.length,
                        itemBuilder: (context, index) {
                          final scholarshipProofDocument = controller
                              .groupDocumentParams
                              .scholarshipProofDocuments![index];
                          final scholarshipProofDocumentId =
                              scholarshipProofDocument.id;
                          //** */

                          final fileId = scholarshipProofDocument.fileId;
                          final proofItemConfigId =
                              scholarshipProofDocument.proofItemConfigId;

                          final isEmptyOrEditing = (fileId == null ||
                                  fileId.isEmpty) ||
                              (state is Editing &&
                                  (state).editingScholarshipProofDocumentId ==
                                      scholarshipProofDocumentId &&
                                  state is! ConfirmEditing);

                          documentNameEditing = (fileId != null)
                              ? scholarshipProofDocuments[index]
                                  .documentId! //scholarshipProofDocument.documentId!
                              : '';

                          final isExpanded = (controller
                                      .state.documentId.isNotEmpty &&
                                  scholarshipProofDocumentId ==
                                      controller
                                          .state.scholarshipProofDocumentId) ||
                              (controller.state is Editing &&
                                  (controller.state as Editing)
                                          .editingScholarshipProofDocumentId ==
                                      scholarshipProofDocumentId &&
                                  controller.state is! ConfirmEditing);

                          // Filtra os documentos aceitos referentes a esse item
                          final acceptedDocumentsForThisItem = acceptedDocument
                              .where((doc) =>
                                  doc.proofItemConfigId == proofItemConfigId)
                              .toList();

                          // Documento selecionado, se já houver
                          AcceptedDocument? selectedDocument;
                          String documentId = '';

                          if (isEdit) {
                            documentId = scholarshipProofDocumentId;
                          }

                          if (controller.state.documentId.isNotEmpty) {
                            selectedDocument = acceptedDocument.firstWhere(
                              (doc) => doc.id == controller.state.documentId,
                              orElse: () =>
                                  acceptedDocumentsForThisItem.isNotEmpty
                                      ? acceptedDocumentsForThisItem.first
                                      : AcceptedDocument.empty(),
                            );
                            documentId = selectedDocument.id;
                          }

                          // Busca o arquivo já carregado (se houver)
                          final files = controller.state.files;
                          AcceptedDocumentFileViewModel? fileViewModel;
                          for (final file in files) {
                            if (file.fileId ==
                                scholarshipProofDocument.fileId) {
                              fileViewModel = file;
                              break;
                            }
                          }

                          // final isEmptyOrEditing = (fileId == null ||
                          //         fileId.isEmpty) ||
                          //     (controller.state is Editing &&
                          //         (controller.state as Editing)
                          //                 .editingScholarshipProofDocumentId ==
                          //             scholarshipProofDocumentId &&
                          //         controller.state is! ConfirmEditing);

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            child: isEmptyOrEditing
                                ? ExpansionSubGroupCardV2(
                                    content: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: state is Adding
                                          ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GridView.builder(
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent:
                                                              75),
                                                  itemCount:
                                                      state.photoPaths.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final path =
                                                        state.photoPaths[index];
                                                    final file = File(path);
                                                    return Stack(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(7),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            child: (state
                                                                        is NewAddingPdf ||
                                                                    state
                                                                        is EditingAddingPdf)
                                                                ? const Icon(
                                                                    Icons
                                                                        .picture_as_pdf_rounded,
                                                                    color: Colors
                                                                        .red)
                                                                : Image.file(
                                                                    file,
                                                                    cacheHeight:
                                                                        60,
                                                                    cacheWidth:
                                                                        60,
                                                                    height: 60,
                                                                    width: 60,
                                                                  ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              if (state
                                                                      is EditingAddingPdf ||
                                                                  state
                                                                      is NewAddingPdf) {
                                                                OpenDocument
                                                                    .openDocument(
                                                                        filePath:
                                                                            path);
                                                                return;
                                                              }
                                                              controller
                                                                  .openPhotoFromFile(
                                                                      file:
                                                                          file);
                                                            },
                                                            child: const Icon(Icons
                                                                .zoom_in_rounded),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    primaryColor),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                if (state
                                                                        is EditingAddingPdf ||
                                                                    state
                                                                        is NewAddingPdf) {
                                                                  controller
                                                                      .deletePdf();
                                                                  return;
                                                                }
                                                                controller
                                                                    .deleteOnePhoto(
                                                                        index:
                                                                            index);
                                                              },
                                                              child: const Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
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
                                                              is NewAddingPdf ||
                                                          state
                                                              is EditingAddingPdf) {
                                                        final path =
                                                            state.photoPaths[0];
                                                        final file = File(path);
                                                        // VERIFICAR DEPOIS ----------------------------------------------------------------------------------------------------------------
                                                        await controller.sendPdf(
                                                            pdfFile: file,
                                                            documentHasDeclarationToShow:
                                                                false,
                                                            fileId: scholarshipProofDocuments[
                                                                        index]
                                                                    .fileId ??
                                                                'OK');
                                                      } else {
                                                        await controller.sendPhotos(
                                                            documentId: state
                                                                .documentId,
                                                            scholarshipProofDocumentId:
                                                                state
                                                                    .scholarshipProofDocumentId);
                                                      }
                                                      if (controller.error ==
                                                              null &&
                                                          controller
                                                                  .sendProofDocumentStore
                                                                  .error ==
                                                              null) {
                                                        getProofs();
                                                        showSuccessfulAttachmentDialog(
                                                            context:
                                                                stateContext);
                                                      }
                                                    },
                                                    label: 'Enviar',
                                                    labelColor: primaryColor),
                                              ],
                                            )
                                          : Column(
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
                                                  await controller.takePhoto(
                                                      scholarshipProofDocumentId: scholarshipProofDocumentId, documentId: documentId);
                                                  // if (successfullySentDocuments) {
                                                  //   showSuccessfulAttachmentDialog(context: context);
                                                  // }
                                                },*/
                                                  onTap: () async {
                                                    await controller
                                                        .takeDocumentScanner(
                                                            documentId:
                                                                documentId,
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
                                                  onTap: controller
                                                      .initAddingFromCellphone,
                                                ),
                                              ],
                                            ),
                                    ),
                                    // isExpanded:
                                    //     controller.state.scholarshipProofId ==
                                    //         proof.id,
                                    // isExpanded: isEmptyOrEditing ||
                                    //     (controller.state.documentId.isNotEmpty &&
                                    //         controller.state.documentId ==
                                    //             documentId),
                                    isExpanded: isExpanded,
                                    subGroupCard: SubGroupCard.initial(
                                      title: (controller.state.documentId ==
                                                  documentId &&
                                              controller.state
                                                      .scholarshipProofDocumentId ==
                                                  scholarshipProofDocumentId)
                                          ? controller.state
                                              .selectedAcceptedDocumentName
                                          : 'Selecione',
                                      onTap: () async {
                                        final selectedIndex =
                                            await showAcceptedDocuments(
                                          context,
                                          acceptedDocument,
                                          controller.state.documentId,
                                          proofItemConfigId,
                                        );

                                        if (selectedIndex == null) return;

                                        final selected =
                                            acceptedDocument[selectedIndex];

                                        if (selected.isDeclaration) {
                                          await showCustomModalBottomSheet(
                                            context: context,
                                            content: (context) => Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  32, 32, 32, 32),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                    declaration,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 24),
                                                  AlternativeRoundedButton(
                                                    label: 'Estou ciente',
                                                    onTap: () =>
                                                        Navigator.maybePop(
                                                            context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }

                                        controller.setNewAcceptedDocumentValues(
                                          documentId: selected.id,
                                          scholarshipProofDocumentId:
                                              scholarshipProofDocumentId,
                                          documentName: selected.name,
                                        );
                                      },
                                    ),
                                  )
                                : ExpansionSubGroupCardV2(
                                    isExpanded: state is ConfirmEditing &&
                                        state.editingScholarshipProofDocumentId ==
                                            scholarshipProofDocumentId,
                                    subGroupCard: SubGroupCard.success(
                                        title: acceptedDocument
                                            .firstWhere(
                                                (doc) =>
                                                    doc.id ==
                                                    documentNameEditing,
                                                orElse: () =>
                                                    AcceptedDocument.empty())
                                            .name,
                                        //selectedDocument?.name ?? groupDocumentName,
                                        onTap: () async {
                                          final state = controller.state;
                                          final files = state.files;

                                          if (scholarshipProofDocument.fileId !=
                                              null) {
                                            //if (document == null) return;
                                            final hasAlreadyGottenThisDocumentFile =
                                                files.any((element) =>
                                                    element.fileId ==
                                                    scholarshipProofDocument
                                                        .fileId);
                                            if (!hasAlreadyGottenThisDocumentFile) {
                                              final fileId =
                                                  scholarshipProofDocument
                                                      .fileId!;
                                              final result = controller
                                                  .getDocumentByFileIdStore(
                                                      get_document_by_file_id
                                                          .Params(
                                                              fileId: fileId));
                                              result.then((value) {
                                                final file = controller
                                                    .getDocumentByFileIdStore
                                                    .state
                                                    .acceptedDocumentFile;
                                                final fileUrl = file.url;
                                                final fileName = file.name;
                                                final filesList =
                                                    controller.state.files;
                                                final newFileList = [
                                                  ...filesList,
                                                  AcceptedDocumentFileViewModel(
                                                      fileId: fileId,
                                                      fileUrl: fileUrl,
                                                      fileName: fileName)
                                                ];
                                                controller.update(
                                                    controller.state.copyWith(
                                                        files: newFileList));
                                              });
                                            }
                                          }
                                          if (state is! ConfirmEditing ||
                                              state.editingScholarshipProofDocumentId !=
                                                  scholarshipProofDocumentId) {
                                            controller.showResendOption(
                                              ConfirmEditing(
                                                  documentId: documentId,
                                                  scholarshipProofDocumentId:
                                                      scholarshipProofDocumentId,
                                                  editingScholarshipProofDocumentId:
                                                      scholarshipProofDocumentId,
                                                  stateBeforeEditing: state
                                                          is Editing
                                                      ? state.stateBeforeEditing
                                                      : state,
                                                  files: state.files,
                                                  selectedAcceptedDocumentName:
                                                      acceptedDocument
                                                          .firstWhere(
                                                            (doc) =>
                                                                doc.proofItemConfigId ==
                                                                proofItemConfigId,
                                                          )
                                                          .name),
                                            );
                                          } else {
                                            controller.exitEditingMode();
                                          }
                                        }),
                                    content: Column(
                                      children: [
                                        const SizedBox(height: 12),
                                        fileViewModel != null
                                            ? StatefulBuilder(
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
                                              )
                                            : const CircularProgressIndicator(),
                                        TextButton(
                                          child: const Text('Substituir'),
                                          onPressed: () {
                                            if (state is ConfirmEditing) {
                                              showResendNewDocumentDialog(
                                                  context: context,
                                                  message: 'substituir',
                                                  onTapYes: (context) {
                                                    Navigator.maybePop(context);
                                                    controller
                                                        .startSendingOneDocument(
                                                      EditingSet(
                                                          documentId:
                                                              documentId,
                                                          scholarshipProofDocumentId:
                                                              scholarshipProofDocumentId,
                                                          editingScholarshipProofDocumentId:
                                                              state
                                                                  .editingScholarshipProofDocumentId,
                                                          stateBeforeEditing: state
                                                              .stateBeforeEditing,
                                                          files: state.files,
                                                          selectedAcceptedDocumentName:
                                                              'Selecione'),
                                                    );
                                                  },
                                                  onTapNo: (context) {
                                                    Navigator.maybePop(context);
                                                  });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    trailingWhenExpanded: const Icon(
                                      Icons.close,
                                      color: Color(0xFFB1F3D4),
                                    ),
                                  ),
                          );
                        });
                  }))
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

//TODO(adbysantos): Fazer componentização da bottom sheet de declaração
const declaration =
    'Declaro a veracidade e autenticidade do documento inserido/anexado e das informações prestadas por mim nesta declaração, ciente de que em caso de omissão ou falsidade estarei sujeito às sanções legais e até mesmo ao cancelamento da bolsa (Lei Complementar nº 187/2021).';
