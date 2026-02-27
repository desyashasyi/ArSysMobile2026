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
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          final participants = data['data'] as List<dynamic>? ?? [];
          if (participants.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(preDefenseParticipantsProvider(eventId).future),
              child: const Center(child: Text('No participants found for this event.'))
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(preDefenseParticipantsProvider(eventId).future),
            child: ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final participant = participants[index] as Map<String, dynamic>;
                final programCode = participant['program_code'] ?? '';
                final studentNim = participant['student_nim'] ?? 'N/A';
                final roomName = participant['room_name'] ?? 'N/A';
                final sessionTime = participant['session_time'] ?? 'N/A';
                final milestoneName = participant['milestone_name'] ?? 'N/A';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 12, color: Colors.blueGrey),
                            const SizedBox(width: 4),
                            Text(
                              roomName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.access_time, size: 12, color: Colors.blueGrey),
                            const SizedBox(width: 4),
                            Text(
                              sessionTime,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$programCode.$studentNim',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          participant['student_name'] ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text((participant['research_title'] ?? 'No Title').toUpperCase()),
                        const SizedBox(height: 4),
                        Text(
                          milestoneName,
                          style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
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
