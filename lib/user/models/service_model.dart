class ServiceModel {
  final String serviceName;
  final int serviceId;
  final String category;
  final String image;
  final int price;
  final int baseSize;
  final int basePrice;

  ServiceModel({
    required this.serviceName,
    required this.serviceId,
    required this.category,
    required this.image,
    required this.price,
    required this.baseSize,
    required this.basePrice,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceName: json['service_name'] ?? '',
      serviceId: json['service_id'] ?? 0,
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? 0,
      baseSize: json['base_size'] ?? 10,
      basePrice: json['base_price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'service_id': serviceId,
      'category': category,
      'image': image,
      'price': price,
      'base_size': baseSize,
      'base_price': basePrice,
    };
  }
}

class Review {
  final String userName;
  final String userImage;
  final double rating;
  final String comment;

  Review({
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
  });
}




// class Service {
//   final String name;
//   final IconData icon;
//   final Color color;
//   final double price;
//   final double rating;
//   final detailImageUrl;
//   final String imageUrl;

//   // final List<Review> reviews;

//   Service(this.name, this.icon, this.color, this.price, this.rating,
//       this.imageUrl, this.detailImageUrl);
// }



// final List<Service> services = [
//   Service(
//       'Home Cleaning',
//       Icons.home,
//       Colors.orange,
//       100.0,
//       4.2,
//       'assets/images/apartment_service.png',
//       'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyaminmellish-186077.jpg&fm=jpg'),
//   Service(
//       'Home Cleaning',
//       Icons.home,
//       Colors.orange,
//       100.0,
//       4.2,
//       'assets/images/furniture_service.png',
//       'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyaminmellish-186077.jpg&fm=jpg'),
//   Service(
//       'Home Cleaning',
//       Icons.home,
//       Colors.orange,
//       100.0,
//       4.2,
//       'assets/images/car_service.png',
//       'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyaminmellish-186077.jpg&fm=jpg'),
//   // Add more services with reviews...
// ];
