import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvp/loginForm.dart';
import 'package:mvp/profil.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:tflite_v2/tflite_v2.dart';
//import 'package:tflite_v2/tflite_v2.dart';

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
  var recognitions;
  var cat = "";

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      print('Model loaded.');
    });
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: 'assets/model.tflite',
        labels: 'assets/labels.txt',
      );
      print('Model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  runModelOnImageUrl(String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Decode the downloaded image
        var image = img.decodeImage(response.bodyBytes);
        if (image == null) {
          print('Failed to decode image');
          return;
        }

        // Resize the image
        var resizedImage = img.copyResize(image, width: 224, height: 224);

        // Save the resized image to a local file
        var tempDir = await getTemporaryDirectory();
        var tempFilePath = '${tempDir.path}/resized_image.jpg';
        File(tempFilePath).writeAsBytesSync(img.encodeJpg(resizedImage));

        // Classify the resized image
        await classifyImage(tempFilePath);
      } else {
        print('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during image download: $e');
    }
  }

  classifyImage(String imagePath) async {
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: imagePath,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.05,
        asynch: true,
      );

      print('Model output: $recognitions'); // Debug print

      setState(() {
        this.recognitions = recognitions;
        cat = this.recognitions[0]['label'];
      });
    } catch (e) {
      print('Error during image classification: $e');
    }
    print('Catégorie: $cat');
  }

  @override
  Widget build(BuildContext context) {
    String userId = widget.user.email!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(116, 179, 201, 1.000),
        title: Text(
          'Ajouter une activité',
          textAlign: TextAlign.justify,
          style: GoogleFonts.satisfy(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(116, 179, 201, 1.000)),
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainApp()),
              );
            },
            icon: Icon(Icons.logout_rounded),
            label: Text("Se déconnecter", style: GoogleFonts.satisfy()),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
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
                    label: Text(
                      "Valider",
                      style: GoogleFonts.satisfy(),
                    ),
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
          borderSide: BorderSide(
              color: Color.fromRGBO(116, 179, 201, 1.000), width: 2.0),
        ),
      ),
      style: GoogleFonts.singleDay(),
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
          borderSide: BorderSide(
              color: Color.fromRGBO(116, 179, 201, 1.000), width: 2.0),
        ),
      ),
      style: GoogleFonts.singleDay(),
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
          borderSide: BorderSide(
              color: Color.fromRGBO(116, 179, 201, 1.000), width: 2.0),
        ),
      ),
      style: GoogleFonts.singleDay(),
      enabled: false,
    );
  }

  void _addActivity() async {
    String titre = _titreController.text;
    String lieu = _lieuController.text;
    double prix = double.tryParse(_prixController.text) ?? 0.0;
    int nombreMin = int.tryParse(_nombreMinController.text) ?? 0;
    String imageUrl = _imageUrlController.text;

    if (titre.isNotEmpty &&
        lieu.isNotEmpty &&
        prix > 0 &&
        nombreMin > 0 &&
        imageUrl.isNotEmpty) {
      await runModelOnImageUrl(imageUrl);

      // Access the category after the image classification is complete
      String categorie = cat;

      print('Champs remplis:');
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
      // ...
    }
  }
}
