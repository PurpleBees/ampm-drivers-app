import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          size: 30.0,
          weight: 100.0,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 21.0),
        ),
      ),
    );
  }
}