import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tassist/core/models/khata.dart';
import 'package:tassist/core/services/database.dart';
import 'package:tassist/theme/colors.dart';
import 'package:tassist/ui/widgets/khataScreen/khatatile.dart';

class KhataList extends StatefulWidget {
  @override
  _KhataListState createState() => _KhataListState();
}

class _KhataListState extends State<KhataList> {
  @override
  Widget build(BuildContext context) {
    final khataData = Provider.of<List<Khata>>(context);
    var user = Provider.of<User>(context);

    // final id = DatabaseService().khataCollection.document(user.uid).collection('transations').document().documentID;

    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: khataData?.length ?? 0,
        itemBuilder: (context, index) {
          return Dismissible(
              key: Key(khataData[index].id.toString()),
              onDismissed: (DismissDirection dismissDirection) async {
                if (khataData.contains(khataData[index])) {
                  setState(() async {
                    await DatabaseService(uid: user.uid)
                        .deleteKhata(khataData[index].id);
                    khataData.removeAt(index);
                  });
                }
                // ignore: deprecated_member_use
                Scaffold.of(context).showSnackBar(
                    new SnackBar(content: Text("Entry deleted permanently.")));
              },
              background: new Container(color: TassistWarning),
              child: KhataTile(khata: khataData[index]));
        },
      ),
    );
  }
}
