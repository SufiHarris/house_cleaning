import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/custom_colors.dart'; // GetX if you're using it for state management

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;

  PasswordTextField({required this.controller});

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true; // Control whether the password is visible or not

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscured, // Controls whether to obscure the text
      decoration: InputDecoration(
        hintText: 'Enter your password',
        labelStyle: const TextStyle(
          color: Color(0xFFDCD7D8),
          fontSize: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: CustomColors.textColorThree),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured
                ? Icons.visibility_off
                : Icons.visibility, // Toggle icon
            color: CustomColors.textColorThree,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured; // Toggle password visibility
            });
          },
        ),
      ),
    );
  }
}
