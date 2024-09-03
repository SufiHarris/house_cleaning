import 'package:flutter/material.dart';
import 'package:house_cleaning/user/widgets/main_card.dart';
import '../models/service_model.dart';
import '../widgets/service_card.dart';

class UserServiceScreen extends StatelessWidget {
  const UserServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Services"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search for products and services',
                  ),
                ),
                //    const SizedBox(height: 20),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final service = services[index];
                  return MainCard(
                    icon: service.icon,
                    name: service.name,
                    price: service.price,
                    rating: service.rating,
                    iconColor: service.color,
                  );
                },
                childCount: services.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
