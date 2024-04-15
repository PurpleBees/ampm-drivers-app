import 'package:flutter/material.dart';
import '../../../const/app_images.dart';
import 'drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  final List<DrawerItem> items;
  final String firstName;
  final String lastName;
  const CustomDrawer({
    super.key,
    required this.items,
    required this.firstName,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50.0,
            ),

            ///Profile
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25.5,
                  backgroundColor: const Color(0XFF34D186),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.5),
                    child: const Image(
                      image: AssetImage(AppImages.profilePlaceholder),
                      height: 36.0,
                      width: 30.0,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$firstName $lastName',
                      style: const TextStyle(
                          fontSize: 23.0, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      'View Profile',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black.withOpacity(0.38)),
                    )
                  ],
                )
              ],
            ),
            const Divider(),
          ] + items,
        ),
      ),
    );
  }
}