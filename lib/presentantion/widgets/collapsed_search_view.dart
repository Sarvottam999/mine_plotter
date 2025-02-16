import 'package:flutter/material.dart';

class CollapsedSearchView extends StatelessWidget {
  final VoidCallback onTap;

  const CollapsedSearchView({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 250, 
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Search coordinates...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.expand_more,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
