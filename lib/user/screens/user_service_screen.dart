import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../widgets/service_card.dart';

class UserServiceScreen extends StatelessWidget {
  const UserServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Services"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search for products and services',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  if (service.name != "View all") {
                    return ServiceCard(service: service);
                  }
                  return const SizedBox
                      .shrink(); // Returns an empty widget for "View all"
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
