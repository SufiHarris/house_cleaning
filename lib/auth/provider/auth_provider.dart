import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../user/screens/user_main.dart';
import '../../user/screens/user_create_profile_screen.dart';
import '../screens/auth_screen.dart';

class AuthProvider extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

      if (userDetails != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users_table')
            .doc(userDetails.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          await _saveUserData(userData);

          isLoading.value = false; // Hide loader
          Get.offAll(() => const UserMain());
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', userData['email'] ?? '');
    await prefs.setString('user_name', userData['name'] ?? '');
    await prefs.setString('user_imgUrl', userData['imgUrl'] ?? '');
    await prefs.setString('user_id', userData['id'] ?? '');
    await prefs.setString('phone', userData['phone'] ?? '');
    await prefs.setString('address', userData['address'] ?? '');
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
      Get.offAll(() => const AuthScreen());

      _showSnackBar('Logged out successfully', false);
    } catch (e) {
      _showSnackBar('Failed to log out. Please try again.', true);
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
