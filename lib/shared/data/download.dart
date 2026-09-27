import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:furlovin_files/furlovin_files.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String sharedMediaDirectory = 'furlovin';

const String androidPictures =
    'content://com.android.externalstorage.documents/tree/primary%3APictures';

bool get platformDownloads => switch (defaultTargetPlatform) {
  TargetPlatform.android ||
  TargetPlatform.linux ||
  TargetPlatform.windows ||
  TargetPlatform.macOS => !kIsWeb,
  _ => false,
};

class DownloadCancelled implements Exception {
  const DownloadCancelled();
}

sealed class DownloadTarget {
  const DownloadTarget();
}

class SharedMediaTarget extends DownloadTarget {
  const SharedMediaTarget();
}

class DirectoryTarget extends DownloadTarget {
  const DirectoryTarget(this.directory);

  final String directory;
}

String directoryLabel(String directory) {
  if (!directory.startsWith('content://')) return directory;
  final String tree = Uri.decodeComponent(
    Uri.parse(directory).pathSegments.last,
  );
  final int colon = tree.indexOf(':');
  final String volume = colon < 0 ? tree : tree.substring(0, colon);
  final String path = colon < 0 ? '' : tree.substring(colon + 1);
  final String root = volume == 'primary' ? 'Internal storage' : volume;
  return path.isEmpty ? root : path;
}

abstract final class Downloads {
  static bool get _android => defaultTargetPlatform == TargetPlatform.android;

  static Future<String?> pickDirectory({String? initial}) async {
    if (_android) {
      return AndroidFiles.pickDirectory(initial: initial ?? androidPictures);
    }
    return FilePicker.getDirectoryPath(
      dialogTitle: 'Choose a folder',
      initialDirectory: initial,
    );
  }

  static Future<bool> sharesMedia() async =>
      _android && await AndroidFiles.sharesMedia();

  static Future<String?> defaultDirectory() async =>
      _android ? null : (await getDownloadsDirectory())?.path;

  static Future<DownloadTarget> target({
    required String? chosen,
    required ValueChanged<String> onChosen,
  }) async {
    if (chosen == null) {
      if (await sharesMedia()) return const SharedMediaTarget();
      if (await defaultDirectory() case final String fallback) {
        return DirectoryTarget(fallback);
      }
    } else if (!_android || await AndroidFiles.canWrite(chosen)) {
      return DirectoryTarget(chosen);
    }
    final String? picked = await pickDirectory(initial: chosen);
    if (picked == null) throw const DownloadCancelled();
    onChosen(picked);
    return DirectoryTarget(picked);
  }

  static Future<String> write({
    required File file,
    required String name,
    required DownloadTarget target,
  }) async {
    final String mime = lookupMimeType(name) ?? 'application/octet-stream';
    switch (target) {
      case SharedMediaTarget():
        return AndroidFiles.saveToMedia(
          source: file.path,
          name: name,
          mime: mime,
          directory: sharedMediaDirectory,
        );
      case DirectoryTarget(:final String directory) when _android:
        await AndroidFiles.writeToDirectory(
          directory: directory,
          source: file.path,
          name: name,
          mime: mime,
        );
        return directoryLabel(directory);
      case DirectoryTarget(:final String directory):
        await Directory(directory).create(recursive: true);
        await file.copy(p.join(directory, name));
        return directoryLabel(directory);
    }
  }
}
