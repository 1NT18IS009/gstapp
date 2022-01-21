import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/stockitem.dart';

class StockItemService {
  final String uid;
  StockItemService({this.uid});

  final CollectionReference companyCollection =
  FirebaseFirestore.instance.collection('company');

  Stream<List<StockItem>> get stockItemsData {
    return companyCollection
        .doc(this.uid)
        .collection('stockitem')
        .orderBy('closingvalue', descending: false)
        .snapshots()
        .map(_stockItemData);
  }

  Future saveStockItem({
    masterId,
    name,
    standardCost,
    standardPrice,
    baseUnits,
    closingBalance,
    minimumStock,
    reorderValue,
  }) async {
    return await companyCollection
        .doc(this.uid)
        .collection('stockitem')
        .doc(masterId)
        .set({
      'name': name,
      'masterid': masterId,
      'standardcost': standardCost,
      'standardprice': standardPrice,
      'baseunits': baseUnits,
      'closingbalance': closingBalance,
      'minimumstock': minimumStock,
      'reordervalue': reorderValue,
    });
  }

  List<StockItem> _stockItemData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return StockItem(
        name: doc['name'] ?? '',
        masterId: doc['masterid'] ?? '',
        closingBalance: doc['closingbalance']?.toString() ?? '',
        closingValue: doc['closingvalue'] != ''
            ? (doc['closingvalue']?.toDouble() ?? 0)
            : 0,
        baseUnit: doc['baseunits']?.toString() ?? '',
        closingRate: doc['closingrate']?.toString() ?? '',
        standardCost: doc['standardcost']?.toString() ?? '',
        standardPrice: doc['standardprice']?.toString() ?? '',
      );
    }).toList();
  }
}
