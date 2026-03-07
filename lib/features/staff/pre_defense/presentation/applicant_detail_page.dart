import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/staff/pre_defense/application/pre_defense_provider.dart';
import 'package:arsys/features/staff/pre_defense/data/pre_defense_repository.dart';
import 'package:arsys/core/utils/snackbar_helper.dart';

class ApplicantDetailPage extends ConsumerWidget {
  final int participantId;

  const ApplicantDetailPage({super.key, required this.participantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defenseDetailAsync = ref.watch(preDefenseParticipantDetailProvider(participantId));

    return Scaffold(
      appBar: AppBar(title: const Text('Applicant Detail')),
      body: defenseDetailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              const SizedBox(height: 12),
              Text('Error: $err', style: TextStyle(color: Colors.grey[600]), textAlign: TextAlign.center),
            ],
          ),
        ),
        data: (data) {
          final participant = data['participant'];
          final research = participant['research'];
          final student = research['student'];
          final supervisors = (research['supervisor'] as List?)?.where((s) => s != null).toList() ?? [];
          final examiners = (participant['defense_examiner'] as List?)?.where((e) => e != null).toList() ?? [];

          final isSupervisor = data['is_supervisor'] as bool? ?? false;
          final isExaminer = data['is_examiner'] as bool? ?? false;
          final isExaminerPresent = data['is_examiner_present'] as bool? ?? false;

          final programCode = student?['program_code'] ?? '';
          final studentNim = student?['number'] ?? '';
          final studentName = '${student?['first_name'] ?? ''} ${student?['last_name'] ?? ''}'.trim();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(preDefenseParticipantDetailProvider(participantId));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student info card
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.orange.shade400, width: 4)),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                participant['room_name'] ?? 'N/A',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[600]),
                              ),
                              const SizedBox(width: 14),
                              Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                participant['session_time'] ?? 'N/A',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '$programCode.$studentNim',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.purple[400]),
                          ),
                          const SizedBox(height: 4),
                          Text(studentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          Text(
                            (research?['title'] ?? 'No Title').toUpperCase(),
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.flag_outlined, size: 14, color: Colors.purple[300]),
                              const SizedBox(width: 6),
                              Text(
                                research?['milestone_name'] ?? 'N/A',
                                style: TextStyle(fontSize: 12, color: Colors.purple[400], fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Supervisors
                  _buildSectionHeader(Icons.supervisor_account, 'Supervisors'),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: List.generate(supervisors.length, (index) {
                        final s = supervisors[index];
                        return Column(
                          children: [
                            if (index > 0) const Divider(height: 1),
                            ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.purple[50],
                                child: Icon(Icons.person, size: 18, color: Colors.purple[400]),
                              ),
                              title: Text(s['name'] ?? 'Unknown', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              subtitle: Text(s['code'] ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Examiners
                  _buildSectionHeader(Icons.people_alt, 'Examiners'),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        ...List.generate(examiners.length, (index) {
                          final e = examiners[index];
                          final isPresent = e['is_present'] as bool? ?? false;
                          return Column(
                            children: [
                              if (index > 0) const Divider(height: 1),
                              ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: isPresent ? Colors.green[50] : Colors.grey[100],
                                  child: Icon(Icons.person, size: 18, color: isPresent ? Colors.green : Colors.grey),
                                ),
                                title: Text(e['name'] ?? 'Unknown', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                subtitle: Text(e['code'] ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                                trailing: isSupervisor
                                    ? IconButton(
                                        icon: Icon(
                                          isPresent ? Icons.check_circle : Icons.check_circle_outline,
                                          color: isPresent ? Colors.green : Colors.grey[300],
                                          size: 24,
                                        ),
                                        onPressed: () async {
                                          try {
                                            await ref.read(preDefenseRepositoryProvider).toggleExaminerPresence(e['id']);
                                            ref.invalidate(preDefenseParticipantDetailProvider(participantId));
                                            if (context.mounted) {
                                              showSuccessSnackBar(context, 'Presence updated successfully.');
                                            }
                                          } catch (err) {
                                            if (context.mounted) {
                                              showErrorSnackBar(context, 'Error: ${err.toString()}');
                                            }
                                          }
                                        },
                                        tooltip: 'Toggle Presence',
                                      )
                                    : Icon(
                                        isPresent ? Icons.check_circle : Icons.check_circle_outline,
                                        color: isPresent ? Colors.green : Colors.grey[300],
                                        size: 22,
                                      ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  if (isSupervisor)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () => _showAddExaminerSheet(context, ref, participantId),
                          icon: const Icon(Icons.person_add, size: 18),
                          label: const Text('Add Examiner'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange[700],
                            side: BorderSide(color: Colors.orange.shade300),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Score section
                  _buildSectionHeader(Icons.grading, 'Submit Score'),
                  const SizedBox(height: 8),
                  _buildScoreButtons(context, ref, participantId, isSupervisor, isExaminer, isExaminerPresent, data),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddExaminerSheet(BuildContext context, WidgetRef ref, int participantId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.purple[50],
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddExaminerSheet(participantId: participantId),
      ),
    );
  }

  void _showSubmitScoreSheet(BuildContext context, WidgetRef ref, int participantId, Map<String, dynamic> data, {required String role}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.purple[50],
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SubmitScoreSheet(participantId: participantId, data: data, role: role),
      ),
    );
  }

  void _showScoreGuideSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.purple[50],
      builder: (context) => const ScoreGuideSheet(),
    );
  }

  Widget _buildScoreButtons(BuildContext context, WidgetRef ref, int participantId, bool isSupervisor, bool isExaminer, bool isExaminerPresent, Map<String, dynamic> data) {
    final mySupervisorScore = data['my_supervisor_score'];
    final myExaminerScore = data['my_examiner_score'];
    final myScoreColorName = data['my_score_color'] as String?;
    final cardColor = myScoreColorName == 'success' ? Colors.green[50] : null;

    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                if (isSupervisor)
                  Expanded(
                    child: _buildScoreChip(
                      label: 'Supervisor',
                      score: mySupervisorScore,
                      color: Colors.purple,
                      onTap: () => _showSubmitScoreSheet(context, ref, participantId, data, role: 'supervisor'),
                    ),
                  ),
                if (isSupervisor && isExaminer && isExaminerPresent) const SizedBox(width: 8),
                if (isExaminer && isExaminerPresent)
                  Expanded(
                    child: _buildScoreChip(
                      label: 'Examiner',
                      score: myExaminerScore,
                      color: Colors.orange,
                      onTap: () => _showSubmitScoreSheet(context, ref, participantId, data, role: 'examiner'),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () => _showScoreGuideSheet(context, ref),
                icon: Icon(Icons.info_outline, size: 16, color: Colors.purple[400]),
                label: Text('Scoring Guide', style: TextStyle(color: Colors.purple[400])),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreChip({required String label, dynamic score, required Color color, required VoidCallback onTap}) {
    final hasScore = score != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: hasScore ? color.withValues(alpha: 0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: hasScore ? color.withValues(alpha: 0.3) : Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text(
              hasScore ? '$score' : 'Tap to score',
              style: TextStyle(
                fontSize: hasScore ? 18 : 13,
                fontWeight: hasScore ? FontWeight.bold : FontWeight.normal,
                color: hasScore ? color : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.orange[700]),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class AddExaminerSheet extends ConsumerStatefulWidget {
  final int participantId;
  const AddExaminerSheet({super.key, required this.participantId});

  @override
  ConsumerState<AddExaminerSheet> createState() => _AddExaminerSheetState();
}

class _AddExaminerSheetState extends ConsumerState<AddExaminerSheet> {
  final _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  dynamic _selectedStaff;

  void _searchStaff(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final results = await ref.read(preDefenseRepositoryProvider).searchStaff(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) showErrorSnackBar(context, 'Error: ${e.toString()}');
    }
  }

  void _addExaminer() async {
    if (_selectedStaff == null) return;
    try {
      await ref.read(preDefenseRepositoryProvider).addExaminer(widget.participantId, _selectedStaff['id']);
      ref.invalidate(preDefenseParticipantDetailProvider(widget.participantId));
      if (mounted) {
        Navigator.of(context).pop();
        showSuccessSnackBar(context, 'Examiner added successfully.');
      }
    } catch (e) {
      if (mounted) showErrorSnackBar(context, 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Add Examiner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by staff code',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _searchStaff,
            ),
            if (_isLoading) const LinearProgressIndicator(),
            if (_searchResults.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final staff = _searchResults[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.purple[50],
                        child: Icon(Icons.person, size: 18, color: Colors.purple[400]),
                      ),
                      title: Text('${staff['first_name']} ${staff['last_name']}'),
                      subtitle: Text(staff['code']),
                      onTap: () {
                        setState(() {
                          _selectedStaff = staff;
                          _searchController.text = '${staff['first_name']} ${staff['last_name']}';
                          _searchResults = [];
                        });
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _selectedStaff != null ? _addExaminer : null,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[200],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubmitScoreSheet extends ConsumerStatefulWidget {
  final int participantId;
  final Map<String, dynamic> data;
  final String role;
  const SubmitScoreSheet({super.key, required this.participantId, required this.data, required this.role});

  @override
  ConsumerState<SubmitScoreSheet> createState() => _SubmitScoreSheetState();
}

class _SubmitScoreSheetState extends ConsumerState<SubmitScoreSheet> {
  final _scoreController = TextEditingController();
  final _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final scoreKey = widget.role == 'supervisor' ? 'my_supervisor_score' : 'my_examiner_score';
    final remarkKey = widget.role == 'supervisor' ? 'my_supervisor_remark' : 'my_examiner_remark';
    _scoreController.text = widget.data[scoreKey]?.toString() ?? '';
    _remarkController.text = widget.data[remarkKey] ?? '';
  }

  void _submitScore() async {
    final score = int.tryParse(_scoreController.text);
    final remark = _remarkController.text;
    if (score == null || score < 1 || score > 400) {
      if (mounted) showErrorSnackBar(context, 'Please enter a valid score between 1 and 400');
      return;
    }
    try {
      await ref.read(preDefenseRepositoryProvider).submitScore(widget.participantId, score, remark: remark);
      ref.invalidate(preDefenseParticipantDetailProvider(widget.participantId));
      if (mounted) {
        Navigator.of(context).pop();
        showSuccessSnackBar(context, 'Score submitted successfully');
      }
    } catch (e) {
      if (mounted) showErrorSnackBar(context, 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSuper = widget.role == 'supervisor';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.grading, color: isSuper ? Colors.purple : Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Submit ${isSuper ? 'Supervisor' : 'Examiner'} Score',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _scoreController,
              decoration: InputDecoration(
                labelText: 'Score (1-400)',
                prefixIcon: const Icon(Icons.score),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _remarkController,
              decoration: InputDecoration(
                labelText: 'Remark',
                prefixIcon: const Icon(Icons.note),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitScore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSuper ? Colors.purple : Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Score', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreGuideSheet extends ConsumerWidget {
  const ScoreGuideSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreGuideAsync = ref.watch(scoreGuideProvider);
    return scoreGuideAsync.when(
      loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
      error: (err, stack) => SizedBox(height: 200, child: Center(child: Text('Error: $err'))),
      data: (scoreGuide) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 60.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.purple),
                    SizedBox(width: 8),
                    Text('Scoring Guide', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                      0: FlexColumnWidth(1.5),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(3),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.purple[50]),
                        children: const [
                          Padding(padding: EdgeInsets.all(10.0), child: Text('Code', style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(10.0), child: Text('Value', style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(10.0), child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                      ...scoreGuide.map((score) {
                        return TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.all(10.0), child: Text(score['code'], style: const TextStyle(fontWeight: FontWeight.w600))),
                            Padding(padding: const EdgeInsets.all(10.0), child: Text(score['value'])),
                            Padding(padding: const EdgeInsets.all(10.0), child: Text(score['description'])),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
