import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/user/screens/user_product_detail_page.dart';

import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Get.to(() => UserProductDetailPage(product: product));
          },
          child: Container(
            width: 150,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Image.network(
                          height: 80,
                          fit: BoxFit.fitHeight,
                          product.imageUrl,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
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
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  product.name,
                                  style: TextStyle(
                                      color: CustomColors.textColorTwo,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w200),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1, // Ensure truncation
                                ),
                              ),
                              //   const Spacer(),

                              const Image(
                                image: AssetImage("assets/images/star.png"),
                              ),
                              Text(
                                product.rating.toString(),
                                style: TextStyle(
                                    color: CustomColors.textColorTwo,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "\$${product.currentPrice.toString()}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1, // Ensure truncation here as well
                            ),
                            const Spacer()
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                // Positioned(
                //   top: 8,
                //   right: 8,
                //   child: Container(
                //     width: 30,
                //     height: 30,
                //     padding: EdgeInsets.all(0),
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(50),
                //     ),
                //     child: Icon(Icons.favorite_border, size: 20),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
