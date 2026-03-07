import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/program/application/program_provider.dart';
import 'package:arsys/features/program/presentation/final_defense_rooms_page.dart';

class FinalDefenseScoresPage extends ConsumerWidget {
  const FinalDefenseScoresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(programFinalDefenseEventsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Final Defense Scores')),
      body: eventsAsync.when(
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
                onPressed: () => ref.invalidate(programFinalDefenseEventsProvider),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (events) {
          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.workspace_premium_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('No final-defense events', style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(programFinalDefenseEventsProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final ev = events[index] as Map<String, dynamic>;
                final hasMissing = ev['has_missing_scores'] == true;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      final id = ev['id'] as int?;
                      if (id != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FinalDefenseRoomsPage(eventId: id, eventCode: ev['event_id_string'] ?? ''),
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
                          Icon(Icons.workspace_premium, size: 18, color: Colors.deepPurple[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${ev['event_id_string'] ?? 'Event ${ev['id'] ?? index}'} ${ev['name'] ?? ''}'.trim().toUpperCase(),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 13, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Text(ev['event_date'] ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  ],
                                ),
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
