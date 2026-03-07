import 'dart:convert';
import 'package:arsys/features/auth/data/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/auth/application/auth_provider.dart';

final preDefenseRepositoryProvider = Provider<PreDefenseRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return PreDefenseRepository(authService);
});

class PreDefenseRepository {
  final AuthService _authService;

  PreDefenseRepository(this._authService);

  Future<Map<String, dynamic>> getEvents({int page = 1}) async {
    final response = await _authService.get('/staff/pre-defense?page=$page');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load pre-defense events');
    }
  }

  Future<Map<String, dynamic>> getParticipants(int eventId) async {
    final response = await _authService.get('/staff/pre-defense/$eventId/participants');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load event participants');
    }
  }

  Future<Map<String, dynamic>> getParticipantDetails(int participantId) async {
    final response = await _authService.get('/staff/pre-defense/participant/$participantId');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['success'] == true) {
        return body['data'];
      } else {
        throw Exception(body['message'] ?? 'Failed to load participant details');
      }
    } else {
      throw Exception('Failed to load participant details');
    }
  }

  Future<void> toggleExaminerPresence(int examinerId) async {
    final response = await _authService.post('/staff/pre-defense/examiner/$examinerId/presence', {});
    
    debugPrint('--- TOGGLE EXAMINER PRESENCE RESPONSE ---');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
    debugPrint('---------------------------------------');

    if (response.statusCode != 200) {
      String errorMessage = 'Failed to update presence (status: ${response.statusCode})';
      try {
        final error = json.decode(response.body);
        if (error is Map && error['message'] != null) {
          errorMessage = error['message'].toString();
        }
      } on FormatException {
        // response body is not JSON, use default message
      }
      throw Exception(errorMessage);
    }

    final body = json.decode(response.body);
    if (body['success'] == false) {
      throw Exception(body['message'] ?? 'Failed to update presence');
    }
  }

  Future<List<dynamic>> searchStaff(String query) async {
    final response = await _authService.get('/staff/pre-defense/staff/search?query=$query');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to search staff');
    }
  }

  Future<void> addExaminer(int participantId, int staffId) async {
    final response = await _authService.post('/staff/pre-defense/participant/$participantId/add-examiner', {'staff_id': staffId});
    if (response.statusCode != 200) {
      try {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to add examiner');
      } catch (e) {
        throw Exception('Failed to add examiner. Invalid error format.');
      }
    }
  }

  Future<List<dynamic>> getScoreGuide() async {
    final response = await _authService.get('/staff/pre-defense/score-guide');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load score guide');
    }
  }

  Future<void> submitScore(int participantId, int score, {String? remark}) async {
    final body = <String, dynamic>{'score': score};
    if (remark != null) {
      body['remark'] = remark;
    }
    final response = await _authService.post('/staff/pre-defense/participant/$participantId/score', body);
    if (response.statusCode != 200) {
      try {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to submit score');
      } catch (e) {
        throw Exception('Failed to submit score. Invalid error format.');
      }
    }
  }
}
