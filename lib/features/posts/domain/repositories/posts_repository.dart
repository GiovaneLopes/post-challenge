import 'package:dartz/dartz.dart';
import 'package:post_challenge/core/errors/failures.dart';
import 'package:post_challenge/features/posts/domain/entities/post_entity.dart';
import 'package:post_challenge/features/posts/domain/entities/post_author_entity.dart';

abstract class PostsRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts(int start);
  Future<Either<Failure, List<PostAuthorEntity>>> getPostAuthors();
}
