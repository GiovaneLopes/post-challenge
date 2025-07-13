part of './post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostLoading extends PostState {}

class PostLoadingMore extends PostState {
  final List<PostEntity> posts;

  const PostLoadingMore(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostLoaded extends PostState {
  final List<PostEntity> posts;
  final bool hasReachedMax;

  const PostLoaded(this.posts, this.hasReachedMax);

  @override
  List<Object?> get props => [posts, hasReachedMax];
}

class PostError extends PostState {
  final String message;

  const PostError(this.message);

  @override
  List<Object?> get props => [message];
}
