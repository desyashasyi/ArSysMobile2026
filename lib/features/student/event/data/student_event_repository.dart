import 'dart:convert';
import 'package:arsys/features/auth/data/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/auth/application/auth_provider.dart';

final studentEventRepositoryProvider = Provider<StudentEventRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return StudentEventRepository(authService);
});

class StudentEventRepository {
  final AuthService _authService;

  StudentEventRepository(this._authService);

  Future<Map<String, dynamic>> getEvents({String? type}) async {
    final queryParams = type != null ? '?type=$type' : '';
    final response = await _authService.get('/student/events$queryParams');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['success'] == true) {
        return {
          'events': body['data'] as List<dynamic>,
          'available_types': body['available_types'] as List<dynamic>? ?? [],
        };
      }
    }
    throw Exception('Failed to load events');
  }

  Future<Map<String, dynamic>> getEventDetail(int id) async {
    final response = await _authService.get('/student/events/$id');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['success'] == true) {
        return body['data'] as Map<String, dynamic>;
      }
    }
    throw Exception('Failed to load event detail');
  }
}
