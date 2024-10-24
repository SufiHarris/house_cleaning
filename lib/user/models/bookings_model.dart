import '../../auth/model/usermodel.dart';

class BookingModel {
  final String address;
  final String bookingDate;
  final String booking_id;
  final String bookingTime;
  final List<String> employee_ids;
  final List<String> shift_names;
  final List<String> endImage; // Changed to List<String>
  final String payment_status;
  final List<ProductBooking> products;
  final List<ServiceBooking> services;
  final List<String> start_image; // Changed to List<String>
  final String status;
  final double total_price;
  final String user_id; // Changed from int to String
  final String user_phn_number;
  final String categoryName;
  final String categoryNameArabic;
  final String categoryImage;
  final String timeTaken; // New field
  final String travelingTime; // New field

  // Address model fields
  final String building;
  final int floor;
  final GeoLocationModel geolocation;
  final String landmark;
  final String location;

  BookingModel({
    required this.address,
    required this.bookingDate,
    required this.booking_id,
    required this.bookingTime,
    required this.employee_ids,
    required this.shift_names,
    required this.endImage,
    required this.payment_status,
    required this.products,
    required this.services,
    required this.start_image,
    required this.status,
    required this.total_price,
    required this.user_id,
    required this.user_phn_number,
    required this.categoryName,
    required this.categoryNameArabic,
    required this.categoryImage,
    required this.building,
    required this.floor,
    required this.geolocation,
    required this.landmark,
    required this.location,
    required this.timeTaken,
    required this.travelingTime,
  });

  factory BookingModel.fromFirestore(Map<String, dynamic> json) {
    return BookingModel(
      address: json['address']?.toString() ?? '',
      bookingDate: json['booking_date']?.toString() ?? '',
      booking_id: json['booking_id']?.toString() ?? '',
      bookingTime: json['booking_time']?.toString() ?? '',
      employee_ids: _parseStringList(json['employee_ids']),
      shift_names: _parseStringList(json['shift_names']),
      endImage: _parseStringList(json['end_image']), // Updated parser
      payment_status: json['payment_status']?.toString() ?? '',
      products: _parseProducts(json['products']),
      services: _parseServices(json['services']),
      start_image: _parseStringList(json['start_image']), // Updated parser
      status: json['status']?.toString() ?? '',
      total_price: _parseDouble(json['total_price']),
      user_id: json['user_id']?.toString() ?? '', // Updated parser
      user_phn_number: json['user_phn_number']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
      categoryNameArabic: json['category_name_arabic']?.toString() ?? '',
      categoryImage: json['category_image']?.toString() ?? '',
      building: json['building']?.toString() ?? '',
      floor: _parseInteger(json['floor']),
      geolocation: GeoLocationModel.fromFirestore(json['Geolocation'] ?? []),
      landmark: json['landmark']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      timeTaken: json['time_taken']?.toString() ?? '', // New field
      travelingTime: json['traveling_time']?.toString() ?? '', // New field
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value is String) return [value];
    return [];
  }

  static List<ServiceBooking> _parseServices(dynamic servicesData) {
    if (servicesData == null) return [];
    if (servicesData is List) {
      return servicesData
          .map((service) => ServiceBooking.fromJson(service))
          .toList();
    }
    return [];
  }

  static List<ProductBooking> _parseProducts(dynamic productsData) {
    if (productsData == null) return [];
    if (productsData is List) {
      return productsData
          .map((product) => ProductBooking.fromJson(product))
          .toList();
    }
    return [];
  }

  static int _parseInteger(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'booking_date': bookingDate,
      'booking_id': booking_id,
      'booking_time': bookingTime,
      'employee_ids': employee_ids,
      'shift_names': shift_names,
      'end_image': endImage, // Now sending as List<String>
      'payment_status': payment_status,
      'products': products.map((p) => p.toJson()).toList(),
      'services': services.map((s) => s.toJson()).toList(),
      'start_image': start_image, // Now sending as List<String>
      'status': status,
      'total_price': total_price,
      'user_id': user_id,
      'user_phn_number': user_phn_number,
      'category_name': categoryName,
      'category_name_arabic': categoryNameArabic,
      'category_image': categoryImage,
      'building': building,
      'floor': floor,
      'Geolocation': [geolocation.lat, geolocation.lon],
      'landmark': landmark,
      'location': location,
      'time_taken': timeTaken, // New field
      'traveling_time': travelingTime, // New field
    };
  }
}

class ServiceBooking {
  final int quantity;
  final String service_name;
  final String service_name_arabic;
  final int size;
  final double price;

  ServiceBooking({
    required this.quantity,
    required this.service_name,
    required this.service_name_arabic,
    required this.size,
    required this.price,
  });

  factory ServiceBooking.fromJson(Map<String, dynamic> json) {
    return ServiceBooking(
      quantity: BookingModel._parseInteger(json['quantity']),
      service_name: json['service_name']?.toString() ?? '',
      service_name_arabic: json['service_name_arabic']?.toString() ?? '',
      size: BookingModel._parseInteger(json['size']),
      price: BookingModel._parseDouble(json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'service_name': service_name,
      'service_name_arabic': service_name_arabic,
      'size': size,
      'price': price,
    };
  }
}

class ProductBooking {
  final String product_name;
  final String product_name_arabic;
  final int quantity;
  final String delivery_time;
  final double price;
  final String imageUrl;

  ProductBooking({
    required this.product_name,
    required this.product_name_arabic,
    required this.quantity,
    required this.delivery_time,
    required this.price,
    required this.imageUrl,
  });

  factory ProductBooking.fromJson(Map<String, dynamic> json) {
    return ProductBooking(
      product_name: json['product_name']?.toString() ?? '',
      product_name_arabic: json['product_name_arabic']?.toString() ?? '',
      quantity: BookingModel._parseInteger(json['quantity']),
      delivery_time: json['delivery_time']?.toString() ?? '',
      price: BookingModel._parseDouble(json['price']),
      imageUrl: json['image_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': product_name,
      'product_name_arabic': product_name_arabic,
      'quantity': quantity,
      'delivery_time': delivery_time,
      'price': price,
      'image_url': imageUrl,
    };
  }
}
