import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/utils/padding.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/auth_field.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/text_divider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 280,
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
                  child: Column(
                children: [
                  AuthField(
                      hintText: "Email Address", controller: _emailController),
                  SizedBox(height: 24),
                  AuthField(
                      hintText: "Password",
                      controller: _passwordController,
                      isObscureText: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ))
                    ],
                  ),
                  SizedBox(height: 10),
                  FilledButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
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
                          context.push('/sign-up');
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  )
                ],
              )))
        ],
      ),
    ));
  }
}
