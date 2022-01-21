import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/receiptvoucher.dart';

class ReceiptVoucherService {
  final String uid;
  ReceiptVoucherService({this.uid});

  final CollectionReference companyCollection =
  FirebaseFirestore.instance.collection('company');

  Stream<List<ReceiptVoucher>> get receiptVoucherData {
    return companyCollection
        .doc(this.uid)
        .collection('voucher')
        .where('primary_voucher_type_name', isEqualTo: 'Receipt')
        .orderBy('amount', descending: true)
        .snapshots()
        .map(_receiptvouchersfromSnapshots);
  }

  List<ReceiptVoucher> _receiptvouchersfromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ReceiptVoucher(
        date: doc['date'] ?? '',
        partyname: doc['restat_party_ledger_name'] ?? '',
        amount: doc['amount'].toInt() ?? 0,
        masterid: doc['master_id'] ?? '',
        iscancelled: doc['is_cancelled'] ?? '',
      );
    }).toList();
  }
}