import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/ledger.dart';

class LedgerItemService {
  final String uid;
  LedgerItemService({this.uid});

  final CollectionReference companyCollection =
      FirebaseFirestore.instance.collection('company');

  Stream<List<LedgerItem>> get inactiveCustomerData {
    return companyCollection
        .doc(this.uid)
        .collection('ledger')
        .where('closing_balance', isEqualTo: 0)
        .where('parentcode', isEqualTo: '20')
        .snapshots()
        .map(_ledgerItemData);
  }

  Stream<List<LedgerItem>> get accountsReceivableData {
    return companyCollection
        .doc(this.uid)
        .collection('ledger')
        .where('restat_total_receivables', isLessThan: 0)
        .snapshots()
        .map(_ledgerItemData);
  }

  Stream<List<LedgerItem>> get accountsPayablesData {
    return companyCollection
        .doc(this.uid)
        .collection('ledger')
        .where('restat_total_payables', isGreaterThan: 0)
        .snapshots()
        .map(_ledgerItemData);
  }

  Stream<List<LedgerItem>> get ledgerItemData {
    return companyCollection
        .doc(this.uid)
        .collection('ledger')
        .orderBy('name', descending: false)
        .snapshots()
        .map(_ledgerItemData);
  }

  Future saveLedger({masterId, name, phone, gst, partyType}) async {
    return await companyCollection
        .doc(this.uid)
        .collection('ledger')
        .doc(masterId)
        .set({
      'name': name,
      'phone': phone,
      'gst': gst,
      'party_type': partyType,
    });
  }

  List<LedgerItem> _ledgerItemData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return LedgerItem(
        name: doc['name'].toString() ?? '',
        masterId: doc['masterid'].toString() ?? '',
        currencyName: doc['currencyname'].toString() ?? '',
        openingBalance: doc['openingbalance']?.toDouble() ?? 0,
        closingBalance: doc['closingbalance']?.toDouble() ?? 0,
        parentid: doc['parentcode'].toString() ?? '',
        contact: doc['contact'].toString() ?? '',
        state: doc['state'].toString() ?? '',
        email: doc['email'].toString() ?? '',
        phone: doc['phone'].toString() ?? '',
        guid: doc['guid'].toString() ?? '',
        // lastPaymentDate: doc['restat_last_payment_date'].toString() ?? '',
        // lastPurchaseDate:
        //     doc['restat_last_purchase_date'].toString() ?? '',
        // lastReceiptDate: doc['restat_last_receipt_date'].toString() ?? '',
        // lastSalesDate: doc['restat_last_sales_date'].toString() ?? '',
        // meanPayment: doc['restat_mean_payment'].toString() ?? '',
        // meanPurchase: doc['restat_mean_purchase'].toString() ?? '',
        // meanReceipt: doc['restat_mean_receipt'].toString() ?? '',
        // meanSales: doc['restat_mean_sales'].toString() ?? '',
        partyGuid: doc['guid'].toString() ?? '',
        // totalPayables: doc['restat_total_payables'].toString() ?? '',
        totalSales: doc['restat_total_sales'].toString() ?? '',
        totalPayment: doc['restat_total_payment'].toString() ?? '',
        totalPurchase: doc['restat_total_purchase'].toString() ?? '',
        totalReceipt: doc['restat_total_receipt'].toString() ?? '',
        // totalReceivables: doc['restat_total_receivables'].toString() ?? '',
        primaryGroupType:
            doc['restat_primary_group_type'].toString() ?? '',

      );
    }).toList();
  }
}
