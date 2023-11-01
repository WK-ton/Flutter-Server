import 'package:application/screen/Profile/Profile.dart';
import 'package:application/screen/Search/Search.dart';
import 'package:application/screen/Ticket.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomTab extends StatefulWidget {
  final token;

  const BottomTab({@required this.token, super.key});

  @override
  _BottomTabState createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  int _currentIndex = 0;

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 92, 36, 212),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
          child: GNav(
            backgroundColor: const Color.fromARGB(255, 92, 36, 212),
            color: Colors.white,
            activeColor: const Color.fromARGB(255, 92, 36, 212),
            tabBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
            gap: 8,
            selectedIndex: _currentIndex,
            onTabChange: _changePage,
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home_sharp,
                text: 'Home',
              ),
              GButton(
                icon: FontAwesomeIcons.ticket,
                text: 'Ticket',
              ),
              GButton(
                icon: Icons.supervised_user_circle_sharp,
                text: 'Account',
              ),
            ],
          ),
        ),
      ),
      body: _getPage(_currentIndex),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return SearchVan(
          token: widget.token,
        );
      case 1:
        return Ticket(
          token: widget.token,
        );
      case 2:
        return Profile(
          token: widget.token,
        );
      default:
        return Container();
    }
  }
}
