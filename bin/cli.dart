import 'package:unscripted/unscripted.dart';

main(arguments) => new Script(Updater).execute(arguments);

class Updater extends Object with CheckForUpdatesCommand {
  @Command(help: 'Updates Dart SDK', plugins: const [const Completion()])
  Updater();
}

class CheckForUpdatesCommand {
  @SubCommand(help: 'Checks for updates.')
  check({@Option(
      help: 'Can be "dev" or "stable"',
      defaultsTo: 'dev',
      abbr: 'c',
      allowed: const [
    'dev',
    'stable'
  ]) String channel}) => print('checking for updates with channel: $channel');
}
