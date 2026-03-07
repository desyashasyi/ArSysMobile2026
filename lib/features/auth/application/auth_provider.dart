import 'package:arsys/core/services/fcm_service.dart';
import 'package:arsys/features/auth/data/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final fcmServiceProvider = Provider<FcmService>((ref) {
  return FcmService();
});

class AuthTokenNotifier extends Notifier<String?> {
  @override
  String? build() {
    return ref.read(authServiceProvider).token;
  }

  void setToken(String? token) => state = token;
}

final authTokenProvider = NotifierProvider<AuthTokenNotifier, String?>(AuthTokenNotifier.new);

final userRoleProvider = Provider<String?>((ref) {
  ref.watch(authTokenProvider);
  final roles = ref.read(authServiceProvider).roles;
  if (roles != null && roles.isNotEmpty) {
    return roles.first;
  }
  return null;
});

final allRolesProvider = Provider<List<String>>((ref) {
  ref.watch(authTokenProvider);
  final roles = ref.read(authServiceProvider).roles;
  if (roles != null) {
    return roles.map((e) => e.toString()).toList();
  }
  return [];
});

final isKaprodiProvider = Provider<bool>((ref) {
  final roles = ref.watch(allRolesProvider);
  return roles.contains('program');
});

final programIdProvider = Provider<int?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  final pid = user['program_id'];
  if (pid is int) return pid;
  if (pid is String) return int.tryParse(pid);
  return null;
});

final currentUserProvider = Provider<Map<String, dynamic>?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.user;
});

enum AuthState {
  authenticated,
  unauthenticated,
}

final authStateProvider = Provider<AuthState>((ref) {
  final token = ref.watch(authTokenProvider);
  if (token != null) {
    return AuthState.authenticated;
  }
  return AuthState.unauthenticated;
});
