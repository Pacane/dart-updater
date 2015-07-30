import 'package:unscripted/unscripted.dart';
import 'package:dart_updater/dart_updater.dart' as du;

main(arguments) => new Script(Updater).execute(arguments);

class Updater extends Object with CheckForUpdatesCommand, UpgradeCommand {
  @Command(help: 'Updates Dart SDK', plugins: const [const Completion()])
  Updater();
}

class CheckForUpdatesCommand {
  @SubCommand(help: 'Checks for updates.')
  check({@Option(
      help: 'The channel of the SDK',
      defaultsTo: 'dev/release',
      allowed: const ['dev/release', 'stable/release', 'be/raw'],
      abbr: 'c') String channel, @Option(
      abbr: 'd',
      help: 'Specifies the directory where dartium and dart-sdk directories reside.',
      defaultsTo: '/home/joel/apps') String destinationDirectory}) async {
    du.version = 'latest';
    du.channel = channel;
    du.destinationDirectory = '/home/joel/apps';

    if (await du.isNewVersionAvailable()) {
      print("A different version from yours is available.");
    } else {
      print("No new version available!");
    }
  }
}

class UpgradeCommand {
  @SubCommand(help: 'Upgrades SDK and Dartium.')
  upgrade({@Option(
      help: 'The channel of the SDK',
      defaultsTo: 'dev/release',
      allowed: const ['dev/release', 'stable/release', 'be/raw'],
      abbr: 'c') String channel, @Option(
      abbr: 'd',
      help: 'Specifies the directory where dartium and dart-sdk directories reside.',
      defaultsTo: '/home/joel/apps') String destinationDirectory}) async {
    du.version = 'latest';
    du.channel = channel;
    du.destinationDirectory = '/home/joel/apps';

    if (await du.isNewVersionAvailable()) {
      print("A different version from yours is available.");
      print("Upgrading SDK!");
      await du.updateDartSDK();
      print("Upgrading Dartium!");
      await du.updateDartium();
    } else {
      print("No new version available!");
    }
  }
}
