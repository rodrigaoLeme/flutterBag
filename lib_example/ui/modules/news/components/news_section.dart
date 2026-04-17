import 'package:flutter/material.dart';

import '../../../helpers/i18n/resources.dart';
import '../../modules.dart';
import '../../web_view/web_view_page.dart';

class NewsSection extends StatelessWidget {
  final NewsListViewModel? viewModel;

  const NewsSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel?.newsList.length ?? 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final newsItem = viewModel?.newsList[index];
        if (newsItem == null) return const SizedBox();
        return NewsCell(
          viewModel: newsItem,
          onTap: (newsItem) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewPage(
                  url: newsItem.details?.link ?? '',
                  title: R.string.newsLabel,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
