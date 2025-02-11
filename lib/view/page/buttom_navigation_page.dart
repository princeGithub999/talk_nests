import 'package:floaty_nav_bar/floaty_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/utils/constants/app_string.dart';
import 'package:talk_nest/utils/constants/colors.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';
import 'package:talk_nest/view/page/buttom_nav_page/call_page.dart';
import 'package:talk_nest/view/page/buttom_nav_page/tab_bar_page.dart';
import 'package:talk_nest/view/page/buttom_nav_page/group_chats_page.dart';
import 'package:talk_nest/view/page/buttom_nav_page/more_page.dart';
import 'package:talk_nest/view/page/buttom_nav_page/profile_page.dart';
import '../../view_model/getx/chat_status_get_x.dart';
import '../../view_model/notifaction_service/notification_service.dart';
import '../../view_model/provider/auth_provider.dart';
import '../../view_model/provider/buttom_navigation_provider.dart';

class ButtomNavigationPage extends StatefulWidget {
  const ButtomNavigationPage({super.key});

  @override
  State<ButtomNavigationPage> createState() => _ButtomNavigationPageState();
}

class _ButtomNavigationPageState extends State<ButtomNavigationPage> {
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<AuthProviderIn>(Get.context!, listen: false)
            .getProfileData();
        Provider.of<AuthProviderIn>(context, listen: false).getCurrentUser();
      },
    );

    notificationService.requestNotificationPermission();
  }

  List<Widget> get tabs {
    return [
      const TabBarPage(),
      const GroupChatsPage(),
      const ProfilePage(),
      const MorePage(),
      const CallPage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Consumer<ButtomNavigationProvider>(
      builder: (BuildContext context, buttomNavPro, Widget? child) {
        ChatStatusGetX chatStatusGetX = Get.put(ChatStatusGetX());

        return Scaffold(
          body: PageView(
            controller: buttomNavPro.pageController,
            children: tabs,
            onPageChanged: (index) {
              buttomNavPro.changeTab(index);
            },
          ),
          bottomNavigationBar: FloatyNavBar(
            selectedTab: buttomNavPro.selectedTab,
            backgroundColor: isDark ? AppColors.blue900 : AppColors.lightBlue,
            gap: 10,
            shape: const RectangleShape(radius: 12),
            tabs: [
              FloatyTab(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  isSelected: buttomNavPro.selectedTab == 0,
                  onTap: () => buttomNavPro.changeTab(0),
                  title: AppString.chats,
                  titleStyle: const TextStyle(color: AppColors.white),
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedMessage01,
                    color: buttomNavPro.selectedTab == 0
                        ? Colors.white
                        : Colors.black,
                  ),
                  selectedColor:
                      isDark ? AppColors.lightBlue : AppColors.blue900,
                  unselectedColor:
                      isDark ? AppColors.blue900 : AppColors.lightBlue),
              FloatyTab(
                  isSelected: buttomNavPro.selectedTab == 1,
                  onTap: () => buttomNavPro.changeTab(1),
                  title: AppString.group,
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedUserGroup,
                    color: buttomNavPro.selectedTab == 1
                        ? Colors.white
                        : Colors.black,
                  ),
                  selectedColor:
                      isDark ? AppColors.lightBlue : AppColors.blue900,
                  unselectedColor:
                      isDark ? AppColors.blue900 : AppColors.lightBlue),
              FloatyTab(
                  isSelected: buttomNavPro.selectedTab == 2,
                  onTap: () => buttomNavPro.changeTab(2),
                  title: AppString.profile,
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedLocationUser04,
                    color: buttomNavPro.selectedTab == 2
                        ? Colors.white
                        : Colors.black,
                  ),
                  selectedColor:
                      isDark ? AppColors.lightBlue : AppColors.blue900,
                  unselectedColor:
                      isDark ? AppColors.blue900 : AppColors.lightBlue),
              FloatyTab(
                  isSelected: buttomNavPro.selectedTab == 3,
                  onTap: () => buttomNavPro.changeTab(3),
                  title: AppString.more,
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedMenu01,
                    color: buttomNavPro.selectedTab == 3
                        ? Colors.white
                        : Colors.black,
                  ),
                  selectedColor:
                      isDark ? AppColors.lightBlue : AppColors.blue900,
                  unselectedColor:
                      isDark ? AppColors.blue900 : AppColors.lightBlue),
              FloatyTab(
                  isSelected: buttomNavPro.selectedTab == 4,
                  onTap: () => buttomNavPro.changeTab(4),
                  title: AppString.call,
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedSmartPhone01,
                    color: buttomNavPro.selectedTab == 4
                        ? Colors.white
                        : Colors.black,
                  ),
                  selectedColor:
                      isDark ? AppColors.lightBlue : AppColors.blue900,
                  unselectedColor:
                      isDark ? AppColors.blue900 : AppColors.lightBlue),
            ],
          ),
        );
      },
    );
  }
}
