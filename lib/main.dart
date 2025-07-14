import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:post_challenge/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:post_challenge/core/di/injection_container.dart';
import 'package:post_challenge/features/shared/theme/app_colors.dart';
import 'package:post_challenge/features/auth/presentation/pages/login_page.dart';
import 'package:post_challenge/features/auth/presentation/pages/splash_page.dart';
import 'package:post_challenge/features/posts/presentation/pages/posts_page.dart';
import 'package:post_challenge/features/posts/presentation/pages/post_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppWdiget());
}

class AppWdiget extends StatelessWidget {
  const AppWdiget({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Posts Challenge',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            useMaterial3: true,
          ),
          routes: {
            '/': (context) => const SplashPage(),
            '/login': (context) => const LoginPage(),
            '/posts': (context) => const PostsPage(),
            '/post-details': (context) =>
                ModalRoute.of(context)?.settings.arguments as PostDetailPage,
          },
        );
      },
    );
  }
}
