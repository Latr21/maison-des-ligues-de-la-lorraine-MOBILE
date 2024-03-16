import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _detailsController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  XFile? _image;
  String? _imagePath; // Chemin de l'image sélectionnée

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _detailsController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
        _imagePath = pickedFile.path; // Mettre à jour le chemin de l'image
      });
    }
  }

  Future<void> _submitProduct() async {
    // Vérifier si les champs requis sont tous renseignés
    if (_nameController.text.isEmpty ||
        _detailsController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _image == null) {
      print('Veuillez remplir tous les champs.');
      return;
    }

    // Ajout des logs pour vérifier les données avant l'envoi au backend
    print('Name: ${_nameController.text}');
    print('details: ${_detailsController.text}');
    print('Price: ${_priceController.text}');
    print('Quantity: ${_quantityController.text}');
    print('Image path: $_imagePath');

    try {
      final url = Uri.parse('http://localhost:3000/api/produitsroute/produit');

      // Convertir l'image sélectionnée en bytes
      List<int> imageBytes = await _image!.readAsBytes();

      // Créer un multipart request pour l'envoi de l'image
      final imageUploadRequest = http.MultipartRequest('POST', url);

      // Ajouter l'image au multipart request
      final imagePart = http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'product_image.jpg', // Nom du fichier à envoyer
      );
      imageUploadRequest.files.add(imagePart);

      // Ajouter les autres données du produit au multipart request
      imageUploadRequest.fields['name'] = _nameController.text;
      imageUploadRequest.fields['details'] = _detailsController.text;
      imageUploadRequest.fields['price'] = _priceController.text;
      imageUploadRequest.fields['quantity'] = _quantityController.text;

      // Envoyer la requête multipart
      final streamedResponse = await imageUploadRequest.send();

      // Attendre la réponse
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Gérer la réponse réussie
        print('Produit ajouté avec succès.');
      } else {
        // Gérer les erreurs de requête
        print('Erreur lors de l\'ajout du produit: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Gérer les erreurs
      print('Erreur lors de l\'ajout du produit: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un produit'),
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
              decoration: InputDecoration(labelText: 'details'),
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
              onPressed: _selectImage,
              child: Text('Sélectionner une image'),
            ),
            SizedBox(height: 16.0),
            // Affichage de la prévisualisation de l'image
            _imagePath != null ? Image.network(_imagePath!) : Container(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _submitProduct();
              },
              child: Text('Ajouter le produit'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AddProductPage(),
  ));
}
