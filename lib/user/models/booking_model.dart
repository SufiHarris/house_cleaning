class Booking {
  final String id;
  final String serviceDate;
  final String location;
  final double price;
  final String status; // "Pending", "Completed", "Cancelled"

  Booking({
    required this.id,
    required this.serviceDate,
    required this.location,
    required this.price,
    required this.status,
  });
}

List<Booking> generateSampleBookings() {
  return [
    Booking(
      id: '#358',
      serviceDate: 'Tue 04-12:30 PM',
      location: 'Granada Area, North Ring Road, exit 08, Riyadh, Saudi Arabia',
      price: 0,
      status: 'Pending',
    ),
    Booking(
      id: '#359',
      serviceDate: 'Tue 05-1:00 PM',
      location: 'King Fahad Road, exit 5, Riyadh, Saudi Arabia',
      price: 0,
      status: 'Pending',
    ),
    Booking(
      id: '#360',
      serviceDate: 'Wed 06-2:00 PM',
      location: 'Olaya Street, Riyadh, Saudi Arabia',
      price: 0,
      status: 'Completed',
    ),
    Booking(
      id: '#361',
      serviceDate: 'Thu 07-3:30 PM',
      location: 'Riyadh Gallery, King Fahad Road, Riyadh',
      price: 0,
      status: 'Completed',
    ),
    Booking(
      id: '#362',
      serviceDate: 'Fri 08-4:00 PM',
      location: 'Granada Mall, North Ring Road, Riyadh',
      price: 0,
      status: 'Cancelled',
    ),
    Booking(
      id: '#363',
      serviceDate: 'Sat 09-5:00 PM',
      location: 'King Khalid Airport, Riyadh',
      price: 0,
      status: 'Cancelled',
    ),
  ];
}
