import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/program/application/program_provider.dart';

class PreDefenseScoreDetailPage extends ConsumerWidget {
  final int eventId;
  final String eventCode;

  const PreDefenseScoreDetailPage({super.key, required this.eventId, required this.eventCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(programPreDefenseDetailProvider(eventId));

    return Scaffold(
      appBar: AppBar(title: Text(eventCode.toUpperCase())),
      body: detailAsync.when(
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
                onPressed: () => ref.invalidate(programPreDefenseDetailProvider(eventId)),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (data) {
          final applicants = data['applicants'] as List<dynamic>? ?? [];
          if (applicants.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('No applicants found', style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(programPreDefenseDetailProvider(eventId).future),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: applicants.length,
              itemBuilder: (context, index) => _ApplicantScoreCard(applicant: applicants[index] as Map<String, dynamic>),
            ),
          );
        },
      ),
    );
  }
}

class _ApplicantScoreCard extends StatelessWidget {
  final Map<String, dynamic> applicant;

  const _ApplicantScoreCard({required this.applicant});

  @override
  Widget build(BuildContext context) {
    final studentName = applicant['student_name'] ?? '-';
    final title = applicant['research_title'] ?? '-';
    final examiners = applicant['examiners'] as List<dynamic>? ?? [];
    final supervisors = applicant['supervisors'] as List<dynamic>? ?? [];
    final hasMissing = applicant['has_missing_scores'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: hasMissing ? Colors.red.shade400 : Colors.green.shade400, width: 4)),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: hasMissing ? Colors.red[50] : Colors.green[50],
            child: Icon(hasMissing ? Icons.warning_amber : Icons.check, size: 18, color: hasMissing ? Colors.red[600] : Colors.green[600]),
          ),
          title: Text(studentName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          subtitle: Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
          children: [
            if (examiners.isNotEmpty) ...[
              _scoreSection(context, 'Examiner Scores', examiners, Colors.orange, showRole: false),
            ],
            if (supervisors.isNotEmpty) ...[
              const SizedBox(height: 8),
              _scoreSection(context, 'Supervisor Scores', supervisors, Colors.purple, showRole: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _scoreSection(BuildContext context, String title, List<dynamic> scores, Color color, {bool showRole = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        const SizedBox(height: 4),
        ...scores.map((s) {
          final sc = s as Map<String, dynamic>;
          final name = sc['staff_name'] ?? '-';
          final role = sc['role'] as String?;
          final score = sc['score'];
          final scoredAsSpv = sc['scored_as_spv'] == true;
          final hasScore = score != null && score.toString() != 'null';
          final isOwnSupervisor = sc['is_own_supervisor'] == true;
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: hasScore ? Colors.grey[50] : (isOwnSupervisor ? Colors.blue[50] : Colors.red[50]),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(child: Text(name, style: const TextStyle(fontSize: 13))),
                      if (showRole && role != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: role == 'SPV' ? Colors.indigo[50] : Colors.teal[50],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: role == 'SPV' ? Colors.indigo[200]! : Colors.teal[200]!),
                          ),
                          child: Text(role, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: role == 'SPV' ? Colors.indigo[700] : Colors.teal[700])),
                        ),
                      ],
                    ],
                  ),
                ),
                if (hasScore && scoredAsSpv)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(4)),
                        child: Text('SPV', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.blue[700])),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(8)),
                        child: Text(score.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green[800])),
                      ),
                    ],
                  )
                else if (hasScore)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(8)),
                    child: Text(score.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green[800])),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      // TODO: Send reminder to this staff
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reminder sent to $name'), duration: const Duration(seconds: 2)),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.red[100], borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_active, size: 12, color: Colors.red[700]),
                          const SizedBox(width: 2),
                          Text('Not scored', style: TextStyle(fontSize: 11, color: Colors.red[700])),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
