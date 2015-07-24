import 'package:dart_updater/dart_updater.dart';
import 'package:dart_updater/zip_extracter.dart';
import 'package:logging/logging.dart';

main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  backupDirectory('$destinationDirectory/dart-sdk');
  backupDirectory('$destinationDirectory/dartium');

  downloadSDK(devChannel, version)
      .then((archive) => extractZipArchive(archive, destinationDirectory));
  downloadDartium(devChannel, version, newDartiumFolderName: 'dartium')
      .then((archive) => extractZipArchive(archive, destinationDirectory));
}
