import 'package:flutter/services.dart';

abstract final class AndroidFiles {
  static const MethodChannel _channel = MethodChannel('furlovin_files');

  static Future<bool> sharesMedia() async =>
      await _channel.invokeMethod<bool>('sharesMedia') ?? false;

  static Future<String> saveToMedia({
    required String source,
    required String name,
    required String mime,
    required String folder,
  }) async => (await _channel.invokeMethod<String>('saveToMedia', {
    'source': source,
    'name': name,
    'mime': mime,
    'folder': folder,
  }))!;

  static Future<String?> pickFolder({String? initial}) =>
      _channel.invokeMethod<String>('pickFolder', {'initial': initial});

  static Future<bool> canWrite(String folder) async =>
      await _channel.invokeMethod<bool>('canWrite', {'folder': folder}) ??
      false;

  static Future<void> writeToFolder({
    required String folder,
    required String source,
    required String name,
    required String mime,
  }) => _channel.invokeMethod<void>('writeToFolder', {
    'folder': folder,
    'source': source,
    'name': name,
    'mime': mime,
  });
}
