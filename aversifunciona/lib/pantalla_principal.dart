import 'package:aversifunciona/biblioteca.dart';
import 'package:aversifunciona/buscar.dart';
import 'package:aversifunciona/configuracion.dart';
import 'package:aversifunciona/desplegable.dart';
import 'package:aversifunciona/podcast.dart';
import 'package:aversifunciona/salas.dart';
import 'package:aversifunciona/verPerfil.dart';
import 'package:aversifunciona/todo.dart';
import 'package:flutter/material.dart';

import 'musica.dart';
import 'historial.dart';

class pantalla_principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: PopupMenuButton<String>(
          icon: CircleAvatar(
            backgroundImage: AssetImage('tu_ruta_de_imagen'),
          ),
          onSelected: (value) {
            // Manejar la selección del desplegable
            if (value == 'verPerfil') {
              // Navegar a la pantalla "verPerfil"
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => verPerfil()),
              );
            } else if (value == 'historial') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => historial()),
              );
            } else if (value == 'configuracion') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => configuracion()),
              );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'verPerfil',
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Ver Perfil'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'historial',
              child: ListTile(
                leading: Icon(Icons.history),
                title: Text('Historial'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'configuracion',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configuración y Privacidad'),
              ),
            ),
          ],
        ),
        title: const Text(
          'Título de la pantalla',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          const Spacer(),

          const Spacer(),
          // Botón Todo
          buildTopButton(context, 'Todo', pantalla_todo()),

          // Botón Música
          buildTopButton(context, 'Música', pantalla_musica()),

          // Botón Podcast
          buildTopButton(context, 'Podcast', pantalla_podcast()),
        ],
      ),
      body: Column(
         children: [
           SizedBox(height: 20),
          Expanded(
            child: Container(
              child: ListView(

                children: [
                  SizedBox(height: 20),
                  const Text(

                    '    Has escuchado recientemente',
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(

                    height: 125,
                    width: 350,

                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                      Expanded(
                          child:
                          Row(
                            children: [

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),


                            ],
                          )

                      ),


                    ),
                  ),
                  Text(
                    '    Hecho para el usuario',
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(

                    height: 125,
                    width: 350,

                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                      Expanded(
                          child:
                          Row(
                            children: [

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),


                            ],
                          )

                      ),


                    ),
                  ),

                  Text(
                    '    Top Canciones',
                    style: TextStyle(color: Colors.white),
                  ),

                  Container(

                    height: 125,
                    width: 350,

                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                      Expanded(
                          child:
                          Row(
                            children: [

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: const Text(''),
                                  )
                              ),


                            ],
                          )

                      ),


                    ),
                  ),
                  const Text(
                    '    Top Podcasts',
                    style: TextStyle(color: Colors.white),
                  ),

                  Container(

                    height: 125,
                    width: 350,

                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                      Expanded(
                          child:
                          Row(
                            children: [

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),

                              Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(onPressed: (){},
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const RoundedRectangleBorder()),
                                    child: Text(''),
                                  )
                              ),


                            ],
                          )

                      ),


                    ),
                  ),

                  Expanded(
                    child: Container(
                      // Contenido principal (puedes colocar aquí tu imagen o cualquier otro contenido)
                    ),
                  ),


                ],
              ),

            ),
          ),

           Container(
             height: 70,
             decoration: const BoxDecoration(
               border: Border(
                 top: BorderSide(width: 1.0, color: Colors.white),
               ),
             ),
             child: Row(

               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [

                 ElevatedButton(
                 onPressed: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) => pantalla_principal()),
                      );
                 },
                   style: ElevatedButton.styleFrom(
                     backgroundColor:Colors.transparent,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(20),
                     ),
                   ),
                   child: const Column(

                     children: [
                       SizedBox(height: 8),
                       Icon(Icons.house_outlined, color: Colors.grey, size: 37.0),
                       Text(
                           'Inicio',
                           style: TextStyle(color: Colors.white, fontSize: 12),
                         ),
                       ]
                 ),
           ),


                 ElevatedButton(
                   onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) => pantalla_buscar()),
                     );
                   },
                   style: ElevatedButton.styleFrom(
                     backgroundColor:Colors.transparent,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(20),
                     ),
                   ),
                   child: const Column(

                       children: [
                         SizedBox(height: 8),
                         Icon(Icons.question_mark_outlined, color: Colors.grey, size: 37.0),
                         Text(
                           'Buscar',
                           style: TextStyle(color: Colors.white, fontSize: 12),
                         ),
                       ]
                   ),
                 ),

                 ElevatedButton(
                   onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) => pantalla_biblioteca()),
                     );
                   },
                   style: ElevatedButton.styleFrom(
                     backgroundColor:Colors.transparent,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(20),
                     ),
                   ),
                   child: const Column(

                       children: [
                         SizedBox(height: 8),
                         Icon(Icons.library_books_rounded, color: Colors.grey, size: 37.0),
                         Text(
                           'Biblioteca',
                           style: TextStyle(color: Colors.white, fontSize: 12),
                         ),
                       ]
                   ),
                 ),

                 ElevatedButton(
                   onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) => pantalla_salas()),
                     );
                   },
                   style: ElevatedButton.styleFrom(
                     backgroundColor:Colors.transparent,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(20),
                     ),
                   ),
                   child: const Column(

                       children: [
                         SizedBox(height: 8),
                         Icon(Icons.chat_bubble_rounded, color: Colors.grey, size: 37.0),
                         Text(
                           'Salas',
                           style: TextStyle(color: Colors.white, fontSize: 12),
                         ),
                       ]
                   ),
                 ),
               ],
             ),

           ),
            ]
           ),
    );
  }

  Widget buildOption(String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Aquí puedes agregar tu propio widget de imagen si es necesario
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18), // Ajusta el tamaño de la fuente según sea necesario
        ),
      ],
    );
  }

  Widget buildTopButton(BuildContext context, String title, Widget screen) {
    return Container(
      margin: EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {
          // Navegar a la pantalla correspondiente
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}




