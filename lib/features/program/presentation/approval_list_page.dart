import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/program/application/program_provider.dart';
import 'package:arsys/features/program/presentation/approval_detail_page.dart';

class ApprovalListPage extends ConsumerWidget {
  const ApprovalListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final approvalsAsync = ref.watch(programApprovalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Defense Approval')),
      body: approvalsAsync.when(
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
                onPressed: () => ref.invalidate(programApprovalsProvider),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (approvals) {
          if (approvals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.approval_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('No pending approvals', style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(programApprovalsProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: approvals.length,
              itemBuilder: (context, index) {
                final a = approvals[index] as Map<String, dynamic>;
                final isAllApproved = a['is_all_approved'] == true;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      final id = a['id'] as int?;
                      if (id != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ApprovalDetailPage(approvalId: id),
                        ));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: isAllApproved ? Colors.green.shade400 : Colors.amber.shade600, width: 4)),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: isAllApproved ? Colors.green[50] : Colors.amber[50],
                            child: Icon(
                              isAllApproved ? Icons.check_circle : Icons.hourglass_top,
                              size: 20,
                              color: isAllApproved ? Colors.green[600] : Colors.amber[800],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a['student_name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text(
                                  a['research_title'] ?? '-',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.grey[400]),
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
