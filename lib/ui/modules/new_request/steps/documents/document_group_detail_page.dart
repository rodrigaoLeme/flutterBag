import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../../main/routes/routes.dart';
import '../../../../components/components.dart';
import '../../../../helpers/app_assets.dart';
import '../../../../helpers/themes/themes.dart';
import '../../widgets/scholarship_step_indicator.dart';
import '../family/widgets/member_registration_sub_step_nav.dart';
import 'document_group_item.dart';
import 'document_proof_submit_page.dart';
import 'document_requirement_item.dart';
import 'document_requirements.dart';

class DocumentGroupDetailPage extends StatefulWidget {
  final List<DocumentGroupItem> groups;
  final int initialIndex;
  final DateTime? submissionDeadline;

  const DocumentGroupDetailPage({
    super.key,
    required this.groups,
    required this.initialIndex,
    this.submissionDeadline,
  });

  @override
  State<DocumentGroupDetailPage> createState() =>
      _DocumentGroupDetailPageState();
}

class _DocumentGroupDetailPageState extends State<DocumentGroupDetailPage> {
  late int _currentIndex;
  late List<DocumentRequirementItem> _requirements;

  DocumentGroupItem get _currentGroup => widget.groups[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.groups.length - 1);
    _loadRequirements();
  }

  void _loadRequirements() {
    _requirements = documentRequirementsForGroup(_currentGroup);
  }

  String? get _formattedDeadline {
    final deadline = widget.submissionDeadline;
    if (deadline == null) return null;

    final day = deadline.day.toString().padLeft(2, '0');
    final month = deadline.month.toString().padLeft(2, '0');
    return '$day/$month/${deadline.year}';
  }

  void _goToGroup(int index) {
    if (index < 0 || index >= widget.groups.length) return;
    setState(() {
      _currentIndex = index;
      _loadRequirements();
    });
  }

  Future<void> _confirmGoHome() async {
    final i18n = AppI18n.current;
    final deadline = _formattedDeadline;
    if (deadline == null) return;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          i18n.familyConfirmDialogTitle,
          style: AppTextStyles.titleLarge,
        ),
        content: Text.rich(
          TextSpan(
            style: AppTextStyles.bodyMedium,
            children: [
              TextSpan(text: i18n.documentsHomeDialogBodyPrefix),
              TextSpan(
                text: deadline,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: i18n.documentsHomeDialogBodySuffix),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Modular.to.navigate(Routes.home);
            },
            child: Text(
              i18n.documentsHomeDialogConfirm,
              style: AppTextStyles.m3LabelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSendDocument(DocumentRequirementItem item) async {
    if (item.id == 'address-proof') {
      final i18n = AppI18n.current;
      final submitted = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => DocumentProofSubmitPage(
            documentTitle: item.title,
            documentTypeOptions: [
              i18n.documentTypeInternet,
              i18n.documentTypeElectricity,
              i18n.documentTypeCableTv,
              i18n.documentTypePipedGas,
              i18n.documentTypeWaterLastMonth,
              i18n.documentTypeLandline,
            ],
          ),
        ),
      );

      if (submitted == true && mounted) {
        setState(() {
          _requirements = [
            for (final requirement in _requirements)
              if (requirement.id == item.id)
                requirement.copyWith(isUploaded: true)
              else
                requirement,
          ];
        });
      }
      return;
    }

    // TODO: integrar picker/envio dos demais documentos
    setState(() {
      _requirements = [
        for (final requirement in _requirements)
          if (requirement.id == item.id)
            requirement.copyWith(isUploaded: true)
          else
            requirement,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    final canGoBack = _currentIndex > 0;
    final canGoForward = _currentIndex < widget.groups.length - 1;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(_currentGroup.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _confirmGoHome,
            icon: SvgPicture.asset(
              AppIcons.houseIcon,
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ScholarshipStepIndicator(
                currentStep: 5,
                completedStep: 5,
                onStepTap: (_) {},
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: MemberRegistrationSubStepNav(
                      navTitle: _currentGroup.title,
                      canGoBack: canGoBack,
                      canGoForward: canGoForward,
                      onBack: () => _goToGroup(_currentIndex - 1),
                      onForward: () => _goToGroup(_currentIndex + 1),
                    ),
                  ),
                  for (var i = 0; i < _requirements.length; i++) ...[
                    _DocumentRequirementRow(
                      title: _requirements[i].title,
                      sendLabel: i18n.documentSendAction,
                      onSend: () => _onSendDocument(_requirements[i]),
                    ),
                    // if (i < _requirements.length - 0)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                      color: Color(0xFFCAC4D0),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: EbolsaButton(
                onPressed: () => Navigator.of(context).pop(),
                label: i18n.documentsBackToDocumentsAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentRequirementRow extends StatelessWidget {
  final String title;
  final String sendLabel;
  final VoidCallback onSend;

  const _DocumentRequirementRow({
    required this.title,
    required this.sendLabel,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyLarge,
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton(
            onPressed: onSend,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onSurface,
              minimumSize: const Size(0, 40),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: const BorderSide(color: Color(0xFFB9BDC6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(
              sendLabel,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
