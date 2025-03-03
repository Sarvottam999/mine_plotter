import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoContentView extends StatelessWidget {
  final String? text;
  final String? sub_text;
  const NoContentView({super.key, this.text, this.sub_text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: SvgPicture.asset(
            'assets/no_data_icon.svg',
            fit: BoxFit.scaleDown,
          ),
        ),
        const SizedBox(height: 10), // Add spacing between illustration and text
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
          SizedBox(
            height: 10,
          ),
          

            if (sub_text != null && sub_text!.isNotEmpty) // Corrected condition
          Expanded(
            child: Text(
              textAlign: TextAlign.center,
              sub_text!, // Safe to use `text!` here because of the null check
              style: const TextStyle(
                
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
      ],
    );
  }
}
 