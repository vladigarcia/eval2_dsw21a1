import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyHomePage(title: 'Lista de Productos'),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      drawer: AppDrawer(), // Agrega el Drawer aquí
      body: ProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateProduct()),
          );
        },
        tooltip: 'Crear',
        child: Icon(Icons.add_box),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Opciones del Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Opción 1'),
            onTap: () {
              // Aquí puedes agregar la lógica para manejar la opción 1
            },
          ),
          ListTile(
            title: Text('Opción 2'),
            onTap: () {
              // Aquí puedes agregar la lógica para manejar la opción 2
            },
          ),
          // Agrega más ListTile según tus necesidades
        ],
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("tb_productos").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No hay datos disponibles."),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final producto = snapshot.data!.docs[index];
              final nombre = producto["nombre"] as String;
              final precio = producto["precio"]?.toString() ?? "Precio no disponible";
              final stock = producto["stock"]?.toString() ?? "Stock no disponible";
              return Card(
                elevation: 3.0,
                child: ListTile(
                  title: Text(nombre, style: TextStyle(fontSize: 18.0)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Precio: $precio"),
                      Text("Stock: $stock"),
                    ],
                  ),
                  onTap: () {

                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}

class CreateProduct extends StatefulWidget {
  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  Future<void> _createProduct() async {
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
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Producto creado correctamente"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Producto"),
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
              onPressed: _createProduct,
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
