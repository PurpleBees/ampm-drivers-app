import 'package:flutter/material.dart';

import '../../../const/app_colors.dart';
import '../../../const/app_text.dart';
import '../../../const/delivery_status.dart';

class DeliveryStatusDDMenu extends StatelessWidget {
  const DeliveryStatusDDMenu({
    super.key,
    required this.onChanged,
  });

  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      borderRadius: BorderRadius.circular(20.0),
      dropdownColor: AppColors.primary,
      iconEnabledColor: Colors.white,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
        ),
        hintText: AppText.status,
        hintStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: const Color(0XFFE76E20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),
      items: [
        DropdownMenuItem(
          value: DeliveryStatus.delivered.name,
          child: Text(
            DeliveryStatus.delivered.name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: DeliveryStatus.failed.name,
          child: Text(
            DeliveryStatus.failed.name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: DeliveryStatus.rejected.name,
          child: Text(
            DeliveryStatus.rejected.name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}