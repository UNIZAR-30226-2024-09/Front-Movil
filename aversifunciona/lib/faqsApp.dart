import 'package:flutter/material.dart';


class FAQApp extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      'question': '¿Cómo puedo restablecer mi contraseña en Musify?',
      'answer': 'Puedes restablecer tu contraseña en la pantalla de inicio de sesión de Musify. Haz clic en "¿Olvidaste tu contraseña?" y sigue las instrucciones para restablecerla.'
    },
    {
      'question': '¿Qué debo hacer si tengo problemas para reproducir música en Musify?',
      'answer': 'Si tienes problemas para reproducir música, asegúrate de tener una conexión a internet estable. También puedes intentar cerrar y volver a abrir la aplicación o reiniciar tu dispositivo.'
    },
    {
      'question': '¿Cómo puedo reportar un problema técnico en Musify?',
      'answer': 'Si encuentras un problema técnico en Musify, puedes informarlo al equipo de soporte técnico enviando un correo electrónico a support@musify.com o utilizando la sección de ayuda en la aplicación.'
    },
    {
      'question': '¿Musify está disponible en mi país?',
      'answer': 'Musify está disponible en la mayoría de los países del mundo. Sin embargo, es posible que algunas funciones estén limitadas en ciertas regiones debido a restricciones de licencia.'
    },

    // Puedes agregar más preguntas y respuestas aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 10),
            Icon(Icons.account_circle, color: Colors.white, size: 30), // Icono redondeado de la foto de perfil
            SizedBox(width: 10),
            Text('Ayuda con la aplicación', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Eliminar el botón de retroceso predeterminado
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
