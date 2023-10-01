import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    home: ScrumPage(),
  ));
}

class nuevodatos extends StatefulWidget {
  const nuevodatos({Key? key}) : super(key: key);

  @override
  _nuevodatosState createState() => _nuevodatosState();
}

class _nuevodatosState extends State<nuevodatos> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Producto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Ingrese los datos del producto",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del producto',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Precio del producto',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Stock del producto',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String newName = nameController.text;
                String newPrice = priceController.text;
                String newStock = stockController.text;

                if (newName.isNotEmpty && newPrice.isNotEmpty && newStock.isNotEmpty) {
                  try {
                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                    String collectionName = 'tb_productos';

                    double price = double.parse(newPrice);
                    int stock = int.parse(newStock);

                    await firestore.collection(collectionName).add({
                      'nombre': newName,
                      'precio': price,
                      'stock': stock,
                    });

                    nameController.clear();
                    priceController.clear();
                    stockController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Datos Agregados Correctamente"),
                      ),
                    );
                  } catch (e) {
                    print("Error: $e");
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Por favor, ingresa todos los datos"),
                    ),
                  );
                }
              },
              child: Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrumPage extends StatefulWidget {
  const ScrumPage({Key? key}) : super(key: key);

  @override
  _ScrumPageState createState() => _ScrumPageState();
}

class _ScrumPageState extends State<ScrumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Productos"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tb_productos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var productos = snapshot.data!.docs;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              var producto = productos[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    producto['nombre'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Precio: \$${producto['precio'].toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Stock: ${producto['stock']}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nuevodatos()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
