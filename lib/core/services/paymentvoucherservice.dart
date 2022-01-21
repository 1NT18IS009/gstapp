import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/paymentvoucher.dart';


class PaymentVoucherService {
  final String uid;
  PaymentVoucherService({this.uid});

  final CollectionReference companyCollection =
      FirebaseFirestore.instance.collection('company');

  Stream<List<PaymentVoucher>> get paymentVoucherData {
    return companyCollection
        .doc(this.uid)
        .collection('voucher')
        .where('primary_voucher_type_name', isEqualTo: 'Payment')
        .orderBy('amount', descending: true)
        .snapshots()
        .map(_purchasevouchersfromSnapshots);
  }

  List<PaymentVoucher> _purchasevouchersfromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PaymentVoucher(
        date: doc['date'] ?? '',
        partyname: doc['restat_party_ledger_name'] ?? '',
        amount: doc['amount'].toDouble() ?? 0,
        masterid: doc['master_id'] ?? '',
        iscancelled: doc['is_cancelled'] ?? '',
      );
    }).toList();
  }
}