import 'package:flutter/material.dart';

class NBackButton extends StatelessWidget {
    final VoidCallback onPressed;

  const NBackButton({super.key, required this.onPressed});


  @override
  Widget build(BuildContext context) {
     return OutlinedButton(
      onPressed: onPressed, // Action when the button is pressed
      style: OutlinedButton.styleFrom(
        // primary: Colors.black, // Color for the icon and outline
        backgroundColor: Colors.white, // White background
        side: BorderSide(color: Colors.black), // Black border color
        shape: CircleBorder(), // Circular shape
        padding: EdgeInsets.all(0), // Remove default padding to control size
      ),
      child: Container(
        width: 50.0, // Define the size of the circular button
        height: 50.0, // Same as width to maintain circular shape
        alignment: Alignment.center, // Center the child (icon)
        child: Icon(
          Icons.arrow_back, // Back arrow icon
          color: Colors.black, // Black color for the icon
          size: 24.0, // Icon size
        ),
      ),
    );
  }
}