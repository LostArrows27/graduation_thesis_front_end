import 'package:flutter/material.dart';

class SearchPageFake extends StatelessWidget {
  const SearchPageFake({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Search Page 🔍',
          ),
        ],
      ),
    );
  }
}
