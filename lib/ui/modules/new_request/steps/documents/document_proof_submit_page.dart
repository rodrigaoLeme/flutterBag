import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../components/searchable_options_bottom_sheet.dart';
import '../../../../helpers/themes/themes.dart';

class DocumentProofSubmitPage extends StatefulWidget {
  final String documentTitle;
  final List<String> documentTypeOptions;

  const DocumentProofSubmitPage({
    super.key,
    required this.documentTitle,
    required this.documentTypeOptions,
  });

  @override
  State<DocumentProofSubmitPage> createState() =>
      _DocumentProofSubmitPageState();
}

class _DocumentProofSubmitPageState extends State<DocumentProofSubmitPage> {
  String? _selectedDocumentType;
  String? _pickedFileName;
  late final TextEditingController _valueController;

  bool get _canConfirm =>
      _selectedDocumentType != null &&
      _pickedFileName != null &&
      _valueController.text.trim().isNotEmpty;

  String get _valueFieldLabel {
    final i18n = AppI18n.current;
    final type = _selectedDocumentType;
    if (type == i18n.documentTypeElectricity) {
      return i18n.documentProofElectricityValueLabel;
    }
    return i18n.documentProofValueLabel;
  }

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _openDocumentTypeSelector() async {
    final i18n = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: i18n.documentTypeSelectorTitle,
      options: widget.documentTypeOptions,
      searchHint: i18n.noticesTermsSearchHint,
      helperText: i18n.noticesTermsBottomSheetSearchHelp,
      emptyStateText: i18n.noticesTermsBottomSheetNoResults,
      closeTooltip: i18n.noticesTermsCloseAction,
      selectedValue: _selectedDocumentType,
    );

    if (selected == null || !mounted) return;
    setState(() => _selectedDocumentType = selected);
  }

  Future<void> _onUploadPressed() async {
    final cameraStatus = await Permission.camera.request();
    final photosStatus = await Permission.photos.request();

    final hasAccess = cameraStatus.isGranted ||
        cameraStatus.isLimited ||
        photosStatus.isGranted ||
        photosStatus.isLimited;

    if (!hasAccess) {
      if (!mounted) return;
      await _showPermissionDialog();
      return;
    }

    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.isEmpty || !mounted) return;

    setState(() => _pickedFileName = result.files.single.name);
  }

  Future<void> _showPermissionDialog() async {
    final i18n = AppI18n.current;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          i18n.familyConfirmDialogTitle,
          style: AppTextStyles.titleLarge,
        ),
        content: Text(
          i18n.documentProofPermissionDialogBody,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              i18n.answerNo,
              style: AppTextStyles.m3LabelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text(
              i18n.documentProofPermissionSettingsAction,
              style: AppTextStyles.m3LabelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirm() {
    if (!_canConfirm) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: Text(i18n.documentProofSubmitAppBarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.documentTitle,
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      i18n.documentAddressProofDescription,
                      style: AppTextStyles.bodyMedium,
                    ),
                    Spacer(),
                    _buildDocumentTypeSelector(i18n),
                    Spacer(),
                    _buildUploadButton(i18n),
                    EbolsaTextField(
                      controller: _valueController,
                      label: _valueFieldLabel,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: EbolsaButton(
                onPressed: _canConfirm ? _onConfirm : null,
                label: i18n.confirmAction,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTypeSelector(AppI18n i18n) {
    final selected = _selectedDocumentType;
    final placeholder = i18n.documentTypeSelectorPlaceholder;

    return SizedBox(
      height: 56,
      child: InkWell(
        onTap: _openDocumentTypeSelector,
        borderRadius: BorderRadius.circular(16),
        child: InputDecorator(
          decoration: InputDecoration(
            hintText: placeholder,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            suffixIcon: const Icon(Icons.keyboard_arrow_down),
          ),
          child: Text(
            selected ?? placeholder,
            style: selected == null
                ? AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurface.withValues(alpha: 0.6),
                  )
                : AppTextStyles.bodyMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton(AppI18n i18n) {
    final label = _pickedFileName ?? widget.documentTitle;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onUploadPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.secondaryContainer,
          foregroundColor: AppColors.onSurface,
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'lib/ui/assets/icons/upload.svg',
              width: 20,
              color: AppColors.onPrimaryContainer,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
