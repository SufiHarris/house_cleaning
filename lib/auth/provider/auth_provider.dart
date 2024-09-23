import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- Add this
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../user/screens/user_main.dart';
import '../screens/auth_screen.dart';

class AuthProvider extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
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
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields', true);
      return;
    }

    bool exists = await userExists(emailController.text.trim());
    if (!exists) {
      _showSnackBar('User does not exist. Please sign up.', true);
      return;
    }

    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
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

          Get.offAll(() => const UserMain());
          _showSnackBar('Logged in successfully', false);
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = _getFirebaseErrorMessage(e.code);
      _showSnackBar(message, true);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? userDetails = result.user;

      if (userDetails != null) {
        bool exists = await userExists(userDetails.email!);

        if (exists) {
          // User exists, fetch data and proceed to home screen
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
        } else {
          // User does not exist, navigate to additional info screen
          // Get.to(() => AdditionalInfoScreen(
          //       onSubmit: (String phone, String address) async {
          //         Map<String, dynamic> userInfoMap = {
          //           "email": userDetails.email,
          //           "name": userDetails.displayName,
          //           "imgUrl": userDetails.photoURL,
          //           "id": userDetails.uid,
          //           "phone": phone,
          //           "address": address,
          //         };

          //         // Save to Firestore
          //         await _firestore
          //             .collection('users_table')
          //             .doc(userDetails.uid)
          //             .set(userInfoMap);

          //         // Save locally
          //         await _saveUserData(userInfoMap);

          //         Get.offAll(() => const UserMain());
          //         _showSnackBar('New user registered successfully', false);
          //       },
          //     ));
        }
      }
    } catch (e) {
      _showSnackBar('Google Sign-In failed. Please try again.', true);
    }
  }

  // Save user data in SharedPreferences
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', userData['email']);
    await prefs.setString('user_name', userData['name']);
    await prefs.setString('user_imgUrl', userData['imgUrl']);
    await prefs.setString('user_id', userData['id']);
    await prefs.setString('phone', userData['phone']);
    await prefs.setString('address', userData['address']);
  }

  // Helper function to show snack bars
  void _showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Function to sign out and clear local data
  Future<void> signOut() async {
    try {
      await _auth.signOut(); // Firebase sign out
      await GoogleSignIn().signOut(); // Google sign out

      // Clear SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear all saved data

      // Clear the user instance and navigate to AuthScreen
      user.value = null;
      Get.offAll(() => const AuthScreen());

      _showSnackBar('Logged out successfully', false);
    } catch (e) {
      _showSnackBar('Failed to log out. Please try again.', true);
    }
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      _showSnackBar('Please enter your email address', true);
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSnackBar(
          'Password reset email sent. Please check your inbox.', false);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'The email address is badly formatted.';
          break;
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        default:
          message =
              'An error occurred while resetting password. Please try again.';
      }
      _showSnackBar(message, true);
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
        return 'An undefined error happened. Please try again.';
    }
  }
}
