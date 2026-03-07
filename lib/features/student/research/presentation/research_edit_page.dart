import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:arsys/features/student/research/application/student_research_provider.dart';
import 'package:arsys/features/student/research/data/student_research_repository.dart';
import 'package:arsys/core/utils/snackbar_helper.dart';

class ResearchEditPage extends ConsumerStatefulWidget {
  final int researchId;

  const ResearchEditPage({super.key, required this.researchId});

  @override
  ConsumerState<ResearchEditPage> createState() => _ResearchEditPageState();
}

class _ResearchEditPageState extends ConsumerState<ResearchEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _abstractController = TextEditingController();
  final _fileUrlController = TextEditingController();

  bool _isSubmitting = false;
  bool _initialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _abstractController.dispose();
    _fileUrlController.dispose();
    super.dispose();
  }

  void _initFields(Map<String, dynamic> data) {
    if (_initialized) return;
    _titleController.text = data['title'] ?? '';
    _abstractController.text = data['abstract'] ?? '';
    _fileUrlController.text = data['file'] ?? '';
    _initialized = true;
  }

  Future<bool> _checkUrlAccessible(String url) async {
    try {
      final response = await http.head(Uri.parse(url)).timeout(const Duration(seconds: 10));
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (_) {
      return false;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final fileUrl = _fileUrlController.text.trim();

      if (fileUrl.isNotEmpty) {
        final isAccessible = await _checkUrlAccessible(fileUrl);
        if (!isAccessible) {
          if (mounted) {
            showErrorSnackBar(context, 'The file URL is not accessible. Please make sure it is publicly shared.');
          }
          return;
        }
      }

      final repo = ref.read(studentResearchRepositoryProvider);
      await repo.updateResearch(
        widget.researchId,
        title: _titleController.text.trim(),
        abstract: _abstractController.text.trim(),
        fileUrl: fileUrl.isEmpty ? null : fileUrl,
      );

      if (mounted) {
        showSuccessSnackBar(context, 'Research updated successfully.');
        ref.invalidate(studentResearchDetailProvider(widget.researchId));
        ref.invalidate(studentResearchListProvider);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(studentResearchDetailProvider(widget.researchId));

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Research')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (data) {
          _initFields(data);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Research info (read-only)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['code'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                          const SizedBox(height: 4),
                          Text(data['type_name'] ?? '', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Abstract
                  TextFormField(
                    controller: _abstractController,
                    decoration: const InputDecoration(
                      labelText: 'Abstract',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 6,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Abstract is required' : null,
                  ),
                  const SizedBox(height: 16),

                  // File URL (optional)
                  TextFormField(
                    controller: _fileUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Google Drive File URL (optional)',
                      border: OutlineInputBorder(),
                      hintText: 'https://drive.google.com/...',
                      helperText: 'Files that are not publicly accessible will not be processed.',
                      helperMaxLines: 2,
                    ),
                    validator: (v) {
                      if (v != null && v.trim().isNotEmpty) {
                        final uri = Uri.tryParse(v.trim());
                        if (uri == null || !uri.hasScheme || !uri.host.contains('.')) {
                          return 'Please enter a valid URL';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                      child: _isSubmitting
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Save Changes', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
