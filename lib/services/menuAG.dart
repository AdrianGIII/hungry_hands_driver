
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class FetchMenuAG extends StatefulWidget {
  const FetchMenuAG({Key? key}) : super(key: key);

  @override
  State<FetchMenuAG> createState() => _FetchDataState();
}


class _FetchDataState extends State<FetchMenuAG> {
// text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final CollectionReference _products =
  FirebaseFirestore.instance.collection('AbarGrill');
  final CollectionReference cartCollection = FirebaseFirestore.instance.collection('cart');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'food'),
                ),
                TextField(
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

              ],
            ),
          );

        });
  }
  Future<void> addToCart(DocumentSnapshot? menuItem) async {
    if (menuItem == null) {
      return; // Return early if menuItem is null
    }

    final QuerySnapshot result = await cartCollection.where('food', isEqualTo: menuItem.get('food')).limit(1).get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.isNotEmpty) {
      final DocumentSnapshot cartItem = documents.first;
      final int previousQuantity = cartItem.get('quantity');
      await cartItem.reference.update({'quantity': previousQuantity + 1});
    } else {
      await cartCollection.add({
        'food': menuItem.get('food'),
        'price': menuItem.get('price'),
        'quantity': 1,
      });
    }
  }

  Future<void> deleteFromCart(String productId) async {
    final DocumentSnapshot cartItem = await cartCollection.doc(productId).get();
    final int previousQuantity = cartItem.get('quantity');

    if (previousQuantity == 1) {
      await cartCollection.doc(productId).delete();
    } else {
      await cartCollection.doc(productId).update({'quantity': previousQuantity - 1});
    }

  }
  Future<void> mainDelete(DocumentSnapshot? menuItem) async {
    if (menuItem == null) {
      return; // Return early if menuItem is null
    }

    final QuerySnapshot result = await cartCollection.where('food', isEqualTo: menuItem.get('food')).limit(1).get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.isNotEmpty) {
      final DocumentSnapshot cartItem = documents.first;
      await deleteFromCart(cartItem.id);
    }
    }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Firebase Firestore')),
        ),
        body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['food']),
                      subtitle: Text(documentSnapshot['price'].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                            children: [
                        IconButton(icon: const Icon(Icons.add_outlined,color: Colors.deepOrange),
                          onPressed: () =>
                              addToCart(documentSnapshot)),
                              IconButton(
                                  icon: const Icon(Icons.remove_outlined),
                                  onPressed: () =>
                                      mainDelete(documentSnapshot)),

                            ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
// Add new product

    );
  }
}