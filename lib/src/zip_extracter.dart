library dart_updater.src.zip_extracter;

import 'dart:async';
import 'dart:io' as IO;
import 'package:archive/archive.dart';

Future extractZipArchive(Archive archive, String extractDirectory) async {
  for (ArchiveFile file in archive) {
    String filename = file.name;
    List<int> data = file.content;

    if (filename.endsWith('/')) {
      await new IO.Directory('$extractDirectory/$filename').create();
    } else {
      await new IO.File('$extractDirectory/$filename')
        ..create()
        ..writeAsBytes(data);
    }
  }
}
