import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalFileUtil {

  static Future<File> getLocalFile(String filename) async {

     String dir = (await getApplicationDocumentsDirectory()).path;
     return new File('$dir/$filename');
  }
}