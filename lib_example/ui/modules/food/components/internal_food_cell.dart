import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/html_view_page.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import '../food_view_model.dart';

class InternalFoodCell extends StatelessWidget {
  final InternalFoodViewModel? viewModel;
  final void Function(InternalFoodViewModel?) onPurchase;
  final ScrollController? scrollController;

  const InternalFoodCell({
    super.key,
    required this.viewModel,
    required this.onPurchase,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: CustomHtml(
                htmlData: viewModel?.descriptionMenu ?? '',
              ),
            ),
          ),
          if (viewModel?.purchaseLink?.isEmpty == false)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 48.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight),
                  onPressed: () {
                    if (viewModel != null) {
                      onPurchase(viewModel);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                          'lib/ui/assets/images/icon/purchase.svg'),
                      const SizedBox(
                        width: 8,
                      ),
                      GcText(
                        text: R.string.ticketPurchaseLabel,
                        textSize: GcTextSizeEnum.headline,
                        textStyleEnum: GcTextStyleEnum.semibold,
                        color: AppColors.white,
                        gcStyles: GcStyles.poppins,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
