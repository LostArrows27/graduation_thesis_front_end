import 'package:flutter/material.dart';

class SurveyFormPage extends StatefulWidget {
  const SurveyFormPage({super.key});

  static const path = '/information/survey-form';

  @override
  State<SurveyFormPage> createState() => _SurveyFormPageState();
}

class _SurveyFormPageState extends State<SurveyFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Survey Form Page'),
      ),
    );
  }
}
