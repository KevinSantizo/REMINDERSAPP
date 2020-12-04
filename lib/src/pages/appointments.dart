import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_reminders/src/components/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:intl/intl.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  TextStyle _textStyle =  GoogleFonts.quicksand(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold);
  final db = Firestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.cyan,
        title: Text('Todas las citas', style: _textStyle),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: _appointments()
      ),
    );
  }

 Widget _appointments() {
  return Container(
    child: StreamBuilder<QuerySnapshot>(
      stream: db.collection('appointments').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.data == null) return Center(child: JumpingDotsProgressIndicator(fontSize: 50.0, color: myTheme.accentColor));
        if (snapshot.data.documents.isEmpty) {
          return FadeInUp(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset('assets/images/med.svg', height: 225.0,),
                  SizedBox(height: 10.0,),
                  Text('No tienes Citas todavía.', textScaleFactor: 1.1, style: GoogleFonts.quicksand(fontWeight: FontWeight.bold ),),
                  SizedBox(height: 30.0,),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    textColor: Colors.white,
                    color: myTheme.accentColor,
                    onPressed: () => Navigator.pop(context),
                    child: Text('REGRESAR', textScaleFactor: 1.3, style: GoogleFonts.quicksand(fontWeight: FontWeight.bold ), ),
                  )
                ],
              ),
            ),
          );
        } else {
          return FadeInUp(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: snapshot.data.documents.map((e) {
                    final DocumentSnapshot app = e;
                    return Builder(
                      builder: (BuildContext context){
                        return Container(
                          padding: EdgeInsets.all(5.0),
                          child: Card(
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 35.0,
                                            backgroundColor: Colors.grey,
                                            backgroundImage: NetworkImage(app.data['user_pic']),
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(color: Colors.transparent, width: 10.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(Feather.user, size: 20.0),
                                              VerticalDivider(width: 5.0,),
                                              Text('${app.data['user_name']} ${app.data['user_last_name']}', style: GoogleFonts.quicksand(fontSize: 20.0))
                                            ],
                                          ),
                                          SizedBox(height: 5.0,),
                                        Row(
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              // Image.asset('assets/futy.png', height: 25.0,),
                                              Text('${app.data['type']}', textScaleFactor: 1.2, style: GoogleFonts.ubuntu(),)
                                            ],
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('${app.data['date'].toString().substring(0, 16)} hrs', style: GoogleFonts.quicksand(fontSize: 15.0))
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    );
                  }).toList()
                ),
              ),
            ),
          );
        } 
      }
    ),
  );
 }
}


