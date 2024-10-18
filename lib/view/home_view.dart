// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? _usuario;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _usuario = user;
      });
    });
  }

  Future<void> _logar() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      print('Erro ao fazer login: $e');
    }
  }

  Future<void> _deslogar() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Autenticação Social",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(label: Text('E-mail')),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(label: Text('Senha')),
              ),
              SizedBox(height: 15),
              Center(
                child: _usuario != null
                    ? _DadosUsuarios(
                        _usuario!.photoURL!,
                        _usuario!.displayName!,
                        _usuario!.email!,
                        _deslogar,
                      )
                    : _BotaoLogar(_logar),
              ),
              SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () {},
                label: Text('Entrar'),
                icon: Icon(Icons.login),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _DadosUsuarios(String fotoUsuario, String nomeUsuario, String emailUsuario, Function() deslogar) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(fotoUsuario),
          ),
          SizedBox(height: 16),
          Text(
            'Bem-vindo, ${nomeUsuario}!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            emailUsuario,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: deslogar,
            child: Text("Sair"),
          ),
        ],
      ),
    );
  }

  Widget _BotaoLogar(Function() apertarBotao) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: "Entrar com Google",
          onPressed: apertarBotao,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
