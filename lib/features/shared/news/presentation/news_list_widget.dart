import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/shared/news/application/news_provider.dart';
import 'package:arsys/features/shared/news/presentation/news_create_page.dart';
import 'package:arsys/features/auth/application/auth_provider.dart';

class NewsListWidget extends ConsumerWidget {
  const NewsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsListProvider);
    final roles = ref.watch(allRolesProvider);
    final canPost = roles.contains('program') || roles.contains('specialization');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.campaign, size: 20, color: Colors.orange[700]),
            const SizedBox(width: 8),
            Text('Announcements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[800])),
            const Spacer(),
            if (canPost)
              TextButton.icon(
                onPressed: () async {
                  final created = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(builder: (_) => const NewsCreatePage()),
                  );
                  if (created == true) ref.invalidate(newsListProvider);
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Post', style: TextStyle(fontSize: 13)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        newsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (err, _) => Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Failed to load news', style: TextStyle(color: Colors.red[400], fontSize: 13)),
          ),
          data: (news) {
            if (news.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.newspaper, size: 32, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Text('No announcements yet', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                  ],
                ),
              );
            }
            final displayed = news.take(5).toList();
            return Column(
              children: displayed.map((item) {
                final n = item as Map<String, dynamic>;
                return _NewsCard(news: n, canPost: canPost, onRefresh: () => ref.invalidate(newsListProvider));
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _NewsCard extends StatefulWidget {
  final Map<String, dynamic> news;
  final bool canPost;
  final VoidCallback onRefresh;

  const _NewsCard({required this.news, required this.canPost, required this.onRefresh});

  @override
  State<_NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<_NewsCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final n = widget.news;
    final title = n['title'] ?? '';
    final content = n['content'] ?? '';
    final author = n['author_name'] ?? '';
    final date = n['created_at'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.orange.shade400, width: 3)),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: _expanded ? 10 : 1, overflow: TextOverflow.ellipsis),
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more, size: 20, color: Colors.grey[400]),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 8),
                Text(content, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              ],
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 13, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(author, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  const Spacer(),
                  Text(date.toString().length > 10 ? date.toString().substring(0, 10) : date.toString(), style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
