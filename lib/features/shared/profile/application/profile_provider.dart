import 'package:arsys/features/shared/profile/data/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfile();
});
