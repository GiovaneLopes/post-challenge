import 'package:dartz/dartz.dart';
import 'package:post_challenge/core/errors/failures.dart';
import 'package:post_challenge/core/errors/exceptions.dart';
import 'package:post_challenge/core/network/network_info.dart';
import 'package:post_challenge/features/posts/domain/entities/post_entity.dart';
import 'package:post_challenge/features/posts/data/datasources/posts_datasource.dart';
import 'package:post_challenge/features/posts/domain/entities/post_author_entity.dart';
import 'package:post_challenge/features/posts/domain/repositories/posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsDatasource _datasource;
  final NetworkInfo networkInfo;

  PostsRepositoryImpl(this._datasource, this.networkInfo);

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts(int start) async {
    if (await networkInfo.isConnected) {
      try {
        final posts = await _datasource.fetchPosts(start);
        return Right(posts);
      } on PostException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, List<PostAuthorEntity>>> getPostAuthors() async {
    if (await networkInfo.isConnected) {
      try {
        final authors = await _datasource.fetchPostAuthors();
        return Right(authors);
      } on PostException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection.'));
    }
  }
}
