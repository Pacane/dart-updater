# dart_updater

A command line application to update the Dart SDK for Linux x64 systems.

## Installation
`pub global activate dart_updater`

## Requirements

To use `dart_updater`, you must add 2 variables to your environment variables :
- `DART_SDK_PATH` : Path where the Dart SDK will be installed.

You should also have a standalone Dart version somewhere on your system to run this package. But once you run it once, you can always keep your SDK up-to-date.

## Example usage

### Showing help
`$ dart_updater --help`

### Showing help for specific command
`$ dart_updater upgrade --help`

### Updating to `dev/release`
`$ dart_updater upgrade -c dev/release`

### Updating to `stable/release`
`$ dart_updater upgrade -c stable/release`
