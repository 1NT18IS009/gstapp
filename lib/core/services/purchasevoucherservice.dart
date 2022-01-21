import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/purchasevoucher.dart';

class PurchaseVoucherService {
  final String uid;
  PurchaseVoucherService({this.uid});

  final CollectionReference companyCollection =
  FirebaseFirestore.instance.collection('company');

  Stream<List<PurchaseVoucher>> get purchaseVoucherData {
    return companyCollection
        .doc(this.uid)
        .collection('voucher')
        .where('primary_voucher_type_name', isEqualTo: 'Purchase')
        .orderBy('amount', descending: true)
        .snapshots()
        .map(_purchasevouchersfromSnapshots);
  }

  List<PurchaseVoucher> _purchasevouchersfromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PurchaseVoucher(
        date: doc['date'] ?? '',
        partyname: doc['restat_party_ledger_name'] ?? '',
        amount: doc['amount'].toInt() ?? 0,
        masterid: doc['master_id'] ?? '',
        iscancelled: doc['is_cancelled'] ?? '',
      );
    }).toList();
  }
}