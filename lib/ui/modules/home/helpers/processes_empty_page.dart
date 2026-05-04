import 'package:flutter/material.dart';

import '../../../../main/i18n/app_i18n.dart';
import '../../../components/components.dart';

class ProcessesEmptyPage extends StatefulWidget {
  const ProcessesEmptyPage({super.key});

  @override
  State<ProcessesEmptyPage> createState() => _ProcessesEmptyPageState();
}

class _ProcessesEmptyPageState extends State<ProcessesEmptyPage> {
  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 12, top: 20, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            appStrings.homeTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            appStrings.homeSubtitleEmptyProcess,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 40),
          EbolsaButton(
            onPressed: () {},
            label: appStrings.homeRenewScholarshipButton,
          ),
          const SizedBox(height: 16),
          EbolsaButton(
            onPressed: () {},
            label: appStrings.homeNewScholarshipButton,
            isOutlined: true,
          ),
          const SizedBox(height: 40),
          EbolsaImportantBanner(
            title: appStrings.homeImportantTitle,
            message: appStrings.homeImportantMessage,
          ),
          const SizedBox(height: 23),
        ],
      ),
    );
  }
}
