import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';

class OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;
  final String icon;

  const OnboardingSlide({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
  }) : super(key: key);

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'briefcase':
        return FeatherIcons.briefcase;
      case 'message-circle':
        return FeatherIcons.messageCircle;
      case 'file-text':
        return FeatherIcons.fileText;
      case 'calendar':
        return FeatherIcons.calendar;
      case 'dollar-sign':
        return FeatherIcons.dollarSign;
      default:
        return FeatherIcons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final IconData iconData = _getIconData(icon);
    
    return Padding(
      padding: EdgeInsets.all(AppTheme.spacing(4)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppTheme.spacing(6)),
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppTheme.spacing(2)),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
