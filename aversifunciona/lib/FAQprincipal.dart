import 'package:aversifunciona/reportarProblema.dart';
import 'package:flutter/material.dart';

import 'faqsApp.dart';
import 'faqsCuenta.dart';
import 'faqsSeguridad.dart';

class FAQprincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              const SizedBox(width: 10),
              const Icon(Icons.account_circle, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              const Text('Ayuda con la cuenta', style: TextStyle(color: Colors.white)),
            ],
          ),
          backgroundColor: Colors.black,
        ),
        body: MainScreen(),
      ),
    );
  }
}


class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(Icons.account_circle, color: Colors.white, size: 30),
            const SizedBox(width: 10),
            const Text('Ayuda con la cuenta', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black,
      ),*/
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            RoundedButton(
              title: 'Ayuda con la cuenta',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQCuenta()),
                );
              },
            ),
            const SizedBox(height: 20),
            RoundedButton(
              title: 'Ayuda con la aplicación',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQApp()),
                );
              },
            ),
            const SizedBox(height: 20),
            RoundedButton(
              title: 'Seguridad y privacidad',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQSeguridad()),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FAQprincipal()),
                      );
                    },
                    child: const Text('Preguntas FAQ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      side: BorderSide.none,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => reportarProblema()),
                      );
                    },
                    child: Text('Reportar Problema'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      side: BorderSide.none,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const RoundedButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}



