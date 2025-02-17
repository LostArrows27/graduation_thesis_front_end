import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

void showConfetti(BuildContext context) {
  final confettiController =
      ConfettiController(duration: Duration(milliseconds: 2500));

  // Start confetti animation
  confettiController.play();

  showDialog(
    context: context,
    barrierDismissible: true, // Close when tapping outside
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirection: 3.14 / 2, // Makes confetti fall down
                shouldLoop: true,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.05, // More frequent confetti
                numberOfParticles: 50, // Many confetti pieces
                gravity: 0.6, // Falls at a smooth speed
              ),
            ),
          ),
        ],
      );
    },
  );

  // Stop confetti after 1 second and close dialog
  Future.delayed(Duration(milliseconds: 2500), () {
    confettiController.stop();
    Navigator.pop(context);
  });
}
