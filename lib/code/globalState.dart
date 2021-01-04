import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

class GlobalState {
  @override
  static GlobalState instance = new GlobalState._();
  GlobalState._();

  set(dynamic key, dynamic value) async {
    _toDos[key] = value;
  }

  get(key) => _toDos[key];

  dynamic _toDos = readcontent();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<Map> _readcontent() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      Map toDos = jsonDecode(contents);
      return toDos;
    } catch (e) {
      // If there is an error reading, return a default String
      return {'main': [], 'archived': [], 'history': []};
    }
  }

  Future<File> _writeContent() async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(jsonEncode(_toDos));
  }

  /*Future<Null> _write_file() async {
    String save_file = jsonEncode(_toDos);
    await (await _getLocalFile()).writeAsString('$save_file');
  }*/
}
