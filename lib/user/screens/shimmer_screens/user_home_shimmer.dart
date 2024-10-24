import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Shimmer for heading text
Widget buildShimmerHeadingText(String text) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: double.infinity,
      height: 30, // Adjust height to suit the heading size
      color: Colors.white,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24, // Adjust font size for the heading
            fontWeight: FontWeight.bold,
            color: Colors.grey[300], // The shimmer will overlay this
          ),
        ),
      ),
    ),
  );
}

// Shimmer for regular text
Widget buildShimmerText({double width = 100, double height = 20}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: width,
      height: height,
      color: Colors.white,
    ),
  );
}

// Shimmer for promotional banner
Widget buildShimmerBanner() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: double.infinity,
      height: 150,
      color: Colors.white,
    ),
  );
}

// Shimmer for service categories
Widget buildShimmerServiceList(int itemCount) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: itemCount,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.only(top: 10),
            height: 80,
            color: Colors.white,
          ),
        ),
      );
    },
  );
}

// Shimmer for product list
Widget buildShimmerProductList(int itemCount) {
  return SizedBox(
    height: 300,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 150,
              margin: EdgeInsets.only(top: 20),
              // color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    ),
  );
}
