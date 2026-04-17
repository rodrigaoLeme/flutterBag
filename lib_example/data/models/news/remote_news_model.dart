import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/entities.dart';
import '../../http/http.dart';

class RemoteListNewsModel {
  final List<RemoteNewsModel>? newsList;

  RemoteListNewsModel({
    required this.newsList,
  });

  factory RemoteListNewsModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final news = decodedResult
          .map((item) => RemoteNewsModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return RemoteListNewsModel(newsList: news);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }
}

class RemoteNewsModel {
  final String? eventExternalId;
  final String? externalId;
  final RemoteNewsDetailsModel? details;
  final int? newsFont;
  final bool? isPinned;
  final bool? isShow;

  RemoteNewsModel({
    required this.eventExternalId,
    required this.externalId,
    required this.details,
    required this.newsFont,
    required this.isPinned,
    required this.isShow,
  });

  factory RemoteNewsModel.fromJson(Map json) {
    if (!json.containsKey('EventExternalId')) {
      throw HttpError.invalidData;
    }
    return RemoteNewsModel(
      eventExternalId: json['EventExternalId'],
      externalId: json['ExternalId'],
      details: RemoteNewsDetailsModel.fromJson(json['Detail']),
      newsFont: json['NewsFont'],
      isPinned: json['IsPinned'],
      isShow: json['IsShow'],
    );
  }

  NewsEntity toEntity() => NewsEntity(
        eventExternalId: eventExternalId,
        externalId: externalId,
        details: details?.toEntity(),
        newsFont: newsFont,
        isPinned: isPinned,
        isShow: isShow,
      );
}

class RemoteNewsDetailsModel {
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

  RemoteNewsDetailsModel({
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

  factory RemoteNewsDetailsModel.fromJson(Map json) {
    return RemoteNewsDetailsModel(
      card: json['Card'],
      title: json['Title'],
      lead: json['Lead'],
      image: json['Image'],
      date: json['Date'],
      tag: json['Tag'],
      link: json['Link'],
      coverPhotoUrl: json['CoverPhotoUrl'],
      homePhotoUrl: json['HomePhotoUrl'],
      description: json['Body'],
    );
  }

  NewsDetailsEntity toEntity() => NewsDetailsEntity(
        card: card,
        title: title,
        lead: lead,
        image: image,
        date: date,
        tag: tag,
        link: link,
        coverPhotoUrl: coverPhotoUrl,
        homePhotoUrl: homePhotoUrl,
        description: description,
      );
}
