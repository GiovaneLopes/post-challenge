part of './post_bloc.dart';

abstract class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostLoading extends PostState {}

class PostLoadingMore extends PostState {
  final List<PostEntity> posts;

  PostLoadingMore(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostLoaded extends PostState {
  final List<PostEntity> posts;
  final bool hasReachedMax;

  PostLoaded(this.posts, this.hasReachedMax);

  @override
  List<Object?> get props => [posts, hasReachedMax];
}

class PostError extends PostState {
  final String message;

  PostError(this.message);

  @override
  List<Object?> get props => [message];
}
