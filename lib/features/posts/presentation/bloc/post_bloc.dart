import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_challenge/core/usecases/usecase.dart';
import 'package:post_challenge/features/posts/domain/entities/post_entity.dart';
import 'package:post_challenge/features/posts/domain/usecases/get_posts_usecase.dart';
import 'package:post_challenge/features/posts/domain/entities/post_author_entity.dart';
import 'package:post_challenge/features/posts/domain/usecases/get_posts_authors_usecase.dart';

part './post_event.dart';
part './post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUsecase postsUsercase;
  final GetPostsAuthorsUsecase postsAuthorsUsecase;
  final List<PostEntity> posts = [];
  final List<PostAuthorEntity> authors = [];
  int _currentPage = 0;
  bool _hasReachedMax = false;

  String getAuthorName(int authorId) {
    return authors
        .firstWhere((author) => author.id == authorId,
            orElse: () => const PostAuthorEntity(
                id: 0, name: 'Unknown Author', username: ''))
        .name;
  }

  PostBloc(this.postsUsercase, this.postsAuthorsUsecase)
      : super(PostLoading()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<FetchPostsAuthorsEvent>(_fetchPostAuthors);
    on<FetchMorePostsEvent>(_onFetchMorePosts);
    add(FetchPostsEvent());
    add(FetchPostsAuthorsEvent());
  }

  Future<void> _onFetchPosts(
      FetchPostsEvent event, Emitter<PostState> emit) async {
    emit(PostLoading());
    _currentPage = 0;
    _hasReachedMax = false;
    final failureOrPosts = await postsUsercase(PostsParams(
      start: _currentPage,
    ));

    failureOrPosts.fold(
      (failure) => emit(PostError(failure.message)),
      (posts) {
        this.posts.addAll(posts);
        emit(PostLoaded(this.posts, _hasReachedMax));
      },
    );
  }

  Future<void> _onFetchMorePosts(
      FetchMorePostsEvent event, Emitter<PostState> emit) async {
    if (state is PostLoadingMore || _hasReachedMax) {
      return;
    }

    final currentPosts =
        (state is PostLoaded) ? (state as PostLoaded).posts : <PostEntity>[];
    emit(PostLoadingMore(currentPosts));

    _currentPage++;
    await Future.delayed(const Duration(seconds: 3));
    final result = await postsUsercase(
      PostsParams(start: (_currentPage * 10).toInt()),
    );

    result.fold(
      (failure) => emit(PostError(failure.message)),
      (newPosts) {
        if (newPosts.isEmpty || newPosts.length < 10) {
          _hasReachedMax = true;
        }
        posts.addAll(newPosts);
        emit(PostLoaded(posts, _hasReachedMax));
      },
    );
  }

  Future<void> _fetchPostAuthors(
      FetchPostsAuthorsEvent event, Emitter<PostState> emit) async {
    final failureOrAuthors = await postsAuthorsUsecase(NoParams());
    failureOrAuthors.fold(
      (failure) => emit(PostError(failure.message)),
      (authors) => this.authors.addAll(authors),
    );
  }
}
