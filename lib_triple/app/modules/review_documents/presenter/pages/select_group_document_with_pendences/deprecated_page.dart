// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:flutter_triple/flutter_triple.dart' as triple;
// import 'package:localization/localization.dart';
// import 'package:open_document/open_document.dart';
// import 'package:simple_html_css/simple_html_css.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// import '../../../../../core/widgets/alternative_rounded_button.dart';
// import '../../../../../core/widgets/custom_app_bar.dart';
// import '../../../../../core/widgets/custom_rounded_button.dart';
// import '../../../../../core/widgets/custom_scaffold.dart';
// import '../../../../../core/widgets/custom_text_button.dart';
// import '../../../../../core/widgets/dotted_border_button.dart';
// import '../../../../../core/widgets/expansion_sub_group_card.dart';
// import '../../../../../core/widgets/show_custom_modal_bottom_sheet.dart';
// import '../../../../../core/widgets/show_resend_new_document_dialog.dart';
// import '../../../../../core/widgets/show_successful_attachment_dialog.dart';
// import '../../../../../core/widgets/sub_group_card.dart';
// import '../../../../home/presenter/pages/select_group_document/stores/usecases/get_accepted_documents_by_proof/store.dart' as get_accepted_documents_by_proof;
// import '../../../../home/presenter/pages/stores/usecases/get_document_by_file_id/store.dart' as get_document_by_file_id;
// import '../../stores/usecases/get_proofs_with_pendences_by_family_params/store.dart' as get_proofs_with_pendences_by_family_member;
// import 'group_with_pendences_dto.dart';
// import 'store.dart';
// import 'store_state.dart';

// class Page extends StatefulWidget {
//   final GroupWithPendencesDto groupWithPendencesDto;
//   const Page({Key? key, required this.groupWithPendencesDto}) : super(key: key);

//   @override
//   State<Page> createState() => _PageState();
// }

// class _PageState extends State<Page> {
//   final store = Modular.get<Store>();
//   late IconData icon;
//   late String groupName;
//   triple.Disposer? exceptionsObserver;

//   @override
//   void initState() {
//     super.initState();
//     initLocalizedStrings();

//     icon = widget.groupWithPendencesDto.groupIcon;
//     groupName = widget.groupWithPendencesDto.groupName;

//     final scholarshipReviewId = widget.groupWithPendencesDto.scholarshipReviewId;
//     final getProofsWithPendencesParams = widget.groupWithPendencesDto.getProofsWithPendencesParams;
//     store.init(scholarshipReviewId: scholarshipReviewId, getProofsWithPendencesParams: getProofsWithPendencesParams);
//     exceptionsObserver = store.observer(
//       onError: (exception) => showSnackBar(exception),
//     );
//   }

//   @override
//   void dispose() {
//     exceptionsObserver?.call();
//     store.reset();
//     super.dispose();
//   }

//   void showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   late String emptyProofList;
//   late String takeAPhoto;
//   late String selectFromCellphone;
//   late String noAcceptedDocuments;
//   late String unableToFindAcceptedDocuments;
//   late String acceptedDocumentsException;
//   late String emptyAcceptedDocumentsList;
//   late String acceptTermLabel;

//   String getLocalization(String attribute, {List<String>? params}) {
//     return 'select_group_document_$attribute'.i18n(params ?? []);
//   }

//   void initLocalizedStrings() {
//     emptyProofList = getLocalization('empty_proof_list');
//     takeAPhoto = getLocalization('take_a_photo');
//     selectFromCellphone = getLocalization('select_from_cellphone');
//     noAcceptedDocuments = getLocalization('no_accepted_documents');
//     unableToFindAcceptedDocuments = getLocalization('unable_to_find_accepted_documents');
//     acceptedDocumentsException = getLocalization('accepted_documents_exception');
//     emptyAcceptedDocumentsList = getLocalization('empty_accepted_documents_list');
//     acceptTermLabel = getLocalization('accept_term_label');
//   }

//   bool get successfullySentDocuments => store.sendProofDocumentWithPendencesStore.error == null;

