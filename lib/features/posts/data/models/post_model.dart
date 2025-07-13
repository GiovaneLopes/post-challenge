import 'package:post_challenge/features/posts/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.id,
    required super.title,
    required super.body,
    required super.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      userId: json['userId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
    };
  }
}
