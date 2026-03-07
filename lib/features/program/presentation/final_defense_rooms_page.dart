import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/program/application/program_provider.dart';
import 'package:arsys/features/program/presentation/final_defense_room_detail_page.dart';

class FinalDefenseRoomsPage extends ConsumerWidget {
  final int eventId;
  final String eventCode;

  const FinalDefenseRoomsPage({super.key, required this.eventId, required this.eventCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(programFinalDefenseRoomsProvider(eventId));

    return Scaffold(
      appBar: AppBar(title: Text('${eventCode.toUpperCase()} Rooms')),
      body: roomsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              const SizedBox(height: 12),
              Text('$err', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(programFinalDefenseRoomsProvider(eventId)),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (rooms) {
          if (rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.meeting_room_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('No rooms found', style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(programFinalDefenseRoomsProvider(eventId).future),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index] as Map<String, dynamic>;
                final hasMissing = room['has_missing_scores'] == true;
                final spaceName = room['room_name'] ?? 'Room ${index + 1}';
                final sessionName = room['session_time'] ?? '';
                final applicantCount = room['applicant_count'] ?? 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      final roomId = room['id'] as int?;
                      if (roomId != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FinalDefenseRoomDetailPage(eventId: eventId, roomId: roomId, roomName: spaceName.toString()),
                        ));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: hasMissing ? Colors.red.shade400 : Colors.green.shade400, width: 4)),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: hasMissing ? Colors.red[50] : Colors.deepPurple[50],
                            child: Icon(Icons.meeting_room, size: 20, color: hasMissing ? Colors.red[600] : Colors.deepPurple[600]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(spaceName.toString(), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                if (sessionName.toString().isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(sessionName.toString(), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                ],
                                const SizedBox(height: 2),
                                Text('$applicantCount applicant(s)', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                              ],
                            ),
                          ),
                          if (hasMissing)
                            Icon(Icons.warning_amber, size: 22, color: Colors.red[500])
                          else
                            Icon(Icons.check_circle, size: 22, color: Colors.green[400]),
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
