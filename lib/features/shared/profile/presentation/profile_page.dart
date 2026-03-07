import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/shared/profile/application/profile_provider.dart';
import 'package:arsys/features/shared/profile/data/profile_repository.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isEditing = false;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateFields(Map<String, dynamic> profile) {
    if (!_isEditing) {
      _nameController.text = profile['name'] ?? '';
      _emailController.text = profile['email'] ?? '';
      _phoneController.text = profile['phone'] ?? '';
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await ref.read(profileRepositoryProvider).updateProfile({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      });
      ref.invalidate(profileProvider);
      if (mounted) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'Edit Profile',
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _isEditing = false),
              tooltip: 'Cancel',
            ),
            IconButton(
              icon: _isSaving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.check),
              onPressed: _isSaving ? null : _saveProfile,
              tooltip: 'Save',
            ),
          ],
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              const SizedBox(height: 12),
              Text('$err', style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(profileProvider),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (profile) {
          _populateFields(profile);
          final staff = profile['staff'] as Map<String, dynamic>?;
          final student = profile['student'] as Map<String, dynamic>?;
          final roles = (profile['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Avatar & name header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.purple[100],
                        child: Text(
                          (profile['name'] ?? 'U').toString().substring(0, 1).toUpperCase(),
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.purple[700]),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (!_isEditing)
                        Text(profile['name'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        children: roles.map((r) => Chip(
                          label: Text(r, style: const TextStyle(fontSize: 11)),
                          backgroundColor: Colors.purple[50],
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        )).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Editable fields
                _buildField('Name', _nameController, _isEditing),
                _buildField('Email', _emailController, _isEditing, keyboardType: TextInputType.emailAddress),
                _buildField('Phone', _phoneController, _isEditing, keyboardType: TextInputType.phone),

                // Read-only info
                if (staff != null) ...[
                  const SizedBox(height: 16),
                  _sectionHeader('Staff Information'),
                  _readOnlyTile('Staff Code', staff['code'] ?? '-'),
                  _readOnlyTile('Program', staff['program_name'] ?? '-'),
                  _readOnlyTile('Position', staff['position'] ?? '-'),
                ],
                if (student != null) ...[
                  const SizedBox(height: 16),
                  _sectionHeader('Student Information'),
                  _readOnlyTile('NIM', student['code'] ?? '-'),
                  _readOnlyTile('Program', student['program_name'] ?? '-'),
                  _readOnlyTile('Level', student['level'] ?? '-'),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, bool editable, {TextInputType? keyboardType}) {
    if (!editable) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _readOnlyTile(label, controller.text.isEmpty ? '-' : controller.text),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: (v) => (v == null || v.isEmpty) ? '$label is required' : null,
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.purple[700])),
    );
  }

  Widget _readOnlyTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600]))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
