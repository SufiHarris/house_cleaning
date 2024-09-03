import 'package:flutter/material.dart';

import '../../theme/custom_colors.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Welcome back! Glad\nto see you, Again!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            TextField(
                decoration: InputDecoration(
              hintText: 'Enter your email',
            )),
          ],
        ),
      ),
    );
  }
}
