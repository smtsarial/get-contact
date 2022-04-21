import 'dart:io';

import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:tipo/connections/firebase.dart';

class ExportHelper {
  Future<String> createExcel() async {
    print("hello");
    String reportLink = "";
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];
    await FirestoreHelper.getAllContacts().then((value) {
      print(value.first.addedEmail);
      //Accessing sheet via index.
      sheet.getRangeByName('A1').setText("");
      sheet.getRangeByName('B1').setText("Display Name");
      sheet.getRangeByName('C1').setText("Family Name");
      sheet.getRangeByName('D1').setText("Company");
      sheet.getRangeByName('E1').setText("Job Title");
      sheet.getRangeByName('F1').setText("Emails");
      sheet.getRangeByName('G1').setText("Phones");
      sheet.getRangeByName('H1').setText("Added UserName");
      sheet.getRangeByName('I1').setText("Added FirstName");
      sheet.getRangeByName('J1').setText("Added LastName");
      sheet.getRangeByName('K1').setText("Added Time");
      sheet.getRangeByName('L1').setText("Added Email");
      sheet.getRangeByName('M1').setText("Added Profile Picture Link");
      for (int i = 0; i < value.length; i++) {
        sheet.getRangeByName('A' + (i + 2).toString()).setText("id");
        sheet
            .getRangeByName('B' + (i + 2).toString())
            .setText(value[i].displayName);
        sheet
            .getRangeByName('C' + (i + 2).toString())
            .setText(value[i].familyName);
        sheet
            .getRangeByName('D' + (i + 2).toString())
            .setText(value[i].company);
        sheet
            .getRangeByName('E' + (i + 2).toString())
            .setText(value[i].jobTitle);
        sheet.getRangeByName('F' + (i + 2).toString()).setText(value[i].emails);
        sheet.getRangeByName('G' + (i + 2).toString()).setText(value[i].phones);
        sheet
            .getRangeByName('H' + (i + 2).toString())
            .setText(value[i].addedUserName);
        sheet
            .getRangeByName('I' + (i + 2).toString())
            .setText(value[i].addedFirstName);
        sheet
            .getRangeByName('J' + (i + 2).toString())
            .setText(value[i].addedLastName);
        sheet
            .getRangeByName('K' + (i + 2).toString())
            .setDateTime(value[i].addedTime);
        sheet
            .getRangeByName('L' + (i + 2).toString())
            .setText(value[i].addedEmail);
        sheet
            .getRangeByName('M' + (i + 2).toString())
            .setText(value[i].addedProfilePicture);
      }
    });

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    final String path = (await getApplicationDocumentsDirectory()).path;
    print(path);
    final String fileName =
        "$path/tipo_report_" + DateTime.now().toString() + ".xlsx";
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true).then((value) async {
      await FirestoreHelper.uploadAdminReport(file).then((value) {
        reportLink = value;
      });
    });
    return reportLink;
  }
}
