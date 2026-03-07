import 'dart:convert';
import 'package:arsys/features/auth/data/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arsys/features/auth/application/auth_provider.dart';

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return NewsRepository(authService);
});

class NewsRepository {
  final AuthService _authService;

  NewsRepository(this._authService);

  Future<List<dynamic>> getNews() async {
    final response = await _authService.get('/news');
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<Map<String, dynamic>> createNews(String title, String content) async {
    final response = await _authService.post('/news', {
      'title': title,
      'content': content,
    });
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create news');
    }
  }

  Future<void> updateNews(int id, String title, String content) async {
    final response = await _authService.put('/news/$id', {
      'title': title,
      'content': content,
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to update news');
    }
  }

  Future<void> deleteNews(int id) async {
    final response = await _authService.delete('/news/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete news');
    }
  }
}
