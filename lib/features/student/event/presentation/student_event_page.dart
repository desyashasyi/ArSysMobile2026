import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/student/event/application/student_event_provider.dart';
import 'package:arsys/features/student/event/presentation/student_event_detail_page.dart';

class StudentEventPage extends ConsumerWidget {
  const StudentEventPage({super.key});

  String _getTypeLabel(String type) {
    switch (type) {
      case 'Defense':
        return 'Pre-defense';
      case 'Seminar':
        return 'Seminar';
      case 'Final-defense':
        return 'Final Defense';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedEventTypeProvider);
    final eventsAsync = ref.watch(studentEventListProvider);

    return Column(
      children: [
        // Dropdown filter
        eventsAsync.whenOrNull(
              data: (result) {
                final availableTypes = (result['available_types'] as List<dynamic>?) ?? [];
                if (availableTypes.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: availableTypes.contains(selectedType) ? selectedType : null,
                          decoration: const InputDecoration(
                            labelText: 'Event Type',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: availableTypes.map<DropdownMenuItem<String>>((type) {
                            final t = type as String;
                            return DropdownMenuItem(value: t, child: Text(_getTypeLabel(t)));
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              ref.read(selectedEventTypeProvider.notifier).state = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ) ??
            const SizedBox.shrink(),

        // Event list
        Expanded(
          child: eventsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $err', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(studentEventListProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (result) {
              final events = (result['events'] as List<dynamic>?) ?? [];

              if (events.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(studentEventListProvider),
                  child: ListView(
                    children: const [
                      SizedBox(height: 200),
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.event_busy, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No events available', style: TextStyle(fontSize: 16, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(studentEventListProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index] as Map<String, dynamic>;
                    return _EventCard(event: event);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;

  const _EventCard({required this.event});

  Color _getTypeColor(String? examinationType) {
    switch (examinationType) {
      case 'Defense':
        return Colors.orange;
      case 'Seminar':
        return Colors.teal;
      case 'Final-defense':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String? examinationType) {
    switch (examinationType) {
      case 'Defense':
        return Icons.gavel;
      case 'Seminar':
        return Icons.co_present;
      case 'Final-defense':
        return Icons.workspace_premium;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    final examinationType = event['examination_type'] as String?;
    final typeColor = _getTypeColor(examinationType);
    final completed = event['completed'] == true;
    final eventDate = event['event_date'] as String? ?? '';
    final quota = event['quota'];
    final current = event['current'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => StudentEventDetailPage(eventId: event['id'] as int),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_getTypeIcon(examinationType), color: typeColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event['type_description'] ?? examinationType ?? 'Event',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: typeColor),
                    ),
                  ),
                  if (completed)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Completed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        event['type_code'] ?? '',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: typeColor),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(eventDate, style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 6),
              if (quota != null)
                Row(
                  children: [
                    const Icon(Icons.people, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text('$current / $quota participants', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  ],
                ),
              if (event['application_deadline'] != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      'Deadline: ${event['application_deadline']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
