import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/payables.dart';

class PayablesItemService {
  final String uid;
  PayablesItemService({this.uid});

  final CollectionReference companyCollection =
      FirebaseFirestore.instance.collection('company');

  Stream<List<PayablesItem>> get accountsPayablesData {
    return companyCollection
        .doc(this.uid)
        .collection('ledger')
        .where('restat_primary_group_type',
            whereIn: ['Sundry Debtors', 'Sundry Creditors'])
        .where('closing_balance', isGreaterThan: 0)
        .orderBy('closing_balance', descending: true)
        .snapshots()
        .map(_payablesItemData);
  }

  List<PayablesItem> _payablesItemData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PayablesItem(
        name: doc['name'].toString() ?? '',
        masterId: doc['master_id'].toString() ?? '',
        currencyName: doc['currencyname'].toString() ?? '',
        openingBalance: doc['opening_balance'].toString() ?? '',
        closingBalance: doc['closing_balance'].toString() ?? '',
        parentid: doc['parentcode'].toString() ?? '',
        contact: doc['contact'].toString() ?? '',
        state: doc['state'].toString() ?? '',
        email: doc['email'].toString() ?? '',
        phone: doc['phone'].toString() ?? '',
        guid: doc['guid'].toString() ?? '',
        lastPaymentDate: doc['restat_last_payment_date'].toString() ?? '',
        lastPurchaseDate:
            doc['restat_last_purchase_date'].toString() ?? '',
        lastReceiptDate: doc['restat_last_receipt_date'].toString() ?? '',
        lastSalesDate: doc['restat_last_sales_date'].toString() ?? '',
        meanPayment: doc['restat_mean_payment'].toString() ?? '',
        meanPurchase: doc['restat_mean_purchase'].toString() ?? '',
        meanReceipt: doc['restat_mean_receipt'].toString() ?? '',
        meanSales: doc['restat_mean_sales'].toString() ?? '',
        partyGuid: doc['restat_party_guid'].toString() ?? '',
        totalPayables: doc['restat_total_payables'].toString() ?? '',
        totalPayment: doc['restat_total_payment'].toString() ?? '',
        totalPurchase: doc['restat_total_purchase'].toString() ?? '',
        totalReceipt: doc['restat_total_receipt'].toString() ?? '',
        totalReceivables: doc['restat_total_receivables'].toString() ?? '',
      );
    }).toList();
  }
}
