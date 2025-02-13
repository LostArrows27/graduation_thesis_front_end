import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/utils/validators.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/auth_field.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/text_divider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Log in or Sign up to manage your album.',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
                  TextDivider(),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name field
                          AuthField(
                            hintText: 'Name',
                            controller: _nameController,
                            validators: [
                              Validators.checkEmpty,
                            ],
                            fieldName: 'Name',
                          ),
                          SizedBox(height: 16),

                          // Email address field
                          AuthField(
                            hintText: 'Email',
                            controller: _emailController,
                            validators: [
                              Validators.checkEmail,
                            ],
                            fieldName: 'Email',
                          ),
                          SizedBox(height: 16),

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
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  FilledButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
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
                          context.push('/login');
                        },
                        child: Text(
                          'Log in',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
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
  }
}
