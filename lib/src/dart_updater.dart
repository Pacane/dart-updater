library dart_updater.src.dart_updater;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:dart_updater/dart_updater.dart' as du;
import 'package:dart_updater/zip_extracter.dart';
import 'package:archive/archive.dart';
import 'dart:io' as io;
import 'dart:convert';

final Logger log = new Logger('dart_updater');
String dartiumPath;
String dartSdkPath;
String channel;
String version;

final String baseDownloadUrl =
    'http://gsdview.appspot.com/dart-archive/channels';

String versionCheckURL(String channel, String version) =>
    'http://gsdview.appspot.com/dart-archive/channels/$channel/$version/VERSION';

const String SDKx64Release = 'dartsdk-linux-x64-release';

String sdkUrl(String channel, String version) =>
    '$baseDownloadUrl/$channel/$version/sdk/$SDKx64Release.zip';

Future<Archive> downloadSDK() async {
  var sdkUrl = du.sdkUrl(channel, version);
  http.Response response = await http.get(sdkUrl);

  if (response.statusCode == 404) {
    throw 'SDK $channel / $version not found';
  }

  return new ZipDecoder().decodeBytes(await response.bodyBytes);
}

renameTopLevelDirectory(ArchiveFile archive, String newDartiumFolderName) {
  archive.name = archive.name
      .replaceRange(0, archive.name.indexOf('/'), newDartiumFolderName);
}

Future backupDirectory(String pathToDirectoryToBackup) async {
  io.Directory oldBackupDirectory =
      await new io.Directory('$pathToDirectoryToBackup.bak');

  if (await oldBackupDirectory.exists()) {
    await oldBackupDirectory.delete(recursive: true);
  }

  io.Directory oldDirectory = await new io.Directory(pathToDirectoryToBackup);

  if (await oldDirectory.exists()) {
    oldDirectory.rename('$pathToDirectoryToBackup.bak');
  } else {
    log.warning(
        "Couldn't find $pathToDirectoryToBackup and therefore no backup was made of it.");
  }
}

Future changePermissionsOnExecutables(
    String directory, String executable) async {
  io.ProcessResult result = await io.Process.run("chmod", ['+x', executable],
      runInShell: true, workingDirectory: directory);

  log.warning(result.stderr);
  log.fine(result.stdout);
}

Future updateDartSDK() async {
  backupDirectory(dartSdkPath);
  backupDirectory(dartiumPath);

  var archive = await downloadSDK();

  await extractZipArchive(archive, dartSdkPath);
  await changePermissionsOnExecutables('$dartSdkPath/bin', 'dart');
  await changePermissionsOnExecutables('$dartSdkPath/bin', 'dart2js');
  await changePermissionsOnExecutables('$dartSdkPath/bin', 'dartdevc');
  await changePermissionsOnExecutables('$dartSdkPath/bin', 'dartanalyzer');
  await changePermissionsOnExecutables('$dartSdkPath/bin', 'dartdocgen');
  await changePermissionsOnExecutables('$dartSdkPath/bin', 'dartdoc');
  await changePermissionsOnExecutables('$dartSdkPath/bin', 'dartfmt');
  await changePermissionsOnExecutables('$dartSdkPath/bin', 'docgen');
  await changePermissionsOnExecutables('$dartSdkPath/bin', 'pub');
}

Future<bool> isNewVersionAvailable() async {
  http.Response response = await http.get(versionCheckURL(channel, version));

  Map decoded = JSON.decode(response.body);
  Version upstreamVersion = new Version.fromMap(decoded);

  Version currentVersion = await getCurrentSDKVersion();

  return upstreamVersion.version != currentVersion.version;
}

Future<Version> getCurrentSDKVersion() async {
  io.File versionFile = new io.File('$dartSdkPath/version');

  List<String> lines = await versionFile.readAsLines();
  return new Version()..version = lines[0];
}

class Version {
  String version;
  DateTime date;
  String gitHash;

  Version();

  Version.fromMap(Map json) {
    version = json['version'];
    date = DateTime.parse(json['date']);
    gitHash = json['revision'];
  }
}
