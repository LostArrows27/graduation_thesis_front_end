import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DobNameFormPage extends StatefulWidget {
  const DobNameFormPage({super.key});

  static const path = '/information/dob-name-form';

  @override
  State<DobNameFormPage> createState() => _DobNameFormPageState();
}

class _DobNameFormPageState extends State<DobNameFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Information'),
      ),
      body: const Center(
        child: Text('Dob Name Form Page'),
      ),
    );
  }
}
