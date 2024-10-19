import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/screens/apartment_service_detail.dart';
import 'package:house_cleaning/user/screens/user_vehicle_cleaning_service_screen.dart';
import '../models/category_model.dart';
import '../providers/user_provider.dart';
import '../screens/call_service_screen.dart';

class ServiceCard extends StatelessWidget {
  final CategoryModel category;

  const ServiceCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    String currentLangCode = Get.locale?.languageCode ?? 'en';
    final userProvider = Get.find<UserProvider>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: InkWell(
        onTap: () {
          switch (category.categoryType) {
            case 'Villa':
              Get.to(() => CallServiceScreen(category: category));
              break;
            case 'Apartment':
              userProvider.fetchServicesByCategory(category.categoryType);
              Get.to(() => ApartmentServiceDetail(category: category));
              break;
            case 'Vehicle':
              userProvider.fetchServicesByCategory(category.categoryType);
              Get.to(
                  () => UserVehicleCleaningServiceScreen(category: category));
              break;
            case 'Facades':
            case 'Furniture':
              Get.to(() => CallServiceScreen(category: category));
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
                return Icon(Icons.error, color: Colors.red);
              },
            ),
            const SizedBox(width: 10),

            // Expanded to avoid text overflow
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.getLocalizedCategoryName(currentLangCode),
                    style: Theme.of(context).textTheme.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text("4.5",
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(width: 5),
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
