import 'package:dart_updater/dart_updater.dart' as du;
import 'package:logging/logging.dart';

final String appsPath = "/home/joel/apps";
final String dartiumPath = '$appsPath/dartium';
final String dartSdkPath = '$appsPath/dart-sdk';
final String devChannel = 'dev';
final String stableChannel = 'stable';
final String version = 'latest';

main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    if (rec.message.isNotEmpty) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    }
  });

  du.channel = devChannel;
  du.version = version;
  du.dartiumPath = dartiumPath;
  du.dartSdkPath = dartSdkPath;

  await du.updateDartSDK();
  await du.updateDartium();
}
