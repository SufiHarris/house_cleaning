class UserProductModel {
  final String name;
  final String imageUrl;
  final double price;
  final String? brand; // Optional fields
  final String? deliveryTime; // Optional fields
  final String? description; // Optional fields
  final String? productId; // Optional fields
  final int? quantity; // Optional fields

  UserProductModel({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.brand,
    this.deliveryTime,
    this.description,
    this.productId,
    this.quantity,
  });

  // Factory method to create a Product object from Firestore
  factory UserProductModel.fromFirestore(Map<String, dynamic> json) {
    return UserProductModel(
      name: json['name'] ?? 'Unknown', // Provide a default if name is null
      imageUrl: json['image'] ?? '', // Check for null values, assign defaults
      price: (json['price'] ?? 0).toDouble(),
      brand: json['brand'],
      deliveryTime: json['delivery_time'],
      description: json['description'],
      productId: json['product_id'],
      quantity: json['quantity'],
    );
  }

  // Method to convert the Product object to a JSON format (for sending to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': imageUrl,
      'price': price,
      'brand': brand,
      'delivery_time': deliveryTime,
      'description': description,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}
