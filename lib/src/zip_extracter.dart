library dart_updater.src.zip_extracter;

import 'dart:async';
import 'dart:io' as io;
import 'package:archive/archive.dart';

Future extractZipArchive(Archive archive, String extractDirectory) async {
  String extractDirectoryWithoutTopLevel =
      extractDirectory.substring(0, extractDirectory.lastIndexOf("/"));
  for (ArchiveFile file in archive) {
    String filename = file.name;
    List<int> data = file.content;

    if (filename.endsWith('/')) {
      await new io.Directory('$extractDirectoryWithoutTopLevel/$filename')
          .create();
    } else {
      await new io.File('$extractDirectoryWithoutTopLevel/$filename')
        ..create()
        ..writeAsBytes(data);
    }
  }
}
