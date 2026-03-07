import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/staff/supervise/application/supervise_provider.dart';
import 'package:arsys/features/staff/supervise/data/supervise_repository.dart';

class Approval {
  final int id;
  final String approverName;
  final String approverCode;
  final String type;
  final bool isApproved;
  final bool isCurrentUser;
  final bool isLocked;

  Approval({
    required this.id,
    required this.approverName,
    required this.approverCode,
    required this.type,
    required this.isApproved,
    required this.isCurrentUser,
    required this.isLocked,
  });

  factory Approval.fromJson(Map<String, dynamic> json) {
    return Approval(
      id: int.parse(json['id'].toString()),
      approverName: json['approver_name'] as String? ?? 'N/A',
      approverCode: json['approver_code'] as String? ?? 'N/A',
      type: json['type'] as String? ?? 'unknown',
      isApproved: json['is_approved'] == true || json['is_approved'] == 1,
      isCurrentUser: json['is_current_user'] as bool? ?? false,
      isLocked: json['is_locked'] as bool? ?? false,
    );
  }

  String get displayName {
    final name = approverName.trim();
    if (name.isEmpty || name == 'Unknown' || name == 'N/A') {
      return approverCode;
    }
    return name;
  }
}

class SuperviseDetailPage extends ConsumerWidget {
  final int researchId;

  const SuperviseDetailPage({super.key, required this.researchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final researchDetailAsync = ref.watch(researchDetailProvider(researchId));
    final approvalsAsync = ref.watch(researchApprovalsProvider(researchId));

    return Scaffold(
      appBar: AppBar(title: const Text('Research Detail')),
      body: researchDetailAsync.when(
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
        data: (research) {
          final student = research['student'];
          final supervisors = research['supervisors'] as List;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(researchDetailProvider(researchId));
              ref.invalidate(researchApprovalsProvider(researchId));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student info card
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.purple.shade400, width: 4)),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, size: 18, color: Colors.purple[400]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${student['nim']} - ${student['name'] ?? ''}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            (research['title'] ?? '').toUpperCase(),
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Supervisors section
                  _buildSectionHeader(Icons.supervisor_account, 'Supervisors'),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: List.generate(supervisors.length, (index) {
                        final s = supervisors[index];
                        final role = s['role'] == 'Pembimbing 1' ? 'Supervisor' : 'Co-supervisor';
                        return Column(
                          children: [
                            if (index > 0) const Divider(height: 1),
                            ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor: role == 'Supervisor' ? Colors.purple[100] : Colors.grey[200],
                                child: Icon(Icons.person, size: 18, color: role == 'Supervisor' ? Colors.purple[700] : Colors.grey[600]),
                              ),
                              title: Text(s['name'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: role == 'Supervisor' ? Colors.purple.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(role, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: role == 'Supervisor' ? Colors.purple : Colors.grey[600])),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Approval section
                  _buildSectionHeader(Icons.verified_user, 'Approval Requests'),
                  const SizedBox(height: 8),
                  approvalsAsync.when(
                    loading: () => const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    error: (err, stack) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text('Failed to load approvals: $err', style: TextStyle(color: Colors.red[400]))),
                      ),
                    ),
                    data: (approvalListRaw) {
                      if (approvalListRaw.isEmpty) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.inbox_outlined, size: 36, color: Colors.grey[300]),
                                  const SizedBox(height: 8),
                                  Text('No approval requests', style: TextStyle(color: Colors.grey[500])),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      final approvals = approvalListRaw
                          .map((item) => Approval.fromJson(item as Map<String, dynamic>))
                          .toList();

                      return Card(
                        child: Column(
                          children: List.generate(approvals.length, (index) {
                            final approval = approvals[index];
                            final bool canBeToggled = approval.isCurrentUser && !approval.isLocked;

                            return Column(
                              children: [
                                if (index > 0) const Divider(height: 1),
                                ListTile(
                                  dense: true,
                                  leading: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: approval.isApproved ? Colors.green[50] : Colors.grey[100],
                                    child: Icon(
                                      approval.isApproved ? Icons.check : Icons.hourglass_empty,
                                      size: 16,
                                      color: approval.isApproved ? Colors.green : Colors.grey,
                                    ),
                                  ),
                                  title: Text(approval.displayName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  subtitle: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.purple.withValues(alpha: 0.08),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(approval.type, style: TextStyle(fontSize: 11, color: Colors.purple[400])),
                                      ),
                                      if (approval.isCurrentUser) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Text('You', style: TextStyle(fontSize: 11, color: Colors.blue)),
                                        ),
                                      ],
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      approval.isApproved ? Icons.check_circle : Icons.check_circle_outline,
                                      color: approval.isApproved ? Colors.green : Colors.grey[300],
                                      size: 28,
                                    ),
                                    onPressed: canBeToggled
                                        ? () async {
                                            try {
                                              await ref.read(superviseRepositoryProvider).approveResearch(approval.id);
                                              ref.invalidate(researchApprovalsProvider(researchId));
                                              ref.invalidate(researchDetailProvider(researchId));
                                              ref.invalidate(supervisedResearchProvider(1));

                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Approval status updated')),
                                                );
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Failed to update approval: $e')),
                                                );
                                              }
                                            }
                                          }
                                        : null,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.purple[400]),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
