import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/staff/final_defense/application/final_defense_provider.dart';
import 'package:arsys/features/staff/final_defense/presentation/final_defense_detail_page.dart';

class FinalDefenseListPage extends ConsumerWidget {
  const FinalDefenseListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(finalDefenseEventsProvider(1));

    return Scaffold(
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text('Failed to load data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                const SizedBox(height: 8),
                Text('$err', style: TextStyle(fontSize: 13, color: Colors.grey[500]), textAlign: TextAlign.center),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => ref.refresh(finalDefenseEventsProvider(1)),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (data) {
          final items = data['data'] as List<dynamic>? ?? [];
          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(finalDefenseEventsProvider(1).future),
              child: ListView(
                children: [
                  const SizedBox(height: 120),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.workspace_premium_outlined, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('No final defense events found', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(finalDefenseEventsProvider(1).future),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final ev = items[index] as Map<String, dynamic>;
                final programCode = ev['program_code'] ?? '';
                final programAbbrev = ev['program_abbrev'] ?? '';
                final hasProgramInfo = (programCode as String).isNotEmpty || (programAbbrev as String).isNotEmpty;

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      final id = ev['id'] as int?;
                      final eventCode = ev['event_code'] as String?;
                      if (id != null && eventCode != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FinalDefenseDetailPage(eventId: id, eventCode: eventCode),
                        ));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.deepPurple.shade400, width: 4)),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.workspace_premium, size: 18, color: Colors.deepPurple[600]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${ev['event_code'] ?? 'Event ${ev['id'] ?? index}'} ${ev['name'] ?? ''}'.toUpperCase(),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (hasProgramInfo)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$programCode${programCode != '' && programAbbrev != '' ? ' ' : ''}$programAbbrev',
                                    style: TextStyle(color: Colors.deepPurple[700], fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 6),
                              Text(
                                ev['event_date'] ?? '',
                                style: TextStyle(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w500),
                              ),
                            ],
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
