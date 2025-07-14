import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_challenge/core/di/injection_container.dart';
import 'package:post_challenge/features/shared/theme/app_colors.dart';
import 'package:post_challenge/features/auth/presentation/bloc/auth_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = sl.get<AuthBloc>();
    return Scaffold(
      backgroundColor: AppColors.onBackground,
      body: BlocConsumer<AuthBloc, AuthState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is AuthSuccess) {
              if (bloc.user != null) {
                Navigator.pushReplacementNamed(context, '/posts');
              }
            } else if (state is AuthInitial) {
              Navigator.pushReplacementNamed(context, '/login');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }),
    );
  }
}
