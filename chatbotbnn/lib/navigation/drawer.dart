// ignore_for_file: deprecated_member_use

import 'package:chatbotbnn/provider/provider_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerCustom extends StatefulWidget {
  final Function(int) onItemSelected;
  const DrawerCustom({super.key, required this.onItemSelected});

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  @override
  Widget build(BuildContext context) {
    final selectedColor = Provider.of<Providercolor>(context).selectedColor;

    return Drawer(
      backgroundColor: selectedColor,
      child: SafeArea(
        minimum: const EdgeInsets.only(left: 5, top: 27, right: 20),
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(color: Colors.black),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildListTile(
                      icon: FontAwesomeIcons.dashboard,
                      title: 'Dasbroads',
                      onTap: () => widget.onItemSelected(0),
                    ),
                    _buildListTile(
                      icon: FontAwesomeIcons.message,
                      title: 'Chat',
                      onTap: () => widget.onItemSelected(1),
                    ),
                    _buildListTile(
                      icon: FontAwesomeIcons.history,
                      title: 'Lịch sử chat',
                      onTap: () => widget.onItemSelected(2),
                    ),
                    _buildListTile(
                      icon: FontAwesomeIcons.person,
                      title: 'Cá nhân',
                      onTap: () => widget.onItemSelected(3),
                    ),
                    _buildListTile(
                      icon: FontAwesomeIcons.gear,
                      title: 'Cài đặt',
                      onTap: () => widget.onItemSelected(4),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildColorSelector(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            iconSize: 23,
            onPressed: () => widget.onItemSelected(3),
          ),
          // SvgPicture.asset(
          //   'resources/logo.svg',
          //   width: 80,
          //   height: 30,
          //   fit: BoxFit.contain,
          // ),
          const Text(
            'Bộ nông nghiệp',
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title,
          style:
              GoogleFonts.robotoCondensed(fontSize: 15, color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.robotoCondensed(fontSize: 15, color: Colors.white),
      ),
      childrenPadding: const EdgeInsets.only(left: 20.0),
      iconColor: Colors.white,
      collapsedIconColor: Colors.grey,
      children: children,
    );
  }

  Widget _buildColorSelector(BuildContext context) {
    final colors = [
      const Color(0xff042E4D),
      const Color(0xff004225),
      const Color(0xff6b240c)
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Text('Màu sắc',
              style: GoogleFonts.robotoCondensed(
                  fontSize: 15, color: Colors.white)),
          const SizedBox(width: 5),
          Wrap(
            children: colors.map((color) {
              return GestureDetector(
                onTap: () => Provider.of<Providercolor>(context, listen: false)
                    .changeColor(color),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Provider.of<Providercolor>(context).selectedColor ==
                          color
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : const SizedBox.shrink(),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
