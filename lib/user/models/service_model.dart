import 'package:flutter/material.dart';

class Service {
  final String name;
  final IconData icon;
  final Color color;
  final double price;
  final double rating;

  Service(this.name, this.icon, this.color, this.price, this.rating);
}

final List<Service> services = [
  Service('Home Cleaning', Icons.home, Colors.orange, 100.0, 3.5),
  Service('Office Cleaning', Icons.desk, Colors.blue, 100.0, 3.5),
  Service('Deep Cleaning', Icons.cleaning_services, Colors.green, 100.0, 3.5),
  // Service('Carpet Cleaning', Icons.carpet, Colors.purple),
  Service('Window Cleaning', Icons.window, Colors.cyan, 100.0, 3.5),
  Service('View all', Icons.arrow_forward, Colors.blueAccent, 100.0, 3.5),
];
