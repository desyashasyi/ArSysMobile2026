import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:arsys/features/student/research/application/student_research_provider.dart';
import 'package:arsys/features/student/research/data/student_research_repository.dart';
import 'package:arsys/features/student/research/presentation/research_edit_page.dart';
import 'package:arsys/features/student/research/presentation/research_remark_page.dart';
import 'package:arsys/core/utils/snackbar_helper.dart';

class ResearchDetailPage extends ConsumerWidget {
  final int researchId;

  const ResearchDetailPage({super.key, required this.researchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(studentResearchDetailProvider(researchId));

    return Scaffold(
      appBar: AppBar(title: const Text('Research Detail')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          final warningState = data['warning_state'] as String?;
          final actions = (data['actions'] as List?) ?? [];

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(studentResearchDetailProvider(researchId)),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Warning banner
                  if (warningState != null)
                    _WarningBanner(warningState: warningState, researchId: researchId),

                  // Research info
                  _ResearchInfoCard(data: data),
                  const SizedBox(height: 16),

                  // Supervisors
                  _SectionTitle('Supervisors'),
                  ..._buildSupervisorList(data),
                  const SizedBox(height: 16),

                  // Reviewers
                  if ((data['reviewers'] as List?)?.isNotEmpty == true) ...[
                    _SectionTitle('Reviewers'),
                    ..._buildReviewerList(data),
                    const SizedBox(height: 16),
                  ],

                  // Approvals
                  if ((data['approvals'] as List?)?.isNotEmpty == true) ...[
                    _SectionTitle('Approvals'),
                    ..._buildApprovalList(data),
                    const SizedBox(height: 16),
                  ],

                  // History
                  _SectionTitle('History'),
                  ..._buildHistoryList(data),
                  const SizedBox(height: 16),

                  // Remarks
                  _RemarksNavCard(
                    researchId: researchId,
                    remarkCount: ((data['remarks'] as List?) ?? []).length,
                  ),

                  // Actions
                  if (actions.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _ActionButtons(
                      researchId: researchId,
                      actions: actions.cast<String>(),
                      data: data,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildSupervisorList(Map<String, dynamic> data) {
    final supervisors = (data['supervisors'] as List?) ?? [];
    if (supervisors.isEmpty) {
      return [const Card(child: ListTile(title: Text('No supervisors assigned')))];
    }
    return supervisors.map<Widget>((s) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(s['name'] ?? 'N/A'),
          subtitle: Text(s['code'] ?? ''),
        ),
      );
    }).toList();
  }

  List<Widget> _buildReviewerList(Map<String, dynamic> data) {
    final reviewers = (data['reviewers'] as List?) ?? [];
    return reviewers.map<Widget>((r) {
      final decision = r['decision'];
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Icon(
            decision != null ? Icons.check_circle : Icons.pending,
            color: decision != null ? Colors.green : Colors.orange,
          ),
          title: Text(r['name'] ?? 'N/A'),
          subtitle: Text(r['code'] ?? ''),
        ),
      );
    }).toList();
  }

  List<Widget> _buildApprovalList(Map<String, dynamic> data) {
    final approvals = (data['approvals'] as List?) ?? [];
    return approvals.map<Widget>((a) {
      final decision = a['decision'];
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Icon(
            decision != null ? Icons.check_circle : Icons.hourglass_empty,
            color: decision != null ? Colors.green : Colors.orange,
          ),
          title: Text(a['approver_name'] ?? 'N/A'),
          subtitle: Text('${a['defense_model'] ?? ''} - ${a['role'] ?? ''}'),
        ),
      );
    }).toList();
  }

  List<Widget> _buildHistoryList(Map<String, dynamic> data) {
    final history = (data['history'] as List?) ?? [];
    if (history.isEmpty) {
      return [const Card(child: ListTile(title: Text('No history')))];
    }
    return history.take(10).map<Widget>((h) {
      final isActive = h['status'] == 1;
      return Card(
        margin: const EdgeInsets.only(bottom: 4),
        color: isActive ? Colors.purple[50] : null,
        child: ListTile(
          dense: true,
          leading: Icon(
            isActive ? Icons.circle : Icons.circle_outlined,
            size: 12,
            color: isActive ? Colors.purple : Colors.grey,
          ),
          title: Text(
            h['type_description'] ?? h['type_code'] ?? 'N/A',
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(h['created_at'] ?? '', style: const TextStyle(fontSize: 11)),
        ),
      );
    }).toList();
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}

class _ResearchInfoCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ResearchInfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final milestoneCode = data['milestone_code'] ?? '';
    final milestonePhase = data['milestone_phase'] ?? '';

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['code'] ?? '',
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              (data['title'] ?? 'No Title').toString().toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              data['type_name'] ?? '',
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
            if (milestoneCode.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$milestoneCode | $milestonePhase',
                  style: TextStyle(fontSize: 12, color: Colors.purple[700], fontWeight: FontWeight.w500),
                ),
              ),
            ],
            if (data['abstract'] != null && data['abstract'].toString().isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Abstract', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                data['abstract'] ?? '',
                style: const TextStyle(fontSize: 13),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (data['file'] != null && data['file'].toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final url = Uri.tryParse(data['file']);
                  if (url != null && await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.link, size: 14, color: Colors.blue),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data['file'],
                        style: const TextStyle(fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.open_in_new, size: 12, color: Colors.blue),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WarningBanner extends ConsumerWidget {
  final String warningState;
  final int researchId;

  const _WarningBanner({required this.warningState, required this.researchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String message;
    Color color;
    IconData icon;
    bool showRenewButton = false;

    switch (warningState) {
      case 'FRE':
        message = 'This research has been frozen due to inactivity.';
        color = Colors.red;
        icon = Icons.ac_unit;
        showRenewButton = true;
        break;
      case 'REN':
        message = 'Research renewal is being processed.';
        color = Colors.amber;
        icon = Icons.autorenew;
        break;
      case 'RJC':
        message = 'This research has been rejected.';
        color = Colors.red;
        icon = Icons.cancel;
        break;
      case 'SIASPRO':
        message = 'SIAS proposal warning.';
        color = Colors.orange;
        icon = Icons.warning;
        break;
      default:
        message = 'Unknown warning state.';
        color = Colors.grey;
        icon = Icons.info;
    }

    return Card(
      color: color.withValues(alpha: 0.1),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
            ),
            if (showRenewButton)
              ElevatedButton(
                onPressed: () async {
                  try {
                    await ref.read(studentResearchRepositoryProvider).renewResearch(researchId);
                    ref.invalidate(studentResearchDetailProvider(researchId));
                    ref.invalidate(studentResearchListProvider);
                    if (context.mounted) {
                      showSuccessSnackBar(context, 'Renewal requested.');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showErrorSnackBar(context, e.toString());
                    }
                  }
                },
                child: const Text('Renew'),
              ),
          ],
        ),
      ),
    );
  }
}

