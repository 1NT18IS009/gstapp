import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tassist/core/models/inactivecustomer.dart';
import 'package:tassist/core/models/payables.dart';
import 'package:tassist/core/models/receivables.dart';
import 'package:tassist/core/models/stockitem.dart';
import 'package:tassist/core/models/vouchers.dart';
import 'package:tassist/core/services/auth.dart';
import 'package:tassist/core/services/inactivecustomerservice.dart';
import 'package:tassist/core/services/payablesservice.dart';
import 'package:tassist/core/services/receivablesservice.dart';
import 'package:tassist/core/services/stockservice.dart';
import 'package:tassist/core/services/vouchers.dart';
import 'package:tassist/route_generator.dart';
import 'package:tassist/theme/texts.dart';
import 'core/models/company.dart';
import 'core/models/ledgerItem.dart';
import 'core/services/companyservice.dart';
import 'core/services/ledgerservice.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const String _title = "TallyAssist";

    return MultiProvider(providers: [
      StreamProvider<User>.value(
        value: AuthService().user,
        initialData: null,
      ),
    ], child: TopWidget(title: _title));
  }
}

class TopWidget extends StatefulWidget {
  const TopWidget({
    Key key,
    @required String title,
  })  : _title = title,
        super(key: key);

  final String _title;

  @override
  _TopWidgetState createState() => _TopWidgetState();
}

class _TopWidgetState extends State<TopWidget> {
  // final Firestore _db = Firestore.instance;

  // StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();

    // String uid = Provider.of<FirebaseUser>(context, listen: false).uid;

    // if (Platform.isIOS) {
    //   iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
    //     print(data);
    //     _saveDeviceToken();
    //   });

    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // } else {
    //_saveDeviceToken();
    // }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text(message.data['notification']['title']),
            subtitle: Text(message.data['notification']['body']),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return MultiProvider(
      providers: [
        StreamProvider<List<ReceivablesItem>>.value(
          // initialData: List<ReceivablesItem>(),
          value: ReceivablesItemService(uid: user?.uid).accountsReceivableData,
          initialData: [],
        ),
        // LEDGER/PARTY DATA
        StreamProvider<List<LedgerItem>>.value(
          value: LedgerItemService(uid: user?.uid).ledgerItemData,
          initialData: [],
        ),
        StreamProvider<List<StockItem>>.value(
          value: StockItemService(uid: user?.uid).stockItemsData,
          initialData: [],
        ),
        StreamProvider<List<PayablesItem>>.value(
          value: PayablesItemService(uid: user?.uid).accountsPayablesData,
          initialData: [],
        ),
        StreamProvider<List<InactiveCustomer>>.value(
          value: InactiveCustomerService(uid: user?.uid).inactiveCustomerData,
          initialData: [],
        ),
        // StreamProvider<List<SalesVoucher>>.value(
        //     value: SalesVoucherService(uid: user?.uid).salesVoucherData),
        // StreamProvider<List<PurchaseVoucher>>.value(
        //     value: PurchaseVoucherService(uid: user?.uid).purchaseVoucherData),
        // StreamProvider<List<PaymentVoucher>>.value(
        //     value: PaymentVoucherService(uid: user?.uid).paymentVoucherData),
        // StreamProvider<List<ReceiptVoucher>>.value(
        //     value: ReceiptVoucherService(uid: user?.uid).receiptVoucherData),
        StreamProvider<List<Voucher>>.value(
          value: VoucherService(uid: user?.uid).voucherData,
          initialData: [],
        ),
        StreamProvider<Company>.value(
          value: CompanyService(uid: user?.uid).companyData,
          initialData: null,
        ),
        // StreamProvider<DocumentSnapshot>.value(
        //     value: DatabaseService()
        //         .companyCollection
        //         .document(user?.uid)
        //         .snapshots()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        // routes: {
        //   '/': (context) => RootPage(),
        //   '/vouchers': (context) => VouchersHome(),
        //   '/voucherview': (context) => VoucherView(),
        //   '/ledgerview': (context) => LedgerView(),
        //   '/ledgers': (context) => LedgerScreen()
        // },
        title: widget._title,
        // home: HomeScreen(),
        // home: RootPage(),
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            toolbarTextStyle:
                TextTheme(headline6: primaryAppBarTitle).bodyText2,
            titleTextStyle: TextTheme(headline6: primaryAppBarTitle).headline6,
          ),
          textTheme: TextTheme(
              headline6: secondaryListTitle,
              subtitle1: secondaryCategoryDesc,
              bodyText1: secondaryListDisc,
              bodyText2: secondaryListTitle2),
        ),
      ),
    );
  }
}
