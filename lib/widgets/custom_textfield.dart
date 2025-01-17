import 'package:flutter/material.dart';
import 'package:ustabuul/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;

  const CustomTextField({
    required this.controller,
    required this.icon,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        width: width * .8,
        child: TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen $hint girin';
            }
            return null;
          },
          obscureText: (hint == 'Şifrenizi Girin' ||
                  hint == 'Lütfen Şifrenizi Girin' ||
                  hint == 'Lütfen Şifrenizi Onaylayın')
              ? true
              : false,
          cursorColor: kMainColor,
          style: const TextStyle(fontSize: 18.0),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: Colors.black,
            ),
            filled: true,
            fillColor: kSecondColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
