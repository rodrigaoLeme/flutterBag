import 'package:flutter/material.dart';

import '../../../../components/ebolsa_pdf_viewer.dart';

class ProofFileViewerPage extends StatelessWidget {
  final String title;
  final String url;

  const ProofFileViewerPage(
      {super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title, overflow: TextOverflow.ellipsis)),
      body: SafeArea(child: EBolsaPdfViwer.fromUrl(url)),
    );
  }
}
