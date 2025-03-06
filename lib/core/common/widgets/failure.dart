import 'package:flutter/material.dart';

class FailureWidget extends StatelessWidget {
  final String message;

  const FailureWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
