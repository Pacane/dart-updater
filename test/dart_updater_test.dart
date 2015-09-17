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

  test('download dartium should download an archive', () async {
    var downloaded = await downloadDartium();
    expect(downloaded.runtimeType, Archive);
  });

  test('should rename the top level directory when flag is set', () async {
    var downloaded = await downloadDartium(newDartiumFolderName: 'dartium');
    expect(downloaded.first.name, 'dartium/');
  });

  test('shouldnt rename the top level directory when flag aint set', () async {
    var downloaded = await downloadDartium();
    expect(downloaded.first.name.startsWith('dartium-lucid64-full'), isTrue);
  });
}
