import 'package:contacts_reminders/src/components/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget appoinmentCard(BuildContext context) {
  TextStyle _textStyle =  GoogleFonts.quicksand(color: Colors.black, fontSize: 18.0); 
  TextStyle _textStyle2 =  GoogleFonts.quicksand(color: Colors.black, fontSize: 16.0); 


  final _screenSize = MediaQuery.of(context).size;
  return Card(
    elevation: 3.0,
    margin: EdgeInsets.all(5.0),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Cita médica", style: _textStyle),
          SizedBox(
            height: 21,
          ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://cdn.vuetifyjs.com/images/john.jpg",
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Charles Barrios",
                      style:  GoogleFonts.quicksand(fontSize: 23, color: myTheme.accentColor),
                    ),
                    Text(
                      "Enfermedad común",
                      style: _textStyle2
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Mañana ",
                style: _textStyle2
              ),
              Text(
                "03:30PM",
                style: _textStyle2
              ),
            ],
          ),
        ],
      ),
    ),
  );
  }