import 'dart:convert';
import 'package:arsys/features/auth/data/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/auth/application/auth_provider.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ProfileRepository(authService);
});

class ProfileRepository {
  final AuthService _authService;

  ProfileRepository(this._authService);

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _authService.get('/user/profile');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _authService.put('/user/profile', data);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update profile');
    }
  }
}
