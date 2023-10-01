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
        title: Text("Nuevos Datos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Nombre del producto',
              ),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Precio del producto',
              ),
            ),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Stock del producto',
              ),
            ),
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
              child: const Text("Guardar"),
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
        title: Text("Scrum"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tb_productos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          var productos = snapshot.data!.docs;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              var producto = productos[index];
              return ListTile(
                title: Text(producto['nombre']),
                subtitle: Text("Precio: ${producto['precio']}, Stock: ${producto['stock']}"),
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
