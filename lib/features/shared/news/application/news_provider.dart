import 'package:arsys/features/shared/news/data/news_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newsListProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.getNews();
});
