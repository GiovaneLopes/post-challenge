import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:post_challenge/core/di/injection_container.dart';
import 'package:post_challenge/features/shared/theme/app_colors.dart';
import 'package:post_challenge/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:post_challenge/features/posts/presentation/bloc/post_bloc.dart';
import 'package:post_challenge/features/posts/presentation/pages/post_detail.dart';
import 'package:post_challenge/features/posts/presentation/widgets/custom_drawer.dart';
import 'package:post_challenge/features/posts/presentation/widgets/custom_app_bar.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final bloc = sl.get<PostBloc>();
  final authBloc = sl.get<AuthBloc>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BlocBuilder<PostBloc, PostState>(
                  bloc: bloc,
                  builder: (context, state) {
                    if (state is PostLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PostError) {
                      return Center(child: Text(state.message));
                    } else if (state is PostLoaded ||
                        state is PostLoadingMore) {
                      final posts = state is PostLoaded
                          ? state.posts
                          : (state as PostLoadingMore).posts;
                      return NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification.metrics.pixels >=
                                  scrollNotification.metrics.maxScrollExtent -
                                      100 &&
                              (state is! PostLoadingMore)) {
                            bloc.add(FetchMorePostsEvent(posts));
                          }
                          return false;
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: posts.length,
                                padding: EdgeInsets.symmetric(horizontal: 1.w),
                                itemBuilder: (context, index) {
                                  final post = posts[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 6.h),
                                    elevation: 2,
                                    child: ListTile(
                                      titleAlignment:
                                          ListTileTitleAlignment.top,
                                      leading: CircleAvatar(
                                        child: Text(bloc
                                            .getAuthorName(post.userId)[0]
                                            .toUpperCase()),
                                      ),
                                      title: Text(post.title),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post.body.length > 100
                                                ? '${post.body.substring(0, 100)}...'
                                                : post.body,
                                          ),
                                          Row(
                                            children: [
                                              const Expanded(child: SizedBox()),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/post-details',
                                                    arguments: PostDetailPage(
                                                      post: post,
                                                      authorName:
                                                          bloc.getAuthorName(
                                                        post.userId,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Text('Read more'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      titleTextStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      subtitleTextStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Visibility(
                              visible: state is PostLoadingMore,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: const CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  const Text('Loading')
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
