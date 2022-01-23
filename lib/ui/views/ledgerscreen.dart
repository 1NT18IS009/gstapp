import 'package:flutter/material.dart';
import 'package:tassist/ui/shared/drawer.dart';
import 'package:tassist/ui/shared/headernav.dart';
import 'package:tassist/ui/widgets/partyscreen/ledgeritemlist.dart';
import 'package:tassist/ui/widgets/sectionHeader.dart';

class LedgerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<FirebaseUser>(context);
    final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
    print("drawer key:");
    print(_drawerKey.toString());
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _drawerKey,
          drawer: tassistDrawer(context),
          appBar: headerNav(_drawerKey),
          body: ListView(
            children: <Widget>[SectionHeader('Ledgers'), LedgerItemList()],
          )),
    );
  }
}
