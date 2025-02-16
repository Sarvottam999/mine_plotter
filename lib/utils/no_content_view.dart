import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoContentView extends StatelessWidget {
  final String? text;
  const NoContentView({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: SvgPicture.asset(
            'assets/no_data_icon.svg',
            fit: BoxFit.scaleDown,
          ),
        ),
        const SizedBox(height: 20), // Add spacing between illustration and text
        if (text != null && text!.isNotEmpty) // Corrected condition
          Text(
            textAlign: TextAlign.center,
            text!, // Safe to use `text!` here because of the null check
            style: const TextStyle(
              
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
      ],
    );
  }
}
 