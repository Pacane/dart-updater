// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

/// The dart_updater library.
library dart_updater;

export 'src/dart_updater.dart';

final String baseDownloadUrl =
    'https://storage.googleapis.com/dart-archive/channels';

final String SDKx64Release = 'dartsdk-linux-x64-release';
final String dartiumx64Release = 'dartium-linux-x64-release';

final String devChannel = 'dev';
final String stableChannel = 'stable';
final String version = 'latest';

String sdkUrl(String channel, String version) =>
    '$baseDownloadUrl/$channel/release/$version/sdk/$SDKx64Release.zip';

String dartiumUrl(String channel, String version) =>
    '$baseDownloadUrl/$channel/release/$version/dartium/$dartiumx64Release.zip';

final destinationDirectory = "/home/joel/tmp";
