import 'package:aversifunciona/pantalla_principal.dart';
import 'package:flutter/material.dart';

class Google extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicia sesión con Google'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Selecciona una cuenta',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 8), // Adjust as needed
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'para ir a ',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Musify',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            AccountTile(
              accountName: '819684@unizar.es',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pantalla_principal()),
                );
              },
            ),
            AccountTile(
              accountName: 'helalizineb@gmail.com',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pantalla_principal()),
                );
              },
            ),
            // Puedes agregar más cuentas según sea necesario
          ],
        ),
      ),
    );
  }
}

class AccountTile extends StatelessWidget {
  final String accountName;
  final VoidCallback onPressed;

  const AccountTile({
    required this.accountName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(Icons.account_circle, size: 40),
            SizedBox(width: 16),
            Text(
              accountName,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
