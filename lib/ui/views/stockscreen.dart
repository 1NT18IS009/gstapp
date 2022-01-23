import 'package:flutter/material.dart';
import 'package:tassist/ui/shared/drawer.dart';
import 'package:tassist/ui/shared/headernav.dart';
import 'package:tassist/ui/widgets/sectionHeader.dart';
import 'package:tassist/ui/widgets/stockscreen/stocklist.dart';

class StockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<FirebaseUser>(context);
    final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
    print(_drawerKey);
    return Scaffold(
      key: _drawerKey,
      drawer: tassistDrawer(context),
      appBar: headerNav(_drawerKey),
      body: ListView(
        children: <Widget>[SectionHeader('Stock Items'), StockItemList()],
      ),
    );
  }
}
