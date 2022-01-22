import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/production.dart';
import 'package:tassist/core/models/khata.dart';
import 'package:tassist/core/models/salesvoucher.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // INITIALIZE DATABASE REFERENCES

  // create reference to metric collection
  final CollectionReference metricCollection =
      FirebaseFirestore.instance.collection('metrics');

  //Connectiong to Collection Products
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('products');

  //Connectiong to Collection Products
  final CollectionReference khataCollection =
      FirebaseFirestore.instance.collection('khata');

  // create reference to company collection
  final CollectionReference companyCollection =
      FirebaseFirestore.instance.collection('company');

  // METRICS

  Future createMetricsRecord() async {
    return await metricCollection.doc(uid).set({
      'total_sales': 0,
    });
  }

  // IDFix - use current user
  Future createProductionRecord(
      DateTime date, String product, String production) async {
    return await companyCollection
        .doc(this.uid)
        .collection('production')
        .doc()
        .set({
      'Date': date,
      'Product': product,
      'Production': production,
    });
  }

// defining a list of production data items
  List<Production> _productionListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Production(
        date: doc['Date'].toDate() ?? '',
        product: doc['Product'] ?? '',
        production: doc['Production'] ?? 0,
      );
    }).toList();
  }

// Creating a stream of production data items so that we can listen on them
  Stream<List<Production>> get productionData {
    return companyCollection
        .doc(this.uid)
        .collection('production')
        .orderBy('Date', descending: true)
        .snapshots()
        .map(_productionListfromSnapshot);
  }

// CTS

  // KHATA

  Future createKhataRecord(
      DateTime date, String partyname, String amount, String trantype) async {
    return await khataCollection
        .doc(this.uid)
        .collection('transactions')
        .doc()
        .set({
      'date': date,
      'trantype': trantype,
      'partyname': partyname,
      'amount': amount,
    });
  }

  Future deleteKhata(String documentId) async {
    // IDFixTODO
    await khataCollection
        .doc(this.uid)
        .collection('transactions')
        .doc(documentId)
        .delete();
  }

// defining a list of production data items
  List<Khata> _khatarecordfromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Khata(
        date: doc['date'].toDate() ?? '',
        partyname: doc['partyname'] ?? '',
        amount: doc['amount'] ?? '',
        trantype: doc['trantype'] ?? '',
        id: doc.id ?? '',
      );
    }).toList();
  }

// Creating a stream of production data items so that we can listen on them
  Stream<List<Khata>> get khataData {
    return khataCollection
        .doc(this.uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map(_khatarecordfromSnapshots);
  }
}

class SalesVoucherService {
  final String uid;
  SalesVoucherService({this.uid});

  final CollectionReference companyCollection =
      FirebaseFirestore.instance.collection('company');

  Stream<List<SalesVoucher>> get salesVoucherData {
    return companyCollection
        .doc(this.uid)
        .collection('voucher')
        .where('primaryvouchertypename', isEqualTo: 'Sales')
        .orderBy('amount', descending: true)
        .snapshots()
        .map(_salesvouchersfromSnapshots);
  }

  List<SalesVoucher> _salesvouchersfromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SalesVoucher(
        date: doc['date'] ?? '',
        partyname: doc['restat_party_ledger_name'] ?? '',
        amount: doc['amount'].toInt() ?? 0,
        masterid: doc['masterid'] ?? '',
        iscancelled: doc['iscancelled'] ?? '',
      );
    }).toList();
  }
}
