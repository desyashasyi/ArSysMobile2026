import 'dart:convert';
import 'package:arsys/features/auth/data/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/auth/application/auth_provider.dart';

final studentResearchRepositoryProvider = Provider<StudentResearchRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return StudentResearchRepository(authService);
});

class StudentResearchRepository {
  final AuthService _authService;

  StudentResearchRepository(this._authService);

  Future<List<dynamic>> getResearchList() async {
    final response = await _authService.get('/student/research');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['success'] == true) {
        return body['data'] as List<dynamic>;
      }
    }
    throw Exception('Failed to load research list');
  }

  Future<Map<String, dynamic>> getResearchDetail(int id) async {
    final response = await _authService.get('/student/research/$id');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['success'] == true) {
        return body['data'] as Map<String, dynamic>;
      }
    }
    throw Exception('Failed to load research detail');
  }

  Future<List<dynamic>> getResearchTypes() async {
    final response = await _authService.get('/student/research/types');
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }
    throw Exception('Failed to load research types');
  }

  Future<Map<String, dynamic>> createResearch({
    required int typeId,
    required String title,
    required String abstract,
    String? fileUrl,
  }) async {
    final response = await _authService.post('/student/research', {
      'type_id': typeId,
      'title': title,
      'abstract': abstract,
      if (fileUrl != null) 'file_url': fileUrl,
    });

    debugPrint('Create research response: ${response.statusCode} ${response.body}');

    final body = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (body['success'] == true) return body;
    }

    throw Exception(body['message'] ?? 'Failed to create research');
  }

  Future<void> updateResearch(int id, {
    required String title,
    required String abstract,
    String? fileUrl,
  }) async {
    final response = await _authService.put('/student/research/$id', {
      'title': title,
      'abstract': abstract,
      if (fileUrl != null) 'file_url': fileUrl,
    });

    final body = json.decode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to update research');
    }
  }

  Future<void> deleteResearch(int id) async {
    final response = await _authService.delete('/student/research/$id');
    final body = json.decode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to delete research');
    }
  }

  Future<void> submitProposal(int id) async {
    final response = await _authService.post('/student/research/$id/submit', {});
    final body = json.decode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to submit proposal');
    }
  }

  Future<void> addRemark(int id, String message) async {
    final response = await _authService.post('/student/research/$id/remark', {
      'message': message,
    });
    final body = json.decode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to add remark');
    }
  }

  Future<void> deleteRemark(int researchId, int remarkId) async {
    final response = await _authService.delete('/student/research/$researchId/remark/$remarkId');
    final body = json.decode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to delete remark');
    }
  }

  Future<void> renewResearch(int id) async {
    final response = await _authService.post('/student/research/$id/renew', {});
    final body = json.decode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to renew research');
    }
  }
}
