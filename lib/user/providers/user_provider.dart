import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/service_model.dart';

class UserProvider extends GetxController {
  var categoryList =
      <CategoryModel>[].obs; // Assuming you have this for categories
  var products = <UserProductModel>[].obs;
  var services = <ServiceModel>[].obs;
  var isLoading = true.obs;

  Future<void> fetchServices() async {
    try {
      isLoading.value = true; // Start loading
      var snapshot =
          await FirebaseFirestore.instance.collection('services_table').get();

      // Map the Firestore documents to ServiceModel and update the services list
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching services: $e");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      var snapshot =
          await FirebaseFirestore.instance.collection('product_table').get();
      products.value = snapshot.docs
          .map((doc) => UserProductModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      // Fetch data from Firestore
      final snapshot =
          await FirebaseFirestore.instance.collection('category_table').get();
      categoryList.value = snapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }
}






// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import '../models/category_model.dart'; // Import the model

// class UserProvider extends GetxController {
//   // Observable list to hold categories data
//   var categoryList = <CategoryModel>[].obs;

//   // Method to fetch category data from Firestore
//   Future<void> fetchCategories() async {
//     try {
//       // Reference to the Firestore collection
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection('category_table').get();

//       // Clear the existing list
//       categoryList.clear();

//       // Loop through the documents and add them to the categoryList
//       for (var doc in snapshot.docs) {
//         categoryList
//             .add(CategoryModel.fromJson(doc.data() as Map<String, dynamic>));
//       }
//     } catch (e) {
//       print("Error fetching categories: $e");
//     }

//   }
// }
