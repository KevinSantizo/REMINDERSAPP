
import 'package:contacts_reminders/src/components/appointment_card.dart';
import 'package:contacts_reminders/src/components/theme.dart';
import 'package:contacts_reminders/src/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle _textStyle =  GoogleFonts.quicksand(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold);
  TextStyle _textStyle2 = GoogleFonts.quicksand(color: myTheme.accentColor, fontSize: 15.0, fontWeight: FontWeight.bold);
  TextStyle _textStyle3 = GoogleFonts.quicksand(color: Colors.black, fontSize: 19.0,);

  // Contact contact = new Contact();


  
  final List<Contact> _reviewsList = [
    Contact(  'John Leider',    'https://avatars0.githubusercontent.com/u/9064066?v=4&s=460',   '07 dic 2020',    '50182700', 'Masculino' ),
    Contact(  'Marc Castillo',  'https://cdn.vuetifyjs.com/images/profiles/marcus.jpg',         '08 dic 2020',    '50182700', 'Masculino' ), 
    Contact(  'John Leider',    'https://cdn.vuetifyjs.com/images/lists/1.jpg',                 '10 dic 2020',    '50182700', 'Masculino' ), 
    Contact(  'John Leider',    'https://cdn.vuetifyjs.com/images/lists/2.jpg',                 '12 dic 2020',    '50182700', 'Masculino' ), 
    Contact(  'Megan Miroslava','https://cdn.vuetifyjs.com/images/lists/3.jpg',                 '12 dic 2020',    '50182700', 'Femenio' ), 

  ];



  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.cyan,
        title: Text('GudkerApp', style: _textStyle),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20.0, bottom: 5.0),
            child: Image.asset('assets/images/avatar.png', height: _screenSize.height * 0.07,)
          )
        ]
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('¡Bienvenido!', style: GoogleFonts.quicksand( fontSize: 25.0, fontWeight: FontWeight.bold)),
                        Text('Admin User', style: GoogleFonts.quicksand(fontSize: 17.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    VerticalDivider(),
                    Image.asset('assets/images/stethoscope.png', height: 50.0,)
                  ],
                ),
                SizedBox(height: 20.0,),
                _buildButtons(),
                SizedBox(height: 25.0,),
                _buildCardAppointment(),
                SizedBox(height: 25.0,),
                _buildCardAppoinmentToday(),
                SizedBox(height: 25.0,),
                _buildNewContacts(),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildCardAppointment() {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Feather.calendar),
            VerticalDivider(width: 3.0,),
            Text('Próximas citas', style: _textStyle3,),
          ],
        ),
        Divider(),
        Container(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              appoinmentCard(context),
              appoinmentCard(context),
              appoinmentCard(context),
            ],
          ),
        ),
      ],
    ),
  ); 
 }

 Widget _buildCardAppoinmentToday(){
   return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Row(
          children: [
            Icon(MdiIcons.noteOutline),
            VerticalDivider(width: 3.0,),
            Text('Hoy', style: _textStyle3,),
          ],
        ),
        Divider(),
        Center(
          child: Chip(
            labelPadding: EdgeInsets.all(5.0),
            backgroundColor:  myTheme.accentColor.withOpacity(0.1),
            label: Text('No tienes citas para hoy', style: _textStyle2,)
          ),
        )
       ],
     ),
   ); 
 }

 Widget _buildNewContacts() {
   return Container(
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Row(
          children: [
            Icon(Feather.users),
            VerticalDivider(width: 3.0,),
            Text('Contactos nuevos', style: _textStyle3,),
          ],
        ),
        Divider(),
        for (var i = 0; i < _reviewsList.length; i++) 
         Padding(
           padding: const EdgeInsets.symmetric(vertical: 3.0),
           child: Card(
             color: Colors.white,
             elevation: 3.0,
             child: Padding(
               padding: const EdgeInsets.all(15.0),
               child: Column(
                 children: <Widget>[
                    Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                      Row(
                        children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(_reviewsList[i].profileImage),
                        ),
                        VerticalDivider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(_reviewsList[i].fisrtName, style: GoogleFonts.quicksand(textStyle: TextStyle(fontWeight: FontWeight.bold) ),),
                            Text(_reviewsList[i].genre, style: GoogleFonts.quicksand(color: Colors.grey)),
                          ],
                        ),
                        ],
                      ),
                     ],
                   ),

                 ],
               ),
             )
           ),
         )
       ],
     ),
   );
 }

 Widget _buildButtons(){
  return Table(
    children: [
      TableRow(
        children: [
          _buildRoundedButton(
            () => Navigator.pushNamed(context, 'new-contact'),
            Icon(Feather.user_plus, size: 45.0, color: Colors.white),
            'Nuevo\ncontacto',
            myTheme.accentColor
          ),
          _buildRoundedButton(
            () => Navigator.pushNamed(context, 'appointments'),
            Icon(Feather.calendar, size: 45.0, color: Colors.white),
            'Citas',
            Colors.pink
          ),
        ]
      ),
    ],
  );
 }

  Widget _buildRoundedButton(Function onTap, Icon icon, String title, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: icon,
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Text(title, style: GoogleFonts.quicksand(color: Colors.white, fontSize: 20.0),),
            )
          ],
        ),
      ),
    );
  }


 
}

