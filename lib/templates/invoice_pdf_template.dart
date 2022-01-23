import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

createInvoicePdf({
  String companyName,
  String companyAddress,
  String companyPincode,
  // Need to add Company GST, signature, terms and conditions, payment link..
  // String companyPan,
  String partyName,
  String partyAddress,
  String partyPincode,
  String partyState,
  String partyGST,
  String invoiceNumber,
  String invoiceDate,
  List<List<String>> itemList,
  String logoPath,
}) {
  final pdf = Document();
  Center logoImage;
  // if (logoPath != null) {
  //   logoImage = Center(
  //     child: Image(MemoryImage(File(logoPath).readAsBytesSync()),
  //         fit: BoxFit.contain),
  //   );
  // } else {
  logoImage = Center(child: SizedBox());
  // }

  pdf.addPage(
    MultiPage(
      pageFormat:
          PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: PdfColors.grey, width: 0.5))),
            child: Text('TallyAssist',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      footer: (Context context) {
        return Container(
          margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Generated using TallyAssist',
                    style: TextStyle(
                        color: PdfColors.purple400, font: Font.timesItalic())),
                Text('Page ${context.pageNumber} of ${context.pagesCount}',
                    style: Theme.of(context)
                        .defaultTextStyle
                        .copyWith(color: PdfColors.grey))
              ]),
        );
      },
      build: (Context context) => <Widget>[
        Header(
          level: 0,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: PdfColors.grey,
                      width: 0.5,
                      style: BorderStyle.solid),
                  bottom: BorderSide(
                      color: PdfColors.grey,
                      width: 0.5,
                      style: BorderStyle.solid)),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(companyName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text(companyAddress),
                      Text(companyPincode),
                      Text('GSTIN: ABCD123456SDS')
                    ],
                  ),
                  logoImage, // C,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('GST Invoice',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text('Invoice No.: $invoiceNumber'),
                      Text('Invoice Date: $invoiceDate'),
                      Text('Place of supply:'),
                    ],
                  ), // Need this to be

                  // PdfLogo()
                ]),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Customer Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text(partyName),
                      Text(partyAddress ?? ''),
                      Text(partyPincode ?? ''),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Customer GSTIN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text(partyGST ?? ''),
                    Text('State: $partyState',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text('Due Date:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: 470,
              child: GridView(
                crossAxisCount: 4,
                childAspectRatio: 0.3,
                children: <Widget>[
                  // Need to add fields here from the invoice
                  gridChild('Delivery Notes', ''),
                  gridChild('Mode/Terms of Payment', ''),
                  // gridChild('Suppliers Ref', ''),
                  // gridChild('Other Reference(s)', ''),
                  gridChild('Buyers order no', ''),
                  gridChild('Dated', ''),
                  gridChild('Despatch Doc No', ''),
                  gridChild('Delivery Note Date', ''),
                  gridChild('Despatched through', ''),
                  gridChild('Destination', ''),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Table.fromTextArray(context: context, data: itemList),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Company PAN:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )), //
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: PdfColors.grey400,
                    width: 5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('For $companyName'),
                    SizedBox(height: 25),
                    Text('Authorised Signatory'),
                  ],
                ),
              ),
            ),
          ],
        ),
        // SizedBox(height: 20),

        Padding(padding: const EdgeInsets.all(10)),
      ],
    ),
  );
  return pdf;
}

gridChild(String text1, String text2) {
  return Container(
    padding: const EdgeInsets.only(left: 2.0 * PdfPageFormat.mm),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      border: Border.all(
        color: PdfColors.grey400,
        width: 5,
      ),
    ),
    child: Column(
      children: <Widget>[
        Text(text1),
        Text(text2),
      ],
    ),
  );
}
