import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/screens/segregation_screen.dart';
import 'package:house_cleaning/employee/screens/employee_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../user/screens/user_main.dart';
import '../../user/screens/user_create_profile_screen.dart';
import '../screens/auth_screen.dart';

class AuthProvider extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Staff login email and password
  TextEditingController staffEmailController = TextEditingController();
  TextEditingController staffPasswordController = TextEditingController();
  Rx<User?> user = Rx<User?>(null);
  RxBool isLoading = false.obs;

  String? get user_id => null; // Loader variable

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());

    ever(user, (User? currentUser) {
      if (currentUser != null) {
        // When user state changes, check if logged-in user is available
        Get.offAll(() => const UserMain());
      }
    });
  }

  Future<bool> staffExists(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('staff_table')
          .where('email', isEqualTo: email)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking staff existence: $e');
      return false;
    }
  }

// Staff sign-in function
  Future<void> staffSignIn() async {
    String email = staffEmailController.text.trim();
    String password = staffPasswordController.text.trim();

    // Check for empty fields
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields', true);
      return;
    }

    isLoading.value = true; // Show loader

    // Check if staff exists in the staff_table
    bool exists = await staffExists(email);
    if (!exists) {
      isLoading.value = false; // Hide loader
      _showSnackBar('Staff user does not exist.', true);
      return;
    }

    // Sign in with Firebase Authentication
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? userDetails = result.user;

      // Check if userDetails is not null
      if (userDetails != null) {
        // Fetch staff data from Firestore
        DocumentSnapshot staffDoc = await _firestore
            .collection('staff_table')
            .doc(userDetails.uid)
            .get();

        // If the staff document exists
        if (staffDoc.exists) {
          Map<String, dynamic> staffData =
              staffDoc.data() as Map<String, dynamic>;

          // Save staff-specific data
          //  await _saveStaffData(staffData);

          isLoading.value = false; // Hide loader
          Get.offAll(() => const EmployeeHome()); // Redirect to staff home
          _showSnackBar('Logged in successfully', false);
        }
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false; // Hide loader
      String message = _getFirebaseErrorMessage(e.code);
      _showSnackBar(message, true);
    }
  }

  Future<bool> userExists(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users_table')
          .where('email', isEqualTo: email)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  Future<void> signIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields', true);
      return;
    }

    isLoading.value = true; // Show loader

    bool exists = await userExists(emailController.text.trim());
    if (!exists) {
      isLoading.value = false; // Hide loader
      _showSnackBar('User does not exist. Please sign up.', true);
      return;
    }

    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? userDetails = result.user;
      print("hiii am here 3");
      print("hiii am here 3");

      if (userDetails != null) {
        print("hiii am here 2");

        print("hiii am here 2");

        DocumentSnapshot userDoc = await _firestore
            .collection('users_table')
            .doc(userDetails.uid)
            .get();

        if (userDoc.exists) {
          print("hiii am here");
          print("hiii am here");
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          await _saveUserData(userData);
          isLoading.value = false; // Hide loader
          Get.offAll(() => const UserMain());
          print("but not here");

          print("but not here");

          _showSnackBar('Logged in successfully', false);
        } else {
          // User does not exist in Firestore, redirect to CreateProfilePage
          isLoading.value = false; // Hide loader
          Get.to(() => CreateProfilePage(
                // name: userDetails.displayName ?? '',
                // email: userDetails.email ?? '',
                email: 'email',
                password: 'password',
                // Pass any other required data here
              ));
        }
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false; // Hide loader
      String message = _getFirebaseErrorMessage(e.code);
      _showSnackBar(message, true);
    }
  }

  Future<void> initiateGoogleSignIn() async {
    try {
      isLoading.value = true; // Show loader

      // Trigger Google Sign-In, but don't authenticate with Firebase yet
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount == null) {
        // Handle case when Google sign-in is canceled
        isLoading.value = false; // Hide loader
        _showSnackBar('Google Sign-In was canceled.', true);
        return;
      }

      final String googleEmail = googleSignInAccount.email;

      // Check if the email exists in the Firestore user table
      bool exists = await userExists(googleEmail);

      if (exists) {
        // If user exists, now perform the Google authentication
        await _signInWithGoogleAuth(googleSignInAccount);
      } else {
        // If user does not exist, redirect to the create profile page
        isLoading.value = false; // Hide loader
        print(googleSignInAccount);
        // Get.to(() => CreateProfilePage(
        //     // name: googleSignInAccount.displayName ?? '',
        //     // email: googleEmail,
        //     // googleSignInAccount:
        //     //     googleSignInAccount, // Pass Google Sign-In data
        //     ));
      }
    } catch (e) {
      isLoading.value = false; // Hide loader
      _showSnackBar('Google Sign-In failed. Please try again.', true);
    }
  }

