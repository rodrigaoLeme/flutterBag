import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/section/section_entity.dart';
import '../../http/http_error.dart';

class SectionResultModel {
  final List<SectionModel>? sections;

  SectionResultModel({
    required this.sections,
  });

  factory SectionResultModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final sections = decodedResult
          .map((item) => SectionModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return SectionResultModel(sections: sections);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }

  SectionResultEntity toEntity() => SectionResultEntity(
        sections: sections
            ?.map<SectionEntity>((section) => section.toEntity())
            .toList(),
      );
}

class SectionModel {
  final String? slug;
  final String? name;
  final String? description;

  SectionModel({
    required this.slug,
    required this.name,
    required this.description,
  });

  factory SectionModel.fromJson(Map json) {
    if (!json.containsKey('Slug')) {
      throw HttpError.invalidData;
    }
    return SectionModel(
      slug: json['Slug'],
      name: json['Name'],
      description: json['Description'],
    );
  }

  SectionEntity toEntity() => SectionEntity(
        slug: slug,
        name: name,
        description: description,
      );
}
