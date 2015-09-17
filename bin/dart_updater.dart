import 'package:unscripted/unscripted.dart';
import 'package:dart_updater/dart_updater.dart' as du;
import 'dart:io';

final DART_SDK_ENV_VARIABLE_NAME = 'DART_SDK_PATH';
final DARTIUM_PATH_ENV_VARIABLE_NAME = 'DARTIUM_PATH';

checkForRequiredEnvironmentVariables() {
  var environment = Platform.environment;
  if (!environment.containsKey(DART_SDK_ENV_VARIABLE_NAME)) {
    print("You need to specify the Dart SDK install path by declaring an "
        "environment variable called DART_SDK_PATH");
  }

  if (!environment.containsKey(DARTIUM_PATH_ENV_VARIABLE_NAME)) {
    print("You need to specify Dartium's install path by declaring an "
        "environment variable called DARTIUM_PATH");
  }

  du.dartiumPath = environment[DARTIUM_PATH_ENV_VARIABLE_NAME];
  du.dartSdkPath = environment[DART_SDK_ENV_VARIABLE_NAME];
}

main(arguments) => new Script(Updater).execute(arguments);

class Updater extends Object with CheckForUpdatesCommand, UpgradeCommand {
  @Command(help: 'Updates Dart SDK', plugins: const [const Completion()])
  Updater();
}

class CheckForUpdatesCommand {
  @SubCommand(help: 'Checks for updates.')
  check(
      {@Option(
          help: 'The channel of the SDK',
          defaultsTo: 'dev/release',
          allowed: const ['dev/release', 'stable/release', 'be/raw'],
          abbr: 'c')
      String channel}) async {
    du.version = 'latest';
    du.channel = channel;

    checkForRequiredEnvironmentVariables();

    if (await du.isNewVersionAvailable()) {
      print("A different version from yours is available.");
    } else {
      print("No new version available!");
    }
  }
}

class UpgradeCommand {
  @SubCommand(help: 'Upgrades SDK and Dartium.')
  upgrade(
      {@Option(
          help: 'The channel of the SDK',
          defaultsTo: 'dev/release',
          allowed: const ['dev/release', 'stable/release', 'be/raw'],
          abbr: 'c')
      String channel}) async {
    du.version = 'latest';
    du.channel = channel;

    checkForRequiredEnvironmentVariables();

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
