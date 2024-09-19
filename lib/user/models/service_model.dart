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
  final String imageUrl;
  final List<Review> reviews;

  Service(this.name, this.icon, this.color, this.price, this.rating,
      this.imageUrl, this.reviews);
}

final List<Service> services = [
  Service(
    'Home Cleaning',
    Icons.home,
    Colors.orange,
    100.0,
    4.2,
    'https://images.pexels.com/photos/731082/pexels-photo-731082.jpeg?cs=srgb&dl=pexels-sebastians-731082.jpg&fm=jpg',
    [
      Review('Saad Falah Abdullah', 'assets/images/user1.jpg', 4.2,
          'Working on our mobile app has been an incredible experience. It\'s user-friendly, efficient, and constantly improving. I\'m proud to be part of a team that values creativity and excellence.'),
      Review('John Doe', 'assets/images/user2.jpg', 5.0,
          'Excellent service! My home has never been cleaner.'),
      Review('Jane Smith', 'assets/images/user3.jpg', 3.8,
          'Good service overall, but theres room for improvement.'),
    ],
  ),
  // Add more services with reviews...
];
