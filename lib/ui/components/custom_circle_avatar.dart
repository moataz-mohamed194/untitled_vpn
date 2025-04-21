import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String imageUrl;

  const CustomCircleAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: imageUrl.isNotEmpty
            ? Icon(Icons.flag)
            : Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}
