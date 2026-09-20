import 'package:flutter/material.dart';
import 'package:gpa_calculator/core/constants/constants.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_images.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.appLogo, width: 32, height: 32),
          const SizedBox(width: 8),
          const Text(AppConstants.appName),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
