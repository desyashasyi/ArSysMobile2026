import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/student/event/application/student_event_provider.dart';

class StudentEventDetailPage extends ConsumerWidget {
  final int eventId;

  const StudentEventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(studentEventDetailProvider(eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('Event Detail')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          final examinationType = data['examination_type'] as String?;
          final rooms = (data['rooms'] as List?) ?? [];

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(studentEventDetailProvider(eventId)),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EventInfoCard(data: data),
                  const SizedBox(height: 16),
                  Text(
                    'Schedule (${rooms.length} rooms)',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (rooms.isEmpty)
                    const Card(child: ListTile(title: Text('No schedule yet')))
                  else
                    ...rooms.map<Widget>((r) {
                      final room = r as Map<String, dynamic>;
                      return _RoomCard(
                        room: room,
                        typeColor: examinationType == 'Defense' ? Colors.orange : Colors.deepPurple,
                        groupSupervisors: examinationType == 'Defense',
                      );
                    }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- Event Info Card ---

class _EventInfoCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _EventInfoCard({required this.data});

  Color _getTypeColor(String? examinationType) {
    switch (examinationType) {
      case 'Defense':
        return Colors.orange;
      case 'Final-defense':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final examinationType = data['examination_type'] as String?;
    final typeColor = _getTypeColor(examinationType);
    final completed = data['completed'] == true || data['completed'] == 1;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data['type_description'] ?? examinationType ?? 'Event',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: typeColor),
                  ),
                ),
                const Spacer(),
                if (completed)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Completed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow(Icons.calendar_today, 'Date', data['event_date'] ?? '-'),
            const SizedBox(height: 6),
            _infoRow(Icons.timer, 'Deadline', data['application_deadline'] ?? '-'),
            const SizedBox(height: 6),
            _infoRow(Icons.description, 'Draft Deadline', data['draft_deadline'] ?? '-'),
            const SizedBox(height: 6),
            _infoRow(Icons.people, 'Participants', '${data['current'] ?? 0} / ${data['quota'] ?? '-'}'),
            if (data['program_name'] != null) ...[
              const SizedBox(height: 6),
              _infoRow(Icons.school, 'Program', data['program_name']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
      ],
    );
  }
}

// --- Shared Room Card for both Pre-defense and Final-defense ---

class _RoomCard extends StatelessWidget {
  final Map<String, dynamic> room;
  final Color typeColor;
  final bool groupSupervisors;

  const _RoomCard({
    required this.room,
    required this.typeColor,
    this.groupSupervisors = false,
  });

  /// Collect unique supervisors from all applicants in this room.
  List<Map<String, dynamic>> _collectSupervisors(List applicants) {
    final seen = <String>{};
    final result = <Map<String, dynamic>>[];
    for (final a in applicants) {
      final sups = (a['supervisors'] as List?) ?? [];
      for (final s in sups) {
        final sup = s as Map<String, dynamic>;
        final code = sup['code'] as String? ?? '';
        if (code.isNotEmpty && seen.add(code)) {
          result.add(sup);
        }
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final examiners = (room['examiners'] as List?) ?? [];
    final applicants = (room['applicants'] as List?) ?? [];
    final moderator = room['moderator'] as Map<String, dynamic>?;
    final supervisors = groupSupervisors ? _collectSupervisors(applicants) : <Map<String, dynamic>>[];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: typeColor.withValues(alpha: 0.15),
          child: Text(
            room['label'] ?? '',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: typeColor),
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.meeting_room, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(room['space'] ?? 'TBD', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.access_time, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text(room['session'] ?? 'TBD', style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 12),
            const Icon(Icons.people, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text('${applicants.length}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        children: [
          // Moderator (Final-defense only)
          if (moderator != null) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Moderator', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 2, bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 13, color: Colors.green),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text('${moderator['name']} (${moderator['code']})', style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],

          // Supervisors
          if (supervisors.isNotEmpty) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Supervisors', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.indigo)),
            ),
            ...supervisors.map<Widget>((sup) {
              return Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: Row(
                  children: [
                    const Icon(Icons.supervisor_account, size: 13, color: Colors.indigo),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text('${sup['name']} (${sup['code']})', style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
          ],

          // Examiners
          if (examiners.isNotEmpty) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Examiners', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
            ),
            ...examiners.map<Widget>((e) {
              final ex = e as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, size: 13, color: Colors.blueGrey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text('${ex['name']} (${ex['code']})', style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
          ],

          // Applicants
          if (applicants.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Participants', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: typeColor)),
            ),
            const SizedBox(height: 4),
            ...applicants.asMap().entries.map<Widget>((entry) {
              final index = entry.key;
              final a = entry.value as Map<String, dynamic>;
              return _ApplicantRow(applicant: a, index: index + 1, showSupervisors: !groupSupervisors);
            }),
          ],
        ],
      ),
    );
  }
}

class _ApplicantRow extends StatelessWidget {
  final Map<String, dynamic> applicant;
  final int index;
  final bool showSupervisors;

  const _ApplicantRow({
    required this.applicant,
    required this.index,
    this.showSupervisors = false,
  });

  @override
  Widget build(BuildContext context) {
    final supervisors = showSupervisors ? ((applicant['supervisors'] as List?) ?? []) : [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$index. ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${applicant['student_name']} (${applicant['student_number'] ?? ''})',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  applicant['research_title'] ?? '',
                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (supervisors.isNotEmpty)
                  ...supervisors.map<Widget>((s) {
                    final sup = s as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Row(
                        children: [
                          const Icon(Icons.supervisor_account, size: 11, color: Colors.indigo),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text('${sup['name']} (${sup['code']})', style: const TextStyle(fontSize: 10)),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
