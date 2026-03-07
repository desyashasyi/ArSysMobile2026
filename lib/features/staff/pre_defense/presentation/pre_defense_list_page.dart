import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/staff/pre_defense/application/pre_defense_provider.dart';
import 'package:arsys/features/staff/pre_defense/presentation/pre_defense_detail_page.dart';

class PreDefenseListPage extends ConsumerWidget {
  const PreDefenseListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(preDefenseEventsProvider(1));

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
                  onPressed: () => ref.refresh(preDefenseEventsProvider(1)),
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
              onRefresh: () => ref.refresh(preDefenseEventsProvider(1).future),
              child: ListView(
                children: [
                  const SizedBox(height: 120),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.gavel_outlined, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('No pre-defense events found', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(preDefenseEventsProvider(1).future),
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
                      if (id != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PreDefenseDetailPage(eventId: id),
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
                          Row(
                            children: [
                              Icon(Icons.gavel, size: 18, color: Colors.orange[700]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  (ev['event_id_string'] ?? 'Event ${ev['id'] ?? index}').toUpperCase(),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              if (hasProgramInfo)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$programCode${programCode != '' && programAbbrev != '' ? ' ' : ''}$programAbbrev',
                                    style: TextStyle(color: Colors.purple[700], fontSize: 11, fontWeight: FontWeight.w600),
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
