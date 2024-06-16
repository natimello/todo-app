import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? icon;
  final List<Widget>? actions;
  const CustomAppBar({super.key, required this.title, this.icon, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        leadingWidth: icon == null ? null : 45,
        leading: icon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  icon!,
                ),
              ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Colors.pink[300], fontWeight: FontWeight.w600)),
        ),
        actions: actions);
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
