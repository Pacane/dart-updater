@TestOn('vm')
library dart_updater.test;

import 'package:dart_updater/dart_updater.dart';
import 'package:test/test.dart';
import 'package:archive/archive.dart';

main() async {
  setUp(() {
    channel = 'dev/release';
    version = 'latest';
  });

  test('download sdk should download an archive', () async {
    var downloaded = await downloadSDK();
    expect(downloaded.runtimeType, Archive);
  });
}
