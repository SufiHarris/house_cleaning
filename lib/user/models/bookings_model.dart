import '../../auth/model/usermodel.dart';

class BookingModel {
  final String address;
  final String bookingDate;
  final int booking_id;
  final String bookingTime;
  final List<String> employee_ids; // Changed to List<String>
  final List<String> shift_names; // Added shift names
  final String endImage;
  final String payment_status;
  final List<ProductBooking> products;
  final List<ServiceBooking> services;
  final String start_image;
  final String status;
  final double total_price;
  final int user_id;
  final String user_phn_number;
  final String categoryName;
  final String categoryNameArabic; // Added Arabic category name
  final String categoryImage;

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
  });

  factory BookingModel.fromFirestore(Map<String, dynamic> json) {
    return BookingModel(
      address: json['address'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      booking_id: _parseInteger(json['booking_id'], 0),
      bookingTime: json['booking_time'] ?? '',
      employee_ids: _parseStringList(json['employee_ids']),
      shift_names: _parseStringList(json['shift_names']),
      endImage: json['end_image'] ?? '',
      payment_status: json['payment_status'] ?? '',
      products: (json['products'] as List<dynamic>?)
              ?.map((p) => ProductBooking.fromJson(p))
              .toList() ??
          [],
      services: _parseServices(json['services']),
      start_image: json['start_image'] ?? '',
      status: json['status'] ?? '',
      total_price: _parseDouble(json['total_price'], 0.0),
      user_id: _parseInteger(json['user_id'], 0),
      user_phn_number: json['user_phn_number'] ?? '',
      categoryName: json['category_name'] ?? '',
      categoryNameArabic: json['category_name_arabic'] ?? '',
      categoryImage: json['category_image'] ?? '',
      building: json['building'] ?? '',
      floor: _parseInteger(json['floor'], 0),
      geolocation: GeoLocationModel.fromFirestore(json['Geolocation'] ?? []),
      landmark: json['landmark'] ?? '',
      location: json['location'] ?? '',
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  static List<ServiceBooking> _parseServices(dynamic servicesData) {
    if (servicesData is List && servicesData.isNotEmpty) {
      var serviceNames = servicesData[0]['service_names'] as List?;
      if (serviceNames != null) {
        return serviceNames.map((s) => ServiceBooking.fromJson(s)).toList();
      }
    }
    return [];
  }

  static int _parseInteger(dynamic value, int defaultValue) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static double _parseDouble(dynamic value, double defaultValue) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'booking_date': bookingDate,
      'booking_id': booking_id,
      'booking_time': bookingTime,
      'employee_ids': employee_ids,
      'shift_names': shift_names,
      'end_image': endImage,
      'payment_status': payment_status,
      'products': products.map((p) => p.toJson()).toList(),
      'services': [
        {'service_names': services.map((s) => s.toJson()).toList()}
      ],
      'start_image': start_image,
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
    };
  }
}

class ServiceBooking {
  final int quantity;
  final String service_name;
  final String service_name_arabic; // Added Arabic service name
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
      quantity: BookingModel._parseInteger(json['quantity'], 0),
      service_name: json['service_name'] ?? '',
      service_name_arabic: json['service_name_arabic'] ?? '',
      size: BookingModel._parseInteger(json['size'], 0),
      price: BookingModel._parseDouble(json['price'], 0.0),
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
  final String product_name_arabic; // Added Arabic product name
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
      product_name: json['product_name'] ?? '',
      product_name_arabic: json['product_name_arabic'] ?? '',
      quantity: BookingModel._parseInteger(json['quantity'], 0),
      delivery_time: json['delivery_time'] ?? '',
      price: BookingModel._parseDouble(json['price'], 0.0),
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': product_name,
      'product_name_arabic': product_name_arabic,
      'quantity': quantity,
      'delivery_time': delivery_time,
      'price': price,
      'image_url': imageUrl
    };
  }
}
