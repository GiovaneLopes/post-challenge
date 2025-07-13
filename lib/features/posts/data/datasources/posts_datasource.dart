import 'package:dio/dio.dart';
import 'package:post_challenge/core/errors/exceptions.dart';
import 'package:post_challenge/features/posts/data/models/post_model.dart';
import 'package:post_challenge/features/posts/data/models/post_author_model.dart';

abstract class PostsDatasource {
  Future<List<PostModel>> fetchPosts(int start);
  Future<List<PostAuthorModel>> fetchPostAuthors();
}

class PostsDatasourceImpl implements PostsDatasource {
  final Dio _dio;
  PostsDatasourceImpl(this._dio);

  @override
  Future<List<PostModel>> fetchPosts(int start) async {
    final response = await _dio.get(
      'https://jsonplaceholder.typicode.com/posts',
      queryParameters: {
        '_start': start,
        '_limit': 10,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw const PostException('Failed to load posts');
    }
  }

  @override
  Future<List<PostAuthorModel>> fetchPostAuthors() async {
    final response =
        await _dio.get('https://jsonplaceholder.typicode.com/users');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data
          .map((json) => PostAuthorModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw const PostException('Failed to load post authors');
    }
  }
}
