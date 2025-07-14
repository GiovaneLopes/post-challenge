import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:post_challenge/core/di/injection_container.dart';
import 'package:post_challenge/features/shared/theme/app_colors.dart';
import 'package:post_challenge/features/auth/presentation/bloc/auth_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = sl.get<AuthBloc>();
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: bloc,
      builder: (context, state) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: state is AuthSuccess
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    state.user.photo ??
                                        'https://i.pinimg.com/236x/6c/99/d8/6c99d882f8eec65f9ee0bd502c17ac84.jpg',
                                    scale: 1.5),
                                radius: 15.r,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                state.user.name ?? 'Guest',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Text(
                                'Age: ${state.user.age ?? 'N/A'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                'Posts: ${state.user.totalPosts ?? 0}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Preferences: ${state.user.preferences?.join(', ') ?? 'N/A'}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.onPrimary,
                        ),
                      ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title:
                    Text('Home', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
