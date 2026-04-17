import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/cached_image.dart';
import '../sponsor_view_model.dart';

class BannerCarouselSection extends StatefulWidget {
  final SponsorsViewModel? viewModel;
  const BannerCarouselSection({
    super.key,
    required this.viewModel,
  });

  @override
  State<BannerCarouselSection> createState() => _BannerCarouselSectionState();
}

class _BannerCarouselSectionState extends State<BannerCarouselSection> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider(
              items: widget.viewModel?.sponsors?.map((i) {
                return GestureDetector(
                  onTap: () {
                    _launchURL(i.link ?? '');
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: CachedImageWidget(
                      imageUrl: i.photoUrl ?? '',
                      fit: BoxFit.cover,
                      errorWidget: const SizedBox.shrink(),
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.21,
                autoPlay: true,
                viewportFraction: 1,
                onPageChanged: (index, reason) =>
                    setState(() => activeIndex = index),
              ),
            ),
            const SizedBox(height: 8),
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: activeIndex,
                  count: widget.viewModel!.sponsors!.length,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 6,
                    dotWidth: 6,
                    expansionFactor: 2,
                    spacing: 8,
                    activeDotColor: AppColors.neutralLowMedium,
                    dotColor: AppColors.neutralHigh,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
