import 'package:flutter/material.dart';

import '../../../const/app_colors.dart';
import '../../../const/app_text.dart';

class CustomTimeButton extends StatelessWidget {
  const CustomTimeButton({
    this.borderRadius = 5.0,
    this.borderColor = AppColors.primary,
    this.contentPadding,
    this.icon = Icons.edit_calendar_rounded,
    this.iconColor = AppColors.primary,
    this.title = AppText.selectDate,
    this.titleColor = AppColors.primary,
    this.subtitle = '',
    this.subtitleColor = AppColors.primary,
    this.onTap,
    super.key,
  });

  final double borderRadius;
  final Color borderColor;
  final EdgeInsets? contentPadding;
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final String subtitle;
  final Color subtitleColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor)),
        child: Padding(
          padding: contentPadding ?? const EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: iconColor,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: titleColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: subtitleColor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}