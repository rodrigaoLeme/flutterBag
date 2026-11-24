import 'package:flutter/material.dart';

import '../../../../../domain/entities/proof_document_file_url_entity.dart';
import '../../../../../domain/usecases/documents/load_proof_document_file_url_usecase.dart';
import '../../../../../main/factories/usecases/enrollment/enrollment_usecase_factories.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';

class ProofDocumentFilePage extends StatefulWidget {
  final String scholarshipId;
  final String proofDocumentId;

  const ProofDocumentFilePage({
    super.key,
    required this.scholarshipId,
    required this.proofDocumentId,
  });

  @override
  State<ProofDocumentFilePage> createState() => _ProofDocumentFilePageState();
}

class _ProofDocumentFilePageState extends State<ProofDocumentFilePage> {
  final _loadFile = makeRemoteLoadProofDocumentFileUrl();

  ProofDocumentFileUrlEntity? _file;
  String? _error;
  bool _isLoading = true;

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
        proofDocumentId: widget.proofDocumentId,
      );
      if (!mounted) return;
      setState(() {
        _file = file;
        _isLoading = false;
      });
    } on LoadProofDocumentFileUrlException catch (e) {
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

    return EBolsaPdfViwer.fromUrl(file.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_file?.filename ?? AppI18n.current.documentFileAppBarTitle),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: _buildBody(),
    );
  }
}
