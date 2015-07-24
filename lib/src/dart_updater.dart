library dart_updater.src.dart_updater;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:dart_updater/dart_updater.dart' as du;
import 'package:archive/archive.dart';
import 'dart:io' as IO;

Future<Archive> downloadSDK(String channel, String version) async {
  var sdkUrl = du.sdkUrl(channel, version);
  http.Response response = await http.get(sdkUrl);

  return new ZipDecoder().decodeBytes(await response.bodyBytes);
}

Future<Archive> downloadDartium(String channel, String version,
    {String newDartiumFolderName}) async {
  var dartiumUrl = du.dartiumUrl(channel, version);
  http.Response response = await http.get(dartiumUrl);

  Archive archive = new ZipDecoder().decodeBytes(await response.bodyBytes);

  if (newDartiumFolderName != null) {
    archive.files.forEach((archive) {
      archive.name = archive.name.replaceRange(
          0, archive.name.indexOf('/'), newDartiumFolderName);
    });
  }

  return archive;
}

Future backupDirectory(String pathToDirectoryToBackup) async {
  await new IO.Directory('$pathToDirectoryToBackup.bak').delete();
  await new IO.Directory(pathToDirectoryToBackup).rename('$pathToDirectoryToBackup.bak');
}
