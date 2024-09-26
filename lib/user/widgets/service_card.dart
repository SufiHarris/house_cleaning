import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/screens/user_service_detail_screen.dart';
import '../models/category_model.dart';
import '../screens/villa_services.dart';
import '../screens/vehicle_services.dart';

class ServiceCard extends StatelessWidget {
  final CategoryModel category;

  const ServiceCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: InkWell(
        onTap: () {
          switch (category.categoryType) {
            case 'Villa':
              Get.to(() => VillaServices(category: category));
              break;
            case 'Apartment':
              Get.to(() => UserServiceDetailPage(category: category));
              break;
            case 'Vehicle':
              Get.to(() => VehicleServices(category: category));
              break;
            case 'Facades':
              Get.to(() => VillaServices(category: category));
              break;
            case 'Furniture':
              Get.to(() => VillaServices(category: category));
              break;
            default:
              Get.snackbar(
                'Service not available',
                'No page for this category type.',
                snackPosition: SnackPosition.BOTTOM,
              );
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image widget
            Image.network(
              category.imageUrl,
              height: 40,
              fit: BoxFit.fill,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: Colors.red); // Image load error
              },
            ),
            const SizedBox(width: 10), // Add some spacing

            // Expanded to avoid text overflow
            Expanded(
              flex: 4, // Adjust flex as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.categoryName,
                    style: Theme.of(context).textTheme.labelLarge,
                    maxLines: 1, // Limit the text to one line
                    overflow:
                        TextOverflow.ellipsis, // Ellipsis if text overflows
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text("4.5",
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(
                          width: 5), // Reduced size for better fitting
                      Text("50 reviews",
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            // The arrow icon at the end
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
