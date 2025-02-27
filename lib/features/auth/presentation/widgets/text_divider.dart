import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  final String placeholder;

  const TextDivider({
    super.key,
    this.placeholder = "or",
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
            placeholder,
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
