import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
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

    ever(user, (User? currentUser) async {
      if (currentUser != null) {
        // Check if the user exists in users_table
        bool userexists = await userExists(currentUser.email!);
        if (userexists) {
          // Navigate to UserMain if the user is a regular user
          Get.offAll(() => const UserMain());
        } else {
          // Check if the user exists in staff_table
          bool staffexists = await staffExists(currentUser.email!);
          if (staffexists) {
            // Navigate to EmployeeHome if the user is staff
            Get.offAll(() => const EmployeeHome());
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
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields', true);
      return;
    }

    isLoading.value = true; // Show loader

    // Check for the user in the users_table
    bool existsuser = await userExists(email);
    if (existsuser) {
      // If user exists, attempt to sign in
      try {
        UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // User signed in successfully
        // Navigate to the user main page
        // Save user details to local storage
        await saveUserDetailsLocally(email);
        isLoading.value = false; // Hide loader
        _showSnackBar('Logged in successfully', false);

        Get.offAll(() => const UserMain());
      } on FirebaseAuthException catch (e) {
        isLoading.value = false; // Hide loader
        String message = _getFirebaseErrorMessage(e.code);
        _showSnackBar(message, true);
      }
    } else {
      // Check for the staff in the staff_table
      bool existsstaff = await staffExists(email);
      if (existsstaff) {
        // If staff exists, attempt to sign in
        try {
          UserCredential result = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          if (result.user != null) {
            // Staff signed in successfully
            // Navigate to the employee home page
            isLoading.value = false; // Hide loader
            Get.offAll(() => const EmployeeHome());
            _showSnackBar('Logged in as staff successfully', false);
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

  // Future<void> initiateGoogleSignIn() async {
  //   try {
  //     isLoading.value = true; // Show loader

  //     // Trigger Google Sign-In
  //     final GoogleSignInAccount? googleSignInAccount =
  //         await GoogleSignIn().signIn();
  //     if (googleSignInAccount == null) {
  //       isLoading.value = false; // Hide loader
  //       _showSnackBar('Google Sign-In was canceled.', true);
  //       return;
  //     }

  //     final String googleEmail = googleSignInAccount.email;

  //     // Check if the email exists in the Firestore user table
  //     bool userExists = await this.userExists(googleEmail);
  //     if (userExists) {
  //       // If user exists, perform the Google authentication
  //       await _signInWithGoogleAuth(googleSignInAccount);
  //     } else {
  //       // Check if the email exists in the staff table
  //       bool staffExists = await this.staffExists(googleEmail);
  //       if (staffExists) {
  //         // If staff exists, perform the Google authentication
  //         await _signInWithGoogleAuth(googleSignInAccount);
  //       } else {
  //         // If user does not exist in both tables, navigate to Create Profile Page
  //         isLoading.value = false; // Hide loader
  //         Get.to(() => CreateProfilePage(
  //             account: googleSignInAccount // Pass only the email
  //             ));
  //       }
  //     }
  //   } catch (e) {
  //     isLoading.value = false; // Hide loader
  //     _showSnackBar('Google Sign-In failed. Please try again.', true);
  //   }
  // }

  // Future<void> _signInWithGoogleAuth(
  //     GoogleSignInAccount googleSignInAccount) async {
  //   try {
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       idToken: googleSignInAuthentication.idToken,
  //       accessToken: googleSignInAuthentication.accessToken,
  //     );

  //     // Authenticate with Firebase using Google credentials
  //     UserCredential result =
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //     User? userDetails = result.user;

  //     if (userDetails != null) {
  //       final String email = userDetails.email!;

  //       // Check if user exists in users_table
  //       bool userexists = await userExists(email);
  //       if (userexists) {
  //         // User exists in users_table
  //         DocumentSnapshot userDoc = await _firestore
  //             .collection('users_table')
  //             .where('email', isEqualTo: email)
  //             .get()
  //             .then((snapshot) => snapshot.docs.first);

  //         Map<String, dynamic> userData =
  //             userDoc.data() as Map<String, dynamic>;
  //         await _saveUserData(userData); // Save user data
  //         Get.offAll(() => const UserMain()); // Navigate to User Main Page
  //         _showSnackBar('Logged in successfully', false);
  //       } else {
  //         // Check if user exists in staff_table
  //         bool staffexists = await staffExists(email);
  //         if (staffexists) {
  //           // Staff exists in staff_table
  //           DocumentSnapshot staffDoc = await _firestore
  //               .collection('staff_table')
  //               .where('email', isEqualTo: email)
  //               .get()
  //               .then((snapshot) => snapshot.docs.first);

  //           Map<String, dynamic> staffData =
  //               staffDoc.data() as Map<String, dynamic>;
  //           // You can save staff-specific data if needed
  //           Get.offAll(
  //               () => const EmployeeHome()); // Navigate to Employee Home Page
  //           _showSnackBar('Logged in as staff successfully', false);
  //         } else {
  //           // If user does not exist in either table, navigate to Create Profile Page
  //           Get.to(() => CreateProfilePage(
  //                 account: googleSignInAccount, // Pass only the email
  //               ));
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     isLoading.value = false; // Hide loader
  //     _showSnackBar('Authentication failed. Please try again.', true);
  //   }
  // }

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
      Get.offAll(() => AuthScreen());

      _showSnackBar('Logged out successfully', false);
    } catch (e) {
      _showSnackBar('Failed to log out. Please try again.', true);
    }
  }

  // In your AuthProvider class
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
          password: user.password, // Assuming UserModel has a password field
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

      // Prepare data for saving
      Map<String, dynamic> data = user.toMap();
      print("Debug line:$data"); // Debugging line

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
