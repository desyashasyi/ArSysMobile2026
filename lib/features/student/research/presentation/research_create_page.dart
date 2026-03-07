import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:arsys/features/student/research/application/student_research_provider.dart';
import 'package:arsys/features/student/research/data/student_research_repository.dart';
import 'package:arsys/core/utils/snackbar_helper.dart';

class ResearchCreatePage extends ConsumerStatefulWidget {
  const ResearchCreatePage({super.key});

  @override
  ConsumerState<ResearchCreatePage> createState() => _ResearchCreatePageState();
}

class _ResearchCreatePageState extends ConsumerState<ResearchCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _abstractController = TextEditingController();
  final _fileUrlController = TextEditingController();

  int? _selectedTypeId;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _abstractController.dispose();
    _fileUrlController.dispose();
    super.dispose();
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
    if (_selectedTypeId == null) {
      showErrorSnackBar(context, 'Please select a research type.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final fileUrl = _fileUrlController.text.trim();

      // Check URL accessibility if provided
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
      await repo.createResearch(
        typeId: _selectedTypeId!,
        title: _titleController.text.trim(),
        abstract: _abstractController.text.trim(),
        fileUrl: fileUrl.isEmpty ? null : fileUrl,
      );

      if (mounted) {
        showSuccessSnackBar(context, 'Research created successfully.');
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
    final typesAsync = ref.watch(researchTypesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Research')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Research Type Dropdown
              typesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Failed to load types: $err'),
                data: (types) {
                  return DropdownButtonFormField<int>(
                    value: _selectedTypeId,
                    decoration: const InputDecoration(
                      labelText: 'Research Type',
                      border: OutlineInputBorder(),
                    ),
                    items: types.map<DropdownMenuItem<int>>((t) {
                      final type = t as Map<String, dynamic>;
                      return DropdownMenuItem<int>(
                        value: type['id'] as int,
                        child: Text('${type['code']} - ${type['description']}', overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedTypeId = value),
                    validator: (value) => value == null ? 'Please select a type' : null,
                    isExpanded: true,
                  );
                },
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
                      : const Text('Create Research', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
