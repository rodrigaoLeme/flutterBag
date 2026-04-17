import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/news/load_news.dart';
import '../../firebase/firestore_client_factory.dart';

LoadNews makeRemoteLoadNews() => RemoteLoadNews(
      client: makeFirestoreClient(),
      collectionPath: 'event-news-v2',
    );
