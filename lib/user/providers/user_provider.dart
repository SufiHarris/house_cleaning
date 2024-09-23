import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/category_model.dart'; // Import the model

class UserProvider extends GetxController {
  // Observable list to hold categories data
  var categoryList = <CategoryModel>[].obs;

  // Method to fetch category data from Firestore
  Future<void> fetchCategories() async {
    try {
      // Reference to the Firestore collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('category_table').get();

      // Clear the existing list
      categoryList.clear();

      // Loop through the documents and add them to the categoryList
      for (var doc in snapshot.docs) {
        categoryList
            .add(CategoryModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }
}
