import 'package:dart_updater/dart_updater.dart';
import 'package:dart_updater/zip_extracter.dart';
import 'package:archive/archive.dart';

main() async {
  backupDirectory('$destinationDirectory/dart-sdk');
  backupDirectory('$destinationDirectory/dartium');

  downloadSDK(devChannel, version)
      .then((archive) => extractZipArchive(archive, destinationDirectory));
  downloadDartium(devChannel, version)
      .then((archive) => extractZipArchive(archive, destinationDirectory));
}
