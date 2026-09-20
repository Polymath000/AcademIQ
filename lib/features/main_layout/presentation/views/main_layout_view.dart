import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_calculator/config/theme/app_icons.dart';
import 'package:gpa_calculator/core/constants/borders.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_images.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../ai_advisor/presentation/views/ai_advisor_view.dart';
import '../../../settings/presentation/views/settings_view.dart';
import '../cubit/main_layout_cubit.dart';

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  static const _screens = <Widget>[AiAdvisorView(), HomeView(), SettingsView()];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainLayoutCubit, int>(
      builder: (context, currentIndex) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.bgDark,
            gradient: LinearGradient(
              colors: [
                AppColors.gradeWeak.withValues(alpha: 0.2),
                AppColors.brandIndigo.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            backgroundColor: AppColors.transparent,
            extendBody: true,
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.05),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(currentIndex),
                child: _screens[currentIndex],
              ),
            ),
            floatingActionButton: SizedBox(
              width: 64,
              height: 64,
              child: FloatingActionButton(
                onPressed: () => context.read<MainLayoutCubit>().changeTab(1),
                shape: const CircleBorder(),
                elevation: 8,
                backgroundColor: AppColors.transparent,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.brandPurple,
                        AppColors.brandIndigo.withValues(alpha: 0.8),
                        AppColors.white.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: currentIndex == 1
                          ? AppColors.brandAccent.withValues(alpha: 0.5)
                          : AppColors.brandPurple.withValues(alpha: 0.5),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandPurple.withValues(alpha: 0.5),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(AppImages.appLogo, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
            bottomNavigationBar: BottomAppBar(
              color: AppColors.navBarPlum,
              shape: const AutomaticNotchedShape(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(48),
                    bottom: Radius.circular(48),
                  ),
                  side: BorderSide(color: AppColors.brandPurple, width: 1.5),
                ),
                CircleBorder(),
              ),
              height: 64,
              notchMargin: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: AppIcons.aiAdvisor,
                    isSelected: currentIndex == 0,
                    onTap: () => context.read<MainLayoutCubit>().changeTab(0),
                  ),
                  _NavItem(
                    icon: AppIcons.settings,
                    isSelected: currentIndex == 2,
                    onTap: () => context.read<MainLayoutCubit>().changeTab(2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.transparent,
                  borderRadius: AppBorders.xxxs,
                ),
                child: Icon(
                  widget.icon,
                  color: widget.isSelected
                      ? AppColors.brandAccent
                      : AppColors.inactive,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
