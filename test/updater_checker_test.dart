@TestOn('vm')
library dart_updater.test;

import 'package:test/test.dart';
import 'package:dart_updater/dart_updater.dart';

main() async {
  setUp(() {
    channel = 'dev';
    version = 'latest';
    destinationDirectory = 'test/';
  });

  test('no new version should be available', () async {
    bool result = await isNewVersionAvailable();
    expect(result, isFalse);
  });
}
