import 'package:aversifunciona/recomendacion2.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(recomendacion1());
}

class recomendacion1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => recomendacion1_(),
          );
        },
      ),
    );
  }
}

class recomendacion1_ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '¿Prefieres música nueva o clásicos?',
          style: TextStyle(color: Colors.white), // Color blanco para el texto
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //SizedBox(height: kToolbarHeight), // Espacio igual a la altura de la AppBar
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón "Nueva"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => recomendacion2()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[800], // Utilizando un tono de gris más oscuro
              ),
              child: Text(
                'Nueva',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón "Clásica"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => recomendacion2()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[800], // Utilizando un tono de gris más oscuro
              ),
              child: Text(
                'Clásica',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón "Ambas"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => recomendacion2()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[800], // Utilizando un tono de gris más oscuro
              ),
              child: Text(
                'Ambas',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
