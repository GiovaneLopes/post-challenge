import 'package:dartz/dartz.dart';
import 'package:post_challenge/core/errors/failures.dart';
import 'package:post_challenge/core/usecases/usecase.dart';
import 'package:post_challenge/features/posts/domain/entities/post_author_entity.dart';
import 'package:post_challenge/features/posts/domain/repositories/posts_repository.dart';

class GetPostsAuthorsUsecase
    implements UseCase<List<PostAuthorEntity>, NoParams> {
  final PostsRepository repository;

  GetPostsAuthorsUsecase(this.repository);

  @override
  Future<Either<Failure, List<PostAuthorEntity>>> call(NoParams params) {
    return repository.getPostAuthors();
  }
}
