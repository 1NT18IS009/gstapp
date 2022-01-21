import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/voucher-item.dart';

class VoucherItemService {
  final String uid;
  final String voucherId;

  VoucherItemService({
    this.uid,
    this.voucherId,
  });

  final CollectionReference companyCollection =
  FirebaseFirestore.instance.collection('company');

  Stream<List<VoucherItem>> get voucherItemData {
    return companyCollection
        .doc(this.uid)
        .collection('inventory_entries')
        .where('voucher_master_id', isEqualTo: voucherId)
        .snapshots()
        .map(_voucherItemData);
  }

  Future saveVoucherItemRecord({
    stockItemName,
    partyLedgerName,
    vdate,
    vMasterId,
    rate,
    primaryVoucherType,
    gstPercent,
    billedQty,
    actualqty,
    amount,
    taxAmount,
  }) async {
    return await companyCollection
        .doc(this.uid)
        .collection('inventory_entries')
        .doc()
        .set({
      'restat_stock_item_name': stockItemName,
      'restat_party_ledger_name': partyLedgerName,
      'restat_voucher_date': vdate,
      'restat_voucher_master_id': vMasterId,
      'rate': rate,
      'restat_primary_voucher_type_name': primaryVoucherType,
      'gstpercent': gstPercent,
      'billedqty': billedQty,
      'actualQty': actualqty,
      'amount': amount,
      'taxamount': taxAmount,
    });
  }

  List<VoucherItem> _voucherItemData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return VoucherItem(
        stockItemName: doc['restat_stock_item_name'].toString() ?? '',
        partyLedgerName: doc['restat_party_ledger_name'].toString() ?? '',
        vDate: doc['restat_voucher_date'].toDate() ?? null,
        vMasterId: doc['restat_voucher_master_id'].toString() ?? '',
        rate: doc['rate'].toString() ?? '',
        primaryVoucherType:
            doc['restat_primary_voucher_type_name'].toString() ?? '',
        discount: doc['discount'].toString() ?? '',
        gstPercent: doc['gstpercent'].toString() ?? '',
        billedQty: doc['billedqty'].toDouble() ?? 0,
        actualQty: doc['actualqty'].toString() ?? '',
        amount: doc['amount'].toDouble() ?? 0,
        taxAmount: doc['taxamount'].toString() ?? '',
      );
    }).toList();
  }
}
