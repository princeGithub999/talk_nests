import 'package:flutter/widgets.dart';

class ButtomNavigationProvider extends ChangeNotifier {
  final PageController _pageController = PageController();

  PageController get pageController => _pageController;
  int _selectedTab = 0;

  int get selectedTab => _selectedTab;

  void changeTab(int index) {
    _selectedTab = index;

    pageController.jumpToPage(index);
    notifyListeners();
  }
}
