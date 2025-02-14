import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/core/utils/validators.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/login_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/auth_field.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/text_divider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const path = '/sign-up';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignupFailure) {
          showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.asset(
                  'assets/images/sign_up_banner.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                            fontSize: 34, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Log in or Sign up to manage your album.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: Image.asset('assets/images/google.webp',
                                  width: 24, height: 24),
                              label: Text(
                                "Google",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: Image.asset('assets/images/discord.webp',
                                  width: 24, height: 24),
                              label: Text(
                                "Discord",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextDivider(),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name field
                            AuthField(
                              hintText: 'Name',
                              controller: _nameController,
                              validators: [
                                Validators.checkEmpty,
                                Validators.check80Characters
                              ],
                              fieldName: 'Name',
                              isEnabled: state is AuthLoading ? false : true,
                            ),
                            SizedBox(height: 12),

                            // Email address field
                            AuthField(
                              hintText: 'Email',
                              controller: _emailController,
                              validators: [
                                Validators.checkEmail,
                              ],
                              fieldName: 'Email',
                              isEnabled: state is AuthLoading ? false : true,
                            ),
                            SizedBox(height: 12),

                            // Password field
                            AuthField(
                              hintText: 'Password',
                              fieldName: 'Password',
                              controller: _passwordController,
                              validators: [
                                Validators.checkPassword,
                                Validators.checkPasswordSpecialChar,
                              ],
                              isObscureText: true,
                              isEnabled: state is AuthLoading ? false : true,
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      FilledButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(AuthSignup(
                                        name: _nameController.text,
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
                                    'Sign Up',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              )
                            : Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                          ),
                          GestureDetector(
                            onTap: () {
                              context.go(LoginPage.path);
                            },
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
      },
    );
  }
}
