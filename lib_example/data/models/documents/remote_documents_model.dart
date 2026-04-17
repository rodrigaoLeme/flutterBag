import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/documents/documents_entity.dart';
import '../../http/http.dart';

class RemoteDocumentsModel {
  final List<RemoteDocumentsResultModel> documents;

  RemoteDocumentsModel({
    required this.documents,
  });

  factory RemoteDocumentsModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final result = decodedResult
          .map((item) =>
              RemoteDocumentsResultModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return RemoteDocumentsModel(documents: result);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }

  DocumentsEntity toEntity() => DocumentsEntity(
        documents: documents
            .map<DocumentsResultEntity>((event) => event.toEntity())
            .toList(),
      );
}

class RemoteDocumentsResultModel {
  final String externalId;
  final String eventExternalId;
  final String sections;
  final String name;
  final String description;
  final String url;
  final int order;

  RemoteDocumentsResultModel({
    required this.externalId,
    required this.eventExternalId,
    required this.sections,
    required this.name,
    required this.description,
    required this.url,
    required this.order,
  });

  factory RemoteDocumentsResultModel.fromJson(Map json) {
    if (!json.containsKey('ExternalId')) {
      throw HttpError.invalidData;
    }

    return RemoteDocumentsResultModel(
      externalId: json['ExternalId'],
      eventExternalId: json['EventExternalId'],
      sections: json['Sections'],
      name: json['Name'],
      description: json['Description'],
      url: json['Url'],
      order: json['Order'],
    );
  }

  DocumentsResultEntity toEntity() => DocumentsResultEntity(
        externalId: externalId,
        eventExternalId: eventExternalId,
        sections: sections,
        name: name,
        description: description,
        url: url,
        order: order,
      );
}

enum DocumentsTypeModel {
  link('Link'),
  text('Text');

  const DocumentsTypeModel(this.type);
  final String type;

  String get icon {
    switch (this) {
      case DocumentsTypeModel.text:
        return 'lib/ui/assets/images/icon/file-pdf-light.svg';
      case DocumentsTypeModel.link:
        return 'lib/ui/assets/images/icon/link-regular.svg';
    }
  }

  static DocumentsTypeModel fromType(String? type) {
    return DocumentsTypeModel.values.firstWhere(
      (e) => e.type == type,
      orElse: () => DocumentsTypeModel.text,
    );
  }
}
