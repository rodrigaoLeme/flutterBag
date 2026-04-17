import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/empty_state.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/input_placeholder.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../modules.dart';
import 'components/faq_information_section.dart';
import 'support_presenter.dart';

class SupportPage extends StatefulWidget {
  final SupportPresenter presenter;

  const SupportPage({
    super.key,
    required this.presenter,
  });

  @override
  SupportPageState createState() => SupportPageState();
}

class SupportPageState extends State<SupportPage> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    widget.presenter.loadData();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: GcText(
            text: R.string.faqLabel,
            textStyleEnum: GcTextStyleEnum.semibold,
            textSize: GcTextSizeEnum.h3w5,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
      ),
      body: StreamBuilder<SupportViewModel?>(
        stream: widget.presenter.viewModel,
        builder: (context, snapshot) {
          final viewModel = snapshot.data;

          if (viewModel == null ||
              viewModel.support == null ||
              viewModel.support!.isEmpty) {
            return EmptyState(
              icon: 'lib/ui/assets/images/icon/messages-question.svg',
              title: R.string.messageEmpty,
            );
          }
          final isEmpty = viewModel.support?.isEmpty == true;
          return isEmpty
              ? EmptyState(
                  icon: 'lib/ui/assets/images/icon/messages-question.svg',
                  title: R.string.messageEmpty,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputPlaceholder(
                        controller: _controller,
                        onChanged: (text) {
                          widget.presenter.filterBy(text, viewModel);
                        },
                        hint: R.string.searchLabel,
                        iconLeading: GestureDetector(
                          onTap: () {
                            _controller.clear();
                            widget.presenter.filterBy('', viewModel);
                          },
                          child: const Icon(
                            Icons.search,
                            color: AppColors.neutralLowMedium,
                          ),
                        ),
                        style: const TextStyle(
                          color: AppColors.neutralHigh,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                          color: AppColors.neutralLowMedium,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: viewModel.supportFiltered!.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 48.0),
                                  child: Column(
                                    children: [
                                      EmptyState(
                                        icon:
                                            'lib/ui/assets/images/icon/lupa.svg',
                                        title: R.string.messageEmptySupport,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: FaqInformationSection(
                                  viewModel: viewModel,
                                  presenter: widget.presenter,
                                ),
                              ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