//   bool lockDocumentOpening = false;

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).colorScheme.primary;
//     return CustomScaffold(
//       appBar: const CustomAppBar(),
//       body: Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.only(left: 32, top: 24, right: 32),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   icon,
//                   size: 23,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     groupName,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       color: Theme.of(context).colorScheme.primary,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//           Expanded(
//             child: triple.ScopedBuilder<get_proofs_with_pendences_by_family_member.Store, String, get_proofs_with_pendences_by_family_member.Entity>(
//               store: store.getProofsWithPendencesStore,
//               onError: (context, error) => Center(child: Text(error.toString())),
//               onLoading: (context) => const Center(child: CircularProgressIndicator()),
//               onState: (context, state) {
//                 final acceptedDocumentsStore = store.getAcceptedDocumentsByProofStore;
//                 final proofs = state.proofs;
//                 if (proofs.isEmpty) {
//                   return Text(
//                     emptyProofList,
//                     style: const TextStyle(fontSize: 16),
//                   );
//                 }
//                 return triple.ScopedBuilder<Store, String, StoreState>(
//                   store: store,
//                   onState: (stateContext, state) {
//                     return ListView.separated(
//                       separatorBuilder: (context, index) => const SizedBox(height: 24),
//                       physics: const ClampingScrollPhysics(),
//                       itemCount: proofs.length + 1,
//                       itemBuilder: (context, index) {
//                         if (index == proofs.length) {
//                           return const SizedBox(height: 20);
//                         }
//                         final proof = proofs[index];
//                         final files = store.state.files;
//                         AcceptedDocumentFileViewModel? fileViewModel;
//                         for (final file in files) {
//                           if (file.fileId == proof.scholarshipProofDocuments.first.fileId) {
//                             fileViewModel = file;
//                             break;
//                           }
//                         }
//                         return Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 32),
//                           child: !proof.scholarshipProofDocuments.first.userHasResent || (state is Editing && proof.id == state.editingProofId && state is! ConfirmEditing)
//                               ? ExpansionSubGroupCardV2(
//                                   key: Key(proof.id),
//                                   content: Container(
//                                     margin: const EdgeInsets.symmetric(vertical: 10),
//                                     child: state is Adding
//                                         ? Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               GridView.builder(
//                                                 shrinkWrap: true,
//                                                 gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 75),
//                                                 itemCount: state.photoPaths.length,
//                                                 itemBuilder: (context, index) {
//                                                   final path = state.photoPaths[index];
//                                                   final file = File(path);
//                                                   return Stack(
//                                                     children: [
//                                                       Container(
//                                                         margin: const EdgeInsets.all(7),
//                                                         child: ClipRRect(
//                                                           borderRadius: BorderRadius.circular(6),
//                                                           child: (state is NewAddingPdf || state is EditingAddingPdf) ? const Icon(Icons.picture_as_pdf_rounded, color: Colors.red) : Image.file(file, cacheHeight: 60, cacheWidth: 60, height: 60, width: 60),
//                                                         ),
//                                                       ),
//                                                       Align(
//                                                         alignment: Alignment.center,
//                                                         child: GestureDetector(
//                                                             onTap: () {
//                                                               if (state is EditingAddingPdf || state is NewAddingPdf) {
//                                                                 OpenDocument.openDocument(filePath: path);
//                                                                 return;
//                                                               }
//                                                               store.openPhotoFromFile(file: file);
//                                                             },
//                                                             child: const Icon(
//                                                               Icons.zoom_in_rounded,
//                                                             )),
//                                                       ),
//                                                       Align(
//                                                         alignment: Alignment.topRight,
//                                                         child: Container(
//                                                           padding: const EdgeInsets.all(3),
//                                                           decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor),
//                                                           child: GestureDetector(
//                                                             onTap: () {
//                                                               if (state is EditingAddingPdf || state is NewAddingPdf) {
//                                                                 store.deletePdf();
//                                                                 return;
//                                                               }
//                                                               store.deleteOnePhoto(index: index);
//                                                             },
//                                                             child: const Icon(
//                                                               Icons.close,
//                                                               color: Colors.white,
//                                                               size: 14,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   );
//                                                 },
//                                               ),
//                                               CustomTextButton(
//                                                   onTap: () async {
//                                                     if (state is NewAddingPdf || state is EditingAddingPdf) {
//                                                       final pdfPaths = state.photoPaths;
//                                                       if (pdfPaths.isEmpty) {
//                                                         store.setError('Você não selecionou um .pdf ou o caminho não foi armazenado');
//                                                         return;
//                                                       }
//                                                       if (pdfPaths.length > 1) {
//                                                         store.setError('Mais de um .pdf foi registrado');
//                                                       }
//                                                       final path = pdfPaths.first;
//                                                       final File file = File(path);
//                                                       await store.sendPdf(pdfFile: file);
//                                                     } else {
//                                                       await store.sendPhotos();
//                                                     }
//                                                     if (store.error != null || store.getProofsWithPendencesStore.error != null) return;
//                                                     showSuccessfulAttachmentDialog(context: stateContext);
//                                                   },
//                                                   label: 'Enviar',
//                                                   labelColor: primaryColor),
//                                             ],
//                                           )
//                                         : Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               DottedBorderButton(
//                                                 leading: Icon(Icons.camera_alt_rounded, color: primaryColor, size: 20),
//                                                 label: takeAPhoto,
//                                                 labelColor: primaryColor,
//                                                 onTap: () async {
//                                                   if (state is Set || (state is EditingSet && proof.id == state.editingProofId)) {
//                                                     await store.takePhoto();
//                                                   }
//                                                 },
//                                               ),
//                                               const SizedBox(height: 14),
//                                               DottedBorderButton(
//                                                 leading: Icon(Icons.attachment_rounded, color: primaryColor, size: 20),
//                                                 label: selectFromCellphone,
//                                                 labelColor: primaryColor,
//                                                 onTap: () {
//                                                   //if (state is Set || (state is SendingNewPdfDocument && proof.id == state.editingProofId)) {
//                                                   if (state is Set) {
//                                                     store.initAddingFromCellphone();
//                                                   }
//                                                 },
//                                               ),
//                                             ],
//                                           ),
//                                   ),
//                                   isExpanded: store.state.selectedProofId == proof.id,
//                                   subGroupCard: SubGroupCard.error(
//                                     title: proof.name,
//                                     onTap: () async {
//                                       if (state is EditingAdding && proof.id == state.editingProofId) {
//                                         return store.exitEditingMode();
//                                       }
//                                       selectedProofIndex = index;
//                                       selectedAcceptedDocumentIndex = null;

