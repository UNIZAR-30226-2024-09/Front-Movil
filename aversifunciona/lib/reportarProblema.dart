import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class reportarProblema extends StatelessWidget {
  final TextEditingController _problemController = TextEditingController();

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
            Text('Reportar problema', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Eliminar el botón de retroceso predeterminado
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tipo de problema', // Nuevo texto
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 10), // Espacio entre el nuevo texto y el campo de texto
            DropdownButton( // Desplegable para seleccionar el tipo de problema
              // Aquí puedes definir la lista de opciones y la lógica de selección
              // Por ahora, solo incluiré un ejemplo básico
              items: [
                DropdownMenuItem(
                  child: Text('Errores técnicos'),
                  value: 'tecnicos',
                ),
                DropdownMenuItem(
                  child: Text('Violación de términos de servicio'),
                  value: 'servicio',
                ),
                DropdownMenuItem(
                  child: Text('Problemas de seguridad'),
                  value: 'seguridad',
                ),
                DropdownMenuItem(
                  child: Text('Errores de contenido'),
                  value: 'contenido',
                ),
                DropdownMenuItem(
                  child: Text('Otros'),
                  value: 'otros',
                ),

              ],
              onChanged: (value) {
                // Aquí puedes manejar la selección del tipo de problema
                // Por ejemplo, podrías almacenar el valor seleccionado en una variable
              },
            ),
            SizedBox(height: 20), // Espacio entre el desplegable y el campo de texto de descripción
            Text(
              'Descripción del problema',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _problemController,
              maxLines: 5,
              style: TextStyle(color: Colors.grey[400]),
              decoration: InputDecoration(
                hintText: 'Describe el problema aquí...',
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: Colors.grey[400]), // Gris más claro
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para enviar el reporte del problema
                String problemDescription = _problemController.text;
                // Aquí puedes realizar la acción necesaria, como enviar el reporte a través de una API
                // Por ahora, simplemente mostraremos un diálogo de confirmación
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('¡Reporte enviado!'),
                    content: Text('Hemos recibido tu reporte. Nos pondremos en contacto contigo para resolver el problema.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Enviar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
