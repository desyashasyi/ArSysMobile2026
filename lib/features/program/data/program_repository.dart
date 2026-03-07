import 'dart:convert';
import 'package:arsys/features/auth/data/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/auth/application/auth_provider.dart';

final programRepositoryProvider = Provider<ProgramRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ProgramRepository(authService);
});

class ProgramRepository {
  final AuthService _authService;

  ProgramRepository(this._authService);

  // Pre-Defense
  Future<List<dynamic>> getPreDefenseEvents() async {
    final response = await _authService.get('/program/pre-defense');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return (body['data'] as List<dynamic>?) ?? [];
    } else {
      throw Exception('Failed to load pre-defense events');
    }
  }

  Future<Map<String, dynamic>> getPreDefenseDetail(int eventId) async {
    final response = await _authService.get('/program/pre-defense/$eventId');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return {'applicants': (body['data'] as List<dynamic>?) ?? []};
    } else {
      throw Exception('Failed to load pre-defense detail');
    }
  }

  // Final-Defense
  Future<List<dynamic>> getFinalDefenseEvents() async {
    final response = await _authService.get('/program/final-defense');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return (body['data'] as List<dynamic>?) ?? [];
    } else {
      throw Exception('Failed to load final-defense events');
    }
  }

  Future<List<dynamic>> getFinalDefenseRooms(int eventId) async {
    final response = await _authService.get('/program/final-defense/$eventId/rooms');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return (body['data'] as List<dynamic>?) ?? [];
    } else {
      throw Exception('Failed to load final-defense rooms');
    }
  }

  Future<Map<String, dynamic>> getFinalDefenseRoomDetail(int eventId, int roomId) async {
    final response = await _authService.get('/program/final-defense/$eventId/room/$roomId');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return (body['data'] as Map<String, dynamic>?) ?? {};
    } else {
      throw Exception('Failed to load room detail');
    }
  }

  // Approval
  Future<List<dynamic>> getApprovals() async {
    final response = await _authService.get('/program/approvals');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return (body['data'] as List<dynamic>?) ?? [];
    } else {
      throw Exception('Failed to load approvals');
    }
  }

  Future<Map<String, dynamic>> getApprovalDetail(int id) async {
    final response = await _authService.get('/program/approvals/$id');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return (body['data'] as Map<String, dynamic>?) ?? {};
    } else {
      throw Exception('Failed to load approval detail');
    }
  }

  Future<void> approve(int id) async {
    final response = await _authService.post('/program/approvals/$id/approve', {});
    if (response.statusCode != 200) {
      throw Exception('Failed to approve');
    }
  }
}
