import '../../../data/models/documents/remote_documents_model.dart';
import '../../helpers/extensions/string_extension.dart';
import '../../helpers/i18n/resources.dart';

class DocumentsViewModel {
  final List<DocumentsResultViewModel>? documents;
  List<DocumentsResultViewModel>? docFiltered;
  final List<DocumentsFilter>? filters;
  DocumentsFilter? currentFilter;
  String filterText = '';
  DocumentsViewModel({
    required this.documents,
    required this.filters,
  });

  void setCurrentFilter(DocumentsFilter? filter) {
    currentFilter = filter;
    filterBy(filterText);
  }

  void filterBy(String text) {
    filterText = text.trim();
    if (currentFilter?.section == R.string.allLabel) {
      final query = filterText.toLowerCase();
      docFiltered = documents
          ?.where((element) => ((element.name?.toLowerCase().contains(query) ??
                  false) ||
              (element.description?.toLowerCase().contains(query) ?? false)))
          .toList();
      return;
    }
    if (filterText.isEmpty) {
      docFiltered = documents
          ?.where((element) => element.sections == currentFilter?.section)
          .toList();
      return;
    }
    final query = filterText.toLowerCase();
    final filteredDocs = documents
        ?.where(
          (element) =>
              ((element.name?.toLowerCase().contains(query) ?? false) ||
                  (element.description?.toLowerCase().contains(query) ??
                      false)) &&
              (element.sections == currentFilter?.section),
        )
        .toList();
    if (filteredDocs != null && filteredDocs.isNotEmpty) {
      final firstSection = filteredDocs.first.sections;

      final matchingFilter = filters?.firstWhere(
        (f) => f.section == firstSection,
        orElse: () => currentFilter!,
      );
      currentFilter = matchingFilter;
    }
    docFiltered = filteredDocs;
  }
}

class DocumentsResultViewModel {
  final String? externalId;
  final String? eventExternalId;
  final String? sections;
  final String? name;
  final String? description;
  final String? url;
  final int? order;
  final DocumentsTypeModel documentsTypeModel;

  DocumentsResultViewModel({
    required this.externalId,
    required this.eventExternalId,
    required this.sections,
    required this.name,
    required this.description,
    required this.url,
    required this.order,
    required this.documentsTypeModel,
  });
  String get docIcon => documentsTypeModel.icon;
}

class DocumentsViewModelFactory {
  static Future<DocumentsViewModel> make(RemoteDocumentsModel? model) async {
    final List<DocumentsResultViewModel> documents = model?.documents != null
        ? await Future.wait<DocumentsResultViewModel>(
            model!.documents.map(
              (element) async => DocumentsResultViewModel(
                  externalId: element.externalId,
                  eventExternalId: element.eventExternalId,
                  sections: element.sections,
                  name: await element.name.translate(),
                  description: await element.description.translate(),
                  url: element.url,
                  order: element.order,
                  documentsTypeModel:
                      DocumentsTypeModel.fromType(element.sections)),
            ),
          )
        : [];

    final filtersString =
        documents.map((toElement) => toElement.sections).toSet().toList();
    final List<DocumentsFilter> filters = await Future.wait<DocumentsFilter>(
      filtersString
          .map(
            (toElement) async => DocumentsFilter(
              section: toElement ?? '',
              sectionTitle: await toElement?.translateSections() ?? '',
            ),
          )
          .toSet()
          .toList(),
    );
    filters.insert(
      0,
      DocumentsFilter(
        section: R.string.allLabel.toUpperCase(),
        sectionTitle: await R.string.allLabel.translate(),
      ),
    );

    DocumentsViewModel viewModel = DocumentsViewModel(
      documents: documents,
      filters: filters,
    );
    viewModel.setCurrentFilter(
      filters.isEmpty == true ? null : filters.first,
    );
    return viewModel;
  }
}

class DocumentsFilter {
  final String section;
  final String sectionTitle;

  DocumentsFilter({
    required this.section,
    required this.sectionTitle,
  });
}