//                                       if (proof.description.isNotEmpty) {
//                                         await showCustomModalBottomSheet(
//                                           context: context,
//                                           isScrollControlled: true,
//                                           content: (context) => Container(
//                                             padding: const EdgeInsets.fromLTRB(32, 30, 32, 26),
//                                             child: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     SizedBox(width: MediaQuery.of(context).size.width * 0.82, child: Center(child: Text(proof.name, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.primary)))),
//                                                   ],
//                                                 ),
//                                                 const SizedBox(height: 22),
//                                                 proof.description.contains('<')
//                                                     ? HTML.toRichText(context, proof.description)
//                                                     : Text(
//                                                         proof.description,
//                                                         style: const TextStyle(
//                                                           height: 1.2,
//                                                           color: Color(0xFF6B6B6B),
//                                                         ),
//                                                         textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
//                                                       ),
//                                                 const SizedBox(height: 26),
//                                                 CustomRoundedButton(
//                                                   width: 149,
//                                                   height: 40,
//                                                   onTap: () {
//                                                     Modular.to.pop();
//                                                   },
//                                                   label: acceptTermLabel,
//                                                   labelColor: Theme.of(context).colorScheme.primary,
//                                                   backgroundColor: const Color(0xFFF1FAFF),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       }
//                                       if (selectedProofIndex == null) return;
//                                       final selectedProofId = proofs[selectedProofIndex!].id;
//                                       //controller.setLoading(true, force: true);
//                                       acceptedDocumentsStore(get_accepted_documents_by_proof.Params(selectedProofId)).then((value) async {
//                                         //controller.update(controller.state, force: true);
//                                         //controller.setLoading(false, force: true);
//                                         if (acceptedDocumentsStore.error != null) {
//                                           return store.exceptionOccuredWhenGettingAcceptedDocuments();
//                                         }
//                                         final acceptedDocuments = acceptedDocumentsStore.state.acceptedDocuments;
//                                         if (acceptedDocuments.isEmpty) {
//                                           return showSnackBar(noAcceptedDocuments);
//                                         }
//                                         if (acceptedDocuments.any((element) => element.required == true)) {
//                                           // store.selectGroupDocument(
//                                           //   GroupDocumentParams(
//                                           //     icon: icon,
//                                           //     groupName: groupName,
//                                           //     groupDocumentName: proof.name,
//                                           //     scholarshipProofDocuments: proof.scholarshipProofDocuments,
//                                           //     acceptedDocuments: acceptedDocuments,
//                                           //     proofId: proof.id,
//                                           //   ),
//                                           // );
//                                           return store.goToRequiredAcceptedDocumentsPage();
//                                         }
//                                         if (acceptedDocuments.length == 1) {
//                                           selectedAcceptedDocumentIndex = 0;
//                                           final proofDocument = acceptedDocuments[selectedAcceptedDocumentIndex!];
//                                           final proofDocumentId = proofDocument.id;
//                                           final scholarshipProofDocumentId = proof.scholarshipProofDocuments.firstWhere((element) => element.entityProofItemId == proofDocument.entityProofItemId).id;
//                                           final proofDocumentName = proofDocument.name;
//                                           store.setNewProofDocumentValues(selectedProofId, scholarshipProofDocumentId, proofDocumentId, proofDocumentName);
//                                           return;
//                                         }
//                                         return showAcceptedDocuments(context, acceptedDocumentsStore).then((newIndex) async {
//                                           if (newIndex == null) return;
//                                           selectedAcceptedDocumentIndex = newIndex;

