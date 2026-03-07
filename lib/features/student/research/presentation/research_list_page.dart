import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/student/research/application/student_research_provider.dart';
import 'package:arsys/features/student/research/presentation/research_detail_page.dart';
import 'package:arsys/features/student/research/presentation/research_create_page.dart';

class StudentResearchListPage extends ConsumerWidget {
  const StudentResearchListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final researchAsync = ref.watch(studentResearchListProvider);

    return researchAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $err', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(studentResearchListProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (researches) {
        return Scaffold(
          body: researches.isEmpty
              ? RefreshIndicator(
                  onRefresh: () async => ref.invalidate(studentResearchListProvider),
                  child: ListView(
                    children: const [
                      SizedBox(height: 200),
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.science_outlined, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No research yet', style: TextStyle(fontSize: 16, color: Colors.grey)),
                            SizedBox(height: 8),
                            Text('Tap + to create your first research', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async => ref.invalidate(studentResearchListProvider),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: researches.length,
                    itemBuilder: (context, index) {
                      final research = researches[index] as Map<String, dynamic>;
                      return _ResearchCard(research: research);
                    },
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ResearchCreatePage()),
              ).then((_) => ref.invalidate(studentResearchListProvider));
            },
            backgroundColor: Colors.purple,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}

class _ResearchCard extends StatelessWidget {
  final Map<String, dynamic> research;

  const _ResearchCard({required this.research});

  Color _getStatusColor(String? statusCode) {
    switch (statusCode) {
      case 'CRE':
        return Colors.grey;
      case 'SUB':
        return Colors.orange;
      case 'REV':
        return Colors.blue;
      case 'ACT':
        return Colors.green;
      case 'FRE':
        return Colors.red;
      case 'RJC':
        return Colors.red;
      case 'REN':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String? statusCode) {
    switch (statusCode) {
      case 'CRE':
        return 'Draft';
      case 'SUB':
        return 'Submitted';
      case 'REV':
        return 'In Review';
      case 'ACT':
        return 'Active';
      case 'FRE':
        return 'Frozen';
      case 'RJC':
        return 'Rejected';
      case 'REN':
        return 'Renewal';
      case 'SIASPRO':
        return 'SIAS';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusCode = research['status_code'] as String?;
    final statusColor = _getStatusColor(statusCode);
    final milestoneCode = research['milestone_code'] ?? '';
    final milestonePhase = research['milestone_phase'] ?? '';
    final supervisors = (research['supervisors'] as List?) ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ResearchDetailPage(researchId: research['id'] as int),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      research['code'] ?? '',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blueGrey),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusLabel(statusCode),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                (research['title'] ?? 'No Title').toString().toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                research['type_name'] ?? '',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              if (milestoneCode.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  '$milestoneCode | $milestonePhase',
                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                ),
              ],
              if (supervisors.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: supervisors.map<Widget>((s) {
                    return Chip(
                      label: Text(s['code'] ?? '', style: const TextStyle(fontSize: 11)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
