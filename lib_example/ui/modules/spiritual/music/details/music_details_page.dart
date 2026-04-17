import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../../share/utils/app_color.dart';
import '../../../../components/enum/design_system_enums.dart';
import '../../../../components/gc_text.dart';
import '../../../../components/themes/gc_styles.dart';
import '../../../../components/youtube_player_web_view.dart';
import '../../../../helpers/i18n/resources.dart';
import '../../music_view_model.dart';
import 'music_details_presenter.dart';

class MusicDetailsPage extends StatefulWidget {
  final MusicDetailsPresenter presenter;
  const MusicDetailsPage({
    super.key,
    required this.presenter,
  });

  @override
  MusicDetailsState createState() => MusicDetailsState();
}

class MusicDetailsState extends State<MusicDetailsPage> {
  @override
  void initState() {
    widget.presenter.convinienceInit();
    super.initState();
  }

  @override
  void dispose() {
    widget.presenter.dispose();
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
          onTap: () {
            Navigator.of(context).pop();
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.white,
            ),
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
      body: StreamBuilder<MusicViewModel?>(
        stream: widget.presenter.viewModel,
        builder: (context, snapshot) {
          final viewModel = snapshot.data;
          if (viewModel == null) {
            return const SizedBox.shrink();
          }
          final url = viewModel.link ?? '';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YoutubeWebViewPlayer(
                key: ValueKey(url),
                youtubeUrl: url,
                aspectRatio: 8 / 6,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 24.0),
                child: GcText(
                  text: viewModel.name ?? '',
                  textSize: GcTextSizeEnum.h3w5,
                  textStyleEnum: GcTextStyleEnum.regular,
                  color: AppColors.neutralLowDark,
                  gcStyles: GcStyles.poppins,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Html(
                      data: viewModel.text ?? '',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              )
            ],
          );
        },
      ),
    );
  }
}
