import 'package:arsys/features/program/data/program_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pre-Defense
final programPreDefenseEventsProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final repository = ref.watch(programRepositoryProvider);
  return repository.getPreDefenseEvents();
});

final programPreDefenseDetailProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, eventId) async {
  final repository = ref.watch(programRepositoryProvider);
  return repository.getPreDefenseDetail(eventId);
});

// Final-Defense
final programFinalDefenseEventsProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final repository = ref.watch(programRepositoryProvider);
  return repository.getFinalDefenseEvents();
});

final programFinalDefenseRoomsProvider = FutureProvider.autoDispose.family<List<dynamic>, int>((ref, eventId) async {
  final repository = ref.watch(programRepositoryProvider);
  return repository.getFinalDefenseRooms(eventId);
});

final programFinalDefenseRoomDetailProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, ({int eventId, int roomId})>((ref, params) async {
  final repository = ref.watch(programRepositoryProvider);
  return repository.getFinalDefenseRoomDetail(params.eventId, params.roomId);
});

// Approval
final programApprovalsProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final repository = ref.watch(programRepositoryProvider);
  return repository.getApprovals();
});

final programApprovalDetailProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, id) async {
  final repository = ref.watch(programRepositoryProvider);
  return repository.getApprovalDetail(id);
});
