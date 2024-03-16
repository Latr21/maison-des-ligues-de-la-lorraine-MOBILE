import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image, // Ajout de l'argument image au constructeur
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ??
          0, // Utilisation de 0 comme valeur par défaut si la valeur est null
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] != null
          ? json['price'].toDouble()
          : 0.0, // Utilisation de 0.0 comme valeur par défaut
      image: json['image'] ??
          '', // Utilisation d'une chaîne vide comme valeur par défaut pour l'image
    );
  }
}

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/api/produitsroute/produit'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        products = data.map((item) => Product.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magasin'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index].name),
            subtitle: Text(products[index].description),
            trailing: CachedNetworkImage(
              imageUrl: 'http://localhost:3000/${products[index].image}',
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: StorePage(),
  ));
}
