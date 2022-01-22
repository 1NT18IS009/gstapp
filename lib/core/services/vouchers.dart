import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/vouchers.dart';

class VoucherService {
  final String uid;
  VoucherService({this.uid});

  final CollectionReference companyCollection =
  FirebaseFirestore.instance.collection('company');

  Stream<List<Voucher>> get voucherData {
    return companyCollection
        .doc(this.uid)
        .collection('voucher')
        .orderBy('vdate', descending: true)
        .limit(2000)
        .snapshots()
        .map(_receiptvouchersfromSnapshots);
  }

  Future saveVoucherRecord({
    number,
    masterId,
    date,
    partyMasterId,
    partyname,
    amount,
    primaryVoucherType,
    isInvoice,
    type,
  }) async {
    return await companyCollection
        .doc(this.uid)
        .collection('voucher')
        .doc(masterId)
        .set({
      'number': number,
      'masterid': masterId,
      'vdate': date,
      'partyledgername': partyMasterId,
      'restat_party_ledger_name': partyname,
      'amount': amount,
      'primaryvouchertypename': primaryVoucherType,
      'isinvoice': isInvoice,
      'type': type,
      'fromTally': '0',
    });
  }

  List<Voucher> _receiptvouchersfromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Voucher(
        date: doc['vdate']?.toDate() ?? null,
        partyname: doc['restat_party_ledger_name'] ?? '',
        amount: doc['amount']?.toDouble() ?? 0,
        masterid: doc['masterid'] ?? '',
        iscancelled: doc['iscancelled'] ?? '',
        primaryVoucherType: doc['primaryvouchertypename'] ?? '',
        isInvoice: doc['isinvoice'] ?? '',
        isPostDated: doc['ispostdated'] ?? '',
        reference: doc['reference'] ?? '',
        type: doc['type'] ?? '',
        partyGuid: doc['partyledgername'] ?? '',
        number: doc['vouchernumber'] ?? '',
      );
    }).toList();
  }
}
