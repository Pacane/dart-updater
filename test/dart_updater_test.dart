@TestOn('vm')
library dart_updater.test;

import 'package:dart_updater/dart_updater.dart';
import 'package:test/test.dart';
import 'package:archive/archive.dart';

main() async {
  test('download sdk should download an archive', () async {
    var downloaded = await downloadSDK(devChannel, version);
    expect(downloaded.runtimeType, Archive);
  });

  test('download dartium should download an archive', () async {
    var downloaded = await downloadDartium(devChannel, version);
    expect(downloaded.runtimeType, Archive);
  });

  test(
      'download dartium should download an archive with top folder called dartium',
      () async {
    var downloaded = await downloadDartium(devChannel, version,
        newDartiumFolderName: 'dartium');
    expect(downloaded.first.name, 'dartium/');
  });
}
