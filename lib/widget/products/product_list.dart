import 'package:appdevl/providers/store_provider.dart';
import 'package:appdevl/services/product_services.dart';
import 'package:appdevl/widget/products/product_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);

    ProductServices _services = ProductServices();

    return SingleChildScrollView(
      child: FutureBuilder<QuerySnapshot>(
        future: _services.products.where('published',isEqualTo: true).where('category.categoryName', isEqualTo: _storeProvider.selectedProductCategory).limit(10).get(),
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
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text('${snapshot.data.docs.length} Items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                      ),
                    ],
                  ),
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
