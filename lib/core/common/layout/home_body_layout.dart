import 'package:flutter/material.dart';

class BodyLayout extends StatelessWidget {
  final Widget body;

  const BodyLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: false,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Smart Gallery',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.notifications_outlined,
                            size: 26,
                            color: Theme.of(context).colorScheme.primary)),
                    SizedBox(width: 16),
                    CircleAvatar(
                      radius: 18,
                      backgroundImage:
                          AssetImage('assets/images/placeholder.jpg'),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
        body: body,
      ),
    );
  }
}
