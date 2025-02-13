import 'package:flutter/material.dart';
import 'package:graduation_thesis_front_end/core/routes/router.dart';
import 'package:graduation_thesis_front_end/core/theme/theme.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/landing_page.dart';
import 'package:graduation_thesis_front_end/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Smart Gallery',
        theme: AppTheme.lightModeTheme(context),
        routerConfig: routerConfig);
  }
}
