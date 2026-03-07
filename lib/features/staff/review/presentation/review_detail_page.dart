import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/staff/review/application/review_provider.dart';
import 'package:arsys/features/staff/review/data/review_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewDetailPage extends ConsumerWidget {
  final int researchId;

  const ReviewDetailPage({super.key, required this.researchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewDetailAsync = ref.watch(reviewDetailProvider(researchId));

    return Scaffold(
      appBar: AppBar(title: const Text('Review Detail')),
      body: reviewDetailAsync.when(
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
        data: (detail) {
          final studentInfo = detail['student_info'] as Map<String, dynamic>;
          final reviewers = detail['reviewers'] as List<dynamic>;
          final abstract = detail['abstract'] as String?;
          final fileUrl = detail['file_url'] as String?;
          final researchTitle = detail['research_title'] as String? ?? 'No Title';

          return RefreshIndicator(
            onRefresh: () => ref.refresh(reviewDetailProvider(researchId).future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student info
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
                                  '${studentInfo['nim']} - ${studentInfo['name'] ?? ''}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            researchTitle.toUpperCase(),
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Reviewers
                  _buildSectionHeader(Icons.people_alt, 'Reviewers'),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 6.0,
                        children: reviewers.map<Widget>((reviewer) {
                          final String code = reviewer['code'];
                          final String rawDecision = reviewer['decision'];
                          final String decision = rawDecision == 'Not Defined' ? 'Pending' : rawDecision;

                          Color chipColor;
                          Color labelColor;
                          IconData chipIcon;

                          switch (decision) {
                            case 'Approve':
                              chipColor = Colors.green;
                              labelColor = Colors.white;
                              chipIcon = Icons.check_circle;
                              break;
                            case 'Reject':
                              chipColor = Colors.red;
                              labelColor = Colors.white;
                              chipIcon = Icons.cancel;
                              break;
                            default:
                              chipColor = Colors.grey.shade200;
                              labelColor = Colors.black54;
                              chipIcon = Icons.hourglass_empty;
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: chipColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(chipIcon, size: 14, color: labelColor),
                                const SizedBox(width: 6),
                                Text('$code: $decision', style: TextStyle(color: labelColor, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  if (abstract != null) ...[
                    const SizedBox(height: 20),
                    _buildSectionHeader(Icons.description, 'Abstract'),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(abstract, style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5)),
                      ),
                    ),
                  ],

                  if (fileUrl != null) ...[
                    const SizedBox(height: 20),
                    _buildSectionHeader(Icons.attach_file, 'File'),
                    const SizedBox(height: 8),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.picture_as_pdf, color: Colors.red[400]),
                        title: const Text('Proposal File', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        subtitle: const Text('Tap to open', style: TextStyle(fontSize: 12)),
                        trailing: const Icon(Icons.open_in_new, size: 18),
                        onTap: () async {
                          final uri = Uri.parse(fileUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Could not launch $fileUrl')),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Decision buttons
                  _buildSectionHeader(Icons.gavel, 'Decision'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _submitDecision(context, ref, 'approve'),
                          icon: const Icon(Icons.check_circle_outline, size: 18),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _submitDecision(context, ref, 'reject'),
                          icon: const Icon(Icons.cancel_outlined, size: 18),
                          label: const Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitDecision(BuildContext context, WidgetRef ref, String decision) async {
    try {
      await ref.read(reviewRepositoryProvider).submitReview(researchId, decision);

      ref.invalidate(reviewListProvider(1));
      ref.invalidate(reviewDetailProvider(researchId));

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit review: $e')),
        );
      }
    }
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
