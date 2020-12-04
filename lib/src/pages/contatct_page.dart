import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_reminders/src/components/theme.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _databaseReference = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    
    TextStyle _textStyle =  GoogleFonts.quicksand(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.cyan,
        title: Text('Contactos', style: _textStyle),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: FadeInUp(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeBottom: true,
                    removeTop: true,
                    child: _contacts()
                  ),
                )
              ]
            )
          ),
        ),
      )
    );
  }

  Widget _contacts() {

    return Container(
      // color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: _databaseReference.collection('users').snapshots(),
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
                  SvgPicture.asset('assets/images/pep.svg', height: 225.0,),
                  SizedBox(height: 10.0,),
                  Text('No tienes contactos todavía', textScaleFactor: 1.1, style: GoogleFonts.quicksand(fontWeight: FontWeight.bold ),),
                  SizedBox(height: 30.0,),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    textColor: Colors.white,
                    color: myTheme.accentColor,
                    onPressed: () => Navigator.pushNamed(context, 'new-contact'),
                    child: Text('AGREGAR CONTACTO', textScaleFactor: 1.1, style: GoogleFonts.quicksand(fontWeight: FontWeight.bold ), ),
                  )
                ],
              ),
            ),
          );
        } else  {
            return Container(
              width: double.infinity,
              child: ListView(
 
                children: snapshot.data.documents.map((contact){
                  final DocumentSnapshot doc = contact;
                  final String _firstName = doc.data['first_name'];
                  final String _lastName    = doc.data['last_name'];
                  final String _gender    = doc.data['gender'];
                  final String _email    = doc.data['email'];
                  final String _image    = doc.data['profile_image'];
                  final String _phone    = doc.data['phone'];
                  


                  return Builder(
                    builder: (BuildContext context){
                      return Container(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 35.0,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: NetworkImage(_image),
                                    ),
                                    VerticalDivider(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('$_firstName $_lastName', style: GoogleFonts.quicksand(fontSize: 18.0, fontWeight: FontWeight.bold)),
                                        Row(
                                          children: [
                                            Icon(Feather.phone, size: 15.0,),
                                            VerticalDivider(width: 3.0,),
                                            Text('$_phone', style: GoogleFonts.quicksand(fontSize: 15.0)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(_gender == 'Femenino' ? MdiIcons.genderFemale : MdiIcons.genderMale, size: 15.0,),
                                            VerticalDivider(width: 3.0,),
                                            Text('$_gender', style: GoogleFonts.quicksand(fontSize: 15.0)),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    // IconButton(
                                    //   icon: Icon(MdiIcons.whatsapp), 
                                    //   onPressed: () => whatsAppOpen(_phone)
                                    // ),
                                    IconButton(
                                      icon: Icon(Feather.phone_call), 
                                      onPressed: () => launchCaller(_phone)
                                    )
                                  ]
                                )
                              ],
                            ),
                          )
                        ),
                      );
                    },
                  );
                }).toList(),
              )
            );
          }
        },
      ),
    );
 }

//  void whatsAppOpen(String whatsappPhone) async {
//     await FlutterLaunch.launchWathsApp(
//       phone: '502$whatsappPhone', 
//       message: 'Hola teto'
//     );
//   }

  void launchCaller(String phone) async {
    String url = "tel://+502$phone";
    if (await canLaunch.call(url)) {
      await launch(url);
    } else {
      throw 'No se pudo realizar la llamada';
    }
  }
}