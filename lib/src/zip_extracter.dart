library dart_updater.src.zip_extracter;

import 'dart:async';
import 'dart:io' as IO;
import 'package:archive/archive.dart';

Future extractZipArchive(Archive archive, String extractDirectory) async {
  for (ArchiveFile file in archive) {
    String filename = file.name;
    List<int> data = file.content;

    runZoned(() async {
      try {
        await new IO.File.fromUri(new Uri.file('$extractDirectory/$filename'))
          ..create()
          ..writeAsBytes(data);
      } on IO.FileSystemException {
        // cannot create a file so we'll try to create a directory
      }

      try {
        await new IO.Directory('$extractDirectory/$filename').create();
      } on IO.FileSystemException {
        // cannot create a directory, so... welp!
      }
    }, onError: (e, s) {});
  }
}
