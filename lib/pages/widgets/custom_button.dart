import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  final String title;
  final Function() onPressed;

  const CustomButton({super.key, required this.title, required this.onPressed});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink[300],
        textStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(fontWeight: FontWeight.w600)),
        foregroundColor: Colors.white,
      ),
      onPressed: widget.onPressed,
      child: Text(widget.title),
    );
  }
}
