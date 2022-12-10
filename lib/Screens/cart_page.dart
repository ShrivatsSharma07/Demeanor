import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denamor/Screens/product_page.dart';
import 'package:denamor/Widgets/custom_action_bar.dart';
import 'package:denamor/Widgets/custom_btn.dart';
import 'package:denamor/constants.dart';
import 'package:denamor/sevices/firebase_sevices.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final String? productid;
  CartPage({this.productid});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  FirebaseServices _firebaseServices = FirebaseServices();
  final CollectionReference usersRef =
  FirebaseFirestore
      .instance
      .collection("Users");

  Future _deleteCartProduct() {
    return _firebaseServices.usersRef
           .doc(_firebaseServices.getUserId())
           .collection("/Cart/")
           .doc(widget.productid)
           .delete()
           .then((value) => print("Product Deleted: " ))
           .catchError((error) => print("Failed to delete product: $error"));
  }

  final SnackBar _snakbarDelete = SnackBar(content: Text("Product Removed"),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.usersRef.doc(_firebaseServices.getUserId())
                .collection("Cart").get(),
            builder: (context, snapshot){
              if (snapshot.hasError){
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if(snapshot.connectionState == ConnectionState.done){
                return ListView(
                  padding: EdgeInsets.only(
                    top: 100.0,
                    bottom: 12.0,
                  ),
                  children: snapshot.data!.docs.map((document) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProductPage(productid: document.id,),
                        ));
                      },
                      child: FutureBuilder(
                        future: _firebaseServices.productRef.doc(document.id).get(),
                        builder: (context, productSnap){

                         var _productMap = productSnap.data as DocumentSnapshot;

                         if (productSnap.hasError){
                           return Container(
                             child: Center(
                               child: Text("${productSnap.error}"),
                             ),
                           );
                         }

                         if (productSnap.connectionState == ConnectionState.done){
                           return Padding(
                             padding: const EdgeInsets.symmetric(
                               vertical: 16.0,
                               horizontal: 24.0,
                             ),
                             child : Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Container(
                                   width: 90,
                                   height: 90,
                                   child: ClipRRect(
                                     borderRadius: BorderRadius.circular(8.0),
                                     child: Image.network(
                                         "${_productMap['image'][0]}",
                                       fit: BoxFit.cover,
                                     ),
                                   ),
                                 ),
                                 Container(
                                   padding: EdgeInsets.only(
                                     left: 16.0,
                                   ),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text("${_productMap['name']}",
                                       style: TextStyle(
                                         fontSize: 18.0,
                                         color: Colors.black,
                                         fontWeight: FontWeight.w600,
                                       ),
                                       ),
                                       Padding(
                                           padding: const EdgeInsets.symmetric(
                                             vertical: 4.0,
                                           ),
                                         child: Text(
                                             "₹${_productMap['price']}",
                                         style: TextStyle(
                                              fontSize: 16.0,
                                              color: Theme.of(context).accentColor,
                                              fontWeight: FontWeight.w600,
                                         ),
                                         ),
                                       ),
                                       Stack(
                                         //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text(
                                               "Size - ${document['size'] ?? ''}",
                                             style: TextStyle(
                                               fontSize: 16.0,
                                               color: Colors.black,
                                               fontWeight: FontWeight.w600,
                                             ),
                                           ),
                                           Padding(
                                             padding: const EdgeInsets.only(
                                               left: 200.0,
                                               bottom: 0.0,
                                             ),
                                             child: GestureDetector(
                                               onTap: () async {
                                                 await _deleteCartProduct();
                                                ScaffoldMessenger.of(context).showSnackBar(_snakbarDelete);
                                                print(document.id);
                                               },
                                               child: Container(
                                                 width: 36.0,
                                                 height: 36.0,
                                                 decoration: BoxDecoration(
                                                   color: Colors.black,
                                                   borderRadius: BorderRadius.circular(8.0),
                                                 ),
                                                 child: Image(
                                                   image: AssetImage(
                                                       "assets/images/remove_btn.png"
                                                   ),
                                                   width: 12.0,
                                                   height: 12.0,
                                                 ),
                                               ),
                                             ),
                                           ),
                                         ],
                                       )
                                     ],
                                   ),
                                 ),
                               ],
                             )
                           );
                         }
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              }

              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            hasBackground: true,
            title: "Cart",
            hasBackArrow: true,

          )
        ],
      ),
    );
  }
}
