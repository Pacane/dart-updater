@TestOn('vm')
library dart_updater.test;

import 'package:test/test.dart';
import 'package:dart_updater/dart_updater.dart';

main() async {
  setUp(() {
    channel = 'dev/release';
    version = 'latest';
    dartiumPath = 'test/dartium/';
    dartSdkPath = 'test/dart-sdk/';
  });

  test('no new version should be available', () async {
    bool result = await isNewVersionAvailable();
    expect(result, isFalse);
  });
}
