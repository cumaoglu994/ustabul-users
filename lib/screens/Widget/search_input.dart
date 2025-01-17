import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: const TextField(
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'aradigin hizmeti  bul ',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
