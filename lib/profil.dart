import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mvp/ajoutActivites.dart';

import 'loginForm.dart';

class UserProfile extends StatefulWidget {
  final String userId = FirebaseAuth.instance.currentUser?.email ?? '';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _dateNaissanceController;
  late TextEditingController _paysController;
  late TextEditingController _villeController;
  late TextEditingController _telephoneController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController();
    _prenomController = TextEditingController();
    _dateNaissanceController = TextEditingController();
    _paysController = TextEditingController();
    _villeController = TextEditingController();
    _telephoneController = TextEditingController();
    _imageUrlController = TextEditingController();

    // Charger les données de l'utilisateur au moment de l'initialisation
    _loadUserData();
  }

  void _loadUserData() async {
    // Récupérer les données de l'utilisateur depuis Firestore
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(widget.userId)
        .get();

    // Mettre à jour les contrôleurs avec les données récupérées
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
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
  }

  @override
  Widget build(BuildContext context) {
    String userId = widget.userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
        backgroundColor: Colors.blue, // Change app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImage(),
            SizedBox(height: 16.0), // Add spacing here
            _buildTextField(_nomController, 'Nom'),
            SizedBox(height: 16.0), // Add spacing here
            _buildTextField(_prenomController, 'Prénom'),
            SizedBox(height: 16.0), // Add spacing here
            _buildDateTextField(_dateNaissanceController, 'Date de Naissance'),
            SizedBox(height: 16.0), // Add spacing here
            _buildTextField(_paysController, 'Pays'),
            SizedBox(height: 16.0), // Add spacing here
            _buildTextField(_villeController, 'Ville'),
            SizedBox(height: 16.0), // Add spacing here
            _buildTextField(_telephoneController, 'Téléphone'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updateUserData();
              },
              child: Text('Mettre à jour'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Change button color
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity),
            label: 'Activités',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Ajout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Naviguer vers la page de la liste d'activités
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        userId: userId,
                      )),
            );
          } else if (index == 1) {
            // Naviguer vers la page d'ajout d'activité (pour le profil dans cet exemple)
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddActivityForm()
                      )
            );
          }
        },
      ),
    );
  }

  Widget _buildImage() {
    String photoUrl = _imageUrlController.text;

    return photoUrl.isNotEmpty
        ? CircleAvatar(
            radius: 75.0,
            backgroundImage: NetworkImage(photoUrl),
          )
        : FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('utilisateurs')
                .doc(widget.userId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Future is still loading
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Error in fetching data
                return Icon(
                  Icons.error_outline,
                  size: 100.0,
                  color: Colors.red,
                );
              } else {
                // Check if the 'photo' field is not empty in the Firestore document
                String photoUrlFromFirestore =
                    snapshot.data?['photo'] ?? ''; // Adjust the field name

                return photoUrlFromFirestore.isNotEmpty
                    ? CircleAvatar(
                        radius: 75.0,
                        backgroundImage: NetworkImage(photoUrlFromFirestore),
                      )
                    : CircleAvatar(
                        radius: 75.0,
                        backgroundColor: Colors
                            .grey, // Set a default color for the container
                        child: Icon(
                          Icons.person,
                          size: 100.0,
                          color: Colors.white,
                        ),
                      );
              }
            },
          );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildDateTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () => _pickDate(context),
      readOnly: true, // To make it non-editable
    );
  }

  void _updateUserData() {
    // Mettre à jour les données de l'utilisateur dans Firestore
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
    }).then((value) {
      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Informations mises à jour avec succès.'),
          duration: Duration(seconds: 3),
        ),
      );
    }).catchError((error) {
      // Gérer les erreurs de mise à jour
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

      // Clear focus to dismiss the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
}
