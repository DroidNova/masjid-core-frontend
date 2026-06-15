import 'package:flutter/material.dart';

class MasjidRequestPlaceholderScreen extends StatelessWidget {
  const MasjidRequestPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Your Masjid')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Masjid request form will be added soon',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
