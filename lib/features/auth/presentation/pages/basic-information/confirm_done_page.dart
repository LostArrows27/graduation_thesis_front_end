import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/routes/routes.dart';
import 'package:lottie/lottie.dart';

class ConfirmDonePage extends StatelessWidget {
  const ConfirmDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          SizedBox(height: 140),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Container(
                  child: Lottie.asset('assets/lottie/congrat.json',
                      width: double.infinity, height: 350),
                ),
                SizedBox(height: 30),
                Text(
                  "Congrats!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  "You've successfully set up\nyour account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.4,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                SizedBox(height: 45),
                SizedBox(
                  width: 250,
                  height: 56,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      context.go(Routes.albumsPage);
                    },
                    child: Text("Continue",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
