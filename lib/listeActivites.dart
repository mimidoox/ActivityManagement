import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ListeActivites extends StatefulWidget {
  @override
  _ListeActivitesState createState() => _ListeActivitesState();
}

class _ListeActivitesState extends State<ListeActivites> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoriesList(),
            Expanded(
              child: _buildActivitiesList(selectedCategory),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('activites').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var categories = snapshot.data!.docs;
        Set<String> uniqueCategories = {'All'};

        for (var category in categories) {
          uniqueCategories.add(category['categorie']);
        }

        return Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var category in uniqueCategories)
                _buildCategoryItem(category),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = category;
          });
        },
        child: Chip(
          label: Text(category,
              style: GoogleFonts.satisfy(
                fontSize: 14,
                //fontWeight: FontWeight.bold,
              )),
          backgroundColor: selectedCategory == category
              ? Color.fromARGB(255, 94, 152, 199)
              : Theme.of(context).chipTheme.backgroundColor,
        ),
      ),
    );
  }

  Widget _buildActivitiesList(String categoryFilter) {
    Query activitiesQuery = FirebaseFirestore.instance.collection('activites');

    if (categoryFilter != 'All') {
      activitiesQuery =
          activitiesQuery.where('categorie', isEqualTo: categoryFilter);
    }

    return StreamBuilder(
      stream: activitiesQuery.snapshots(),
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
                        title: Text(
                          activite['titre'],
                          style: GoogleFonts.sevillana(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text('${activite['prix']}€ - ${activite['lieu']}',
                                style: GoogleFonts.singleDay(fontSize: 16)),
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
    );
  }

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> activite) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(116, 179, 201, 1.000),
          title: Text('Détails de l\'activité',
              style: GoogleFonts.satisfy(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                activite['image'],
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              SizedBox(height: 16),
              Text('${activite['titre']}',
                  style: GoogleFonts.sevillana(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 8),
              Text('aura lieu à ${activite['lieu']}',
                  style: GoogleFonts.singleDay(fontSize: 16)),
              SizedBox(height: 8),
              Text('- ${activite['categorie']}',
                  style: GoogleFonts.singleDay(fontSize: 16)),
              SizedBox(height: 8),
              Text(
                '- le nombre min des personnes est ${activite['nbrMin']}',
                style: GoogleFonts.singleDay(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '- le prix du ticket est ${activite['prix']}€ par heure',
                style: GoogleFonts.singleDay(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}
