import 'package:flutter/material.dart';

class acercanosotros extends StatefulWidget {
  const acercanosotros({Key? key}) : super(key: key);

  @override
  _acercanosotrosState createState() => _acercanosotrosState();
}

class _acercanosotrosState extends State<acercanosotros> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de Nosotros'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Persona 1
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image.asset(
                      'images/mifoto.jpg',
                      width: 150.0,
                      height: 150.0,
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Nombre: Eduardo Vladimir'),
                    Text('Apellido: Garcia Mestizo'),
                    Text('Correo: eduardo@example.com'),
                  ],
                ),
              ],
            ),
            // Persona 2
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image.asset(
                      'images/jairo.jpg',
                      width: 150.0,
                      height: 150.0,
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Nombre: Jairo Enoc'),
                    Text('Apellido: Lopez Montano'),
                    Text('Correo: jairo@example.com'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: acercanosotros(),
  ));
}
