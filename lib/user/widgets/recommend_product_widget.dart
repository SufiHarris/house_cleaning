import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/user/screens/user_product_detail_page.dart';
import '../models/product_model.dart';

class RecommendProduct extends StatelessWidget {
  final UserProductModel product;
  final bool isSelected;
  final VoidCallback onToggle;
  const RecommendProduct({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: GestureDetector(
        onTap: () {
          Get.to(() => UserProductDetailPage(product: product));
        },
        child: Container(
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Image.network(
                        product.imageUrl,
                        height: 80,
                        fit: BoxFit.fitHeight,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
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
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const SizedBox(
                            height: 80,
                            width: 110,
                            child: Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            product.name,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: CustomColors.textColorTwo),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Image(
                          width: 16,
                          height: 16,
                          image: AssetImage("assets/images/star.png"),
                        ),
                        Text(
                          product.price.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: CustomColors.textColorTwo),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "\$${product.price.toString()}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => onToggle(),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        side: BorderSide(color: Colors.grey.shade300),
                        backgroundColor:
                            isSelected ? Colors.green : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        isSelected ? "Added" : "+ Add",
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
