import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:post_challenge/core/errors/failures.dart';
import 'package:post_challenge/core/usecases/usecase.dart';
import 'package:post_challenge/features/posts/domain/entities/post_entity.dart';
import 'package:post_challenge/features/posts/domain/repositories/posts_repository.dart';

class GetPostsUsecase implements UseCase<List<PostEntity>, PostsParams> {
  final PostsRepository repository;

  GetPostsUsecase(this.repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(PostsParams params) async {
    return await repository.getPosts(params.start);
  }
}

class PostsParams extends Equatable {
  final int start;

  const PostsParams({
    required this.start,
  });

  @override
  List<Object> get props => [start];
}
