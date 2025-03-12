import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final String? message;
  const Loader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          (message != null) ? SizedBox(width: 10) : SizedBox(),
          (message != null)
              ? Text(
                  message!,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
