import 'package:flutter/material.dart';


class FAQCuenta extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      'question': 'No me acuerdo de mis datos de inicio de sesión',
      'answer': 'Si has olvidado tus datos de inicio de sesión, puedes utilizar la opción de "¿Olvidaste tu contraseña?" en la pantalla de inicio de sesión para restablecerla. Si aún tienes problemas, ponte en contacto con nuestro equipo de soporte para obtener ayuda adicional.'
    },
    {
      'question': 'Inicio de Sesión',
      'answer': 'Para iniciar sesión en tu cuenta, simplemente abre la aplicación Musify e introduce tu dirección de correo electrónico y contraseña en la pantalla de inicio de sesión. Si aún no tienes una cuenta, puedes registrarte fácilmente seleccionando la opción "Registrarse".'
    },
    {
      'question': 'Imagen de Perfil',
      'answer': 'Puedes cambiar tu imagen de perfil en la sección de configuración de tu cuenta. Busca la opción "Editar perfil" o "Cambiar imagen de perfil" y sigue las instrucciones para seleccionar una nueva imagen desde tu galería o tomar una foto.'
    },
    {
      'question': 'Nombre de Usuario',
      'answer': 'Tu nombre de usuario es único y está asociado a tu cuenta. Si deseas cambiar tu nombre de usuario, puedes hacerlo en la sección de configuración de tu cuenta. Busca la opción "Editar perfil" o "Cambiar nombre de usuario" y sigue las instrucciones para actualizarlo.'
    },
    {
      'question': 'Cambiar Correo',
      'answer': 'Si deseas cambiar la dirección de correo electrónico asociada a tu cuenta, puedes hacerlo en la sección de configuración de tu cuenta. Busca la opción "Editar perfil" o "Cambiar correo electrónico" y sigue las instrucciones para proporcionar tu nueva dirección de correo electrónico y confirmar los cambios.'
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
            Text('Ayuda con la cuenta', style: TextStyle(color: Colors.white)),
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
