import 'package:flutter/material.dart';

class Review {
  final String userName;
  final String userImage;
  final double rating;
  final String comment;

  Review(this.userName, this.userImage, this.rating, this.comment);
}

class Service {
  final String name;
  final IconData icon;
  final Color color;
  final double price;
  final double rating;
  final detailImageUrl;
  final String imageUrl;

  // final List<Review> reviews;

  Service(this.name, this.icon, this.color, this.price, this.rating,
      this.imageUrl, this.detailImageUrl);
}

final List<Review> reviews = [
  Review('Saad Falah Abdullah', 'assets/images/user1.jpg', 4.2,
      'Working on our mobile app has been an incredible experience. It\'s user-friendly, efficient, and constantly improving. I\'m proud to be part of a team that values creativity and excellence.'),
  Review('John Doe', 'assets/images/user2.jpg', 5.0,
      'Excellent service! My home has never been cleaner.'),
  Review('Jane Smith', 'assets/images/user3.jpg', 3.8,
      'Good service overall, but theres room for improvement.'),
];

final List<Service> services = [
  Service(
      'Home Cleaning',
      Icons.home,
      Colors.orange,
      100.0,
      4.2,
      'assets/images/apartment_service.png',
      'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyaminmellish-186077.jpg&fm=jpg'),
  Service(
      'Home Cleaning',
      Icons.home,
      Colors.orange,
      100.0,
      4.2,
      'assets/images/furniture_service.png',
      'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyaminmellish-186077.jpg&fm=jpg'),
  Service(
      'Home Cleaning',
      Icons.home,
      Colors.orange,
      100.0,
      4.2,
      'assets/images/car_service.png',
      'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyaminmellish-186077.jpg&fm=jpg'),
  // Add more services with reviews...
];
