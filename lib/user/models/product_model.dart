class Product {
  final String name;
  final String imageUrl;
  final double currentPrice;
  final double? originalPrice;
  final double price;
  final double rating;

  Product(
      {required this.name,
      required this.imageUrl,
      required this.currentPrice,
      this.originalPrice,
      required this.price,
      required this.rating});
}

List<Product> products = [
  Product(
      name: 'Mr Muscle Kitchen Cleaner - 425ml Pouch (Lemon)',
      imageUrl:
          'https://cloudinary-marketing-res.cloudinary.com/images/w_1000,c_scale/v1679921049/Image_URL_header/Image_URL_header-png?_i=AA', // Replace with your image URL
      currentPrice: 15,
      originalPrice: 999,
      rating: 4,
      price: 400),
  Product(
      name: 'Spotzero by Milton Prime Spin Mop',
      imageUrl: '',
      currentPrice: 349.99,
      originalPrice: 999,
      rating: 4,
      price: 400),
  Product(
      name: 'Mr Muscle Kitchen Cleaner - 425ml Pouch (Lemon)',
      imageUrl:
          'https://cloudinary-marketing-res.cloudinary.com/images/w_1000,c_scale/v1679921049/Image_URL_header/Image_URL_header-png?_i=AA', // Replace with your image URL
      currentPrice: 15,
      originalPrice: 999,
      rating: 4,
      price: 400),
  Product(
      name: 'Spotzero by Milton Prime Spin Mop',
      imageUrl: '',
      currentPrice: 349.99,
      originalPrice: 999,
      rating: 4,
      price: 400),
  Product(
      name: 'Mr Muscle Kitchen Cleaner - 425ml Pouch (Lemon)',
      imageUrl:
          'https://cloudinary-marketing-res.cloudinary.com/images/w_1000,c_scale/v1679921049/Image_URL_header/Image_URL_header-png?_i=AA', // Replace with your image URL
      currentPrice: 15,
      originalPrice: 999,
      rating: 4,
      price: 400),
  Product(
      name: 'Spotzero by Milton Prime Spin Mop',
      imageUrl: '',
      currentPrice: 349.99,
      originalPrice: 999,
      rating: 4,
      price: 400),
];
