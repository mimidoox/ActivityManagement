import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ListeActivites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('activites').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var activites = snapshot.data!.docs;

          return ListView.builder(
            itemCount: activites.length,
            itemBuilder: (context, index) {
              var activite = activites[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  _showDetailsDialog(context, activite);
                },
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Afficher l'image de l'activité à partir de l'URL
                      Image.network(
                        activite['image'],
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(activite['titre']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                  '${activite['prix']}€ - ${activite['lieu']}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fonction pour afficher les détails dans une boîte de dialogue
  void _showDetailsDialog(BuildContext context, Map<String, dynamic> activite) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Détails de l\'activité'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                activite['image'],
                width: 200, // Ajustez la largeur selon vos besoins
                height: 200, // Ajustez la hauteur selon vos besoins
                fit: BoxFit
                    .cover, // Ajustez le mode d'ajustement selon vos besoins
              ),
              SizedBox(height: 16),
              Text('${activite['titre']}'),
              SizedBox(height: 8),
              Text('aura lieu à ${activite['lieu']}'),
              SizedBox(height: 8),
              Text('- ${activite['categorie']}'),
              SizedBox(height: 8),
              Text(
                  '- le nombre minimal des personnes est ${activite['nbrMin']}'),
              SizedBox(height: 8),
              Text('- le prix du ticket est ${activite['prix']}€ par heure'),
              // Ajoutez d'autres champs ici
            ],
          ),
        );
      },
    );
  }
}
