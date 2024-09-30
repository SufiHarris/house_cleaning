import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/service_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserProvider extends GetxController {
  var categoryList =
      <CategoryModel>[].obs; // Assuming you have this for categories
  var products = <UserProductModel>[].obs;
  var services = <ServiceModel>[].obs;
  var isLoading = true.obs;

  var profileImage = Rx<File?>(null); // Observable for the profile image
  final ImagePicker _picker = ImagePicker();

  // Function to pick image from gallery
  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  // Function to pick image from camera
  Future<void> pickImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  Future<void> fetchServicesByCategory(String category) async {
    try {
      isLoading.value = true; // Start loading indicator
      var snapshot = await FirebaseFirestore.instance
          .collection('services_table')
          .where('category',
              isEqualTo: category) // Firestore query to filter by category
          .get();

      // Map the Firestore documents to ServiceModel and update the services list
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data()))
          .toList();
      print(services.value);
    } catch (e) {
      print("Error fetching services by category: $e");
    } finally {
      print("data fethced");
      isLoading.value = false; // Stop loading indicator
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
