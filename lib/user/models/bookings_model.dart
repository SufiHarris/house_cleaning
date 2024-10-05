class BookingModel {
  final String address;
  final String bookingDate;
  final int booking_id;
  final String bookingTime;
  final int employee_id;
  final String endImage;
  final String payment_status;
  final List<ProductBooking> products;
  final List<ServiceBooking> services;
  final String start_image;
  final String status;
  final int total_price;
  final int user_id;
  final int user_phn_number;

  BookingModel({
    required this.address,
    required this.bookingDate,
    required this.booking_id,
    required this.bookingTime,
    required this.employee_id,
    required this.endImage,
    required this.payment_status,
    required this.products,
    required this.services,
    required this.start_image,
    required this.status,
    required this.total_price,
    required this.user_id,
    required this.user_phn_number,
  });

  factory BookingModel.fromFirestore(Map<String, dynamic> json) {
    return BookingModel(
      address: json['address'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      booking_id: _parseInteger(json['booking__id'], 0),
      bookingTime: json['booking_time'] ?? '',
      employee_id: _parseInteger(json['employee__id'], 0),
      endImage: json['end_image'] ?? '',
      payment_status: json['payment_status'] ?? '',
      products: (json['products'] as List<dynamic>?)
              ?.map((p) => ProductBooking.fromJson(p))
              .toList() ??
          [],
      services: _parseServices(json['services']),
      start_image: json['start_image'] ?? '',
      status: json['status'] ?? '',
      total_price: _parseInteger(json['total_price'], 0),
      user_id: _parseInteger(json['user__id'], 0),
      user_phn_number: _parseInteger(json['user_phn_number'], 0),
    );
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

  // Helper method to parse integers
  static int _parseInteger(dynamic value, int defaultValue) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }
}

class ServiceBooking {
  final int quantity;
  final String service_name;
  final int size;

  ServiceBooking({
    required this.quantity,
    required this.service_name,
    required this.size,
  });

  factory ServiceBooking.fromJson(Map<String, dynamic> json) {
    return ServiceBooking(
      quantity: BookingModel._parseInteger(json['quantity'], 0),
      service_name: json['service_name'] ?? '',
      size: BookingModel._parseInteger(json['size'], 0),
    );
  }
}

class ProductBooking {
  final String product_name;
  final int quantity;
  final String delivery_time;

  ProductBooking({
    required this.product_name,
    required this.quantity,
    required this.delivery_time,
  });

  factory ProductBooking.fromJson(Map<String, dynamic> json) {
    return ProductBooking(
      product_name: json['product_name'] ?? '',
      quantity: BookingModel._parseInteger(json['quantity'], 0),
      delivery_time: json['delivery_time'] ?? '',
    );
  }
}
