import 'package:appdevl/services/product_services.dart';
import 'package:appdevl/widget/products/product_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeatureProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ProductServices _services = ProductServices();

    return SingleChildScrollView(
      child: FutureBuilder<QuerySnapshot>(
        future: _services.products.where('published',isEqualTo: true).where('collection', isEqualTo: 'Best Selling').limit(10).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

         // if (snapshot.connectionState == ConnectionState.waiting) {
         //   return Center(child: CircularProgressIndicator());
        //  }
          if(snapshot.data.docs.isEmpty){
            return Container();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  //color: Colors.orangeAccent,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text('Best seller', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),)),
                ),
              ),
              new ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return new ProductCard(document);
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
