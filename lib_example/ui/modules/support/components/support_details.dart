import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/html_view_page.dart';
import '../../../helpers/helpers.dart';
import '../../../mixins/navigation_manager.dart';
import '../support_view_model.dart';

class SupportDetails extends StatefulWidget with NavigationManager {
  final SupportResultViewModel viewModel;

  const SupportDetails({
    super.key,
    required this.viewModel,
  });

  @override
  SupportDetailsState createState() => SupportDetailsState();
}

class SupportDetailsState extends State<SupportDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: HtmlViewPage(
              html: widget.viewModel.description ?? '',
              title: widget.viewModel.title ?? '',
              isTitleInBody: false,
              showAppBar: false,
            ),
          ),
        ),
      ],
    );
  }
}

void showSupportModal(BuildContext context, SupportResultViewModel viewModel) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: ResponsiveLayout.of(context).hp(60),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 100,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: AppColors.neutralLowMedium,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: HtmlViewPage(
                  html: viewModel.description ?? '',
                  title: viewModel.title ?? '',
                  isTitleInBody: false,
                  showAppBar: false,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