// Perform the actual Google authentication after profile creation
  Future<void> _signInWithGoogleAuth(
      GoogleSignInAccount googleSignInAccount) async {
    try {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      // Authenticate with Firebase using Google credentials
      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? userDetails = result.user;

      if (userDetails != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users_table')
            .doc(userDetails.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          await _saveUserData(userData);
          Get.offAll(() => const UserMain());
          _showSnackBar('Logged in successfully', false);
        }
      }
    } catch (e) {
      isLoading.value = false;
      _showSnackBar('Authentication failed. Please try again.', true);
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', userData['email'] ?? '');
      await prefs.setString('user_name', userData['name'] ?? '');
      await prefs.setString('user_imgUrl', userData['imgUrl'] ?? '');
      await prefs.setString(
          'user_id', userData['user_id'] ?? 0); // Ensure this is an int
      await prefs.setString('phone', userData['phone'] ?? '');
      await prefs.setString('address', userData['address'] ?? '');

      print("User data saved: ${userData}");
    } catch (e) {
      print(e);
      print("Error occurred while saving");
    }
  }

  void _showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      user.value = null;
      Get.offAll(() => SegerationScreen());

      _showSnackBar('Logged out successfully', false);
    } catch (e) {
      _showSnackBar('Failed to log out. Please try again.', true);
    }
  }

  Future<void> saveUserProfile({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    String? tempUid;

    try {
      // Generate temporary user ID
      tempUid = FirebaseFirestore.instance.collection('users_table').doc().id;

      // Save user data without the password
      await FirebaseFirestore.instance
          .collection('users_table')
          .doc(tempUid)
          .set({
        'name': name,
        'email': email,
        'phone': phone,
        'image': "",
        'password': password,
        'user_id': 2, // Temporary ID until registration completes
      });

      // Create user in Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw FirebaseAuthException(
            code: 'user-null', message: 'User creation failed');
      } else {
        Get.snackbar("Success", "Profile created and registered successfully!");
        Future.delayed(Duration(seconds: 2), () {
          Get.offAll(() => UserMain());
        });
      }

      // Update the user_id with the Firebase Authentication UID
      // String uid = userCredential.user!.uid;
      // await FirebaseFirestore.instance
      //     .collection('users_table')
      //     .doc(tempUid)
      //     .update({
      //   'user_id': uid,
      // });
    } on FirebaseAuthException catch (e) {
      // Remove temporary document in case of failure
      if (tempUid != null) {
        await FirebaseFirestore.instance
            .collection('users_table')
            .doc(tempUid)
            .delete();
      }

      // Handle specific FirebaseAuthException cases
      if (e.code == 'email-already-in-use') {
        Get.snackbar("Error", "The email address is already in use.");
      } else if (e.code == 'weak-password') {
        Get.snackbar("Error", "The password provided is too weak.");
      } else {
        Get.snackbar(
            "Error", e.message ?? "An error occurred during authentication");
      }
    } on FirebaseException catch (e) {
      // Handle Firestore exceptions
      Get.snackbar("Error", "Failed to save data to Firestore: ${e.message}");
    } catch (e) {
      // Catch any other unexpected errors
      Get.snackbar("Error", "An unexpected error occurred: ${e.toString()}");
    }
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
