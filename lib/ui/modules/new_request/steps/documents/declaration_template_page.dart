import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../domain/entities/declaration_template_file_entity.dart';
import '../../../../../domain/usecases/documents/load_declaration_template_file_usecase.dart';
import '../../../../../main/factories/usecases/enrollment/enrollment_usecase_factories.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../../share/utils/file_downloader.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';

class DeclarationTemplatePage extends StatefulWidget {
  final String scholarshipId;
  final String declarationTemplateId;

  const DeclarationTemplatePage({
    super.key,
    required this.scholarshipId,
    required this.declarationTemplateId,
  });

  @override
  State<DeclarationTemplatePage> createState() =>
      _DeclarationTemplatePageState();
}

class _DeclarationTemplatePageState extends State<DeclarationTemplatePage> {
  final _loadFile = makeRemoteLoadDeclarationTemplateFile();
  final _shareKey = GlobalKey();

  DeclarationTemplateFileEntity? _file;
  String? _error;
  bool _isLoading = true;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final file = await _loadFile.load(
        scholarshipId: widget.scholarshipId,
        declarationTemplateId: widget.declarationTemplateId,
      );
      if (!mounted) return;
      setState(() {
        _file = file;
        _isLoading = false;
      });
    } on LoadDeclarationTemplateFileException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = AppI18n.current.errorUnexpected;
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  Future<void> _onDownload() async {
    final uri = Uri.tryParse(_file?.url ?? '');
    if (uri == null) return;
    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted)
        _showError(AppI18n.current.documentFullscreenError);
    } catch (_) {
      if (mounted) _showError(AppI18n.current.documentFullscreenError);
    }
  }

  Future<void> _onShare() async {
    final file = _file;
    if (file == null || _isSharing) return;

    setState(() => _isSharing = true);
    try {
      final local = await downloadToTemp(file.url, filename: file.filename);

      final box = _shareKey.currentContext?.findRenderObject() as RenderBox?;
      final origin =
          box == null ? null : box.localToGlobal(Offset.zero) & box.size;

      await Share.shareXFiles(
        [XFile(local.path, mimeType: file.contentType)],
        sharePositionOrigin: origin,
      );
    } catch (_) {
      if (mounted) _showError(AppI18n.current.documentTemplateShareError);
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Widget _buildActions() {
    final i18n = AppI18n.current;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TemplateAction(
              icon: SvgPicture.asset(
                AppIcons.downloadIcon,
                width: 24,
                color: AppColors.onSurface,
              ),
              label: i18n.documentTemplateDownloadAction,
              onTap: _onDownload,
            ),
            const SizedBox(width: 56),
            _TemplateAction(
              key: _shareKey,
              icon: const Icon(Icons.send_outlined, size: 24),
              label: i18n.documentTemplateShareAction,
              loading: _isSharing,
              onTap: _onShare,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final file = _file;
    if (_error != null || file == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EbolsaErrorBanner(
              message: _error ?? AppI18n.current.errorUnexpected,
            ),
            const SizedBox(height: 16),
            EbolsaButton(
              onPressed: _load,
              isOutlined: true,
              label: AppI18n.current.tryAgain,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(child: EBolsaPdfViwer.fromUrl(file.url)),
        _buildActions(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppI18n.current.documentTemplateAppBarTitle),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: _buildBody(),
    );
  }
}

class _TemplateAction extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final bool loading;

  const _TemplateAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(
            side: BorderSide(color: Color(0xFFB9BDC6)),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: loading ? null : onTap,
            child: SizedBox(
              width: 56,
              height: 56,
              child: Center(
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : icon,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
