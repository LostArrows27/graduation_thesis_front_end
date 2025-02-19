import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoader extends StatelessWidget {
  const LottieLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random().nextInt(2) + 1;
    return Scaffold(
      body: Center(
          child: Lottie.asset(
              'assets/lottie/loading${random == 1 ? '' : '_2'}.json',
              height: 150)),
    );
  }
}
