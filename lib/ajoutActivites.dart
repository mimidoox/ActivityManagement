import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvp/loginForm.dart';
import 'package:mvp/profil.dart';

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
        title: Text('Ajouter une activité'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titreController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: _lieuController,
              decoration: InputDecoration(labelText: 'Lieu'),
            ),
            TextField(
              controller: _prixController,
              decoration: InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _nombreMinController,
              decoration: InputDecoration(labelText: 'Nombre minimum'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _categorieController,
              decoration: InputDecoration(labelText: 'Catégorie'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'URL de l\'image'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addActivity();
              },
              child: Text('Valider et Ajouter'),
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
          } else if (index == 2) {
            // Naviguer vers la page d'ajout d'activité (pour le profil dans cet exemple)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfile()),
            );
          }
        },
      ),
    );
  }

  void _addActivity() {
    // Récupérer les valeurs des champs du formulaire
    String titre = _titreController.text;
    String lieu = _lieuController.text;
    double prix = double.tryParse(_prixController.text) ?? 0.0;
    int nombreMin = int.tryParse(_nombreMinController.text) ?? 0;
    String categorie = _categorieController.text;
    String imageUrl = _imageUrlController.text;

    // Vérifier si tous les champs sont remplis
    if (titre.isNotEmpty &&
        lieu.isNotEmpty &&
        prix > 0 &&
        nombreMin > 0 &&
        categorie.isNotEmpty &&
        imageUrl.isNotEmpty) {
      // Ajouter l'activité à Firestore
      FirebaseFirestore.instance.collection('activites').add({
        'titre': titre,
        'lieu': lieu,
        'prix': prix,
        'nbrMin': nombreMin,
        'categorie': categorie,
        'image': imageUrl,
      }).then((value) {
        // Fermer le formulaire après l'ajout réussi
        Navigator.pop(context);
      }).catchError((error) {
        // Gérer les erreurs d'ajout
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
      // Afficher un message si tous les champs ne sont pas remplis
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs du formulaire.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
