import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/staff/review/application/review_provider.dart';
import 'package:arsys/features/staff/review/presentation/review_detail_page.dart';

class ReviewListPage extends ConsumerWidget {
  const ReviewListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewAsync = ref.watch(reviewListProvider(1));

    return Scaffold(
      body: reviewAsync.when(
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
                  onPressed: () => ref.refresh(reviewListProvider(1)),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (reviewData) {
          final List<dynamic> reviews = reviewData['data'];

          if (reviews.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(reviewListProvider(1).future),
              child: ListView(
                children: [
                  const SizedBox(height: 120),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('No reviews found', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(reviewListProvider(1).future),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                final reviewers = review['reviewers'] as List<dynamic>;

                // Determine overall status color for left border
                final hasReject = reviewers.any((r) => r['decision'] == 'Reject');
                final allApproved = reviewers.every((r) => r['decision'] == 'Approve');
                final borderColor = hasReject ? Colors.red : allApproved ? Colors.green : Colors.orange;

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewDetailPage(researchId: review['id']),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: borderColor, width: 4)),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${review['student_nim']} - ${review['student_name'] ?? ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            (review['research_title'] ?? 'No Title').toUpperCase(),
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6.0,
                            runSpacing: 4.0,
                            children: reviewers.map<Widget>((reviewer) {
                              final String code = reviewer['reviewer_code'];
                              final String decision = reviewer['decision'];

                              Color chipColor;
                              Color labelColor;
                              IconData chipIcon;

                              switch (decision) {
                                case 'Approve':
                                  chipColor = Colors.green;
                                  labelColor = Colors.white;
                                  chipIcon = Icons.check;
                                  break;
                                case 'Reject':
                                  chipColor = Colors.red;
                                  labelColor = Colors.white;
                                  chipIcon = Icons.close;
                                  break;
                                default:
                                  chipColor = Colors.grey.shade200;
                                  labelColor = Colors.black54;
                                  chipIcon = Icons.hourglass_empty;
                              }

                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: chipColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(chipIcon, size: 12, color: labelColor),
                                    const SizedBox(width: 4),
                                    Text(code, style: TextStyle(color: labelColor, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                              );
                            }).toList(),
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
