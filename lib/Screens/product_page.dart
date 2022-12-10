import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denamor/Widgets/custom_action_bar.dart';
import 'package:denamor/Widgets/custom_tag.dart';
import 'package:denamor/Widgets/image_swipe.dart';
import 'package:denamor/Widgets/product_size.dart';
import 'package:denamor/constants.dart';
import 'package:denamor/sevices/firebase_sevices.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String? productid;
  ProductPage({this.productid});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _selectedProductSize = "0";

  Future _addToCart() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productid)
        .set({"size" : _selectedProductSize});
  }

  Future _addToSaved() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.productid)
        .set({"size" : _selectedProductSize});
  }

    final SnackBar _snakbarCart = SnackBar(content: Text("Product Added to Cart"),);
    final SnackBar _snakbarSaved = SnackBar(content: Text("Product Added to Saved"),);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
         FutureBuilder(
           future: _firebaseServices.productRef.doc(widget.productid).get(),
           builder: (context, snapshot) {
             if (snapshot.hasError) {
               return Scaffold(
                 body: Center(
                   child: Text("Error ${snapshot.error}"),
                 ),
               );
             }

             if(snapshot.connectionState == ConnectionState.done) {
               DocumentSnapshot<Object?>? documentData = snapshot.data! as DocumentSnapshot<Object?>?;
               List imagelist = documentData!['image'];
               List productSizes = documentData['size'];

               _selectedProductSize = productSizes[0];

               return ListView(
                 padding: EdgeInsets.all(0) ,
                 children: [
                   ImageSwipe(
                       imagelist: imagelist,
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(
                           top: 24.0,
                           left: 24.0,
                           right: 24.0,
                           bottom: 4.0,
                         ),
                         child: Text (
                         " ${documentData['name']}",
                         style: Constants.boldHeading,
                         ),
                       ),
                         Padding(
                         padding: const EdgeInsets.only(
                         top: 20.0,
                         right: 10.0,
                          ),
                          child:CustomTag(
                          title : "Branded"
                       )
                          ),
                     ],
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(
                       vertical: 4.0,
                       horizontal: 24.0,
                     ),
                     child: Text(
                       "\₹ ${documentData['price']}",
                     style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600,
                     ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(
                       vertical: 8.0,
                       horizontal: 24.0,
                     ),
                     child: Text(
                       "${documentData['desc']}",
                     style: TextStyle(
                     fontSize: 16.0,
                     ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(
                       vertical: 8.0,
                       horizontal: 24.0,
                     ),
                     child: Text("Select Size",
                     style: Constants.regularDarkText,
                     ),
                   ),
                   ProductSize(
                     productSizes: productSizes,
                     onSelected: (size) {
                       _selectedProductSize = size;
                     }
                   ),
                   Padding(
                     padding: const EdgeInsets.all(24.0),
                     child: Row(
                       children: [
                         GestureDetector(
                           onTap : () async {
                             await _addToSaved();
                             ScaffoldMessenger.of(context).showSnackBar(_snakbarSaved);
                             },
                           child: Container(
                             width : 65.0,
                             height : 65.0,
                             decoration: BoxDecoration(
                              color: Color(0xFFDCDCDC),
                               borderRadius: BorderRadius.circular(12.0),
                           ),
                             alignment : Alignment.center,
                             child: Image(
                               image: AssetImage(
                                 "assets/images/tab_saved.png"
                               ),
                               height: 22.0,
                             ),
                           ),
                         ),
                         Expanded(
                           child: GestureDetector(
                             onTap: () async {
                              await _addToCart();
                              ScaffoldMessenger.of(context).showSnackBar(_snakbarCart);
                             },
                             child: Container(
                               height: 65.0,
                               margin: EdgeInsets.only(
                                 left: 16.0,
                               ),
                               decoration: BoxDecoration(
                                 color: Colors.black,
                                 borderRadius: BorderRadius.circular(12.0),
                               ),
                               alignment: Alignment.center,
                               child: Text("Add to Cart",
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 16.0,
                                 fontWeight: FontWeight.w600,
                               ),
                               ),
                             ),
                           ),
                         )
                       ],
                     ),
                   )
                 ],
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
            hasBackArrow: true,
            hasTitle: false,
            hasBackground: false,
          ),
        ],
      )
    );
  }
}
