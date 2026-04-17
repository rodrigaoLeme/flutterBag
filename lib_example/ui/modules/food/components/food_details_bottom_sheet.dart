import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/cached_image.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/extensions/string_extension.dart';
import '../../../helpers/i18n/resources.dart';
import '../food_view_model.dart';

// ignore: must_be_immutable
class FoodDetailsBottomSheet extends StatefulWidget {
  ExternalFoodViewModel viewModel;
  ValueNotifier<bool?> isFavorite = ValueNotifier(null);
  final Future<ExternalFoodViewModel> Function(ExternalFoodViewModel)
      onFavoriteToggle;

  FoodDetailsBottomSheet({
    super.key,
    required this.viewModel,
    required this.onFavoriteToggle,
  });

  @override
  FoodDetailsBottomSheetState createState() => FoodDetailsBottomSheetState();
}

class FoodDetailsBottomSheetState extends State<FoodDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      widget.isFavorite.value = widget.viewModel.isFavorite;

      return Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    color: widget.viewModel.photoBackgroundColor?.toColor(),
                    width: double.infinity,
                    height: 120,
                    child: const ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
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
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: CachedImageWidget(
                            imageUrl: widget.viewModel.photoUrl ?? '',
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
              SizedBox(
                  height:
                      widget.viewModel.discount?.isNotEmpty == true ? 58 : 36),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, bottom: 8.0),
                            child: GcText(
                              text: widget.viewModel.discount ?? '',
                              textStyleEnum: GcTextStyleEnum.regular,
                              textSize: GcTextSizeEnum.callout,
                              color: AppColors.primaryLight,
                              gcStyles: GcStyles.poppins,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, bottom: 8.0, right: 16),
                            child: Row(
                              children: [
                                if (widget.viewModel.isSponsor ?? false) ...[
                                  SvgPicture.asset(
                                    'lib/ui/assets/images/icon/circle-star-regular.svg',
                                    height: 16,
                                    width: 16,
                                    fit: BoxFit.fill,
                                    color: AppColors.sunFlower,
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Flexible(
                                  child: GcText(
                                    text: widget.viewModel.name ?? '',
                                    textStyleEnum: GcTextStyleEnum.bold,
                                    textSize: GcTextSizeEnum.h2,
                                    color: AppColors.black,
                                    gcStyles: GcStyles.poppins,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 6.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'lib/ui/assets/images/icon/location-dot-light.svg',
                                  height: 16,
                                  width: 16,
                                  fit: BoxFit.fill,
                                  color: AppColors.neutralLowDark,
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      callGoogleMaps(
                                          widget.viewModel.location ?? '');
                                    },
                                    child: GcText(
                                      text: widget.viewModel.location ?? '',
                                      textStyleEnum: GcTextStyleEnum.regular,
                                      textSize: GcTextSizeEnum.callout,
                                      color: AppColors.primaryLight,
                                      gcStyles: GcStyles.poppins,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.primaryLight,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 6.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'lib/ui/assets/images/icon/hat-chef-light.svg',
                                  height: 16,
                                  width: 16,
                                  fit: BoxFit.fill,
                                  color: AppColors.neutralLowDark,
                                ),
                                const SizedBox(width: 8.0),
                                GcText(
                                  text: widget.viewModel.typeCuisine ?? '',
                                  textStyleEnum: GcTextStyleEnum.regular,
                                  textSize: GcTextSizeEnum.callout,
                                  color: AppColors.neutralLowDark,
                                  gcStyles: GcStyles.poppins,
                                ),
                              ],
                            ),
                          ),
                          if (widget.viewModel.phone != null &&
                              widget.viewModel.phone!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 6.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'lib/ui/assets/images/icon/phone-light.svg',
                                    height: 16,
                                    width: 16,
                                    fit: BoxFit.fill,
                                    color: AppColors.neutralLowDark,
                                  ),
                                  const SizedBox(width: 8.0),
                                  GestureDetector(
                                    onTap: () {
                                      final Uri url = Uri(
                                        scheme: 'tel',
                                        path: widget.viewModel.phone!,
                                      );
                                      openUrl(url);
                                    },
                                    child: GcText(
                                      text: widget.viewModel.phone!,
                                      textStyleEnum: GcTextStyleEnum.regular,
                                      textSize: GcTextSizeEnum.callout,
                                      color: AppColors.primaryLight,
                                      gcStyles: GcStyles.poppins,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.primaryLight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (widget.viewModel.website != null &&
                              widget.viewModel.website!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 6.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'lib/ui/assets/images/icon/globe-pointer-light.svg',
                                    height: 16,
                                    width: 16,
                                    fit: BoxFit.fill,
                                    color: AppColors.neutralLowDark,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        final url = Uri.parse(
                                            widget.viewModel.website ?? '');
                                        openUrl(url);
                                      },
                                      child: Builder(builder: (context) {
                                        return GcText(
                                          text: widget.viewModel.website ?? '',
                                          textStyleEnum:
                                              GcTextStyleEnum.regular,
                                          textSize: GcTextSizeEnum.callout,
                                          color: AppColors.primaryLight,
                                          gcStyles: GcStyles.poppins,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                AppColors.primaryLight,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 16.0, bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ValueListenableBuilder<bool?>(
                            valueListenable: widget.isFavorite,
                            builder: (context, snapshot, _) {
                              return Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.neutralLight,
                                ),
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                    snapshot == true
                                        ? 'lib/ui/assets/images/icon/heart-solid.svg'
                                        : 'lib/ui/assets/images/icon/heart-light.svg',
                                    color: AppColors.primaryLight,
                                    width: 18,
                                    height: 18,
                                  ),
                                  onPressed: () async {
                                    widget.viewModel = await widget
                                        .onFavoriteToggle(widget.viewModel);
                                    widget.isFavorite.value =
                                        widget.viewModel.isFavorite;
                                  },
                                ),
                              );
                            }),
                        const SizedBox(width: 8.0),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.neutralLight,
                          ),
                          child: IconButton(
                            icon: SvgPicture.asset(
                              'lib/ui/assets/images/icon/share-nodes-light.svg',
                              color: AppColors.primaryLight,
                              width: 18,
                              height: 18,
                            ),
                            onPressed: () async {
                              final texto = StringBuffer();

                              final name = widget.viewModel.name;
                              final location = widget.viewModel.location;
                              final website = widget.viewModel.website;
                              final phone = widget.viewModel.phone;

                              if (name?.isNotEmpty == true) {
                                texto.writeln('🍽️ $name');
                              }
                              if (location?.isNotEmpty == true) {
                                texto.writeln('📍$location');
                              }
                              if (website?.isNotEmpty == true) {
                                texto.writeln('🌐 $website');
                              }
                              if (phone?.isNotEmpty == true) {
                                texto.writeln('☏ $phone');
                              }

                              try {
                                await Share.share(
                                  texto.toString().trim(),
                                  subject: name,
                                );
                              } catch (e) {
                                print('Erro ao compartilhar: $e');
                              }
                            },
                          ),
                        ),
                      ],
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
                          text: R.string.directionsLabel,
                          textStyleEnum: GcTextStyleEnum.bold,
                          textSize: GcTextSizeEnum.callout,
                          color: AppColors.white,
                          gcStyles: GcStyles.poppins,
                        ),
                        onPressed: () {
                          callGoogleMaps(widget.viewModel.location ?? '');
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
      );
    });
  }

  Future<void> callGoogleMaps(String endereco) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(endereco)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> openUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
