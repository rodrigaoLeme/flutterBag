// import 'package:flutter/material.dart';

// import '../../../../share/utils/app_color.dart';
// import '../../../components/enum/design_system_enums.dart';
// import '../../../components/gc_text.dart';
// import '../../../components/themes/gc_styles.dart';
// import '../../../helpers/i18n/resources.dart';
// import 'select_language_modal.dart';

// class SelectLanguageSection extends StatelessWidget {
//   const SelectLanguageSection({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GcText(
//             text: R.string.languageLabel,
//             textSize: GcTextSizeEnum.h3,
//             textStyleEnum: GcTextStyleEnum.bold,
//             color: AppColors.black,
//             gcStyles: GcStyles.poppins,
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.close,
//               color: AppColors.primaryLight,
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//      ListView.builder(
//         itemCount: 4,
//         itemBuilder: (BuildContext context, int index) {
//           return const SelectLanguageModal();
//         },
//       ),
//     );
//   }
// }