//                                           if (acceptedDocuments.length <= selectedAcceptedDocumentIndex!) {
//                                             showSnackBar(unableToFindAcceptedDocuments);
//                                             return;
//                                           }

//                                           final proofDocument = acceptedDocuments[selectedAcceptedDocumentIndex!];
//                                           final proofDocumentId = proofDocument.id;
//                                           final proofDocumentName = proofDocument.name;
//                                           final scholarshipProofDocument = proof.scholarshipProofDocuments.firstWhere((element) => element.entityProofItemId == proofDocument.entityProofItemId);
//                                           final scholarshipProofDocumentId = scholarshipProofDocument.id;
//                                           if (scholarshipProofDocument.isDeclaration) {
//                                             await showCustomModalBottomSheet(
//                                                 context: context,
//                                                 content: (context) => Container(
//                                                       margin: const EdgeInsets.fromLTRB(32, 32, 32, 32),
//                                                       child: Column(
//                                                         mainAxisSize: MainAxisSize.min,
//                                                         children: [
//                                                           const Text(
//                                                             declaration,
//                                                             style: TextStyle(
//                                                               fontWeight: FontWeight.bold,
//                                                             ),
//                                                           ),
//                                                           const SizedBox(height: 24),
//                                                           AlternativeRoundedButton(
//                                                             label: 'Estou ciente',
//                                                             onTap: () {
//                                                               Navigator.maybePop(context);
//                                                             },
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ));
//                                           }
//                                           store.setNewProofDocumentValues(selectedProofId, scholarshipProofDocumentId, proofDocumentId, proofDocumentName);
//                                         });
//                                       });
//                                     },
//                                   ),
//                                 )
//                               : ExpansionSubGroupCardV2(
//                                   isExpanded: state is ConfirmEditing && state.editingProofId == proof.id,
//                                   subGroupCard: SubGroupCard.success(
//                                       title: proof.name,
//                                       onTap: () async {
//                                         final state = store.state;
//                                         final files = state.files;
//                                         if (!proof.scholarshipProofDocuments.any((element) => element.fileId == null)) {
//                                           final hasAlreadyGottenThisDocumentFile = files.any((element) => element.fileId == proof.id);
//                                           if (!hasAlreadyGottenThisDocumentFile) {
//                                             final fileId = proof.scholarshipProofDocuments.first.fileId!;
//                                             final result = store.getDocumentByFileIdStore(get_document_by_file_id.Params(fileId: fileId));
//                                             result.then((value) {
//                                               final file = store.getDocumentByFileIdStore.state.acceptedDocumentFile;
//                                               final fileUrl = file.url;
//                                               final fileName = file.name;
//                                               final filesList = store.state.files;
//                                               final newFileList = [
//                                                 ...filesList,
//                                                 AcceptedDocumentFileViewModel(fileId: fileId, fileUrl: fileUrl, fileName: fileName)
//                                               ];
//                                               store.update(store.state.copyWith(files: newFileList));
//                                             });
//                                           }
//                                         }
//                                         if (state is! ConfirmEditing || state.editingProofId != proof.id) {
//                                           if (proof.scholarshipProofDocuments.any((element) => element.documentLocked)) {
//                                             return acceptedDocumentsStore(get_accepted_documents_by_proof.Params(proof.id)).then((value) {
//                                               final acceptedDocuments = acceptedDocumentsStore.state.acceptedDocuments;
//                                               if (acceptedDocumentsStore.error != null) {
//                                                 log('Durante edição, exceção ocorreu na busca de comprovantes aceitos');
//                                               }
//                                               if (acceptedDocuments.isEmpty) {
//                                                 log('Durante edição, lista de comprovantes aceitos é vazia');
//                                               }
//                                               // store.selectGroupDocument(
//                                               //   GroupDocumentParams(
//                                               //     icon: icon,
//                                               //     groupName: groupName,
//                                               //     groupDocumentName: proof.name,
//                                               //     scholarshipProofDocuments: proof.scholarshipProofDocuments,
//                                               //     acceptedDocuments: acceptedDocumentsStore.state.acceptedDocuments,
//                                               //     isEdit: true,
//                                               //     proofId: proof.id,
//                                               //   ),
//                                               // );
//                                               return store.goToRequiredAcceptedDocumentsPage();
//                                             });
//                                           }
//                                           if (proof.scholarshipProofDocuments.isEmpty) {
//                                             log('Durante edição, lista de comprovantes é vazia');
//                                             return;
//                                           }
//                                           final scholarshipProofDocumentId = proof.scholarshipProofDocuments.first.id;
//                                           final document = proof.scholarshipProofDocuments.first;
//                                           final documentId = document.documentId;
//                                           if (documentId == null) {
//                                             log('Durante edição, documentId é nulo');
//                                             return;
//                                           }
//                                           StoreState stateBeforeEditing;
//                                           if (state is Editing) {
//                                             stateBeforeEditing = (state).stateBeforeEditing;
//                                           } else {
//                                             stateBeforeEditing = state;
//                                           }
//                                           final documentName = document.name;
//                                           store.showResendOption(ConfirmEditing(
//                                             getProofsWithPendencesParams: state.getProofsWithPendencesParams,
//                                             scholarshipReviewId: state.scholarshipReviewId,
//                                             selectedProofId: proof.id,
//                                             selectedScholarshipProofDocumentId: scholarshipProofDocumentId,
//                                             selectedAcceptedDocumentId: documentId,
//                                             editingProofId: proof.id,
//                                             stateBeforeEditing: stateBeforeEditing,
//                                             files: state.files,
//                                             selectedAcceptedDocumentName: documentName,
//                                           ));
//                                         } else {
//                                           store.exitEditingMode();
//                                         }
//                                       }),
//                                   content: Column(
//                                     children: [
//                                       const SizedBox(height: 12),
//                                       fileViewModel != null
//                                           ? StatefulBuilder(
//                                               builder: (context, setState) => GestureDetector(
//                                                 onTap: lockDocumentOpening
//                                                     ? null
//                                                     : () {
//                                                         setState(() {
//                                                           lockDocumentOpening = true;
//                                                         });
//                                                         final url = fileViewModel!.fileUrl;
//                                                         canLaunchUrlString(url).then((canLaunch) {
//                                                           if (canLaunch) {
//                                                             launchUrlString(url,
//                                                                 mode: Platform.isAndroid
//                                                                     ? LaunchMode.externalApplication
//                                                                     : Platform.isIOS
//                                                                         ? LaunchMode.inAppWebView
//                                                                         : LaunchMode.platformDefault);
//                                                           } else {
//                                                             showSnackBar('Não foi possível abrir o documento');
//                                                           }
//                                                         }).whenComplete(() {
//                                                           setState(() {
//                                                             lockDocumentOpening = false;
//                                                           });
//                                                         });
//                                                       },
//                                                 child: Container(
//                                                   padding: const EdgeInsets.all(8),
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(8),
//                                                     border: Border.all(color: const Color(0xFFF6F6F6)),
//                                                   ),
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.start,
//                                                     children: [
//                                                       const Icon(Icons.picture_as_pdf, color: Colors.red),
//                                                       const SizedBox(width: 5),
//                                                       Expanded(
//                                                         child: Text(
//                                                           fileViewModel!.fileName,
//                                                           overflow: TextOverflow.ellipsis,
//                                                         ),
//                                                       ),
//                                                       const Icon(Icons.fullscreen_rounded),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                           : const CircularProgressIndicator(),
//                                       Builder(
//                                         builder: (context) {
//                                           final scholarshipProofDocument = proof.scholarshipProofDocuments.firstWhere((element) => element.documentId == state.selectedAcceptedDocumentId);
//                                           return Container(
//                                             margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//                                             child: Column(
//                                               children: [
//                                                 RichText(
//                                                   maxLines: 1,
//                                                   overflow: TextOverflow.ellipsis,
//                                                   text: TextSpan(
//                                                     text: 'Observação: ',
//                                                     children: [
//                                                       TextSpan(
//                                                         text: scholarshipProofDocument.observation,
//                                                         style: const TextStyle(
//                                                           fontWeight: FontWeight.normal,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                     style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                                 CustomTextButton(
//                                                     onTap: () {
//                                                       showCustomModalBottomSheet(
//                                                         context: context,
//                                                         content: (context) => Container(
//                                                           padding: const EdgeInsets.fromLTRB(32, 30, 32, 26),
//                                                           child: Column(
//                                                             mainAxisSize: MainAxisSize.min,
//                                                             children: [
//                                                               RichText(
//                                                                 text: TextSpan(
//                                                                   text: 'Observação: ',
//                                                                   children: [
//                                                                     TextSpan(
//                                                                       text: scholarshipProofDocument.observation,
//                                                                       style: const TextStyle(
//                                                                         fontWeight: FontWeight.normal,
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                   style: const TextStyle(color: Color(0xFF6B6B6B), fontWeight: FontWeight.bold),
//                                                                 ),
//                                                               ),
//                                                               const SizedBox(height: 24),
//                                                               AlternativeRoundedButton(
//                                                                 label: 'Estou ciente',
//                                                                 onTap: () {
//                                                                   Navigator.maybePop(context);
//                                                                 },
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       );
//                                                     },
//                                                     label: 'Ler mais',
//                                                     labelColor: const Color(0xFF04A0F9),
//                                                     fontSize: 12),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                       TextButton(
//                                         child: const Text(
//                                           'Substituir',
//                                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                                         ),
//                                         onPressed: () {
//                                           if (state is ConfirmEditing) {
//                                             showResendNewDocumentDialog(
//                                                 context: context,
//                                                 onTapYes: () {
//                                                   Navigator.maybePop(context);
//                                                   final selectedProofId = proof.id;
//                                                   acceptedDocumentsStore(get_accepted_documents_by_proof.Params(proof.id)).then((value) async {
//                                                     if (acceptedDocumentsStore.error != null) {
//                                                       return store.exceptionOccuredWhenGettingAcceptedDocuments();
//                                                     }
//                                                     final acceptedDocuments = acceptedDocumentsStore.state.acceptedDocuments;
//                                                     if (acceptedDocuments.isEmpty) {
//                                                       return showSnackBar(noAcceptedDocuments);
//                                                     }
//                                                     if (acceptedDocuments.length == 1) {
//                                                       selectedAcceptedDocumentIndex = 0;
//                                                       final proofDocument = acceptedDocuments[selectedAcceptedDocumentIndex!];
//                                                       final proofDocumentId = proofDocument.id;
//                                                       final scholarshipProofDocumentId = proof.scholarshipProofDocuments.firstWhere((element) => element.entityProofItemId == proofDocument.entityProofItemId).id;
//                                                       final proofDocumentName = proofDocument.name;
//                                                       store.startSendingOneDocument(EditingSet(
//                                                         getProofsWithPendencesParams: state.getProofsWithPendencesParams,
//                                                         scholarshipReviewId: state.scholarshipReviewId,
//                                                         selectedProofId: selectedProofId,
//                                                         selectedScholarshipProofDocumentId: scholarshipProofDocumentId,
//                                                         selectedAcceptedDocumentId: proofDocumentId,
//                                                         editingProofId: state.editingProofId,
//                                                         stateBeforeEditing: state.stateBeforeEditing,
//                                                         files: state.files,
//                                                         selectedAcceptedDocumentName: proofDocumentName,
//                                                       ));
//                                                       return;
//                                                     }
//                                                     return showAcceptedDocuments(context, acceptedDocumentsStore).then((newIndex) {
//                                                       if (newIndex == null) {
//                                                         return;
//                                                       }
//                                                       selectedAcceptedDocumentIndex = newIndex;

