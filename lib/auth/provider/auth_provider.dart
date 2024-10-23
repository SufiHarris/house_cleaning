import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/screeens/admin_home.dart';
import 'package:house_cleaning/auth/model/staff_model.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
import 'package:house_cleaning/employee/screens/employee_home.dart';
import 'package:house_cleaning/user/providers/user_provider.dart';
import 'package:house_cleaning/user/screens/confirm_order_screen.dart';
import 'package:house_cleaning/user/screens/user_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../admin/screeens/admin_main.dart';
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

    ever(user, (User? currentUser) async {
      if (currentUser != null) {
        // Check if the user exists in users_table
        bool userexists = await userExists(currentUser.email!);
        if (userexists) {
          // Navigate to UserMain if the user is a regular user
          Get.offAll(() => const UserMain());
        } else {
          // Check if the user exists in staff_table using email
          bool staffexists = await staffExists(currentUser.email!);
          if (staffexists) {
            // Fetch staff data from Firestore using email
            QuerySnapshot staffSnapshot = await _firestore
                .collection('staff_table')
                .where('email', isEqualTo: currentUser.email) // Query by email
                .get();

            if (staffSnapshot.docs.isNotEmpty) {
              // Get the first document (since email is unique)
              DocumentSnapshot staffDoc = staffSnapshot.docs.first;

              Map<String, dynamic> staffData =
                  staffDoc.data() as Map<String, dynamic>;

              // Check the role of the staff member
              String role =
                  staffData['role']; // Assuming 'role' is a field in Firestore

              // Navigate based on role
              if (role == 'admin') {
                Get.offAll(() => AdminMain()); // Navigate to Admin Page
                _showSnackBar('Logged in as Admin', false);
              } else if (role == 'staff') {
                Get.offAll(
                    () => const EmployeeHome()); // Navigate to Employee Home
              } else {
                _showSnackBar(
                    'Role not recognized.', true); // Handle unrecognized roles
              }
            }
          } else {
            // Handle case when the user is not found in either table
            Get.offAll(() => AuthScreen());
          }
        }
      }
    });
  }

  Future<bool> staffExists(String email) async {
    final QuerySnapshot result = await _firestore
        .collection('staff_table')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty; // Return true if staff exists
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
    final QuerySnapshot result = await _firestore
        .collection('users_table')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty; // Return true if user exists
  }

  Future<void> signIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Check for empty fields
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields', true);
      return;
    }

    isLoading.value = true; // Show loader

    // Check if the email exists in the users_table
    bool existsUser = await userExists(email);
    if (existsUser) {
      // If the user exists, try to sign in
      try {
        UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // User signed in successfully
        // Save user details locally
        await saveUserDetailsLocally(email);
        isLoading.value = false; // Hide loader
        _showSnackBar('Logged in successfully', false);

        // Navigate to the UserMain page
        Get.offAll(() => const UserMain());
      } on FirebaseAuthException catch (e) {
        isLoading.value = false; // Hide loader
        String message = _getFirebaseErrorMessage(e.code);
        _showSnackBar(message, true);
      }
    } else {
      // Check if the email exists in the staff_table
      bool existsStaff = await staffExists(email);
      if (existsStaff) {
        // If the staff exists, try to sign in
        try {
          UserCredential result = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          if (result.user != null) {
            // Fetch staff data from Firestore using email (not UID)
            QuerySnapshot staffSnapshot = await _firestore
                .collection('staff_table')
                .where('email', isEqualTo: email) // Query by email
                .get();

            if (staffSnapshot.docs.isNotEmpty) {
              // Get the first document (since email is unique)
              DocumentSnapshot staffDoc = staffSnapshot.docs.first;

              Map<String, dynamic> staffData =
                  staffDoc.data() as Map<String, dynamic>;

              // Check the role of the staff member
              String role =
                  staffData['role']; // Assuming 'role' is stored in Firestore

              // Save staff details locally (if needed)
              await saveStaffDetailsLocally(email);

              isLoading.value = false; // Hide loader

              // Navigate based on the role
              if (role == 'admin') {
                Get.offAll(
                  () => AdminMain(),
                ); // Navigate to Admin Page
                _showSnackBar('Logged in as Admin', false);
              } else if (role == 'staff') {
                Get.offAll(
                    () => const EmployeeHome()); // Navigate to Employee Home
                _showSnackBar('Logged in as Staff', false);
              } else {
                _showSnackBar(
                    'Role not recognized.', true); // Handle unrecognized roles
              }
            }
          }
        } on FirebaseAuthException catch (e) {
          isLoading.value = false; // Hide loader
          String message = _getFirebaseErrorMessage(e.code);
          _showSnackBar(message, true);
        }
      } else {
        // If neither user nor staff found
        isLoading.value = false; // Hide loader
        _showSnackBar('User not found in both tables.', true);
      }
    }
  }

  Future<void> initiateGoogleSignIn() async {
    try {
      isLoading.value = true; // Show loader

      // Trigger Google Sign-In
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount == null) {
        isLoading.value = false; // Hide loader
        _showSnackBar('Google Sign-In was canceled.', true);
        return;
      }

      final String googleEmail = googleSignInAccount.email;

      // Check if the email exists in either the users_table or staff_table
      bool userExistsInUsers = await userExists(googleEmail);
      bool userExistsInStaff = await staffExists(googleEmail);

      if (userExistsInUsers || userExistsInStaff) {
        // If the user exists in either table, perform the Google authentication
        await _signInWithGoogleAuth(googleSignInAccount, googleEmail);
      } else {
        // If user does not exist in both tables, navigate to Create Profile Page
        isLoading.value = false; // Hide loader
        Get.to(
            () => CreateProfilePage(email: googleEmail, password: googleEmail));
      }
    } catch (e) {
      isLoading.value = false; // Hide loader
      print("Error Google $e");
      _showSnackBar('Google Sign-In failed. Please try again.', true);
    }
  }

  Future<void> _signInWithGoogleAuth(
      GoogleSignInAccount googleSignInAccount, String email) async {
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
        // Check if user exists in users_table
        if (await userExists(email)) {
          await saveUserDetailsLocally(email);

          Get.offAll(() => const UserMain()); // Navigate to User Main Page
          _showSnackBar('Logged in successfully', false);
        } else if (await staffExists(email)) {
          // Fetch staff data from Firestore using email
          QuerySnapshot staffSnapshot = await _firestore
              .collection('staff_table')
              .where('email', isEqualTo: email)
              .get();

          if (staffSnapshot.docs.isNotEmpty) {
            // Get the first document (since email is unique)
            DocumentSnapshot staffDoc = staffSnapshot.docs.first;

            Map<String, dynamic> staffData =
                staffDoc.data() as Map<String, dynamic>;

            // Check the role of the staff member
            String role =
                staffData['role']; // Assuming 'role' is stored in Firestore

            // Navigate based on the role
            if (role == 'admin') {
              // Save staff details locally (if needed)
              await saveStaffDetailsLocally(email);
              Get.offAll(() => AdminMain()); // Navigate to Admin Page
              _showSnackBar('Logged in as Admin', false);
            } else if (role == 'staff') {
              // Save staff details locally (if needed)
              await saveStaffDetailsLocally(email);
              Get.offAll(
                  () => const EmployeeHome()); // Navigate to Employee Home
              _showSnackBar('Logged in as Staff', false);
            } else {
              _showSnackBar('Role not recognized.', true);
            }
          }
        }
      }
    } catch (e) {
      isLoading.value = false; // Hide loader
      _showSnackBar('Authentication failed. Please try again.', true);
    }
  }

  // Facebook Login with Firebase
  Future<void> signInWithFacebook() async {
    try {
      isLoading.value = true; // Show loader

      // Trigger Facebook login
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        // Get the Facebook access token
        final AccessToken accessToken = loginResult.accessToken!;

        // Create a credential using the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.token);

        // Sign in to Firebase with Facebook credentials
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        // Get the email from the Facebook account
        final String facebookEmail = userCredential.user?.email ?? '';

        // Check if the user exists in the users_table
        bool userExistsInUsers = await userExists(facebookEmail);
        bool userExistsInStaff = await staffExists(facebookEmail);

        // If user exists in either users or staff table
        if (userExistsInUsers || userExistsInStaff) {
          // Sign in the user based on their role (user, staff, or admin)
          await _handleFacebookAuth(userCredential.user!, facebookEmail);
        } else {
          // If user does not exist in both tables, navigate to Create Profile Page
          isLoading.value = false; // Hide loader
          Get.to(() =>
              CreateProfilePage(email: facebookEmail, password: facebookEmail));
        }
      } else {
        isLoading.value = false; // Hide loader
        _showSnackBar('Facebook Sign-In was canceled.', true);
      }
    } catch (e) {
      isLoading.value = false; // Hide loader
      print("Error Facebook $e");
      _showSnackBar('Facebook Sign-In failed. Please try again.', true);
    }
  }

  Future<void> _handleFacebookAuth(User userDetails, String email) async {
    try {
      // Check if the user exists in users_table
      if (await userExists(email)) {
        // Save user details locally and navigate to UserMain
        await saveUserDetailsLocally(email);
        Get.offAll(() => const UserMain()); // Navigate to User Main Page
        _showSnackBar('Logged in successfully', false);
      } else if (await staffExists(email)) {
        // Fetch staff data from Firestore using email
        QuerySnapshot staffSnapshot = await _firestore
            .collection('staff_table')
            .where('email', isEqualTo: email)
            .get();

        if (staffSnapshot.docs.isNotEmpty) {
          // Get the first document (since email is unique)
          DocumentSnapshot staffDoc = staffSnapshot.docs.first;

          Map<String, dynamic> staffData =
              staffDoc.data() as Map<String, dynamic>;

          // Check the role of the staff member
          String role =
              staffData['role']; // Assuming 'role' is stored in Firestore

          // Save staff details locally (if needed)
          await saveStaffDetailsLocally(email);

          // Navigate based on the role
          if (role == 'admin') {
            Get.offAll(() => AdminMain()); // Navigate to Admin Page
            _showSnackBar('Logged in as Admin', false);
          } else if (role == 'staff') {
            Get.offAll(() => const EmployeeHome()); // Navigate to Employee Home
            _showSnackBar('Logged in as Staff', false);
          } else {
            _showSnackBar('Role not recognized.', true);
          }
        }
      }
    } catch (e) {
      isLoading.value = false; // Hide loader
      _showSnackBar('Authentication failed. Please try again.', true);
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
      Get.offAll(() => AuthScreen());

      _showSnackBar('Logged out successfully', false);
    } catch (e) {
      _showSnackBar('Failed to log out. Please try again.', true);
    }
  }

  Future<void> saveUserProfile(UserModel user) async {
    try {
      UserCredential userCredential;
      try {
        print("User details before creating account: ${user.toMap()}");

        print(
            "Creating user with email: ${user.email} and password: ${user.password}");

        // Create the user in Firebase Authentication
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );
      } catch (e) {
        print("Error creating user: $e");
        Get.snackbar("Error", "Failed to create user. ${e.toString()}",
            snackPosition: SnackPosition.BOTTOM);
        return; // Exit the function if user creation fails
      }

      // Get the user ID from the userCredential
      String userId = userCredential.user!.uid;

      CollectionReference users =
          FirebaseFirestore.instance.collection('users_table');

      // Prepare data for saving, including userId
      Map<String, dynamic> data = user.toMap();
      data['user_id'] = userId; // Set user_id here
      print("Debug line:$data"); // Debugging line

      // Update SharedPreferences with the new user details
      await _updateUserDetailsInPrefs(userId, user);
      print("Updated User");

      // Set document ID based on the user's email (or any unique identifier)
      await users.doc(userId).set(data, SetOptions(merge: true));

      // Show success snackbar
      Get.snackbar("Success", "User profile saved successfully.",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print("Error saving user profile: $e");
      // Show error snackbar
      Get.snackbar("Error", "Failed to save user profile. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> saveUserProfileForGuest(
      UserModel user, bool isCartAction) async {
    try {
      UserCredential userCredential;
      try {
        print("User details before creating account: ${user.toMap()}");

        print(
            "Creating user with email: ${user.email} and password: ${user.password}");

        // Create the user in Firebase Authentication
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );
      } catch (e) {
        print("Error creating user: $e");
        Get.snackbar("Error", "Failed to create user. ${e.toString()}",
            snackPosition: SnackPosition.BOTTOM);
        return; // Exit the function if user creation fails
      }

      // Get the user ID from the userCredential
      String userId = userCredential.user!.uid;

      CollectionReference users =
          FirebaseFirestore.instance.collection('users_table');

      // Prepare data for saving, including userId
      Map<String, dynamic> data = user.toMap();
      data['user_id'] = userId; // Set user_id here
      print("Debug line:$data"); // Debugging line

      // Update SharedPreferences with the new user details
      await _updateUserDetailsInPrefs(userId, user);
      print("Updated User");

      // Set document ID based on the user's email (or any unique identifier)
      await users.doc(userId).set(data, SetOptions(merge: true));

      // After successfully saving the user profile, call addToCart from UserProvider
      UserProvider userProvider = Get.find<UserProvider>();
      // Call the appropriate method based on the flag
      if (isCartAction) {
        await userProvider.addToCart(); // Call addToCart
      } else {
        await userProvider
            .saveBookingToFirestore(); // Call saveBookingToFirestore
      }
      // Show success snackbar
      Get.snackbar("Success", "User profile saved successfully.",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print("Error saving user profile: $e");
      // Show error snackbar
      Get.snackbar("Error", "Failed to save user profile. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
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

// Method to update user details in SharedPreferences
  Future<void> _updateUserDetailsInPrefs(String userId, UserModel user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Prepare the user details to be saved
      String updatedUserJson = jsonEncode({
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'image': user.image,
        'password': user.password,
        'address': user.address?.map((addr) => addr.toMap()).toList() ?? [],
        'userId': userId, // Save the userId here
      });

      // Update the SharedPreferences
      await prefs.setString('userDetails', updatedUserJson);
      await prefs.setString('userDocId', userId);

      print("User details updated in SharedPreferences: $updatedUserJson");
    } catch (e) {
      print("Error updating SharedPreferences: $e");
      Get.snackbar(
          "Error", "Failed to update local user details. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
