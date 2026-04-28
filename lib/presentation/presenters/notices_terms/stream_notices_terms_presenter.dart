import 'dart:async';

import '../../../domain/entities/notice_entity.dart';
import '../../../ui/modules/notices_terms/notices_terms_presenter.dart';

class StreamNoticesTermsPresenter implements NoticesTermsPresenter {
  final _noticesController = StreamController<List<NoticeEntity>>.broadcast();

  @override
  Stream<List<NoticeEntity>> get noticesStream => _noticesController.stream;

  @override
  Future<void> fetchNotices({
    required String year,
    required String city,
    required String unit,
  }) async {
    try {
      // TODO: Implement API call to fetch notices
      // For now, returning mock data for development
      await Future.delayed(const Duration(milliseconds: 500));

      final mockNotices = _getMockNotices(
        year: year,
        city: city,
        unit: unit,
      );
      _emit(mockNotices);
    } catch (_) {
      _emit([]);
    }
  }

  @override
  void clearNotices() => _emit([]);

  void _emit(List<NoticeEntity> notices) {
    if (!_noticesController.isClosed) {
      _noticesController.add(notices);
    }
  }

  @override
  void dispose() => _noticesController.close();

  List<NoticeEntity> _getMockNotices({
    required String year,
    required String city,
    required String unit,
  }) {
    if (year != '2026' ||
        city != 'Engenheiro Coelho - SP' ||
        unit != 'UNASP - EC') {
      return [];
    }

    return [
      NoticeEntity(
        id: '1',
        name: 'Edital Nº 01/2026',
        publishedAt: DateTime.parse('2026-02-27T17:00:40'),
        modality: 'PROUNI - Ensino Superior',
        enrollmentType: 'Nova',
        additiveTerms: [
          AdditiveTermEntity(
            id: 'at1',
            name: 'Termo Aditivo Nº 01/2026 ao Edital Nº 01/2026',
            publishedAt: DateTime.parse('2026-02-27T17:00:40'),
            modality: 'CEBAS',
            enrollmentType: 'Renovação',
            noticeId: '1',
          ),
        ],
      ),
      NoticeEntity(
        id: '2',
        name: 'Edital Nº 02/2026',
        publishedAt: DateTime.parse('2026-02-20T10:30:00'),
        modality: 'PROUNI - Ensino Superior',
        enrollmentType: 'Nova',
      ),
      NoticeEntity(
        id: '3',
        name: 'Edital Nº 03/2026',
        publishedAt: DateTime.parse('2026-02-15T14:45:00'),
        modality: 'Bolsa Integral',
        enrollmentType: 'Renovação',
      ),
    ];
  }
}
