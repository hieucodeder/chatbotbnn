// ignore_for_file: deprecated_member_use

import 'package:chatbotbnn/provider/provider_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNavigation(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    final selectedColor = Provider.of<Providercolor>(context).selectedColor;
    return Container(
      decoration: BoxDecoration(
        color: selectedColor.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          widget.onTap(index);
        },
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.robotoCondensed(
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        unselectedLabelStyle: GoogleFonts.robotoCondensed(
          textStyle: const TextStyle(fontSize: 13),
        ),
        items: [
          _buildNavItem(
            isSelected: widget.currentIndex == 0,
            activeIcon: FontAwesomeIcons.home,
            inactiveIcon: Icons.home_outlined,
            label: 'Home',
          ),
          _buildNavItem(
            isSelected: widget.currentIndex == 1,
            activeIcon: FontAwesomeIcons.message,
            inactiveIcon: Icons.message_outlined,
            label: 'Chat',
          ),
          _buildNavItem(
            isSelected: widget.currentIndex == 2,
            activeIcon: FontAwesomeIcons.history,
            inactiveIcon: Icons.history_outlined,
            label: 'History',
          ),
          _buildNavItem(
            isSelected: widget.currentIndex == 3,
            activeIcon: FontAwesomeIcons.person,
            inactiveIcon: Icons.person_outline,
            label: 'Profile',
          ),
          _buildNavItem(
            isSelected: widget.currentIndex == 4,
            activeIcon: FontAwesomeIcons.gear,
            inactiveIcon: Icons.settings_outlined,
            label: 'Setting',
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required bool isSelected,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.orange.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isSelected ? activeIcon : inactiveIcon,
          size: 22,
        ),
      ),
      label: label,
    );
  }
}
