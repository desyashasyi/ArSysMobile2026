import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:arsys/features/student/research/application/student_research_provider.dart';
import 'package:arsys/features/student/research/data/student_research_repository.dart';
import 'package:arsys/core/utils/snackbar_helper.dart';

class ResearchRemarkPage extends ConsumerStatefulWidget {
  final int researchId;

  const ResearchRemarkPage({super.key, required this.researchId});

  @override
  ConsumerState<ResearchRemarkPage> createState() => _ResearchRemarkPageState();
}

class _ResearchRemarkPageState extends ConsumerState<ResearchRemarkPage> {
  late quill.QuillController _quillController;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _quillController = quill.QuillController.basic();
  }

  @override
  void dispose() {
    _quillController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getPlainText() {
    return _quillController.document.toPlainText().trim();
  }

  String _getHtmlFromDelta() {
    final plainText = _getPlainText();
    if (plainText.isEmpty) return '';

    final ops = _quillController.document.toDelta().operations;
    final segments = <({String text, Map<String, dynamic>? attrs})>[];
    for (final op in ops) {
      if (op.value is String) {
        segments.add((text: op.value as String, attrs: op.attributes));
      }
    }

    final lines =
        <({List<({String text, Map<String, dynamic>? attrs})> fragments, Map<String, dynamic>? blockAttrs})>[];
    var currentFragments = <({String text, Map<String, dynamic>? attrs})>[];

    for (final seg in segments) {
      final parts = seg.text.split('\n');
      for (int i = 0; i < parts.length; i++) {
        if (parts[i].isNotEmpty) {
          currentFragments.add((text: parts[i], attrs: seg.attrs));
        }
        if (i < parts.length - 1) {
          final isBlockNewline =
              seg.text == '\n' && seg.attrs != null && (seg.attrs!.containsKey('list'));
          lines.add((fragments: currentFragments, blockAttrs: isBlockNewline ? seg.attrs : null));
          currentFragments = [];
        }
      }
    }
    if (currentFragments.isNotEmpty) {
      lines.add((fragments: currentFragments, blockAttrs: null));
    }

    final result = StringBuffer();
    String? currentListType;

    for (final line in lines) {
      final lineHtml = StringBuffer();
      for (final frag in line.fragments) {
        var text = frag.text;
        text = text.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
        final attrs = frag.attrs;
        if (attrs != null) {
          if (attrs.containsKey('bold')) text = '<strong>$text</strong>';
          if (attrs.containsKey('italic')) text = '<em>$text</em>';
          if (attrs.containsKey('underline')) text = '<u>$text</u>';
        }
        lineHtml.write(text);
      }

      final listType = line.blockAttrs?['list'] as String?;

      if (currentListType != null && currentListType != listType) {
        result.write(currentListType == 'ordered' ? '</ol>' : '</ul>');
        currentListType = null;
      }

      if (listType != null) {
        if (currentListType == null) {
          currentListType = listType;
          result.write(listType == 'ordered' ? '<ol>' : '<ul>');
        }
        result.write('<li>$lineHtml</li>');
      } else {
        result.write('<p style="margin:0">$lineHtml</p>');
      }
    }

    if (currentListType != null) {
      result.write(currentListType == 'ordered' ? '</ol>' : '</ul>');
    }

    return result.toString();
  }

  void _addRemark() async {
    final plainText = _getPlainText();
    if (plainText.isEmpty) return;

    setState(() => _isSending = true);

    try {
      final html = _getHtmlFromDelta();
      await ref.read(studentResearchRepositoryProvider).addRemark(widget.researchId, html);
      _quillController.clear();
      ref.invalidate(studentResearchDetailProvider(widget.researchId));
      if (mounted) {
        showSuccessSnackBar(context, 'Remark added.');
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(studentResearchDetailProvider(widget.researchId));

    return Scaffold(
      appBar: AppBar(title: const Text('Remarks')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          final remarks = (data['remarks'] as List?) ?? [];

          return Column(
            children: [
              // Messages area (scrollable, takes remaining space)
              Expanded(
                child: remarks.isEmpty
                    ? const Center(
                        child: Text('No remarks yet', style: TextStyle(color: Colors.grey)),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        itemCount: remarks.length,
                        itemBuilder: (context, index) {
                          final r = remarks[index];
                          return _RemarkBubble(
                            author: r['author'] ?? 'Unknown',
                            message: r['message'] ?? '',
                            createdAt: r['created_at'] ?? '',
                          );
                        },
                      ),
              ),

              // Input area at bottom
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Toolbar
                        quill.QuillSimpleToolbar(
                          controller: _quillController,
                          config: const quill.QuillSimpleToolbarConfig(
                            showBoldButton: true,
                            showItalicButton: true,
                            showUnderLineButton: true,
                            showStrikeThrough: false,
                            showColorButton: false,
                            showBackgroundColorButton: false,
                            showClearFormat: false,
                            showAlignmentButtons: false,
                            showHeaderStyle: false,
                            showListNumbers: true,
                            showListBullets: true,
                            showListCheck: false,
                            showCodeBlock: false,
                            showQuote: false,
                            showIndent: false,
                            showLink: false,
                            showSearchButton: false,
                            showSubscript: false,
                            showSuperscript: false,
                            showInlineCode: false,
                            showFontFamily: false,
                            showFontSize: false,
                            showDirection: false,
                            showDividers: false,
                            showSmallButton: false,
                            showLineHeightButton: false,
                            showClipboardCut: false,
                            showClipboardCopy: false,
                            showClipboardPaste: false,
                            showRedo: false,
                            showUndo: false,
                            multiRowsDisplay: false,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Editor + send button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                constraints: const BoxConstraints(maxHeight: 120),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.shade50,
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: quill.QuillEditor.basic(
                                  controller: _quillController,
                                  focusNode: _focusNode,
                                  config: quill.QuillEditorConfig(
                                    placeholder: 'Type a remark...',
                                    minHeight: 40,
                                    maxHeight: 120,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 44,
                              width: 44,
                              child: Material(
                                color: Colors.purple,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  onTap: _isSending ? null : _addRemark,
                                  customBorder: const CircleBorder(),
                                  child: Center(
                                    child: _isSending
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Icon(Icons.send, color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RemarkBubble extends StatelessWidget {
  final String author;
  final String message;
  final String createdAt;

  const _RemarkBubble({
    required this.author,
    required this.message,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              author,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 4),
            _buildHtmlContent(message),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                createdAt,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHtmlContent(String html) {
    if (html.isEmpty) return const SizedBox.shrink();

    if (!html.contains('<')) {
      return Text(html, style: const TextStyle(fontSize: 13, color: Colors.black87));
    }

    final widgets = <Widget>[];
    bool inOrderedList = false;
    int olCounter = 0;

    final blocks = <({String text, String type})>[];

    for (final match in RegExp(
      r'<p[^>]*>(.*?)</p>|<li>(.*?)</li>|<ul>|</ul>|<ol>|</ol>',
      dotAll: true,
    ).allMatches(html)) {
      final full = match.group(0)!;
      if (full == '<ul>') {
        inOrderedList = false;
        continue;
      }
      if (full == '<ol>') {
        inOrderedList = true;
        olCounter = 0;
        continue;
      }
      if (full == '</ul>' || full == '</ol>') {
        inOrderedList = false;
        continue;
      }
      final pContent = match.group(1);
      final liContent = match.group(2);

      if (pContent != null) {
        blocks.add((text: pContent, type: 'p'));
      } else if (liContent != null) {
        if (inOrderedList) {
          olCounter++;
          blocks.add((text: liContent, type: 'ol:$olCounter'));
        } else {
          blocks.add((text: liContent, type: 'ul'));
        }
      }
    }

    if (blocks.isEmpty) {
      final stripped = html.replaceAll(RegExp(r'<[^>]*>'), '');
      return Text(stripped, style: const TextStyle(fontSize: 13, color: Colors.black87));
    }

    for (final block in blocks) {
      final spans = _parseInlineHtml(block.text);
      if (block.type == 'ul') {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('\u2022 ', style: TextStyle(fontSize: 13, color: Colors.black87)),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                    children: spans,
                  ),
                ),
              ),
            ],
          ),
        ));
      } else if (block.type.startsWith('ol:')) {
        final num = block.type.split(':')[1];
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$num. ', style: const TextStyle(fontSize: 13, color: Colors.black87)),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                    children: spans,
                  ),
                ),
              ),
            ],
          ),
        ));
      } else {
        widgets.add(RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            children: spans,
          ),
        ));
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }

  List<TextSpan> _parseInlineHtml(String html) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'<(strong|em|u|b|i)>(.*?)</\1>', dotAll: true);

    int lastEnd = 0;
    for (final match in regex.allMatches(html)) {
      if (match.start > lastEnd) {
        final before = html.substring(lastEnd, match.start).replaceAll(RegExp(r'<[^>]*>'), '');
        if (before.isNotEmpty) {
          spans.add(TextSpan(text: _decodeHtmlEntities(before)));
        }
      }

      final tag = match.group(1)!;
      final inner = match.group(2)!;
      final innerSpans = _parseInlineHtml(inner);

      FontWeight? weight;
      FontStyle? style;
      TextDecoration? decoration;

      if (tag == 'strong' || tag == 'b') weight = FontWeight.bold;
      if (tag == 'em' || tag == 'i') style = FontStyle.italic;
      if (tag == 'u') decoration = TextDecoration.underline;

      if (innerSpans.length == 1 && innerSpans[0].children == null) {
        spans.add(TextSpan(
          text: innerSpans[0].text,
          style: TextStyle(fontWeight: weight, fontStyle: style, decoration: decoration),
        ));
      } else {
        spans.add(TextSpan(
          style: TextStyle(fontWeight: weight, fontStyle: style, decoration: decoration),
          children: innerSpans,
        ));
      }

      lastEnd = match.end;
    }

    if (lastEnd < html.length) {
      final remaining = html.substring(lastEnd).replaceAll(RegExp(r'<[^>]*>'), '');
      if (remaining.isNotEmpty) {
        spans.add(TextSpan(text: _decodeHtmlEntities(remaining)));
      }
    }

    return spans;
  }

  String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
  }
}
