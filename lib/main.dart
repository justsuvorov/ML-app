import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';


void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time} | ${record.loggerName}${record.message}');
  });  
  runApp(
    const MyApp(),
  );
}