import '../../auth/model/usermodel.dart';

class CallBookingModel {
  final String address;
  final String bookingDate;
  final String booking_id;
  final String startTime;
  final String endTime;
  final List<String> employee_ids;
  final List<String> shift_names;
  final List<String> endImage;
  final String payment_status;
  final List<String> start_image;
  final String status;
  final double total_price;
  final String user_id; // Changed from int to String
  final String user_phn_number;
  final String categoryName;
  final String categoryNameArabic;
  final String categoryImage;
  final String timeTaken;
  final String travelingTime;

  // Address model fields
  final String building;
  final int floor;
  final GeoLocationModel geolocation;
  final String landmark;
  final String location;

  CallBookingModel({
    required this.address,
    required this.bookingDate,
    required this.booking_id,
    required this.startTime,
    required this.endTime,
    required this.employee_ids,
    required this.shift_names,
    required this.endImage,
    required this.payment_status,
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

  factory CallBookingModel.fromFirestore(Map<String, dynamic> json) {
    return CallBookingModel(
      address: json['address']?.toString() ?? '',
      bookingDate: json['booking_date']?.toString() ?? '',
      booking_id: json['booking_id']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      employee_ids: _parseStringList(json['employee_ids']),
      shift_names: _parseStringList(json['shift_names']),
      endImage: _parseStringList(json['end_image']),
      payment_status: json['payment_status']?.toString() ?? '',
      start_image: _parseStringList(json['start_image']),
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
      timeTaken: json['time_taken']?.toString() ?? '',
      travelingTime: json['traveling_time']?.toString() ?? '',
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value is String) return [value];
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
      'start_time': startTime,
      'end_time': endTime,
      'employee_ids': employee_ids,
      'shift_names': shift_names,
      'end_image': endImage,
      'payment_status': payment_status,
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
      'time_taken': timeTaken,
      'traveling_time': travelingTime,
    };
  }
}
