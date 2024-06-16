import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 60),
          ListTile(
            leading: const Icon(Icons.event),
            title: Text(
              'Todas as tarefas',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/allTodos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(
              'Adicionar tarefa',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/addTodo');
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: Text(
              'Mapa',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/googleMaps');
            },
          ),
        ],
      ),
    );
  }
}
