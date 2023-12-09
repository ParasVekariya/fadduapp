import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // creat the credentials

  static const _credentials = r'''{
    credentials here
  }''';

  static final _spreadsheetId = '';
  static final _gsheet = GSheets(_credentials);
  static Worksheet? _worksheet;

  // initialise the wroksheet

  Future init() async {
    final ss = await _gsheet.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle("Worksheet1");
  }
}
