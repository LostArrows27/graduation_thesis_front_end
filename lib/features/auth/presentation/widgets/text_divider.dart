import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "or",
            style: TextStyle(
                fontSize: 14, color: Theme.of(context).colorScheme.outline),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
