import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/program/application/program_provider.dart';
import 'package:arsys/features/program/data/program_repository.dart';

class ApprovalDetailPage extends ConsumerStatefulWidget {
  final int approvalId;

  const ApprovalDetailPage({super.key, required this.approvalId});

  @override
  ConsumerState<ApprovalDetailPage> createState() => _ApprovalDetailPageState();
}

class _ApprovalDetailPageState extends ConsumerState<ApprovalDetailPage> {
  bool _approving = false;

  Future<void> _approve() async {
    setState(() => _approving = true);
    try {
      await ref.read(programRepositoryProvider).approve(widget.approvalId);
      ref.invalidate(programApprovalDetailProvider(widget.approvalId));
      ref.invalidate(programApprovalsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Approved successfully'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _approving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(programApprovalDetailProvider(widget.approvalId));

    return Scaffold(
      appBar: AppBar(title: const Text('Approval Detail')),
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
                onPressed: () => ref.invalidate(programApprovalDetailProvider(widget.approvalId)),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (data) {
          final studentName = data['student_name'] ?? '-';
          final researchTitle = data['research_title'] ?? '-';
          final defenseModel = data['defense_model'] ?? '-';
          final allApprovals = data['all_approvals'] as List<dynamic>? ?? [];
          final canApprove = data['can_approve'] == true;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Student info
              Card(
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.amber.shade600, width: 4)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.purple[50],
                            child: Text(
                              studentName.toString().isNotEmpty ? studentName.toString()[0].toUpperCase() : '?',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[700]),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(studentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
                                  child: Text(defenseModel.toString(), style: TextStyle(fontSize: 11, color: Colors.blue[700])),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('Research Title', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      const SizedBox(height: 4),
                      Text(researchTitle, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text('Approval Status', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[700])),
              const SizedBox(height: 8),

              ...allApprovals.map((a) {
                final ap = a as Map<String, dynamic>;
                final roleName = ap['role_name'] ?? '-';
                final staffName = ap['staff_name'] ?? '-';
                final approved = ap['decision'] == 1;
                final date = ap['approval_date'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: approved ? Colors.green[50] : Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: approved ? Colors.green[200]! : Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        approved ? Icons.check_circle : Icons.hourglass_top,
                        size: 20,
                        color: approved ? Colors.green[600] : Colors.orange[600],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(roleName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                            Text(staffName, style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      if (approved && date != null)
                        Text(date.toString().length > 10 ? date.toString().substring(0, 10) : date.toString(), style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    ],
                  ),
                );
              }),

              if (canApprove) ...[
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _approving ? null : _approve,
                    icon: _approving
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
