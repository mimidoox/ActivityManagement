import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mvp/loginForm.dart';
import 'package:mvp/profil.dart';

import 'bottomNav.dart';
import 'main.dart';

class Activite {
  String titre;
  String lieu;
  double prix;
  int nbrMin;
  String categorie;
  String image;

  Activite({
    required this.titre,
    required this.lieu,
    required this.prix,
    required this.nbrMin,
    required this.categorie,
    required this.image,
  });
}

class AddActivityForm extends StatefulWidget {
  @override
  _AddActivityFormState createState() => _AddActivityFormState();
  User user = FirebaseAuth.instance.currentUser!;
}

class _AddActivityFormState extends State<AddActivityForm> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _lieuController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _nombreMinController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String userId = widget.user.email!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajouter une activité',
          textAlign: TextAlign.justify,
        ),
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainApp()),
              );
            },
            icon: Icon(Icons.logout_rounded),
            label: Text("Se déconnecter"),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_titreController, 'Titre'),
            SizedBox(height: 16.0),
            _buildTextField(_lieuController, 'Lieu'),
            SizedBox(height: 16.0),
            _buildNumberTextField(
              _nombreMinController,
              'Nombre de personnes (minimum)',
              false,
            ),
            SizedBox(height: 16.0),
            _buildNumberTextField(
              _prixController,
              'Prix',
              true,
            ),
            SizedBox(height: 16.0),
            _buildTextField(_imageUrlController, 'Url de l\'image'),
            SizedBox(height: 16.0),
            _buildDisabledTextField(_categorieController, 'Catégorie'),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _addActivity();
                  },
                  icon: Icon(Icons.add),
                  label: Text("Valider"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    fixedSize: Size(160, 40),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(userId: userId),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfile()),
            );
          }
        },
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
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildNumberTextField(
    TextEditingController controller,
    String label,
    bool isDecimal,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      keyboardType: isDecimal
          ? TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      inputFormatters: isDecimal
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ]
          : <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
    );
  }

  Widget _buildDisabledTextField(
    TextEditingController controller,
    String label,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      enabled: false,
    );
  }

  void _addActivity() {
    String titre = _titreController.text;
    String lieu = _lieuController.text;
    double prix = double.tryParse(_prixController.text) ?? 0.0;
    int nombreMin = int.tryParse(_nombreMinController.text) ?? 0;
    String categorie = _categorieController.text;
    String imageUrl = _imageUrlController.text;

    if (titre.isNotEmpty &&
        lieu.isNotEmpty &&
        prix > 0 &&
        nombreMin > 0 &&
        categorie.isNotEmpty &&
        imageUrl.isNotEmpty) {
      FirebaseFirestore.instance.collection('activites').add({
        'titre': titre,
        'lieu': lieu,
        'prix': prix,
        'nbrMin': nombreMin,
        'categorie': categorie,
        'image': imageUrl,
      }).then((value) {
        Navigator.pop(context);
      }).catchError((error) {
        print('Erreur d\'ajout: $error');
      });
    } else {
      print('Champs non remplis:');
      print('Titre: $titre');
      print('Lieu: $lieu');
      print('Prix: $prix');
      print('Nombre minimum: $nombreMin');
      print('Catégorie: $categorie');
      print('Image URL: $imageUrl');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs du formulaire.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
