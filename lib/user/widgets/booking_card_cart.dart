import 'package:flutter/material.dart';
import 'package:house_cleaning/user/models/bookings_model.dart';
import '../../theme/custom_colors.dart';

class BookingCardCart extends StatelessWidget {
  final BookingModel booking;
  const BookingCardCart({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://placeholder.com/100',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.services.isNotEmpty
                          ? booking.services.first.service_name
                          : booking.products.first.product_name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${booking.total_price} SAR',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: CustomColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (booking.services.isNotEmpty)
            _buildServiceGrid()
          else
            _buildProductCard(),
        ],
      ),
    );
  }

  Widget _buildServiceGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 1.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: booking.services.length,
      itemBuilder: (context, index) {
        final service = booking.services[index];
        return serviceCard(
          service.service_name,
          service.quantity,
          service.price,
          service.size,
        );
      },
    );
  }

  Widget _buildProductCard() {
    final product = booking.products.first;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product.product_name} x ${product.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Price: ${product.price} SAR',
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Delivery Time: ${product.delivery_time}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: CustomColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${product.quantity}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget serviceCard(String name, int quantity, double price, int size) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            maxLines: 1,
            '$name X $quantity',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              overflow: TextOverflow.clip,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '\$$price | $size Sq/ft',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
