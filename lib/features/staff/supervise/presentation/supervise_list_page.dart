import 'package:arsys/features/staff/supervise/application/supervise_provider.dart';
import 'package:arsys/features/staff/supervise/presentation/supervise_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuperviseListPage extends ConsumerWidget {
  const SuperviseListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final researchAsyncValue = ref.watch(supervisedResearchProvider(1));

    return researchAsyncValue.when(
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
                onPressed: () => ref.refresh(supervisedResearchProvider(1)),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (researchData) {
        final List<dynamic> researches = researchData['data'];

        if (researches.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(supervisedResearchProvider(1).future),
            child: ListView(
              children: [
                const SizedBox(height: 120),
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.school_outlined, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('No active research found', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.refresh(supervisedResearchProvider(1).future),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            itemCount: researches.length,
            itemBuilder: (context, index) {
              final research = researches[index];
              final bool needsApproval = research['needs_approval'] ?? false;
              final milestoneCode = research['milestone_code'];
              final milestonePhase = research['milestone_phase'];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuperviseDetailPage(researchId: research['id']),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: needsApproval ? Colors.orange : Colors.purple.shade300,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${research['student_nim']} - ${research['student_name'] ?? ''}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              if (needsApproval)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.pending_actions, size: 12, color: Colors.orange),
                                      SizedBox(width: 4),
                                      Text('Approval', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            (research['research_title'] ?? 'No Title').toUpperCase(),
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (milestoneCode != null || milestonePhase != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.flag_outlined, size: 14, color: Colors.purple[300]),
                                const SizedBox(width: 6),
                                if (milestoneCode != null)
                                  Text(milestoneCode, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.purple[400])),
                                if (milestoneCode != null && milestonePhase != null)
                                  Text(' | ', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                                if (milestonePhase != null)
                                  Expanded(
                                    child: Text(milestonePhase, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[600]), overflow: TextOverflow.ellipsis),
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
