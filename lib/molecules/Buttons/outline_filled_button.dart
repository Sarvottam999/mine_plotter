// lib/widgets/outline_filled_button.dart

import 'package:flutter/material.dart';

class NButtonOutline extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isSelected;
  final Color color;

  const NButtonOutline({
    Key? key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isSelected = false,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  State<NButtonOutline> createState() => _NButtonOutlineState();
}

class _NButtonOutlineState extends State<NButtonOutline> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: OutlinedButton(
        onPressed: widget.onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: widget.isSelected ? widget.color : Colors.transparent,
          side: BorderSide(
            color: widget.color,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                color: widget.isSelected ? Colors.white : widget.color,
                size: 20,
              ),
              SizedBox(width: 8),
            ],
            Text(
              widget.label,
              style: TextStyle(
                color: widget.isSelected ? Colors.white : widget.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}