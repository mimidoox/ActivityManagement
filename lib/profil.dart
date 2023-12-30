import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mvp/ajoutActivites.dart';
import 'package:mvp/bottomNav.dart';
import 'package:mvp/main.dart';

import 'loginForm.dart';

class UserProfile extends StatefulWidget {
  final String userId = FirebaseAuth.instance.currentUser?.email ?? '';
  final String userPassword = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late TextEditingController _idController;
  late TextEditingController _passwordController;
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _dateNaissanceController;
  late TextEditingController _paysController;
  late TextEditingController _villeController;
  late TextEditingController _telephoneController;
  late TextEditingController _adresseController;
  late TextEditingController _codePostalController;
  late TextEditingController _imageUrlController;
  final SizedBox _sizedBox = SizedBox(height: 16.0);
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _passwordController = TextEditingController();
    _nomController = TextEditingController();
    _prenomController = TextEditingController();
    _dateNaissanceController = TextEditingController();
    _paysController = TextEditingController();
    _villeController = TextEditingController();
    _telephoneController = TextEditingController();
    _adresseController = TextEditingController();
    _codePostalController = TextEditingController();
    _imageUrlController = TextEditingController();

    // Load user data during initialization
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      // Retrieve user data from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(widget.userId)
          .get();

      // Check if the document exists
      if (!userSnapshot.exists) {
        print('User document does not exist for ID: ${widget.userId}');

        // Create a new document for the user with empty fields
        await FirebaseFirestore.instance
            .collection('utilisateurs')
            .doc(widget.userId)
            .set({
          'nom': '',
          'prenom': '',
          'dateNaissance': Timestamp.fromDate(DateTime.now()),
          'pays': '',
          'ville': '',
          'telephone': '',
          'photo': '',
          'adresse': '',
          'codePostal': '',
        });

        print('New user document created for ID: ${widget.userId}');
      } else {
        // Update controllers with retrieved data
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        _idController.text = widget.userId;
        _passwordController.text = FirebaseAuth.instance.currentUser?.uid ?? '';
        _nomController.text = userData['nom'];
        _prenomController.text = userData['prenom'];

        // Format the date and set it to the controller
        Timestamp timestamp = userData['dateNaissance'];
        DateTime dateNaissance = timestamp.toDate();
        _dateNaissanceController.text =
            DateFormat('dd/MM/yyyy').format(dateNaissance);

        _paysController.text = userData['pays'];
        _villeController.text = userData['ville'];
        _telephoneController.text = userData['telephone'];
        _imageUrlController.text = userData['photo'];
        _adresseController.text = userData['adresse'];
        _codePostalController.text = userData['codePostal'];
      }
    } catch (error) {
      print('Error loading user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = widget.userId;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Mon Profil',
          style: GoogleFonts.satisfy(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.justify,
        ),
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(116, 179, 201, 1.000)),
            ),
            onPressed: _updateUserData,
            child: Text('Valider', style: GoogleFonts.satisfy()),
          )
        ],
        backgroundColor: Color.fromRGBO(116, 179, 201, 1.000),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImage(),
                _sizedBox,
                _buildTextField(_idController, 'Login'),
                _sizedBox,
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(116, 179, 201, 1.000),
                          width: 2.0),
                    ),
                  ),
                  style: GoogleFonts.singleDay(),
                  obscureText: true,
                ),
                _sizedBox,
                _buildTextField(_nomController, 'Nom'),
                _sizedBox,
                _buildTextField(_prenomController, 'Prénom'),
                _sizedBox,
                _buildDateTextField(
                    _dateNaissanceController, 'Date de Naissance'),
                _sizedBox,
                _buildTextField(_paysController, 'Pays'),
                _sizedBox,
                _buildTextField(_villeController, 'Ville'),
                _sizedBox,
                _buildTextField(_adresseController, 'Adresse'),
                _sizedBox,
                _buildTextField(_telephoneController, 'Télephone'),
                _sizedBox,
                TextField(
                  controller: _codePostalController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Code Postal',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(116, 179, 201, 1.000),
                          width: 2.0),
                    ),
                  ),
                  style: GoogleFonts.singleDay(),
                ),
                _sizedBox,
                _buildTextField(_imageUrlController, 'Photo de profil'),
                _sizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainApp()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      icon: Icon(Icons.logout_rounded),
                      label:
                          Text("Se déconnecter", style: GoogleFonts.satisfy()),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        fixedSize: Size(180, 40),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        userId: userId,
                      )),
            );
          } else if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddActivityForm()));
          }
        },
      ),
    );
  }

  Widget _buildImage() {
    String photoUrl = _imageUrlController.text;

    try {
      return photoUrl.isNotEmpty
          ? CircleAvatar(
              radius: 75.0,
              child: ClipOval(
                child: Image.network(
                  photoUrl,
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Handle image loading errors
                    return _buildFallbackImage();
                  },
                ),
              ),
            )
          : FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('utilisateurs')
                  .doc(widget.userId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return _buildFallbackImage();
                } else {
                  String photoUrlFromFirestore = snapshot.data?['photo'] ?? '';

                  return photoUrlFromFirestore.isNotEmpty
                      ? CircleAvatar(
                          radius: 75.0,
                          child: ClipOval(
                            child: Image.network(
                              photoUrlFromFirestore,
                              width: 150.0,
                              height: 150.0,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Handle image loading errors
                                return _buildFallbackImage();
                              },
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 75.0,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            size: 100.0,
                            color: Colors.white,
                          ),
                        );
                }
              },
            );
    } catch (error) {
      // Handle any other errors that might occur
      return _buildFallbackImage();
    }
  }

  Widget _buildFallbackImage() {
    return CircleAvatar(
      radius: 75.0,
      backgroundColor: Colors.grey,
      child: Icon(
        Icons.person,
        size: 100.0,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromRGBO(116, 179, 201, 1.000), width: 2.0),
          ),
        ),
        style: GoogleFonts.singleDay());
  }

  Widget _buildDateTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Color.fromRGBO(116, 179, 201, 1.000), width: 2.0),
        ),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      style: GoogleFonts.singleDay(),
      onTap: () => _pickDate(context),
      readOnly: true,
    );
  }

  void _updateUserData() {
    FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(widget.userId)
        .update({
      'nom': _nomController.text,
      'prenom': _prenomController.text,
      'dateNaissance': Timestamp.fromDate(
          DateFormat('dd/MM/yyyy').parse(_dateNaissanceController.text)),
      'pays': _paysController.text,
      'ville': _villeController.text,
      'telephone': _telephoneController.text,
      'photo': _imageUrlController.text,
      'adresse': _adresseController.text,
      'codePostal': _codePostalController.text,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Informations mises à jour avec succès.'),
          duration: Duration(seconds: 3),
        ),
      );
    }).catchError((error) {
      print('Erreur de mise à jour: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la mise à jour. Veuillez réessayer.'),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (pickedDate != null) {
      setState(() {
        _dateNaissanceController.text =
            DateFormat('dd/MM/yyyy').format(pickedDate);
      });

      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
}
