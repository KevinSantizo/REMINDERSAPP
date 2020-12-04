import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_reminders/src/components/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mime_type/mime_type.dart';


import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class NewContact extends StatefulWidget {
  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {

  TextStyle _textStyle =  GoogleFonts.quicksand(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold);

   final  _formKey = GlobalKey<FormState>();
  final TextEditingController _textFirstName = TextEditingController();
  final TextEditingController _textLastName = TextEditingController();
  final TextEditingController _textPhone = TextEditingController();
  final TextEditingController _textEmail = TextEditingController();

  final db = Firestore.instance;


  String textButton = 'GUARDAR';
  String email = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
  String profileImage = '';

  String dropdownValue = 'Masculino';
  String gender = '';


  final picker = ImagePicker();
  File photo;
  var _selectedValue;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  @override
  void dispose() {
    _textFirstName.dispose();
    _textLastName.dispose();
    _textPhone.dispose();
    _textEmail.dispose();
    super.dispose();
  }

  Future<String> subirImagen( File imagen ) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dsnuspy5j/image/upload?upload_preset=eipjsdgz');
    final mimeType = mime(imagen.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType( mimeType[0], mimeType[1] )
    );

    imageUploadRequest.files.add(file);


    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('Algo salio mal');
      print( resp.body );
      return null;
    }

    final respData = json.decode(resp.body);
    print( respData);

    return respData['secure_url'];


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 3.0,
        backgroundColor: Colors.cyan,
        title: Text('Nuevo contacto', style: _textStyle),
        // automaticallyImplyLeading: false,
      ),
      body: Container(
        child: FadeInUp(
          child: Container(
            child: Column(
              children: [ 
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeTop: true,
                      child: ListView(
                        children: [
                          _formNewContact()
                        ],
                      )
                    ),
                  ),
                )
              ]
            )
          ),
        ),
      ),
    );
  }
  
   Widget _formNewContact() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 15.0),
          GestureDetector(
            onTap: showCameraOrGallery,
            child: _profileImage()
          ),
          SizedBox(height: 15.0),
          Divider(),
          SizedBox(height: 15.0),
          _firstName(),
          SizedBox(height: 15.0),
          _lastName(),
          SizedBox(height: 15.0),
          _phone(),
          SizedBox(height: 15.0),
          _email(),
          SizedBox(height: 15.0),
          _gender(),
          SizedBox(height: 15.0),
          Divider(),
          SizedBox(height: 15.0),
          _buildButtonForm()
        ],
      )
    );
  }

  Widget _profileImage(){
  if (photo == null) {    
    return Container(
      padding: EdgeInsets.all(45.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: myTheme.accentColor
      ),
      child: Icon(Feather.camera, color: Colors.white, size: 35.0)
    );
    } else {
      return Container(
        child: CircleAvatar(
          radius: 70.0,
          backgroundImage: new FileImage(photo)
        )   
      );
    }
  }

  Widget _firstName(){
    return TextFormField(
      style: GoogleFonts.quicksand(color: Colors.grey, fontWeight: FontWeight.bold),
      controller: _textFirstName,
      onChanged: (val) => setState(() => firstName = val),
      validator: (String value){
        if (value.isEmpty) {
          return 'Ingrese los nombres';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(2.0),
          prefixIcon: Icon(
            Feather.user,
            color: Colors.grey,
          ),
          labelStyle: GoogleFonts.quicksand(
            color: Colors.grey.withOpacity(0.5),
            fontSize: 15.0,
            fontWeight: FontWeight.bold),
        labelText: 'Nombres',
      )
    );
  }

  Widget _lastName(){
    return TextFormField(
      style: GoogleFonts.quicksand(color: Colors.grey, fontWeight: FontWeight.bold),
      controller: _textLastName,
      onChanged: (val) => setState(() => lastName = val),
      validator: (String value){
        if (value.isEmpty) {
          return 'Ingrese los apellidos';
        }
        return null;
      },
      autocorrect: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(2.0),
        prefixIcon: Icon(
          Feather.user,
          color: Colors.grey,
        ),
        labelStyle: GoogleFonts.quicksand(
          color: Colors.grey.withOpacity(0.5),
          fontSize: 15.0,
          fontWeight: FontWeight.bold),
        labelText: 'Apellidos',
      ),
    );
  }

  Widget _phone(){
    return TextFormField(
      style: GoogleFonts.quicksand(color: Colors.grey, fontWeight: FontWeight.bold),
      controller: _textPhone,
      keyboardType: TextInputType.number,
      onChanged: (val) => setState(() => phone = val),
      validator: (String value){
        if (value.isEmpty) {
          return 'Ingrese el número de teléfono';
        }
        return null;
      },
      autocorrect: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2.0),
          prefixIcon: Icon(
            Feather.phone,
            color: Colors.grey,
          ),
          labelStyle: GoogleFonts.quicksand(
            color: Colors.grey.withOpacity(0.5),
            fontSize: 15.0,
            fontWeight: FontWeight.bold),
          labelText: 'Número de teléfono',
        ),
    );
  }

  Widget _email(){
    return TextFormField(
      style: GoogleFonts.quicksand(color: Colors.grey, fontWeight: FontWeight.bold),
      keyboardType: TextInputType.emailAddress,
      controller: _textEmail,
      onChanged: (val) => setState(() => email = val),
      validator: (String value){
        if (value.isEmpty) {
          return 'Ingrese el email';
        } if (!value.contains(new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'))) {
          return 'Ingrese un correo válido (correo123@gmail.com)';
        }
        return null;
      },
      autocorrect: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(2.0),
        prefixIcon: Icon(
          Feather.mail,
          color: Colors.grey,
        ),
        labelStyle: GoogleFonts.quicksand(
          color: Colors.grey.withOpacity(0.5),
          fontSize: 15.0,
          fontWeight: FontWeight.bold),
        labelText: 'E-mail',
      ),
    );
  }
  
  Widget _gender() {
    return DropdownButtonFormField<String>(
      style: GoogleFonts.quicksand(color: Colors.grey, fontWeight: FontWeight.bold),
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
      decoration: InputDecoration(
        prefixIcon: Icon(MdiIcons.genderMaleFemale, color: Colors.grey),
      ),
      value: _selectedValue,
      hint: Text('Género', style: GoogleFonts.quicksand(
        color: Colors.grey.withOpacity(0.5),
        fontSize: 15.0,
        fontWeight: FontWeight.bold
        ),
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          gender = dropdownValue;
          print(dropdownValue);
          print(gender);
        });
      },
      validator: (String value){
        if (value == null) {
          return 'Seleccione un género';
        }
        return null;
      },
      items: <String>['Masculino', 'Femenino']
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
          if (photo != null) {
            profileImage = await subirImagen(photo);
          }
          dynamic result = await db.collection('users').document().setData({
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'phone': phone,
            'gender': gender,
            'profile_image': profileImage

          }).then((result) => true ).catchError((err) {
            print('Error al subir la data $err');
            return false;
          });
          if (result != null) {
            showSnackbar('¡Contacto guardado!', myTheme.accentColor, Colors.white, Icon(Feather.check_circle, color: Colors.white,));
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

  void showCameraOrGallery() {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) =>
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async { 
                      await _takeNewPhoto();
                      setState(() { });
                    },
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: myTheme.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Feather.camera, size: 35.0, color: myTheme.accentColor),
                          Container(
                            child: Text('Nueva', style: GoogleFonts.quicksand(fontSize: 20.0, color: myTheme.accentColor)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _selectFromGallery,
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: myTheme.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Feather.image, size: 35.0, color: myTheme.accentColor),
                          Container(
                            child: Text('Galería', style: GoogleFonts.quicksand(fontSize: 20.0, color: myTheme.accentColor)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
  _selectFromGallery() async {
    Navigator.pop(context);
    setState((){
      _proccessImage(ImageSource.gallery);
    });
  }

  _takeNewPhoto() async {
    Navigator.pop(context);
    setState((){
      _proccessImage(ImageSource.camera);
    });
  }

  Future _proccessImage( ImageSource origin ) async {
    final pickedFile = await picker.getImage(source: origin);
    // if ( photo != null ) { user.profile_pic = null; }
    setState(() => pickedFile != null ? photo = File(pickedFile?.path) : print('No image selected'));
  }
}