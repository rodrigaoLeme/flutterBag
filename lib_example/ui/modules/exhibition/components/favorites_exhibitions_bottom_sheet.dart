import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../presentation/presenters/navigation_bar/tab_bar_itens.dart'
    show ParamController, TabBarItens;
import '../../../../share/utils/app_color.dart';
import '../../../components/cached_image.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/extensions/string_extension.dart';
import '../../../helpers/i18n/resources.dart';
import '../../navigation/navigation_bar_presenter.dart';
import '../exhibition_view_model.dart';
import './card_exhibitions_section.dart';
import './header_favorites_exhibitions.dart';
import './resources_favorites_exhibitions.dart';

class FavoritesExhibitionsBottomSheet extends StatefulWidget {
  final ExhibitionViewModel viewModel;
  final Future<ExhibitionViewModel> Function(ExhibitionViewModel)
      onFavoriteToggle;
  final Function(FilesViewModel?) onTapDownload;

  const FavoritesExhibitionsBottomSheet({
    super.key,
    required this.viewModel,
    required this.onFavoriteToggle,
    required this.onTapDownload,
  });

  @override
  FavoritesExhibitionsBottomSheetState createState() =>
      FavoritesExhibitionsBottomSheetState();
}

class FavoritesExhibitionsBottomSheetState
    extends State<FavoritesExhibitionsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final hasFiles = widget.viewModel.files?.isEmpty == false;
    final tabLength = hasFiles ? 2 : 1;

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: DefaultTabController(
          length: tabLength,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    color: widget.viewModel.exhibitorPictureBackgroundColor
                        ?.toColor(),
                  ),
                  Positioned(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 100,
                            height: 3,
                            decoration: BoxDecoration(
                              color: AppColors.neutralHigh,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white,
                            width: 1.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: CachedImageWidget(
                            imageUrl: widget.viewModel.exhibitorPictureUrl,
                            fit: BoxFit.cover,
                            errorWidget: Image.asset(
                              'lib/ui/assets/images/image_default.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              HeaderFavoritesExhibitions(
                viewModel: widget.viewModel,
                onFavoriteToggle: widget.onFavoriteToggle,
              ),
              TabBar(
                indicatorColor: AppColors.primaryLight,
                labelColor: AppColors.primaryLight,
                unselectedLabelColor: AppColors.neutralLowDark,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                tabs: [
                  Tab(text: R.string.detailsCapital),
                  if (hasFiles)
                    Tab(
                      text: R.string.resourcesCapital,
                    ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ResourcesFavoritesExhibitions(
                      viewModel: widget.viewModel,
                    ),
                    if (hasFiles)
                      CardExhibitionsSection(
                        files: widget.viewModel.files,
                        onTapDownload: widget.onTapDownload,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0, top: 12),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.neutralLight,
                      ),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          widget.viewModel.isFavorite ?? true
                              ? 'lib/ui/assets/images/icon/heart-solid.svg'
                              : 'lib/ui/assets/images/icon/heart-light.svg',
                          color: AppColors.primaryLight,
                          width: 18,
                          height: 18,
                        ),
                        onPressed: () async {
                          final updatedViewModel =
                              await widget.onFavoriteToggle(widget.viewModel);
                          setState(() {
                            widget.viewModel.isFavorite =
                                updatedViewModel.isFavorite;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: SvgPicture.asset(
                          'lib/ui/assets/images/icon/diamond-turn-right-light.svg',
                          color: AppColors.white,
                          width: 18,
                          height: 18,
                        ),
                        label: GcText(
                          text: R.string.locationLabel,
                          textStyleEnum: GcTextStyleEnum.bold,
                          textSize: GcTextSizeEnum.callout,
                          color: AppColors.white,
                          gcStyles: GcStyles.poppins,
                        ),
                        onPressed: () {
                          final presenter =
                              Modular.get<NavigationBarPresenter>();
                          Navigator.pop(context);
                          final paramController =
                              Modular.get<ParamController>();

                          paramController
                              .setParam('booth-${widget.viewModel.location}');
                          presenter.setCurrentTab(tab: TabBarItens.map);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLight,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
