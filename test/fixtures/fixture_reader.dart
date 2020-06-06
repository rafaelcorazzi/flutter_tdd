import 'dart:io';
import 'package:path/path.dart';

final testDirectory = join(
  Directory.current.path,
  Directory.current.path.endsWith('test') ? '' : 'test',
);

String fixture(String name) => File('$testDirectory/fixtures/$name').readAsStringSync();