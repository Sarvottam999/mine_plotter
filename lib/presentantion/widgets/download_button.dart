import 'package:flutter/material.dart';

class NDownloadButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color primaryColor;
  final Color secondaryColor;

  const NDownloadButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.width = 200,
    this.height = 50,
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.white,
  }) : super(key: key);

  @override
  _NDownloadButtonState createState() => _NDownloadButtonState();
}

class _NDownloadButtonState extends State<NDownloadButton> {

 


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  widget.onPressed,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.primaryColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: widget.primaryColor.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
           
          ],
        ),
      ),
    );
  }

 
}

 