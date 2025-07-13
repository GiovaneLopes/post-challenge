import 'package:post_challenge/features/posts/domain/entities/post_author_entity.dart';

class PostAuthorModel extends PostAuthorEntity {
  PostAuthorModel({
    required super.id,
    required super.name,
    required super.username,
  });

  factory PostAuthorModel.fromJson(Map<String, dynamic> json) {
    return PostAuthorModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
    );
  }
}
