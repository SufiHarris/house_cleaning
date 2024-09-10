import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../user/screens/user_main.dart';
import '../screens/auth_screen.dart';
import '../screens/log_in_screen.dart';
import 'database_methods.dart';

class AuthProvider extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  void _showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.fixed,
        // margin: EdgeInsets.only(
        //   bottom: Get.height - 100,
        //   right: 20,
        //   left: 20,
        // ),
      ),
    );
  }

  Future<void> signIn() async {
    // Check for empty fields
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields', true);
      return;
    }

    // Basic email format validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text.trim())) {
      _showSnackBar('Please enter a valid email address', true);
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      Get.offAll(() => const UserMain());
      _showSnackBar('Logged in successfully', false);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          message = 'The email address is badly formatted.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          message =
              'Too many unsuccessful login attempts. Please try again later.';
          break;
        case 'operation-not-allowed':
          message = 'Email & Password accounts are not enabled.';
          break;
        case 'network-request-failed':
          message = 'A network error occurred. Please check your connection.';
          break;
        default:
          message = 'An undefined error happened. Please try again.';
      }
      _showSnackBar(message, true);
    } catch (e) {
      _showSnackBar('An unexpected error occurred. Please try again.', true);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAll(() => const AuthScreen());
      _showSnackBar('Logged out successfully', false);
    } catch (e) {
      _showSnackBar('Failed to log out. Please try again.', true);
    }
  }

  // Additional method for password reset
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

  getCurrentUser() async {
    return await _auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken,
    );

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    if (result != null) {
      Map<String, dynamic> userInfoMap = {
        "email": userDetails!.email,
        "name": userDetails.displayName,
        "imgUrl": userDetails.photoURL,
        "id": userDetails.uid,
      };
      await DatabaseMethods()
          .addUser(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserMain(),
          ),
        );
      });
    }
  }
}
