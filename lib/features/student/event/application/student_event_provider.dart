import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/student/event/data/student_event_repository.dart';

class SelectedEventTypeNotifier extends Notifier<String> {
  @override
  String build() => 'Defense';
}

final selectedEventTypeProvider = NotifierProvider<SelectedEventTypeNotifier, String>(
  SelectedEventTypeNotifier.new,
);

final studentEventListProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final type = ref.watch(selectedEventTypeProvider);
  return ref.watch(studentEventRepositoryProvider).getEvents(type: type);
});

final studentEventDetailProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, id) async {
  return ref.watch(studentEventRepositoryProvider).getEventDetail(id);
});
