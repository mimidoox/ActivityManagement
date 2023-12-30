import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvp/main.dart';
import 'package:mvp/profil.dart';
import 'package:provider/provider.dart';
import 'bottomNav.dart';
import 'listeActivites.dart';
import 'ajoutActivites.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
              labelText: 'Login',
              labelStyle:
                  TextStyle(color: Color.fromRGBO(255, 255, 255, 0.829)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(116, 179, 201, 1.000), width: 2.0),
              )),
          style: GoogleFonts.singleDay(),
          cursorColor: Color.fromRGBO(116, 179, 201, 1.000),
        ),
        SizedBox(height: 16.0),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.829)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromRGBO(116, 179, 201, 1.000), width: 2.0),
            ),
          ),
          style: GoogleFonts.singleDay(),
          cursorColor: Color.fromRGBO(116, 179, 201, 1.000),
          obscureText: true,
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
            onPressed: () async {
              try {
                UserCredential userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _usernameController.text,
                  password: _passwordController.text,
                );

                // Set the user ID in the UserProvider
                String userId = userCredential.user?.email ?? '';

                // Navigate to HomeScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            userId: userId,
                          )),
                );
              } catch (e) {
                // Handle login error
                print('Error during login: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Login failed. Please try again.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            child: Text('Se connecter', style: GoogleFonts.satisfy()),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(116, 179, 201, 1.000)),
            )),
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({required this.userId});
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(116, 179, 201, 1.000),
        title: Text(
          'Toutes les activités',
          style: GoogleFonts.satisfy(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.justify,
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
      body: ListeActivites(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (value) => {
          if (value == 1)
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddActivityForm()),
              )
            }
          else if (value == 2)
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              )
            }
        },
      ),
    );
  }
}
