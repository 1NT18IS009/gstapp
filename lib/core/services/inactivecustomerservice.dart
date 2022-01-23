import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/inactivecustomer.dart';

class InactiveCustomerService {
  final String uid;

  InactiveCustomerService({this.uid});

  final CollectionReference companyCollection =
      FirebaseFirestore.instance.collection('company');

  Stream<List<InactiveCustomer>> get inactiveCustomerData {
    return companyCollection
        .doc(this.uid)
        .collection('ledgeritem')
        .where('closingbalance', isEqualTo: 0)
        .where('restat_primary_group_type', isEqualTo: 'Sundry Debtors')
        .snapshots()
        .map(_inactiveCustomerData);
  }

  List<InactiveCustomer> _inactiveCustomerData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return InactiveCustomer(
        name: doc['name'].toString() ?? '',
        masterId: doc['master_id'].toString() ?? '',
        currencyName: doc['currencyname'].toString() ?? '',
        openingBalance: doc['openingbalance'].toString() ?? '',
        closingBalance: doc['closingbalance'].toString() ?? '',
        parentid: doc['parentcode'].toString() ?? '',
        contact: doc['contact'].toString() ?? '',
        state: doc['state'].toString() ?? '',
        email: doc['email'].toString() ?? '',
        phone: doc['phone'].toString() ?? '',
        guid: doc['guid'].toString() ?? '',
        partyGuid: doc['guid'].toString() ?? '',
        primaryGroupType: doc['restat_primary_group_type'].toString() ?? '',
      );
    }).toList();
  }
}
