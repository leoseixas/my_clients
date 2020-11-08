import 'package:flutter/material.dart';

class CustomBottomClient extends StatelessWidget implements PreferredSizeWidget {

  final bool isExpanded;
  final void Function() onTap;
  CustomBottomClient({this.isExpanded, this.onTap});

  @override
  Size get preferredSize => Size.fromHeight(30);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        color: Colors.white,
        size: 28,
      ),
      onTap: onTap,
    );
  }
}
