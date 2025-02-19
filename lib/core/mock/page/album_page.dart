import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';

class AlbumPageFake extends StatelessWidget {
  const AlbumPageFake({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album Page'),
        actions: [
          IconButton(
            onPressed: () async {
              context.read<AuthBloc>().add(AuthSignOut());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Album page 📂',
            ),
          ],
        ),
      ),
    );
  }
}
