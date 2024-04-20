import 'package:flutter/material.dart';


class FAQSeguridad extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      'question': '¿Cómo protege Musify mis datos personales?',
      'answer': 'Musify sigue estrictos protocolos de seguridad para proteger tus datos personales. Utiliza encriptación de extremo a extremo y prácticas de seguridad líderes en la industria para mantener tu información segura.'
    },
    {
      'question': '¿Qué información recopila Musify sobre mí?',
      'answer': 'Musify recopila información como tu nombre, dirección de correo electrónico y preferencias de música para personalizar tu experiencia en la aplicación. Sin embargo, Musify no comparte esta información con terceros sin tu consentimiento.'
    },
    {
      'question': '¿Cómo puedo controlar quién ve mi actividad en Musify?',
      'answer': 'Puedes controlar quién ve tu actividad en Musify ajustando la configuración de privacidad en tu perfil. Desde allí, puedes decidir si quieres que tu actividad sea visible para otros usuarios o mantenerla privada.'
    },
    {
      'question': '¿Musify vende mis datos personales a terceros?',
      'answer': 'No, Musify no vende tus datos personales a terceros. Tu privacidad es importante para nosotros y nos comprometemos a proteger tus datos según lo establecido en nuestra política de privacidad.'
    },
    {
      'question': '¿Cómo reporto problemas de seguridad en Musify?',
      'answer': 'Si encuentras algún problema de seguridad en Musify o crees que tu cuenta ha sido comprometida, por favor contáctanos de inmediato a través de nuestro equipo de soporte. Estamos aquí para ayudarte y resolver cualquier problema que puedas tener.'
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
            Text('Preguntas FAQ', style: TextStyle(color: Colors.white)),
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
