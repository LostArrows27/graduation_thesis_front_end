import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/utils/padding.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/core/utils/validators.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/sign_up_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/auth_field.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/text_divider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const path = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 250,
                child: Image.asset(
                  'assets/images/login_banner.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Padding(
                    padding: PaddingUtils.pad(0, 30),
                    child: Column(
                      children: [
                        Text(
                          "Let's Connect With Us!",
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthField(
                              hintText: "Email Address",
                              isEnabled: state is AuthLoading ? false : true,
                              validators: [
                                Validators.checkEmail,
                              ],
                              controller: _emailController),
                          SizedBox(height: 24),
                          AuthField(
                              hintText: "Password",
                              isEnabled: state is AuthLoading ? false : true,
                              controller: _passwordController,
                              validators: [
                                Validators.checkPassword,
                                Validators.checkPasswordSpecialChar,
                              ],
                              isObscureText: true),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(height: 10),
                          FilledButton(
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(AuthLogin(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          ));
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: state is AuthLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Text(
                                        'Login',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                          SizedBox(height: 20),
                          TextDivider(),
                          SizedBox(height: 20),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Image.asset('assets/images/discord.webp',
                                width: 24, height: 24),
                            label: Text(
                              "Sign up with Discord",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Image.asset('assets/images/google.webp',
                                width: 24, height: 24),
                            label: Text(
                              "Sign up with Google",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? "),
                              GestureDetector(
                                onTap: () {
                                  context.go(SignUpPage.path);
                                },
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          )
                        ],
                      )))
            ],
          );
        },
      ),
    ));
  }
}
