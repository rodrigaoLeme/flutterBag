import 'package:flutter/material.dart';

import '../../news/news_view_model.dart';
import './components.dart';

class InformationSection extends StatelessWidget {
  final Function(NewsViewModel) onTap;
  final NewsListViewModel newsViewModel;

  const InformationSection({
    super.key,
    required this.onTap,
    required this.newsViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newsViewModel.newsList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        final item = newsViewModel.newsList[index];

        return Padding(
          padding: EdgeInsets.only(right: 12, left: index == 0 ? 16 : 0),
          child: GestureDetector(
            onTap: () => onTap(item),
            child: InformationCell(
              viewModel: item,
            ),
          ),
        );
      },
    );
  }
}
