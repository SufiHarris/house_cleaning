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
          'https://cdn.shopify.com/s/files/1/2303/2711/files/10.jpg?v=1617058819', // Replace with your image URL
      currentPrice: 15,
      originalPrice: 999,
      rating: 4,
      price: 400),
  Product(
      name: 'Spotzero by Milton Prime Spin Mop',
      imageUrl:
          'https://cdn.shopify.com/s/files/1/2303/2711/files/2_e822dae0-14df-4cb8-b145-ea4dc0966b34.jpg?v=1617059123',
      currentPrice: 349.99,
      originalPrice: 999,
      rating: 4,
      price: 400),
  Product(
      name: 'Mr Muscle Kitchen Cleaner - 425ml Pouch (Lemon)',
      imageUrl:
          'https://cdn.shopify.com/s/files/1/2303/2711/files/4_98b999c5-25a8-48ff-8998-d819c1db9d75.jpg?v=1617058517', // Replace with your image URL
      currentPrice: 15,
      originalPrice: 999,
      rating: 4,
      price: 400),
  Product(
      name: 'Spotzero by Milton Prime Spin Mop',
      imageUrl:
          'https://cdn.shopify.com/s/files/1/2303/2711/files/7_324422e0-fe83-4b3d-ae5c-641f4567b5ff.jpg?v=1617058709',
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
