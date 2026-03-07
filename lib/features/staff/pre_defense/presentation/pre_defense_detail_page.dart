import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/staff/pre_defense/application/pre_defense_provider.dart';
import 'package:arsys/features/staff/pre_defense/presentation/applicant_detail_page.dart';

class PreDefenseDetailPage extends ConsumerWidget {
  final int eventId;
  const PreDefenseDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participantsAsync = ref.watch(preDefenseParticipantsProvider(eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('Pre-Defense Participants')),
      body: participantsAsync.when(
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
          final participants = data['data'] as List<dynamic>? ?? [];
          if (participants.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(preDefenseParticipantsProvider(eventId).future),
              child: ListView(
                children: [
                  const SizedBox(height: 120),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('No participants found', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(preDefenseParticipantsProvider(eventId).future),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final participant = participants[index] as Map<String, dynamic>;
                final programCode = participant['program_code'] ?? '';
                final studentNim = participant['student_nim'] ?? 'N/A';
                final roomName = participant['room_name'] ?? 'N/A';
                final sessionTime = participant['session_time'] ?? 'N/A';

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      final participantId = participant['id'] as int?;
                      if (participantId != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ApplicantDetailPage(participantId: participantId),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.orange.shade400, width: 4)),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Room & session
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(roomName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[600])),
                              const SizedBox(width: 14),
                              Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(sessionTime, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[600])),
                              const Spacer(),
                              Icon(Icons.chevron_right, size: 20, color: Colors.grey[400]),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Student info
                          Text(
                            '$programCode.$studentNim',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.purple[400]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            participant['student_name'] ?? 'N/A',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            (participant['research_title'] ?? 'No Title').toUpperCase(),
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
