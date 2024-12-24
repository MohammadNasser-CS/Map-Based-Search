import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_based_search/core/utils/app_color.dart';
import 'package:map_based_search/features/bockmark/views/bookmark_page.dart';
import 'package:map_based_search/features/home/views/home_page.dart';
import 'package:map_based_search/features/map_search/manager/controller/map_cubit.dart';
import 'package:map_based_search/features/map_search/views/map_search_page.dart';
import 'package:map_based_search/features/profile/views/profile_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

List<PersistentTabConfig> buildScreens() {
  return [
    PersistentTabConfig(
      screen: const HomePage(),
      item: ItemConfig(
        icon: const Icon(Icons.home_outlined),
        title: "Home",
        activeForegroundColor: AppColor.blue,
        inactiveForegroundColor: AppColor.grey,
      ),
    ),
    PersistentTabConfig(
      screen: BlocProvider(
        create: (context) {
          final cubit = MapCubit();
          cubit.loadInitialLocation();
          return MapCubit();
        },
        child: const MapSearchPage(),
      ),
      item: ItemConfig(
        icon: const Icon(Icons.search),
        title: "Search",
        activeForegroundColor: AppColor.blue,
        inactiveForegroundColor: AppColor.grey,
      ),
    ),
    PersistentTabConfig(
      screen: const BookmarkPage(),
      item: ItemConfig(
        icon: const Icon(Icons.bookmark_outline),
        title: "Bookmark",
        activeForegroundColor: AppColor.blue,
        inactiveForegroundColor: AppColor.grey,
      ),
    ),
    PersistentTabConfig(
      screen: const ProfilePage(),
      item: ItemConfig(
        icon: const Icon(Icons.person_outline),
        title: "Profile",
        activeForegroundColor: AppColor.blue,
        inactiveForegroundColor: AppColor.grey,
      ),
    ),
  ];
}
