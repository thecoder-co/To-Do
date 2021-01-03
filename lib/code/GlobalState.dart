import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class GlobalState {
  Map _toDos = {'main': [], 'archived': [], 'history': []}; //_write_file()

  static GlobalState instance = new GlobalState._();
  GlobalState._();

  set(dynamic key, dynamic value) {
    _toDos[key] = value;
    // _write_file();
  }

  get(key) => _toDos[key];

  /* Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/toDos.txt');
  }

  Future<Map> _read_file() async {
    try {
      File file = await _getLocalFile();
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      Map toDos = jsonDecode(contents);
      return toDos;
    } on FileSystemException {
      return {'main': [], 'archived': [], 'history': []};
    }
  }

  Future<Null> _write_file() async {
    String save_file = jsonEncode(_toDos);
    await (await _getLocalFile()).writeAsString('$save_file');
  
    
  }


  work in progress
  */
}
