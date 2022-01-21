import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/ledgerparty.dart';

class LedgerPartyService {
  final String uid;

  final String voucherId;

  LedgerPartyService({this.uid, this.voucherId});

  final CollectionReference companyCollection =
      FirebaseFirestore.instance.collection('company');

  Stream<List<LedgerParty>> get voucherLedgerData {
    return companyCollection
        .doc(this.uid)
        .collection('ledger_entries')
        .where('restat_voucher_master_id', isEqualTo: voucherId)
        .snapshots()
        .map(_voucherLedgerData);
  }

  List<LedgerParty> _voucherLedgerData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return LedgerParty(
        amount: doc['amount'].toDouble() ?? 0,
        isDeemedPositive: doc['isdeemedpositive'].toString() ?? '',
        isPartyLedger: doc['ispartyledger'].toString() ?? '',
        ledgerGuid: doc['ledger_guid'].toString() ?? '',
        ledgerMasterId: doc['ledgername'].toString() ?? '',
        ledgerRefMasterId: doc['ledgerrefname'].toString() ?? '',
        // primaryVoucherType:
        //     doc['primary_voucher_type_name'].toString() ?? '',
        primaryGroup: doc['primarygroup'].toString() ?? '',
        ledgerName: doc['restat_ledger_name'].toString() ?? '',
        ledgerRefName: doc['restat_ledger_ref_name'].toString() ?? '',
        partyName: doc['restat_party_ledger_name'].toString() ?? '',
        date: doc['restat_voucher_date'].toDate() ?? null,
        voucherMasterID: doc['restat_voucher_master_id'].toString() ?? '',
      );
    }).toList();
  }
}
