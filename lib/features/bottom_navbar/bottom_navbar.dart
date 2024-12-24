import 'package:flutter/material.dart';
import 'package:map_based_search/core/utils/app_color.dart';
import 'package:map_based_search/features/bottom_navbar/utils/bottom_navbar_screens.dart';
import 'package:map_based_search/features/bottom_navbar/widgets/app_bar_title_for_user.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomBottomNavbar extends StatefulWidget {
  const CustomBottomNavbar({super.key});

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  late final PersistentTabController _controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
    _controller.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.index != currentIndex) {
          setState(() {
            currentIndex = _controller.index;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _controller.index != 1
          ? AppBar(
              toolbarHeight: size.height * 0.1,
              backgroundColor: Theme.of(context).primaryColor,
              centerTitle: true,
              leading: const Icon(
                Icons.location_on_outlined,
                color: AppColor.red,
              ),
              title: AppBarTitleForUser(index: _controller.index),
            )
          : null,
      body: PersistentTabView(
        margin: EdgeInsets.only(top: size.height * 0.02),
        backgroundColor: Theme.of(context).primaryColor,
        controller: _controller,
        navBarBuilder: (navBarConfig) => Style6BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration:
              NavBarDecoration(color: Theme.of(context).primaryColor),
        ),
        tabs: buildScreens(),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          curve: Curves.ease,
          duration: Duration(milliseconds: 400),
        ),
        onTabChanged: (value) {},
        stateManagement: true,
      ),
    );
  }
}
