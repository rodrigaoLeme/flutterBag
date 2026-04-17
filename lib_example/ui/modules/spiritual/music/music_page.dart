import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/empty_state.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/input_placeholder.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import '../music_view_model.dart';
import 'components/preview_video_widget.dart';
import 'music_presenter.dart';

class MusicPage extends StatefulWidget {
  final MusicPresenter presenter;
  const MusicPage({
    super.key,
    required this.presenter,
  });

  @override
  MusicState createState() => MusicState();
}

class MusicState extends State<MusicPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    widget.presenter.convinienceInit();
    super.initState();
  }

  @override
  void dispose() {
    widget.presenter.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryLight,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.translucent,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.arrow_back, color: AppColors.white),
          ),
        ),
        title: Align(
          alignment: Alignment.topLeft,
          child: GcText(
            text: R.string.musicLabel,
            gcStyles: GcStyles.poppins,
            textSize: GcTextSizeEnum.h3w5,
            textStyleEnum: GcTextStyleEnum.regular,
            color: AppColors.white,
          ),
        ),
      ),
      body: StreamBuilder<MusicListViewModel?>(
        stream: widget.presenter.viewModel,
        builder: (context, snapshot) {
          final viewModel = snapshot.data;
          if (viewModel == null) {
            return EmptyState(
              icon: 'lib/ui/assets/images/icon/folder-music.svg',
              title: R.string.messageEmpty,
            );
          }
          final isEmpty = viewModel.musics.isEmpty == true;
          return isEmpty
              ? EmptyState(
                  icon: 'lib/ui/assets/images/icon/folder-music.svg',
                  title: R.string.messageEmpty,
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 16.0, right: 16.0, bottom: 8.0),
                      child: InputPlaceholder(
                        onChanged: (text) {
                          widget.presenter.filterBy(text, viewModel);
                        },
                        hint: R.string.searchMusic,
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
                    Expanded(
                      child: viewModel.filteredMusic.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 48.0),
                                child: Column(
                                  children: [
                                    EmptyState(
                                      icon:
                                          'lib/ui/assets/images/icon/lupa.svg',
                                      title: R.string.messageEmpty,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: viewModel.filteredMusic.length,
                              itemBuilder: (context, index) {
                                final musicViewModel =
                                    viewModel.filteredMusic[index];
                                return PreviewVideoWidget(
                                  viewModel: musicViewModel,
                                  onTap: (element) {
                                    if (element != null) {
                                      widget.presenter.goToMusicDetails(
                                        musicViewModel: element,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
