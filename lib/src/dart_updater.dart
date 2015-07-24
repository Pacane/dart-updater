library dart_updater.src.dart_updater;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:dart_updater/dart_updater.dart' as du;
import 'package:archive/archive.dart';
import 'dart:io' as IO;
import 'package:logging/logging.dart';

final Logger log = new Logger('dart_updater');

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
  IO.Directory oldBackupDirectory =
      await new IO.Directory('$pathToDirectoryToBackup.bak');

  if (await oldBackupDirectory.exists()) {
    await oldBackupDirectory.delete(recursive: true);
  }

  IO.Directory oldDirectory = await new IO.Directory(pathToDirectoryToBackup);

  if (await oldDirectory.exists()) {
    oldDirectory.rename('$pathToDirectoryToBackup.bak');
  } else {
    log.warning(
        "Couldn't find $pathToDirectoryToBackup and therefore no backup was made of it.");
  }
}
