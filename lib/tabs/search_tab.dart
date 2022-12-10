import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denamor/Screens/product_page.dart';
import 'package:denamor/Widgets/custom_input.dart';
import 'package:denamor/constants.dart';
import 'package:denamor/sevices/firebase_sevices.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (_searchString.isEmpty)
            Center(
              child: Container(
                child: Text("Search Results",
                style: Constants.regularDarkText,),
              ),
            )
          else
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.productRef.orderBy("search_string")
                .startAt([_searchString])
                .endAt(["$_searchString\uf8ff"])
                .get(),
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
                    top: 12+0.0,
                    bottom: 12.0,
                  ),
                  children: snapshot.data!.docs.map((document) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProductPage(productid: document.id,),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        height: 350.0,
                        margin: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                        child: Stack(
                          children: [
                            Container(
                              height :350.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(""
                                    "${document['image'][0]}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      document['name'] ?? "Product Name" ,
                                      style: Constants.regularHeading,),
                                    Text(
                                      "\₹${document['price']}" ?? "Price" ,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
          Padding(
            padding: const EdgeInsets.only(
              top: 45.0,
            ),
            child: CustomInput(
              hintText: "Search here...",
              onSubmitted: (value) {
                 setState(() {
                   _searchString = value.toLowerCase();
                 });
                }
            ),
          ),
        ],
      ),
    );
  }
}
