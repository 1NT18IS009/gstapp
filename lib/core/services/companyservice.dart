import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tassist/core/models/company.dart';

class CompanyService {
  final String uid;

  CompanyService({this.uid});

  final CollectionReference companyCollection =
      FirebaseFirestore.instance.collection('company');

  Stream<Company> get companyData {
    return companyCollection.doc(this.uid).snapshots().map(_companydata);
  }

  Future updateCompanyRecord(
      {String upiAddress,
      String companyName,
      String phoneNumber,
      String gstNumber,
      String registeredAddress}) async {
    return await companyCollection.doc(this.uid).set({
      'upi_address': upiAddress,
      'name': companyName,
      'phonenumber': phoneNumber,
      'gstnumber': gstNumber,
      'address': registeredAddress,
    }, SetOptions(merge: true));
  }

  Company _companydata(DocumentSnapshot snapshot) {
    Map companyData = snapshot.data();

    if (companyData != null) {
      return Company(
        address: companyData['address'] ?? '',
        countryName: companyData['countryname'] ?? '',
        email: companyData['email'] ?? '',
        formalName: companyData['basicompanyformalname'] ?? '',
        gstNumber: companyData['gstnumber'] ?? '',
        pincode: companyData['pincode'] ?? '',
        stateName: companyData['statename'] ?? '',
        hasLogo: companyData['restat_has_logo'] ?? '',
        lastEntryDate: companyData['lastentrydate']?.toDate() ?? null,
        lastSyncedAt: companyData['last_synced_at']?.toDate() ?? null,
      );
    } else {
      return Company(
        address: '',
        countryName: '',
        email: '',
        formalName: '',
        gstNumber: '',
        pincode: '',
        stateName: '',
        hasLogo: '',
      );
    }
  }
}
