class NotificationModel {
  final String title;
  final String imageUrl;
  final double totalPrice;
  final DateTime dateTime;
  final String address;
  final Map<String, int> rooms;
  final String paymentMethod;

  NotificationModel({
    required this.title,
    required this.imageUrl,
    required this.totalPrice,
    required this.dateTime,
    required this.address,
    required this.rooms,
    required this.paymentMethod,
  });
}

// Generate dummy data
List<NotificationModel> generateDummyNotifications() {
  return [
    NotificationModel(
      title: 'Home Cleaning',
      imageUrl: 'https://example.com/home-cleaning.jpg',
      totalPrice: 57.00,
      dateTime: DateTime(2024, 10, 14, 12, 30),
      address: '1234 Desert Oasis Street, Riyadh, Saudi Arabia, 12345',
      rooms: {'Living': 1, 'Bed': 2, 'Kitchen': 1},
      paymentMethod: 'Cash On Delivery',
    ),
    // Add more dummy notifications here
  ];
}
