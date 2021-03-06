import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tassist/core/models/ledgerItem.dart';
import 'package:tassist/theme/dimensions.dart';
import 'package:tassist/ui/views/ledgerview.dart';
import 'package:tassist/ui/widgets/partyscreen/ledgertile-new.dart';

class LedgerItemList extends StatefulWidget {
  @override
  _LedgerItemListState createState() => _LedgerItemListState();
}

class _LedgerItemListState extends State<LedgerItemList> {
  TextEditingController editingController = TextEditingController();

  List<LedgerItem> ledgerItemData;
  // ignore: deprecated_member_use
  List<LedgerItem> ledgerItemDataforDisplay = List<LedgerItem>();

  @override
  void initState() {
    ledgerItemData = Provider.of<List<LedgerItem>>(context, listen: false);
    print("ledger item list k andar");
    print(ledgerItemData);
    ledgerItemDataforDisplay.addAll(ledgerItemData);

    super.initState();
  }

  void filterSearchResults(String query) {
    // ignore: deprecated_member_use
    List<LedgerItem> dummySearchList = List<LedgerItem>();
    dummySearchList.addAll(ledgerItemData);
    if (query.isNotEmpty) {
      // ignore: deprecated_member_use
      List<LedgerItem> dummyListData = List<LedgerItem>();
      print("yeh dummy list data");
      print(dummyListData);
      dummySearchList.forEach((item) {
        if (item.name.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        ledgerItemDataforDisplay.clear();
        ledgerItemDataforDisplay.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        ledgerItemDataforDisplay.clear();
        ledgerItemDataforDisplay.addAll(ledgerItemData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String partyname;
    String ledgerGuid;

    return Container(
        height: MediaQuery.of(context).size.height / 1.1,
        child: Column(
          children: <Widget>[
            Padding(
              padding: spacer.all.xxs,
              child: Text('Total Ledgers: ${ledgerItemDataforDisplay.length}'),
            ),
            Container(
              padding: spacer.bottom.xs,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50.0,
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value.toLowerCase());
                    },
                    controller: editingController,
                    style: Theme.of(context).textTheme.bodyText2,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      labelText: "Search",
                      labelStyle: Theme.of(context).textTheme.bodyText2,
                      counterStyle: Theme.of(context).textTheme.bodyText2,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: ledgerItemDataforDisplay?.length ?? 0,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onDoubleTap: () => {
                            partyname = ledgerItemDataforDisplay[index].name,
                            ledgerGuid = ledgerItemDataforDisplay[index].guid,
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => LedgerView(
                                          ledgerGuid: ledgerGuid,
                                          partyname: partyname,
                                        )))
                          },
                      child: LedgerItemTileNew(
                          ledgerItem: ledgerItemDataforDisplay[index]));
                },
              ),
            ),
          ],
        ));
  }
}
