import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/alert_Dialog.dart';



class OrderInfromationDelivery extends StatefulWidget {
  const OrderInfromationDelivery({Key? key}) : super(key: key);

  @override
  State<OrderInfromationDelivery> createState() => _FetchDataState();
}


class _FetchDataState extends State<OrderInfromationDelivery> {
  final CollectionReference _products =
  FirebaseFirestore.instance.collection('Shopping Cart');
  int _selectedIndex = 0;


  _showDialogOne(BuildContext context)
  {
    VoidCallback continueCallBack = () => {
      Navigator.of(context).pop(),
      // code on continue comes here

    };
    BlurryDialog  alert = BlurryDialog("Delivered","Was the currently selected order delivered",continueCallBack);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  _showDialogTwo(BuildContext context)
  {
    VoidCallback continueCallBack = () => {
      Navigator.of(context).pop(),
      // code on continue comes here

    };
    BlurryDialog  alert = BlurryDialog("Cancel Current Order","Are you sure you want to cancel the currently assigned order?",continueCallBack);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _LoadView(int index){
    switch(index) {
      case 0: _showDialogOne(context);
      break;
      case 1: _showDialogTwo(context);
    }


  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _LoadView(_selectedIndex);
    });
  }

  void _goBack(){
    Navigator.pop(context);
  }

  @override

  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Order Information",
            style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          onTap: (_goBack),
          child: Icon(Icons.arrow_back_sharp, color: Colors.black,),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 20,
        items: <BottomNavigationBarItem>[

          BottomNavigationBarItem(icon: Icon(Icons.check, color: Colors.green), label: 'Complete',),

          BottomNavigationBarItem(icon: Icon(Icons.cancel_outlined, color: Colors.red), label: 'Cancel',),

        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: _products.snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            final documents = streamSnapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                final totalPrice = document['totalPrice'];
                final cartItems = document['cartItems'];
                final customerName = document['customerName'];
                final timestamp = document['timestamp'];

                return Card(
                  color: Colors.red,
                    child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          'Customer: $customerName',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          'Date: ${timestamp.toDate()}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const Divider(height: 1),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartItems[index];
                          final food = cartItem['food'];
                          final price = cartItem['price'];
                          final quantity = cartItem['quantity'];

                          return ListTile(
                            title: Text(food),
                            subtitle: Text(
                              'Price: $price, Quantity: $quantity',
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          'Total Price: $totalPrice',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ));
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

    );
  }
}
