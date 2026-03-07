import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/student/research/data/student_research_repository.dart';

final studentResearchListProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final repository = ref.watch(studentResearchRepositoryProvider);
  return repository.getResearchList();
});

final studentResearchDetailProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, id) async {
  final repository = ref.watch(studentResearchRepositoryProvider);
  return repository.getResearchDetail(id);
});

final researchTypesProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final repository = ref.watch(studentResearchRepositoryProvider);
  return repository.getResearchTypes();
});
