import '../../../data/models/news/remote_news_model.dart';
import '../../helpers/extensions/string_extension.dart';

class NewsListViewModel {
  final List<NewsViewModel> newsList;

  NewsListViewModel({
    required this.newsList,
  });
}

class NewsViewModel {
  final String? eventExternalId;
  final String? externalId;
  final NewsDetailsViewModel? details;
  final int? newsFont;
  final bool? isPinned;
  final bool? isShow;

  NewsViewModel({
    required this.eventExternalId,
    required this.externalId,
    required this.details,
    required this.newsFont,
    required this.isPinned,
    required this.isShow,
  });
}

class NewsDetailsViewModel {
  final String? card;
  final String? title;
  final String? lead;
  final String? image;
  final String? date;
  final String? tag;
  final String? link;
  final String? coverPhotoUrl;
  final String? homePhotoUrl;
  final String? description;

  NewsDetailsViewModel({
    required this.card,
    required this.title,
    required this.lead,
    required this.image,
    required this.date,
    required this.tag,
    required this.link,
    required this.coverPhotoUrl,
    required this.homePhotoUrl,
    required this.description,
  });
}

class NewsViewModelFactory {
  static Future<NewsListViewModel> make(RemoteListNewsModel model) async {
    return NewsListViewModel(
      newsList: model.newsList != null
          ? await Future.wait<NewsViewModel>(
              model.newsList!
                  .map(
                    (element) async => NewsViewModel(
                      eventExternalId: element.eventExternalId,
                      externalId: element.externalId,
                      details: NewsDetailsViewModel(
                        card: element.details?.card?.formatImagByWordPress,
                        title: element.details?.title != null
                            ? await element.details?.title!.translate()
                            : null,
                        lead: element.details?.lead,
                        image: element.details?.image,
                        date: element.details?.date,
                        tag: element.details?.tag,
                        link: element.details?.link,
                        coverPhotoUrl: element.details?.coverPhotoUrl,
                        homePhotoUrl: element.details?.homePhotoUrl,
                        description: element.details?.description,
                      ),
                      newsFont: element.newsFont,
                      isPinned: element.isPinned,
                      isShow: element.isShow,
                    ),
                  )
                  .toList(),
            )
          : [],
    );
  }
}
