import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          decoration: InputDecoration(labelText: 'Login'),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
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
          child: const Text('Se connecter'),
        ),
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
        title: const Text(
          'Toutes les activités',
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
