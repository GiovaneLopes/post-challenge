import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:post_challenge/core/di/injection_container.dart';
import 'package:post_challenge/features/shared/theme/app_colors.dart';
import 'package:post_challenge/features/shared/utils/input_validators.dart';
import 'package:post_challenge/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:post_challenge/features/shared/widgets/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bloc = sl<AuthBloc>();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onBackground,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: BlocConsumer<AuthBloc, AuthState>(
              bloc: bloc,
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.of(context).pushReplacementNamed('/posts');
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.onPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      CustomTextFormField(
                        controller: emailController,
                        suffixIcon: Icons.email,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: InputValidators.validateEmail,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: passwordController,
                        labelText: 'Password',
                        obscureText: true,
                        suffixIcon: Icons.lock,
                        validator: InputValidators.validatePassword,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              bloc.add(
                                LoginWithEmailAndPasswordEvent(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                            }
                          },
                          child: state is AuthLoading
                              ? SizedBox(
                                  width: 16.w,
                                  height: 16.w,
                                  child: const CircularProgressIndicator(
                                    color: AppColors.onPrimary,
                                  ),
                                )
                              : const Text('Send'),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
