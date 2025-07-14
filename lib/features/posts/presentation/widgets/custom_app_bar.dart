import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_challenge/core/di/injection_container.dart';
import 'package:post_challenge/features/auth/presentation/bloc/auth_bloc.dart'
    show AuthState, AuthBloc, LogoutSuccess, LogoutError, LogoutEvent;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = sl.get<AuthBloc>();
    return AppBar(
      title: Text(
        'Posts',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      leading: GestureDetector(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: const Icon(Icons.menu),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        BlocListener<AuthBloc, AuthState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is LogoutSuccess) {
              Navigator.pushReplacementNamed(context, '/login');
            } else if (state is LogoutError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: IconButton(
            onPressed: () => bloc.add(LogoutEvent()),
            icon: const Icon(Icons.logout),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
