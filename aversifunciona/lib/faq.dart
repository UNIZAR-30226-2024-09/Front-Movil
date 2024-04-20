import 'package:flutter/material.dart';


class Faq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FAQScreen(),
    );
  }
}

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      'question': '¿Qué es Musify?',
      'answer': 'Musify es una aplicación de streaming de música que te permite acceder a una amplia biblioteca de canciones y álbumes de diferentes artistas.'
    },
    {
      'question': '¿Cómo puedo descargar Musify?',
      'answer': 'Puedes descargar Musify desde la tienda de aplicaciones de tu dispositivo. Está disponible tanto para iOS como para Android.'
    },
    {
      'question': '¿Es necesario tener una cuenta para usar Musify?',
      'answer': 'Puedes explorar y escuchar música en Musify sin una cuenta, pero necesitarás crear una cuenta gratuita para acceder a ciertas funciones, como crear listas de reproducción personalizadas.'
    },
    {
      'question': '¿Puedo compartir mi cuenta de Musify con otros usuarios?',
      'answer': 'No, compartir cuentas de Musify viola los términos de servicio. Cada cuenta está destinada a ser utilizada por una sola persona.'
    },
    {
      'question': '¿Musify tiene una versión web?',
      'answer': 'Sí, además de las aplicaciones para dispositivos móviles, Musify también tiene una versión web que puedes acceder desde tu navegador en cualquier dispositivo.'
    },
    {
      'question': '¿Cómo puedo buscar canciones en Musify?',
      'answer': 'Puedes buscar canciones en Musify utilizando la barra de búsqueda en la parte superior de la pantalla. Simplemente ingresa el nombre del artista, álbum o canción que estás buscando.'
    },
    {
      'question': '¿Puedo escuchar música en Musify sin conexión a internet?',
      'answer': 'Con Musify Premium, puedes descargar canciones y álbumes para escucharlos sin conexión a internet. La versión gratuita requiere conexión a internet para reproducir música.'
    },
    // Puedes agregar más preguntas y respuestas aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preguntas Frecuentes'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              faqList[index]['question']!,
              style: TextStyle(color: Colors.white),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  faqList[index]['answer']!,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
