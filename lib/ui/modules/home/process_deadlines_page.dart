import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/process_period_entity.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../helpers/themes/themes.dart';

class ProcessDeadlinesPage extends StatelessWidget {
  final ProcessPeriodAvailableEntity? period;

  const ProcessDeadlinesPage({super.key, this.period});

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    final items = _buildTimelineItems(appStrings);

    return Scaffold(
      appBar: AppBar(
        title: Text(appStrings.processDetailDeadlines),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appStrings.processDeadLinesTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            Text(
              appStrings.processDeadlinesSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            for (var i = 0; i < items.length; i++)
              _TimelineTile(
                date: items[i].date,
                label: items[i].label,
                isPast: items[i].isPast,
                isLast: i == items.length - 1,
              ),
          ],
        ),
      ),
    );
  }

  List<_DeadlineItem> _buildTimelineItems(AppI18n appString) {
    final now = DateTime.now();

    final raw = <_DeadlineItem>[
      _DeadlineItem(
        date: period?.registerStart,
        label: appString.processDeadlinesRegisterStart,
      ),
      _DeadlineItem(
        date: period?.registerEnd,
        label: appString.processDeadlinesRegisterEnd,
      ),
      _DeadlineItem(
        date: period?.documentationUploadDeadLine,
        label: appString.processDeadlinesDocumentationUpload,
      ),
      _DeadlineItem(
        date: period?.documentationReturnUploadDeadLine,
        label: appString.processDeadlinesDocumentationReturn,
      ),
      _DeadlineItem(
        date: period?.resultRelease,
        label: appString.processDeadlinesResultRelease,
      ),
    ];

    final filtered = raw.where((e) => e.date != null).toList();

    // Marca como passado os itens com data já decorrida
    return filtered
        .map((e) => e.copyWith(isPast: e.date!.isBefore(now)))
        .toList();
  }
}

class _DeadlineItem {
  final DateTime? date;
  final String label;
  final bool isPast;

  const _DeadlineItem({
    required this.date,
    required this.label,
    this.isPast = false,
  });

  _DeadlineItem copyWith({bool? isPast}) => _DeadlineItem(
        date: date,
        label: label,
        isPast: isPast ?? this.isPast,
      );
}

class _TimelineTile extends StatelessWidget {
  final DateTime? date;
  final String label;
  final bool isPast;
  final bool isLast;

  const _TimelineTile({
    required this.date,
    required this.label,
    required this.isPast,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = isPast ? AppColors.primary : AppColors.secondaryContainer;
    final formattedDate =
        date != null ? DateFormat('dd/MM/yyyy').format(date!) : '-';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 4, bottom: 4),
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.borderLight,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(width: 12),
                  Text(label, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