//                                                       if (acceptedDocuments.length <= selectedAcceptedDocumentIndex!) {
//                                                         showSnackBar(unableToFindAcceptedDocuments);
//                                                         return;
//                                                       }

//                                                       final proofDocument = acceptedDocuments[selectedAcceptedDocumentIndex!];
//                                                       final proofDocumentId = proofDocument.id;
//                                                       final proofDocumentName = proofDocument.name;
//                                                       final scholarshipProofDocumentId = proof.scholarshipProofDocuments.firstWhere((element) => element.entityProofItemId == proofDocument.entityProofItemId).id;
//                                                       store.startSendingOneDocument(EditingSet(
//                                                         scholarshipReviewId: state.scholarshipReviewId,
//                                                         getProofsWithPendencesParams: state.getProofsWithPendencesParams,
//                                                         selectedProofId: selectedProofId,
//                                                         selectedScholarshipProofDocumentId: scholarshipProofDocumentId,
//                                                         selectedAcceptedDocumentId: proofDocumentId,
//                                                         editingProofId: state.editingProofId,
//                                                         stateBeforeEditing: state.stateBeforeEditing,
//                                                         files: state.files,
//                                                         selectedAcceptedDocumentName: proofDocumentName,
//                                                       ));
//                                                     });
//                                                   });
//                                                 },
//                                                 onTapNo: () {
//                                                   Navigator.maybePop(context);
//                                                 });
//                                           }
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   trailingWhenExpanded: const Icon(
//                                     Icons.close,
//                                     color: Color(0xFFB1F3D4),
//                                   ),
//                                 ),
//                         );
//                       },
//                     );
//                   },
//                   onLoading: (_) => const Center(child: CircularProgressIndicator()),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   int? selectedProofIndex;

//   int? selectedAcceptedDocumentIndex;

//   Future<int?> showAcceptedDocuments(BuildContext context, get_accepted_documents_by_proof.Store acceptedDocumentsStore) {
//     final primaryColor = Theme.of(context).colorScheme.primary;
//     //acceptedDocumentsStore(accepted_documents.Params(proofId));
//     return showCustomModalBottomSheet<int>(
//       context: context,
//       hasScrollIcon: true,
//       content: (context) => Container(
//         padding: const EdgeInsets.fromLTRB(32, 30, 32, 26),
//         child: triple.ScopedBuilder<get_accepted_documents_by_proof.Store, get_accepted_documents_by_proof.UsecaseException, get_accepted_documents_by_proof.Entity>(
//             store: acceptedDocumentsStore,
//             onLoading: (context) => const Center(child: CircularProgressIndicator()),
//             onError: (context, error) => Center(child: Text(error?.message ?? acceptedDocumentsException)),
//             onState: (context, state) {
//               final acceptedDocuments = state.acceptedDocuments;
//               if (acceptedDocuments.isEmpty) {
//                 return Center(child: Text(emptyAcceptedDocumentsList));
//               }
//               return ListView.separated(
//                 separatorBuilder: (_, __) => const SizedBox(height: 16),
//                 itemCount: acceptedDocuments.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//                     title: Text(acceptedDocuments[index].name, maxLines: 3, textAlign: TextAlign.center
//                         //overflow: TextOverflow.ellipsis,
//                         ),
//                     selected: selectedAcceptedDocumentIndex == index,
//                     selectedColor: Colors.white,
//                     selectedTileColor: primaryColor,
//                     tileColor: const Color(0xFFF1FAFF),
//                     textColor: primaryColor,
//                     onTap: () {
//                       Modular.to.pop(index);
//                     },
//                   );
//                 },
//               );
//             }),
//       ),
//     );
//   }
// }

// const declaration = 'Declaro a veracidade e autenticidade do documento inserido/anexado e das informações prestadas por mim nesta declaração, ciente de que em caso de omissão ou falsidade estarei sujeito às sanções legais e até mesmo ao cancelamento da bolsa (Lei Complementar nº 187/2021).';
