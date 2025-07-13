part of './post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class FetchPostsEvent extends PostEvent {}

class FetchMorePostsEvent extends PostEvent {
  final List<PostEntity> posts;
  const FetchMorePostsEvent(this.posts);
  @override
  List<Object?> get props => [posts];
}

class FetchPostsAuthorsEvent extends PostEvent {}
