import 'package:dart_updater/dart_updater.dart' as du;
import 'package:logging/logging.dart';

final String destinationDirectory = "/home/joel/apps";
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
  du.destinationDirectory = destinationDirectory;

  await du.updateDartSDK();
  await du.updateDartium();
}
