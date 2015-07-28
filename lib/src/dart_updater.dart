library dart_updater.src.dart_updater;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:dart_updater/dart_updater.dart' as du;
import 'package:dart_updater/zip_extracter.dart';
import 'package:archive/archive.dart';
import 'dart:io' as IO;
import 'package:logging/logging.dart';

final Logger log = new Logger('dart_updater');
String channel;
String version;
String destinationDirectory;

Future<Archive> downloadSDK() async {
  var sdkUrl = du.sdkUrl(channel, version);
  http.Response response = await http.get(sdkUrl);

  return new ZipDecoder().decodeBytes(await response.bodyBytes);
}

renameTopLevelDirectory(ArchiveFile archive, String newDartiumFolderName) {
  archive.name = archive.name.replaceRange(
      0, archive.name.indexOf('/'), newDartiumFolderName);
}

///
/// If you want to change Dartium's top level directory name to
/// something predictable use [newDartiumFolderName]
///
Future<Archive> downloadDartium({String newDartiumFolderName}) async {
  var dartiumUrl = du.dartiumUrl(channel, version);
  http.Response response = await http.get(dartiumUrl);

  Archive archive = new ZipDecoder().decodeBytes(await response.bodyBytes);

  if (newDartiumFolderName != null) {
    archive.files.forEach((archive) {
      renameTopLevelDirectory(archive, newDartiumFolderName);
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

Future changePermissionsOnExecutables(
    String directory, String executable) async {
  IO.ProcessResult result = await IO.Process.run("chmod", ['+x', executable],
      runInShell: true, workingDirectory: directory);

  log.warning(result.stderr);
  log.fine(result.stdout);
}

Future updateDartSDK() async {
  backupDirectory('$destinationDirectory/dart-sdk');
  backupDirectory('$destinationDirectory/dartium');

  var archive = await downloadSDK();
  await extractZipArchive(archive, destinationDirectory);
  await changePermissionsOnExecutables(
      '$destinationDirectory/dart-sdk/bin', 'dart');
  await changePermissionsOnExecutables(
      '$destinationDirectory/dart-sdk/bin', 'dart2js');
  await changePermissionsOnExecutables(
      '$destinationDirectory/dart-sdk/bin', 'dartanalyzer');
  await changePermissionsOnExecutables(
      '$destinationDirectory/dart-sdk/bin', 'dartdocgen');
  await changePermissionsOnExecutables(
      '$destinationDirectory/dart-sdk/bin', 'dartfmt');
  await changePermissionsOnExecutables(
      '$destinationDirectory/dart-sdk/bin', 'docgen');
  await changePermissionsOnExecutables(
      '$destinationDirectory/dart-sdk/bin', 'pub');
}

Future updateDartium() async {
  var archive = await downloadDartium(newDartiumFolderName: 'dartium');
  await extractZipArchive(archive, destinationDirectory);
  await changePermissionsOnExecutables(
      '$destinationDirectory/dartium', 'chrome');
}