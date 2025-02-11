import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talk_nest/utils/constants/app_string.dart';
import 'package:talk_nest/view/page/tab_bar_page/chats_home_page.dart';
import 'package:talk_nest/view/page/tab_bar_page/stutas_page.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({super.key});

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppString.chats),
          bottom: const TabBar(tabs: [
            Tab(
              text: 'Chats',
            ),
            Tab(
              text: 'Stutas',
            ),
          ]),
        ),
        body: const TabBarView(
          children: [ChatHomePage(), StutasPage()],
        ),
      ),
    );
  }
}
