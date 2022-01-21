import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/ledgervoucher.dart';

class LedgerVoucherService {
  final String uid;
  // final String ledgerId;
  final String partyName;

  LedgerVoucherService({this.uid, this.partyName});

  final CollectionReference companyCollection =
      FirebaseFirestore.instance.collection('company');

  Stream<List<LedgerVoucherModel>> get ledgerVoucherData {
    return companyCollection
        .doc(this.uid)
        .collection('voucher')
        .where('restat_party_ledger_name', isEqualTo: partyName)
        .orderBy('vdate', descending: true)
        .snapshots()
        .map(_ledgervoucherdata);
  }

  List<LedgerVoucherModel> _ledgervoucherdata(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        return LedgerVoucherModel(
          date: doc['vdate']?.toDate() ?? null,
          partyname: doc['restat_party_ledger_name'] ?? '',
          amount: doc['amount']?.toDouble() ?? 0,
          masterid: doc['masterid'] ?? '',
          iscancelled: doc['iscancelled'] ?? '',
          primaryVoucherType: doc['primary_voucher_type_name'] ?? '',
          isInvoice: doc['isinvoice'] ?? '',
          isPostDated: doc['ispostdated'] ?? '',
          reference: doc['reference'] ?? '',
          type: doc['type'] ?? '',
          partyGuid: doc['partyledgername'] ?? '',
          number: doc['number'] ?? '',
          ledgerEntries: doc['ledger_entries'] ?? [],
          inventoryEntries: doc['inventory_entries'] != ''
              ? (doc['inventory_entries'] ?? [])
              : [0],
        );
      },
    ).toList();
  }
}
