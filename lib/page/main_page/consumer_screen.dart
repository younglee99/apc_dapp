import 'package:flutter/material.dart';
import 'package:trust_blockchain/page/setting_page/setting_screen.dart';
import 'package:trust_blockchain/user/consumer/consumer_profile.dart';

class ConsumerScreen extends StatelessWidget {
  ConsumerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {return BottomNavigation();}
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationExampleState createState() => _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State<BottomNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 정보',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '더보기',
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return ConsumerProfile();
      case 1:
        return SettingScreen();
      default:
        return Container();
    }
  }
}
