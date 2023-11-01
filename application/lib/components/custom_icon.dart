import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Widget icon;
  final Function()? onPressed;
  final double size;

  const CustomIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.size = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}