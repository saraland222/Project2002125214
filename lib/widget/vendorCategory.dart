import 'package:appdevl/Screen/product_list_screen.dart';
import 'package:appdevl/providers/store_provider.dart';
import 'package:appdevl/services/product_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class VendorCategories extends StatefulWidget {
  @override
  _VendorCategoriesState createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {
  ProductServices _services = ProductServices();

  List _catList = [];

  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);
    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: _store.storedetails['uid'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {

                  _catList.add(doc['category']['categoryName']);

              }),
            });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);
    return FutureBuilder(
        future: _services.category.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something wrong'),
            );
          }
          if (_catList.length==0) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Container();
          }
          return SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return
                  _catList.contains(document.data()['name']) ?
                  InkWell(
                    onTap: () {
                      _storeProvider.selectedCategory(document.data()['name']);
                      pushNewScreenWithRouteSettings(
                        context,
                        settings:
                        RouteSettings(name: ProductListScreen.id),
                        screen: ProductListScreen(),
                        withNavBar: true,
                        pageTransitionAnimation:
                        PageTransitionAnimation.cupertino,
                      );
                    },
                    child: Container(
                      height: 120,
                      width: 150,
                      child: Card(
                          child: Column(
                            children: [
                              Center(
                                child:
                                    Image.network(document.data()['image']),
                              ),
                              Text(document.data()['name']),
                            ],
                          ),
                        ),
                    ),
                  )
                    : Text('');
              }).toList(),
            ),
          );
        });
  }
}
