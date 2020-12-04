import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_reminders/src/components/my_datetime_picker.dart';
import 'package:contacts_reminders/src/components/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../main.dart';

class ContactAppointment extends StatefulWidget {

  final DocumentSnapshot ctc;

  const ContactAppointment({Key key, this.ctc}) : super(key: key);
  @override
  _ContactAppointmentState createState() => _ContactAppointmentState();
}

class _ContactAppointmentState extends State<ContactAppointment> {

  TextStyle _textStyle =  GoogleFonts.quicksand(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold);
  final  _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _textTitle = TextEditingController();
  final db = Firestore.instance;



  var _date = DateTime.now();
  String dropdownValue = 'Primer Consulta';
  String consultation = '';
  var _selectedValue;
  String title = '';

  String textButton = 'GUARDAR';


  @override
  void dispose() {
    _textTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.cyan,
        title: Text('${widget.ctc.data['first_name']} ${widget.ctc.data['last_name']}', style: _textStyle),
        // automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nueva cita', style: GoogleFonts.quicksand(fontSize: 20.0, fontWeight: FontWeight.bold )),
              SizedBox(height: 20.0),
              CircleAvatar(
                radius: 55.0,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(widget.ctc.data['profile_image']),
              ),
              _formNewAppointment()
            ],
          ),
        ),
      ),
    );
  }

  Widget _formNewAppointment() {
   return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 15.0),
          _titleAppointment(),
          SizedBox(height: 20.0),
          _dateInput(context),
          SizedBox(height: 25.0),
          _typeInput(),
          SizedBox(height: 15.0),
          Divider(),
          SizedBox(height: 15.0),
          _buildButtonForm()
        ],
      )
    );
 }


  Widget _titleAppointment(){
    return TextFormField(
      style: GoogleFonts.quicksand(color: Colors.grey, fontWeight: FontWeight.bold),
      controller: _textTitle,
      onChanged: (val) => setState(() => title = val),
      validator: (String value){
        if (value.isEmpty) {
          return 'Ingrese el título';
        }
        return null;
      },
      autocorrect: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(2.0),
        prefixIcon: Icon(
          MdiIcons.formatTitle,
          color: Colors.grey,
        ),
        labelStyle: GoogleFonts.quicksand(
          color: Colors.grey.withOpacity(0.5),
          fontSize: 15.0,
          fontWeight: FontWeight.bold),
        labelText: 'Título de la cita',
      ),
    );
  }

 Widget _dateInput(context) {
  return MyDateTimePicker(
    dateTime: _date,
    label: 'Fecha y Hora',
    timePicker: true,
    onChange: (date) {
      setState(() {
        _date = date;
      });
      print('Dateee $date');
      },
    );
  }

  Widget _typeInput() {
    return DropdownButtonFormField<String>(
      style: GoogleFonts.quicksand(color: Colors.grey, fontWeight: FontWeight.bold),
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
      value: _selectedValue,
      hint: Text('Tipo', style: GoogleFonts.quicksand(
        color: Colors.grey.withOpacity(0.5),
        fontSize: 15.0,
        fontWeight: FontWeight.bold
        ),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(MdiIcons.noteOutline, color: Colors.grey),
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          consultation = dropdownValue;
          print(dropdownValue);
          print(consultation);
        });
      },
      validator: (String value){
        if (value == null) {
          return 'Seleccione';
        }
        return null;
      },
      items: <String>['Primer Consulta', 'Seguimiento', 'Emergencia']
        .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: GoogleFonts.quicksand(
            color: Colors.grey,
            fontSize: 15.0,
            fontWeight: FontWeight.bold
            ),
          ),
        );
      }).toList(),
    );
  }

 Widget _buildButtonForm() {
    return RaisedButton(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      padding: EdgeInsets.symmetric(vertical: 13.0,),
      child: Text(
        textButton,
        style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        textScaleFactor: 1.2,
      ),
      color: Colors.cyan,
      textColor: Colors.white,
      onPressed: () async {
        if (_formKey.currentState.validate()) {
        setState(() => textButton = 'GUARDANDO...' );
          dynamic result = await db.collection('appointments').document().setData({
            'title': title,
            'date': _date.toString(),
            'type': consultation,
            'user': widget.ctc.documentID,
            'user_name': widget.ctc.data['first_name'],
            'user_last_name': widget.ctc.data['last_name'],
            'user_pic': widget.ctc.data['profile_image'],
          }).then((result) => true ).catchError((err) {
            print('Error al subir la data $err');
            return false;
          }).whenComplete(()  {
             db.collection('users').document(widget.ctc.documentID).collection('appointments').document().setData({
              'title': title,
              'date': _date,
              'type': consultation,
             }).then((result) => true ).catchError((err) {
            print('Error al subir la data $err');
            return false;
          });
          });
          if (result != null) {
            showSnackbar('¡Cita guardada!', myTheme.accentColor, Colors.white, Icon(Feather.check_circle, color: Colors.white,));
            scheduleAlarm();
            setState(() => textButton = 'GUARDAR' );
            Timer(Duration(seconds: 3), () {
              Navigator.pop(context);
            });
          } else {
            showSnackbar('¡No se ha podido guardar!', Colors.redAccent, Colors.white, Icon(Feather.alert_circle, color: Colors.white,));
            setState(() => textButton = 'GUARDAR' );
          }
        } else {
          setState(() => textButton = 'GUARDAR' );
        }
      }
    );
  }

  void showSnackbar(String mensaje, Color color, Color colorMessage, Icon icon) {
    final snackbar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      content: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            icon,
            SizedBox(width: 10.0,),
            Text(
              mensaje,
              style: GoogleFonts.quicksand(
                color: colorMessage,
                fontSize: 16.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        )
      ),
      duration: Duration(milliseconds: 2500),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void scheduleAlarm() async {

    var scheduledNotificationDateTime = _date.add(Duration(seconds: 10));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'logo',
      // sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        // sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Cita',
        '¡Tienes una cita ahora mismo!',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

}
  