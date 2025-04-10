import 'dart:io';

import 'package:pdf/widgets.dart';
import 'package:sound_stage/services/pdf/save_and_open_pdf.dart';

class User {
  final String name;
  final String age;

  const User({required this.name, required this.age});
}

class SimplePdfApi {
  static Future<File> generateTablePdf() async {
    final pdf = Document();
    final headers = ['Name', 'Age'];
    final users = [
      const User(name: 'John Doe', age: '25'),
      const User(name: 'Jane Smith', age: '30'),
      const User(name: 'Alice Johnson', age: '28'),
    ];
    final data = users.map((user) => [user.name, user.age]).toList();
    pdf.addPage(
      Page(
        build:
            (context) => TableHelper.fromTextArray(
              data: data,
              headers: headers,
              cellAlignment: Alignment.center,
              tableWidth: TableWidth.max,
            ),
      ),
    );
    return SaveAndOpenDocument.savePdf(name: "table_pdf.pdf", pdf: pdf);
  }
}
