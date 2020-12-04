
import 'package:contacts_reminders/src/components/theme.dart';
import 'package:contacts_reminders/src/pages/contatct_page.dart';
import 'package:contacts_reminders/src/pages/home_page.dart';
import 'package:contacts_reminders/src/pages/new_appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavigationBarComponent extends StatefulWidget {
  @override
  _BottomNavigationBarComponentState createState() =>
      _BottomNavigationBarComponentState();
}

class _BottomNavigationBarComponentState
    extends State<BottomNavigationBarComponent> {
  int _currentIndex = 0;

  final List<Widget> pages = [HomePage(),  NewAppointmentPage(), ContactPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Color(0XFF353535),
        iconSize: 30.0,
        selectedLabelStyle: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: myTheme.accentColor,
        elevation: 10.0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Feather.home), label:'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Feather.calendar), label: 'Nueva cita',),
          BottomNavigationBarItem(
              icon: Icon(Feather.users), label: 'Contactos'),
        ],
      ),
    );
  }
}