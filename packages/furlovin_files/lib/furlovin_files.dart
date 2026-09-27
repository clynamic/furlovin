import 'package:flutter/services.dart';

abstract final class AndroidFiles {
  static const MethodChannel _channel = MethodChannel('furlovin_files');

  static Future<bool> sharesMedia() async =>
      await _channel.invokeMethod<bool>('sharesMedia') ?? false;

  static Future<String> saveToMedia({
    required String source,
    required String name,
    required String mime,
    required String directory,
  }) async => (await _channel.invokeMethod<String>('saveToMedia', {
    'source': source,
    'name': name,
    'mime': mime,
    'directory': directory,
  }))!;

  static Future<String?> pickDirectory({String? initial}) =>
      _channel.invokeMethod<String>('pickDirectory', {'initial': initial});

  static Future<bool> canWrite(String directory) async =>
      await _channel.invokeMethod<bool>('canWrite', {'directory': directory}) ??
      false;

  static Future<void> writeToDirectory({
    required String directory,
    required String source,
    required String name,
    required String mime,
  }) => _channel.invokeMethod<void>('writeToDirectory', {
    'directory': directory,
    'source': source,
    'name': name,
    'mime': mime,
  });
}
