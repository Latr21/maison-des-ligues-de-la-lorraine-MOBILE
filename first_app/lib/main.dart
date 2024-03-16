import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dashboard.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
            ),
            obscureText: true,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre mot de passe';
              }
              return null;
            },
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Process login
                String email = _emailController.text;
                String password = _passwordController.text;
                // You can add your login logic here
                print('Email: $email, Mot de passe: $password');

                // Log pour vérifier l'accès au serveur
                print('Trying to access server...');

                // Exemple de requête HTTP vers le serveur
                _login(email, password);
              }
            },
            child: Text('Se connecter'),
          ),
        ],
      ),
    );
  }

  // Méthode pour effectuer une requête de connexion au serveur
  void _login(String email, String password) async {
    try {
      // URL de l'API sur votre serveur
      String apiUrl = 'http://localhost:3000/api/usersroute/connexion';

      // Données à envoyer au serveur
      Map<String, String> data = {
        'email': email,
        'password': password,
      };

      // Envoi de la requête POST au serveur
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Log de la réponse du serveur
      print('Server Response: ${response.statusCode}');
      print('Server Data: ${response.body}');

      // Vérifier si la connexion a réussi (par exemple, si le code de statut est 200)
      if (response.statusCode == 200) {
        // Si la connexion réussit, redirigez l'utilisateur vers la page de tableau de bord
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        // Sinon, affichez un message d'erreur à l'utilisateur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Identifiants incorrects. Veuillez réessayer.'),
          ),
        );
      }
    } catch (e) {
      // Log en cas d'erreur
      print('Error accessing server: $e');

      // Afficher un message d'erreur à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Une erreur s\'est produite lors de la connexion. Veuillez réessayer.'),
        ),
      );
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulaire de connexion',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Formulaire de connexion'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LoginForm(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
