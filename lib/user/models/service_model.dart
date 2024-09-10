import 'package:flutter/material.dart';

class Service {
  final String name;
  final IconData icon;
  final Color color;
  final double price;
  final double rating;
  final String imageUrl;

  Service(
      this.name, this.icon, this.color, this.price, this.rating, this.imageUrl);
}

final List<Service> services = [
  Service('Home Cleaning', Icons.home, Colors.orange, 100.0, 3.5,
      'https://images.pexels.com/photos/731082/pexels-photo-731082.jpeg?cs=srgb&dl=pexels-sebastians-731082.jpg&fm=jpg'),
  Service('Office Cleaning', Icons.desk, Colors.blue, 100.0, 3.5,
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWwZGWnpdqGGBcZm1jkl1v4KboQYjjNhb9Ag&s'),
  Service('Deep Cleaning', Icons.cleaning_services, Colors.green, 100.0, 3.5,
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWwZGWnpdqGGBcZm1jkl1v4KboQYjjNhb9Ag&s'),
  // Service('Carpet Cleaning', Icons.carpet, Colors.purple),
  Service('Window Cleaning', Icons.window, Colors.cyan, 100.0, 3.5,
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWwZGWnpdqGGBcZm1jkl1v4KboQYjjNhb9Ag&s'),
  Service('View all', Icons.arrow_forward, Colors.blueAccent, 100.0, 3.5,
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWwZGWnpdqGGBcZm1jkl1v4KboQYjjNhb9Ag&s'),
];
