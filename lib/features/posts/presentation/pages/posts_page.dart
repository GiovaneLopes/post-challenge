import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_challenge/core/di/injection_container.dart';
import 'package:post_challenge/features/auth/presentation/bloc/auth_bloc.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final bloc = sl<AuthBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Posts Page'),
            BlocListener<AuthBloc, AuthState>(
              bloc: bloc,
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  Navigator.of(context).pushReplacementNamed('/');
                }
              },
              child: ElevatedButton(
                onPressed: () {
                  bloc.add(LogoutEvent());
                },
                child: const Text('Logout'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