class _RemarksNavCard extends StatelessWidget {
  final int researchId;
  final int remarkCount;

  const _RemarksNavCard({required this.researchId, required this.remarkCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.chat_bubble_outline, color: Colors.purple),
        title: const Text('Remarks'),
        subtitle: Text(
          remarkCount > 0 ? '$remarkCount message${remarkCount > 1 ? 's' : ''}' : 'No remarks yet',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (_) => ResearchRemarkPage(researchId: researchId),
              ))
              .then((_) {
            // Refresh detail when coming back from remarks page
          });
        },
      ),
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  final int researchId;
  final List<String> actions;
  final Map<String, dynamic> data;

  const _ActionButtons({
    required this.researchId,
    required this.actions,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: actions.map((action) {
            switch (action) {
              case 'edit':
                return ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ResearchEditPage(researchId: researchId),
                      ),
                    ).then((_) {
                      ref.invalidate(studentResearchDetailProvider(researchId));
                      ref.invalidate(studentResearchListProvider);
                    });
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                );
              case 'delete':
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => _confirmDelete(context, ref),
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Delete'),
                );
              case 'submit':
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => _confirmSubmit(context, ref),
                  icon: const Icon(Icons.send, size: 16),
                  label: const Text('Submit Proposal'),
                );
              case 'propose_predefense':
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {},
                  icon: const Icon(Icons.gavel, size: 16),
                  label: const Text('Propose Pre-Defense'),
                );
              case 'propose_finaldefense':
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  onPressed: () {},
                  icon: const Icon(Icons.workspace_premium, size: 16),
                  label: const Text('Propose Final Defense'),
                );
              case 'propose_seminar':
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {},
                  icon: const Icon(Icons.co_present_outlined, size: 16),
                  label: const Text('Propose Seminar'),
                );
              default:
                return const SizedBox.shrink();
            }
          }).toList(),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Research'),
        content: const Text('Are you sure you want to delete this research? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref.read(studentResearchRepositoryProvider).deleteResearch(researchId);
                ref.invalidate(studentResearchListProvider);
                if (context.mounted) {
                  Navigator.pop(context);
                  showSuccessSnackBar(context, 'Research deleted.');
                }
              } catch (e) {
                if (context.mounted) {
                  showErrorSnackBar(context, e.toString());
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmSubmit(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Proposal'),
        content: const Text('Submit this research proposal for review? Make sure all information is correct.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref.read(studentResearchRepositoryProvider).submitProposal(researchId);
                ref.invalidate(studentResearchDetailProvider(researchId));
                ref.invalidate(studentResearchListProvider);
                if (context.mounted) {
                  showSuccessSnackBar(context, 'Proposal submitted for review.');
                }
              } catch (e) {
                if (context.mounted) {
                  showErrorSnackBar(context, e.toString());
                }
              }
            },
            child: const Text('Submit', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
