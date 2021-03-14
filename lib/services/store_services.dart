import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  CollectionReference vendorbanner =
      FirebaseFirestore.instance.collection('vendorbanner');

  getTopPickedStore() {
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerofoed', isEqualTo: true)
        .where('isTopPicked')
        .where('shopOpen', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }

  getNearByStore() {
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerofoed', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }

  getNearByStorePagination() {
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerofoed', isEqualTo: true)
        .orderBy('shopName');
  }
}
