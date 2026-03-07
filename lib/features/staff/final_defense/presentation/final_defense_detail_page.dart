import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/staff/final_defense/application/final_defense_provider.dart';
import 'package:arsys/features/staff/final_defense/data/final_defense_repository.dart';
import 'package:arsys/core/utils/snackbar_helper.dart';

class FinalDefenseDetailPage extends ConsumerWidget {
  final int eventId;
  final String eventCode;
  const FinalDefenseDetailPage({super.key, required this.eventId, required this.eventCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(finalDefenseDetailProvider(eventId));

    return Scaffold(
      appBar: AppBar(title: Text(eventCode)),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              const SizedBox(height: 12),
              Text('Failed to load rooms: $err', style: TextStyle(color: Colors.grey[600]), textAlign: TextAlign.center),
            ],
          ),
        ),
        data: (data) {
          final allRooms = data['data'] as List<dynamic>? ?? [];
          if (allRooms.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(finalDefenseDetailProvider(eventId).future),
              child: ListView(
                children: [
                  const SizedBox(height: 120),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.meeting_room_outlined, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('No rooms found for you', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          final examinerRooms = allRooms.where((r) => r['is_examiner_or_moderator'] == true).toList();
          final supervisorRooms = allRooms.where((r) => (r['supervised_applicant_ids'] as List).isNotEmpty).toList();

          return RefreshIndicator(
            onRefresh: () => ref.refresh(finalDefenseDetailProvider(eventId).future),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (examinerRooms.isNotEmpty)
                  ...examinerRooms.map((room) => _ExaminerRoomCard(room: room as Map<String, dynamic>, eventId: eventId)),
                if (supervisorRooms.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.supervisor_account, size: 20, color: Colors.deepPurple[400]),
                      const SizedBox(width: 8),
                      const Text("Supervised Students", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...supervisorRooms.map((room) => _SupervisorRoomCard(room: room as Map<String, dynamic>, eventId: eventId)),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ExaminerRoomCard extends ConsumerWidget {
  final Map<String, dynamic> room;
  final int eventId;
  const _ExaminerRoomCard({required this.room, required this.eventId});

  Future<void> _showConfirmationDialog(BuildContext context, String title, String content, VoidCallback onConfirm) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moderator = room['moderator'] as Map<String, dynamic>?;
    final examiners = room['examiners'] as List<dynamic>? ?? [];
    final applicants = room['applicants'] as List<dynamic>? ?? [];
    final supervisedApplicantIds = (room['supervised_applicant_ids'] as List).cast<int>();
    final isCurrentUserModerator = room['is_current_user_moderator'] as bool? ?? false;

    final moderatorCode = moderator?['code'] as String?;
    final filteredExaminers = examiners.where((examiner) {
      final examinerCode = (examiner as Map<String, dynamic>)['code'] as String?;
      if (moderatorCode == null) return true;
      return examinerCode != moderatorCode;
    }).toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.deepPurple.shade400, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room header
            Container(
              padding: const EdgeInsets.all(14),
              color: Colors.deepPurple.withValues(alpha: 0.04),
              child: Row(
                children: [
                  Icon(Icons.meeting_room, size: 18, color: Colors.deepPurple[600]),
                  const SizedBox(width: 8),
                  Expanded(child: Text(room['room_name'] ?? 'N/A', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepPurple[700]))),
                  const SizedBox(width: 12),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(room['session_time'] ?? 'N/A', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),

            // Examiners and moderator
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Row(
                children: [
                  Icon(Icons.people_alt, size: 16, color: Colors.deepPurple[400]),
                  const SizedBox(width: 6),
                  Text('Examiners & Moderator', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.deepPurple[400])),
                ],
              ),
            ),
            if (moderator != null)
              _buildPersonTile(
                name: '${moderator['name']} (${moderator['code']})',
                isModerator: true,
              ),
            if (moderator != null && filteredExaminers.isNotEmpty)
              const Divider(height: 1, indent: 56),
            ...filteredExaminers.asMap().entries.map((entry) {
              final index = entry.key;
              final examiner = entry.value as Map<String, dynamic>;
              final staffId = examiner['staff_id'] as int?;
              final examinerId = examiner['id'] as int?;

              return Column(
                children: [
                  if (index > 0) const Divider(height: 1, indent: 56),
                  _buildPersonTile(
                    name: '${examiner['name']} (${examiner['code']})',
                    isPresent: examiner['is_present'] ?? false,
                    isSwitchable: isCurrentUserModerator && staffId != null,
                    onSwitch: () {
                      _showConfirmationDialog(
                        context,
                        'Switch Moderator',
                        'Are you sure you want to make ${examiner['name']} the new moderator?',
                        () async {
                          try {
                            await ref.read(finalDefenseRepositoryProvider).switchModerator(room['id'], staffId!);
                            if (context.mounted) showSuccessSnackBar(context, 'Moderator switched successfully!');
                            ref.refresh(finalDefenseDetailProvider(eventId));
                          } catch (e) {
                            if (context.mounted) showErrorSnackBar(context, 'Error: ${e.toString()}');
                          }
                        },
                      );
                    },
                    onTogglePresence: isCurrentUserModerator && examinerId != null
                        ? () async {
                            try {
                              await ref.read(finalDefenseRepositoryProvider).toggleExaminerPresence(room['id'], examinerId);
                              if (context.mounted) showSuccessSnackBar(context, 'Presence updated!');
                              ref.refresh(finalDefenseDetailProvider(eventId));
                            } catch (e) {
                              if (context.mounted) showErrorSnackBar(context, 'Error: ${e.toString()}');
                            }
                          }
                        : null,
                  ),
                ],
              );
            }),

            const Divider(height: 1),

            // Participants
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Row(
                children: [
                  Icon(Icons.school, size: 16, color: Colors.deepPurple[400]),
                  const SizedBox(width: 6),
                  Text('Participants', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.deepPurple[400])),
                ],
              ),
            ),
            ...applicants.asMap().entries.map((entry) {
              final index = entry.key;
              final applicant = entry.value as Map<String, dynamic>;
              final presenceId = applicant['presence_id'] as int?;
              final studentName = applicant['student_name'] as String? ?? '';
              final studentNim = applicant['student_nim'] as String? ?? '';
              final milestoneName = applicant['milestone_name'] as String? ?? 'N/A';
              final myScore = applicant['my_examiner_score'];
              final myRemark = applicant['my_examiner_remark'] as String?;
              final bool isSupervised = supervisedApplicantIds.contains(applicant['id']);

              return Column(
                children: [
                  if (index > 0) const Divider(height: 1, indent: 56),
                  _buildParticipantTile(
                    context: context,
                    ref: ref,
                    name: studentName,
                    nim: studentNim,
                    milestone: milestoneName,
                    myScore: myScore,
                    showScoreButton: !isSupervised,
                    onPressed: () {
                      if (presenceId != null) {
                        _showScoreBottomSheet(context, ref, eventId, presenceId, null, studentName, studentNim, myScore, myRemark);
                      }
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SupervisorRoomCard extends ConsumerWidget {
  final Map<String, dynamic> room;
  final int eventId;
  const _SupervisorRoomCard({required this.room, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supervisedApplicantIds = (room['supervised_applicant_ids'] as List).cast<int>();
    final applicants = (room['applicants'] as List<dynamic>? ?? [])
        .where((a) => supervisedApplicantIds.contains(a['id']))
        .toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.purple.shade300, width: 4)),
        ),
        child: Column(
          children: [
            // Room header
            Container(
              padding: const EdgeInsets.all(14),
              color: Colors.purple.withValues(alpha: 0.04),
              child: Row(
                children: [
                  Icon(Icons.meeting_room, size: 18, color: Colors.purple[600]),
                  const SizedBox(width: 8),
                  Expanded(child: Text(room['room_name'] ?? 'N/A', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.purple[700]))),
                  const SizedBox(width: 12),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(room['session_time'] ?? 'N/A', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            ...applicants.asMap().entries.map((entry) {
              final index = entry.key;
              final applicant = entry.value as Map<String, dynamic>;
              final researchSupervisorId = applicant['research_supervisor_id'] as int?;
              final studentName = applicant['student_name'] as String? ?? '';
              final studentNim = applicant['student_nim'] as String? ?? '';
              final milestoneName = applicant['milestone_name'] as String? ?? 'N/A';
              final myScore = applicant['my_supervisor_score'];
              final myRemark = applicant['my_supervisor_remark'] as String?;

              return Column(
                children: [
                  if (index > 0) const Divider(height: 1, indent: 56),
                  _buildParticipantTile(
                    context: context,
                    ref: ref,
                    name: studentName,
                    nim: studentNim,
                    milestone: milestoneName,
                    myScore: myScore,
                    onPressed: () {
                      if (researchSupervisorId != null) {
                        _showScoreBottomSheet(context, ref, eventId, null, researchSupervisorId, studentName, studentNim, myScore, myRemark);
                      }
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

void _showScoreBottomSheet(BuildContext context, WidgetRef ref, int eventId, int? presenceId, int? supervisorId, String studentName, String studentNim, dynamic myScore, String? myRemark) {
  final scoreController = TextEditingController(text: (myScore != null && myScore != -1) ? myScore.toString() : '');
  final remarkController = TextEditingController(text: myRemark);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    backgroundColor: Colors.deepPurple[50],
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  Icon(Icons.grading, color: Colors.deepPurple[600]),
                  const SizedBox(width: 8),
                  const Text('Submit Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '$studentNim - $studentName',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: scoreController,
                decoration: InputDecoration(
                  labelText: 'Score',
                  prefixIcon: const Icon(Icons.score),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: remarkController,
                decoration: InputDecoration(
                  labelText: 'Remark',
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => _showScoreGuideBottomSheet(context),
                    icon: Icon(Icons.info_outline, size: 16, color: Colors.deepPurple[400]),
                    label: Text('Scoring Guide', style: TextStyle(color: Colors.deepPurple[400])),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final score = int.tryParse(scoreController.text);
                      final remark = remarkController.text;

                      if (score == null) {
                        if (context.mounted) showErrorSnackBar(context, 'Please enter a valid score.');
                        return;
                      }

                      try {
                        if (presenceId != null) {
                          await ref.read(finalDefenseRepositoryProvider).submitExaminerScore(presenceId, score, remark);
                        } else if (supervisorId != null) {
                          await ref.read(finalDefenseRepositoryProvider).submitSupervisorScore(supervisorId, score, remark);
                        } else {
                          throw Exception('No valid ID provided for submission.');
                        }
                        if (context.mounted) showSuccessSnackBar(context, 'Score submitted successfully!');
                        navigator.pop();
                        ref.refresh(finalDefenseDetailProvider(eventId));
                      } catch (e) {
                        if (context.mounted) showErrorSnackBar(context, 'Error: ${e.toString()}');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showScoreGuideBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    backgroundColor: Colors.deepPurple[50],
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
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
                Icon(Icons.info_outline, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text('Scoring Guide', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final scoreGuideAsync = ref.watch(finalDefenseScoreGuideProvider);
                return scoreGuideAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                  data: (scoreGuide) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Table(
                        border: TableBorder.all(color: Colors.grey.shade300),
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1.5),
                          2: FlexColumnWidth(2.5),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: Colors.deepPurple[100]),
                            children: const [
                              Padding(padding: EdgeInsets.all(10.0), child: Text('Grade', style: TextStyle(fontWeight: FontWeight.bold))),
                              Padding(padding: EdgeInsets.all(10.0), child: Text('Score', style: TextStyle(fontWeight: FontWeight.bold))),
                              Padding(padding: EdgeInsets.all(10.0), child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                          ),
                          ...scoreGuide.map((guide) {
                            final item = guide as Map<String, dynamic>;
                            return TableRow(
                              children: [
                                Padding(padding: const EdgeInsets.all(10.0), child: Text(item['code']?.toString() ?? '', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600))),
                                Padding(padding: const EdgeInsets.all(10.0), child: Text(item['value']?.toString() ?? '')),
                                Padding(padding: const EdgeInsets.all(10.0), child: Text(item['description']?.toString() ?? '')),
                              ],
                            );
                          }),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildPersonTile({
  required String name,
  bool isPresent = false,
  bool isModerator = false,
  bool isSwitchable = false,
  VoidCallback? onSwitch,
  VoidCallback? onTogglePresence,
}) {
  return ListTile(
    dense: true,
    leading: CircleAvatar(
      radius: 16,
      backgroundColor: isModerator ? Colors.deepPurple[50] : (isPresent ? Colors.green[50] : Colors.grey[100]),
      child: isSwitchable
          ? InkWell(
              onTap: onSwitch,
              child: Icon(Icons.person, size: 18, color: Colors.deepPurple[400]),
            )
          : Icon(Icons.person, size: 18, color: isModerator ? Colors.deepPurple[400] : (isPresent ? Colors.green : Colors.grey)),
    ),
    title: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
    trailing: isModerator
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('Moderator', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.deepPurple[600])),
          )
        : onTogglePresence != null
            ? IconButton(
                icon: Icon(
                  isPresent ? Icons.check_circle : Icons.check_circle_outline,
                  color: isPresent ? Colors.green : Colors.grey.shade300,
                  size: 22,
                ),
                onPressed: onTogglePresence,
                tooltip: 'Toggle Presence',
              )
            : Icon(
                isPresent ? Icons.check_circle : Icons.check_circle_outline,
                color: isPresent ? Colors.green : Colors.grey.shade300,
                size: 22,
              ),
  );
}

Widget _buildParticipantTile({
  required BuildContext context,
  required WidgetRef ref,
  required String name,
  required String nim,
  required String milestone,
  required VoidCallback onPressed,
  dynamic myScore,
  bool showScoreButton = true,
}) {
  final hasScore = myScore != null && myScore != -1;

  return ListTile(
    dense: true,
    leading: CircleAvatar(
      radius: 16,
      backgroundColor: hasScore ? Colors.green[50] : Colors.grey[100],
      child: Icon(Icons.school, size: 18, color: hasScore ? Colors.green : Colors.grey),
    ),
    title: Text('$name ($nim)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
    subtitle: Row(
      children: [
        Icon(Icons.flag_outlined, size: 12, color: Colors.purple[300]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(milestone, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ),
      ],
    ),
    trailing: showScoreButton
        ? InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: hasScore ? Colors.green.withValues(alpha: 0.1) : Colors.deepPurple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: hasScore ? Colors.green.withValues(alpha: 0.3) : Colors.deepPurple.withValues(alpha: 0.2)),
              ),
              child: Text(
                hasScore ? myScore.toString() : 'Score',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: hasScore ? Colors.green[700] : Colors.deepPurple[400],
                ),
              ),
            ),
          )
        : null,
  );
}
