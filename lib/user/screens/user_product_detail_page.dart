import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:house_cleaning/user/models/product_model.dart';
import '../../theme/custom_colors.dart';

class UserProductDetailPage extends StatefulWidget {
  final Product product;

  const UserProductDetailPage({super.key, required this.product});

  @override
  State<UserProductDetailPage> createState() => _UserProductDetailPageState();
}

class _UserProductDetailPageState extends State<UserProductDetailPage> {
  final List<String> feature = [
    "Feature 1",
    "Feature 2",
    "Feature 3",
    "Feature 4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Top Image Section
              Stack(
                children: [
                  Container(
                    height: 250, // Fixed height for the image
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.product.imageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "assets/images/chevron_left.svg",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: 40,
                  //   right: 16,
                  //   child: IconButton(
                  //     icon: const Icon(Icons.person, color: Colors.white),
                  //     onPressed: () {
                  //       // Handle user profile action
                  //     },
                  //   ),
                  // ),
                ],
              ),

              // Scrollable Details Section
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          widget.product.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  color: CustomColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -1,
                                  height: 1),
                          // style: TextStyle(
                          //   fontSize: 20,
                          //   color: CustomColors.primaryColor,
                          //   fontWeight: FontWeight.w500,
                          //   letterSpacing: -1,
                          //   height: 1,
                          // ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "UltraVac 3000: Powerful, lightweight vacuum cleaner with advanced HEPA filtration. Perfect for all floor types and hard-to-reach areas. Keep your home spotless effortlessly!",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: CustomColors.textColorFour,
                                  letterSpacing: 0.5,
                                  height: 1.5),
                          // style: TextStyle(
                          //   fontSize: 16,
                          //   color: CustomColors.textColorFour,
                          //   fontWeight: FontWeight.w300,
                          //   letterSpacing: -1,
                          //   height: 1.3,
                          // ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          "What's Included?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: CustomColors.textColorTwo,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: feature
                              .map((feature) => Text(
                                    '• $feature',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: CustomColors.textColorFour,
                                            letterSpacing: 0.5,
                                            height: 1.5),
                                    // style: TextStyle(
                                    //   color: CustomColors.textColorOne,
                                    //   fontSize: 16,
                                    //   fontWeight: FontWeight.w200,
                                    // ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Customer Ratings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: CustomColors.textColorTwo,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (index) => Icon(
                                index < widget.product.rating.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: CustomColors.primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${widget.product.rating} out of 5'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Bottom Fixed Section
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: CustomColors.primaryColor, width: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.product.rating}% Off",
                        style: TextStyle(
                          color: CustomColors.textColorFour,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Add to cart functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Add to cart',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}