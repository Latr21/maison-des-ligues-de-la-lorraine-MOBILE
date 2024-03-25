import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Définition de la classe Product pour stocker les détails du produit
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
  });
}

class ModifyProductPage extends StatefulWidget {
  // Ajout d'une variable pour stocker les détails du produit
  final Product product;

  // Ajout d'un constructeur qui accepte les détails du produit
  ModifyProductPage({required this.product});

  @override
  _ModifyProductPageState createState() => _ModifyProductPageState();
}

class _ModifyProductPageState extends State<ModifyProductPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Utilisation des détails du produit passés via le constructeur
    _nameController.text = widget.product.name;
    _detailsController.text = widget.product.description;
    _priceController.text = widget.product.price.toString();
    _quantityController.text = widget.product.quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le produit'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom du produit'),
            ),
            TextField(
              controller: _detailsController,
              decoration: InputDecoration(labelText: 'Détails du produit'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Prix'),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantité'),
            ),
            ElevatedButton(
              onPressed: () {
                // Appeler la méthode pour mettre à jour le produit
                _updateProduct();
              },
              child: Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour mettre à jour le produit sur le serveur
  void _updateProduct() async {
    // Construire l'URL pour mettre à jour le produit
    String apiUrl =
        'http://localhost:3000/api/produitsroute/produit/${widget.product.id}';

    // Construire le corps de la requête avec les données mises à jour
    Map<String, dynamic> data = {
      'name': _nameController.text,
      'details': _detailsController.text,
      'price': double.parse(_priceController.text),
      'quantity': int.parse(_quantityController.text),
    };

    // Envoyer la requête PUT pour mettre à jour le produit
    final response = await http.put(
      Uri.parse(apiUrl),
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // Traiter la réponse du serveur
    if (response.statusCode == 200) {
      // Produit mis à jour avec succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produit mis à jour avec succès.'),
        ),
      );
    } else {
      // Erreur lors de la mise à jour du produit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la mise à jour du produit.'),
        ),
      );
    }
  }
}
