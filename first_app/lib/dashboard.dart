// dashboard.dart
import 'package:flutter/material.dart';
import 'magasin.dart'; // Importez la page du magasin ici
import 'ajout.dart'; // Importez la page d'ajout ici
import 'modifproduit.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigation vers la page du magasin
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StorePage(), // Utilisez StorePage ici
                  ),
                );
              },
              child: Text('Page du magasin'),
            ),
            SizedBox(height: 16), // Espacement entre les boutons
            ElevatedButton(
              onPressed: () {
                // Navigation vers la page d'ajout de produit
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddProductPage(), // Utilisez AddProductPage ici
                  ),
                );
              },
              child: Text('Ajouter un produit'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigation vers la page de modification du produit
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifyProductPage(
                        product: Product(
                            id: 1,
                            name: 'Produit',
                            description: 'Description',
                            price: 10.0,
                            quantity: 1)),
                  ),
                );
              },
              child: Text('Modifier produit'),
            ),
          ],
        ),
      ),
    );
  }
}
