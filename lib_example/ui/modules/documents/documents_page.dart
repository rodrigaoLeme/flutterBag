import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/empty_state.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/input_placeholder.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../food/components/filter_costum.dart';
import 'components/documents_section.dart';
import 'documents_presenter.dart';
import 'documents_view_model.dart';

class DocumentsPage extends StatefulWidget {
  final DocumentsPresenter presenter;

  const DocumentsPage({
    super.key,
    required this.presenter,
  });

  @override
  DocumentsPageState createState() => DocumentsPageState();
}

class DocumentsPageState extends State<DocumentsPage> {
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
            text: R.string.documentsLabel,
            textStyleEnum: GcTextStyleEnum.regular,
            textSize: GcTextSizeEnum.h3w5,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
      ),
      body: StreamBuilder<DocumentsViewModel?>(
        stream: widget.presenter.viewModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          final viewModel = snapshot.data;

          if (viewModel == null ||
              viewModel.documents == null ||
              viewModel.documents!.isEmpty) {
            return EmptyState(
              icon: 'lib/ui/assets/images/icon/folder-open.svg',
              title: R.string.messageEmpty,
            );
          }
          final isEmpty = viewModel.documents?.isEmpty == true;
          return isEmpty
              ? EmptyState(
                  icon: 'lib/ui/assets/images/icon/folder-open.svg',
                  title: R.string.messageEmpty,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: InputPlaceholder(
                          controller: _controller,
                          onChanged: (text) {
                            widget.presenter.filterBy(text, viewModel);
                          },
                          hint: R.string.searchDocuments,
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
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ListView.builder(
                          itemCount: viewModel.filters?.length ?? 0,
                          itemBuilder: (context, index) {
                            final filter = viewModel.filters?[index];
                            final isSelectedFilter = filter?.section ==
                                viewModel.currentFilter?.section;
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: index == 0 ? 16.0 : 8.0, top: 12.0),
                              child: FilterCostum(
                                text: filter?.sectionTitle ?? '',
                                backgroundColor: isSelectedFilter
                                    ? AppColors.primaryLight
                                    : AppColors.neutralLight,
                                textColor: isSelectedFilter
                                    ? AppColors.white
                                    : AppColors.primaryLight,
                                onTap: () {
                                  widget.presenter.selectCurrentFilter(
                                      filter: filter, viewModel: viewModel);
                                },
                              ),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      Expanded(
                        child: viewModel.docFiltered!.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 48.0),
                                  child: Column(
                                    children: [
                                      EmptyState(
                                        icon:
                                            'lib/ui/assets/images/icon/lupa.svg',
                                        title: R.string.messageEmptyDocument,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : DocumentsSection(
                                viewModel: viewModel,
                                presenter: widget.presenter,
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
