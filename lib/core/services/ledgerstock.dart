import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/ledgerstock.dart';

class LedgerStockService {
  final String uid;
  final String ledgerId;

  LedgerStockService({this.uid, this.ledgerId});

  final CollectionReference companyCollection =
      FirebaseFirestore.instance.collection('company');

  Stream<List<LedgerStock>> get ledgerStockData {
    return companyCollection
        .doc(this.uid)
        .collection('ledger')
        .doc(this.ledgerId)
        .collection('ledger_stock_metrics')
        .snapshots()
        .map(_ledgerstockdata);
  }

  List<LedgerStock> _ledgerstockdata(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return LedgerStock(
        lastAmount: doc['total_amount'].toString() ?? '',
        lastDiscount: doc['last_discount'].toString() ?? '',
        lastRate: doc['last_rate'].toString() ?? '',
        lastDate: doc['last_voucher_date'].toDate() ?? null,
        itemName: doc['restat_stock_item_name'].toString() ?? '',
        totalAmount: doc['total_amount'].toString() ?? '',
        totalActualQty: doc['total_actualqty'].toString() ?? '',
        totalBilledQty: doc['total_billedqty']?.toDouble() ?? 0,
        numVouchers: doc['num_vouchers'].toString() ?? '',
      );
    }).toList();
  }
}
