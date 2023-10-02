import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Crear__dato.dart';
import 'acerca_nosotros.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List> getMensajes() async {
    List chats = [];
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection("tb_productos");
    QuerySnapshot mensajes = await collectionReference.get();
    if (mensajes.docs.length != 0) {
      for (var doc in mensajes.docs) {
        print(doc.data());
        chats.add(doc.data());
      }
    }
    return chats;
  }

  void refreshData() {
    setState(() {
      getMensajes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => nuevodatos()),
              ).then((_) {
                refreshData();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => acercanosotros()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getMensajes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      "${snapshot.data?[index]["nombre"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(Icons.attach_money, color: Colors.green),
                        Text(
                          "Precio: ${snapshot.data?[index]["precio"].toString()} | ",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Icon(Icons.store, color: Colors.orange),
                        Text(
                          "Stock: ${snapshot.data?[index]["stock"].toString()}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No hay datos disponibles.'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: refreshData,
        tooltip: 'Refrescar',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MyHomePage(title: 'Productos'),
  ));
}
