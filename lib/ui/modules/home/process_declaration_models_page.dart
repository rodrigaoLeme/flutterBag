import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../main/i18n/app_i18n.dart';
import '../../helpers/themes/themes.dart';

class _DeclarationModel {
  final String label;
  const _DeclarationModel({required this.label});
}

class ProcessDeclarationModelsPage extends StatelessWidget {
  const ProcessDeclarationModelsPage({super.key});

  // Mock — substituir por lista vinda do endpoint quando disponível
  static const _models = [
    _DeclarationModel(label: 'Declaração de ajuda financeira (doador)'),
    _DeclarationModel(label: 'Declaração de ajuda financeira (recebedor)'),
    _DeclarationModel(label: 'Declaração de desempregado'),
    _DeclarationModel(
        label: 'Declaração de não recebimento de benefício de programa social'),
    _DeclarationModel(
        label:
            'Declaração de não recebimento de benefício de pensão alimentícia'),
    _DeclarationModel(label: 'Declaração de proprietário de MEI'),
    _DeclarationModel(
        label:
            'Declaração de trabalho autônomo (contribuinte individual do INSS)'),
  ];

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      appBar: AppBar(
        title: Text(appStrings.processDetailDeclarationModels),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appStrings.processDeclarationModelsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              appStrings.processDeclarationModelsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
            const SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _models.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return _DeclarationModelItem(
                  model: _models[index],
                  onDownload: () {
                    // TODO: chamar endpoint de download/visualização do PDF
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (_) => NoticeDocumentPage(
                    //     presenter: makeNoticeDocumentPresenter(),
                    //     announcementId: model.id,
                    //     title: model.label,
                    //   ),
                    // ));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DeclarationModelItem extends StatelessWidget {
  final _DeclarationModel model;
  final VoidCallback onDownload;

  const _DeclarationModelItem({
    required this.model,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      leading: SvgPicture.asset(
        AppIcons.pdfFileIcon,
        width: 18,
        height: 18,
        color: AppColors.onSurface,
      ),
      title: Text(
        model.label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurface,
            ),
      ),
      trailing: GestureDetector(
        onTap: onDownload,
        child: SvgPicture.asset(
          AppIcons.downloadIcon,
          width: 18,
          height: 18,
          color: AppColors.onSurface,
        ),
      ),
    );
  }
}
