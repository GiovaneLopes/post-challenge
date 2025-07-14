import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_challenge/core/errors/failures.dart';
import 'package:post_challenge/core/usecases/usecase.dart';
import 'package:post_challenge/features/posts/domain/entities/post_entity.dart';
import 'package:post_challenge/features/posts/presentation/bloc/post_bloc.dart';
import 'package:post_challenge/features/posts/domain/usecases/get_posts_usecase.dart';
import 'package:post_challenge/features/posts/domain/entities/post_author_entity.dart';
import 'package:post_challenge/features/posts/domain/usecases/get_posts_authors_usecase.dart';

class MockGetPostsUsecase extends Mock implements GetPostsUsecase {}

class MockGetPostsAuthorsUsecase extends Mock
    implements GetPostsAuthorsUsecase {}

void main() {
  late PostBloc bloc;
  late MockGetPostsUsecase mockGetPostsUsecase;
  late MockGetPostsAuthorsUsecase mockGetPostsAuthorsUsecase;

  setUp(() {
    mockGetPostsUsecase = MockGetPostsUsecase();
    mockGetPostsAuthorsUsecase = MockGetPostsAuthorsUsecase();
    bloc = PostBloc(
      mockGetPostsUsecase,
      mockGetPostsAuthorsUsecase,
    );
  });

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const PostsParams(start: 0));
  });

  const posts = [
    PostEntity(id: 1, title: 'Test', body: 'Body', userId: 1),
    PostEntity(id: 2, title: 'Test2', body: 'Body2', userId: 2),
  ];

  const authors = [
    PostAuthorEntity(id: 1, name: 'Author 1', username: 'author1'),
    PostAuthorEntity(id: 2, name: 'Author 2', username: 'author2'),
  ];

  group('PostBloc', () {
    blocTest<PostBloc, PostState>(
      'emits [PostLoading, PostLoaded] when FetchPostsEvent is added and posts are fetched successfully',
      build: () => bloc,
      setUp: () {
        when(() => mockGetPostsUsecase(any()))
            .thenAnswer((_) async => const Right(posts));
        when(() => mockGetPostsAuthorsUsecase(NoParams()))
            .thenAnswer((_) async => const Right(authors));
      },
      act: (bloc) => bloc.add(FetchPostsEvent()),
      expect: () => [
        PostLoaded(posts, false),
      ],
    );

    blocTest<PostBloc, PostState>(
      'emits [PostLoading, PostError] when FetchPostsEvent is added and fetching fails',
      build: () => bloc,
      setUp: () {
        when(() => mockGetPostsUsecase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('error')));
        when(() => mockGetPostsAuthorsUsecase(any()))
            .thenAnswer((_) async => const Right(authors));
      },
      act: (bloc) async {
        bloc.add(FetchPostsEvent());
        await Future.delayed(Duration.zero);
      },
      expect: () => [
        PostLoading(),
        PostError('error'),
      ],
    );

    blocTest<PostBloc, PostState>(
      'emits [PostLoadingMore, PostLoaded] when FetchMorePostsEvent is added and more posts are fetched',
      build: () => bloc,
      setUp: () {
        when(() => mockGetPostsUsecase(any())).thenAnswer((invocation) async {
          final params = invocation.positionalArguments[0] as PostsParams;
          if (params.start == 0) return const Right(posts);
          return const Right([
            PostEntity(id: 3, title: 'Test3', body: 'Body3', userId: 1),
          ]);
        });
        when(() => mockGetPostsAuthorsUsecase(any()))
            .thenAnswer((_) async => const Right(authors));
      },
      act: (bloc) async {
        bloc.add(FetchPostsEvent());
        await Future.delayed(Duration.zero);
        bloc.add(const FetchMorePostsEvent([]));
        await Future.delayed(const Duration(seconds: 3));
      },
      skip: 2,
      expect: () => [
        PostLoadingMore(const []),
        PostLoaded(posts, false),
      ],
    );

    blocTest<PostBloc, PostState>(
      'emits [PostError] when FetchMorePostsEvent fails',
      build: () => bloc,
      setUp: () {
        when(() => mockGetPostsUsecase(any())).thenAnswer((invocation) async {
          final params = invocation.positionalArguments[0] as PostsParams;
          if (params.start == 0) return const Right(posts);
          return const Left(ServerFailure('fetch more error'));
        });
        when(() => mockGetPostsAuthorsUsecase(any()))
            .thenAnswer((_) async => const Right(authors));
      },
      act: (bloc) async {
        bloc.add(FetchPostsEvent());
        await Future.delayed(Duration.zero);
        bloc.add(const FetchMorePostsEvent([]));
        await Future.delayed(const Duration(seconds: 3));
      },
      skip: 2,
      expect: () => [
        PostLoadingMore(const []),
        PostError('fetch more error'),
      ],
    );

    blocTest<PostBloc, PostState>(
      'emits [PostError] when FetchPostsAuthorsEvent fails',
      build: () => bloc,
      setUp: () {
        when(() => mockGetPostsUsecase(any()))
            .thenAnswer((_) async => const Right(posts));
        when(() => mockGetPostsAuthorsUsecase(any())).thenAnswer(
            (_) async => const Left(ServerFailure('authors error')));
      },
      act: (bloc) async {
        bloc.add(FetchPostsAuthorsEvent());
        await Future.delayed(Duration.zero);
      },
      expect: () => [
        PostError('authors error'),
      ],
    );
  });
}
