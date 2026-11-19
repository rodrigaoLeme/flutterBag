import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../helpers/themes/themes.dart';

class ProofGuidance extends StatefulWidget {
  final String? markdown;

  const ProofGuidance({super.key, required this.markdown});

  @override
  State<ProofGuidance> createState() => _ProofGuidanceState();
}

class _ProofGuidanceState extends State<ProofGuidance> {
  static const double _collapsedHeight = 66; // ~3 linhas de bodyMedium

  final _contentKey = GlobalKey();
  bool _measured = false;
  bool _overflows = false;
  bool _expanded = false;

  String get _text {
    final value = widget.markdown?.trim() ?? '';
    return value.isEmpty ? AppI18n.current.documentProofGuidanceDefault : value;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void didUpdateWidget(covariant ProofGuidance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.markdown != widget.markdown) {
      _measured = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    }
  }

  void _measure() {
    if (!mounted) return;
    final box = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    setState(() {
      _overflows = box.size.height > _collapsedHeight + 1;
      _measured = true;
    });
  }

  Future<void> _openLink(String? href) async {
    final uri = href == null ? null : Uri.tryParse(href.trim());
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    final content = KeyedSubtree(
      key: _contentKey,
      child: MarkdownBody(
        data: _text,
        onTapLink: (text, href, title) => _openLink(href),
        styleSheet: MarkdownStyleSheet(
          p: AppTextStyles.bodyMedium,
          listBullet: AppTextStyles.bodyMedium,
          strong:
              AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );

    final collapsed = _measured && _overflows && !_expanded;

    return Opacity(
      opacity: _measured ? 1 : 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (collapsed)
            ClipRect(
              child: SizedBox(
                height: _collapsedHeight,
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  minHeight: 0,
                  maxHeight: double.infinity,
                  child: content,
                ),
              ),
            )
          else
            content,
          if (_measured && _overflows)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _expanded
                      ? i18n.documentProofGuidanceReadLess
                      : i18n.documentProofGuidanceReadMore,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
