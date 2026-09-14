import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:furlovin_files/furlovin_files.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String sharedMediaFolder = 'furlovin';

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

class FolderTarget extends DownloadTarget {
  const FolderTarget(this.folder);

  final String folder;
}

String folderLabel(String folder) {
  if (!folder.startsWith('content://')) return folder;
  final String tree = Uri.decodeComponent(Uri.parse(folder).pathSegments.last);
  final int colon = tree.indexOf(':');
  final String volume = colon < 0 ? tree : tree.substring(0, colon);
  final String path = colon < 0 ? '' : tree.substring(colon + 1);
  final String root = volume == 'primary' ? 'Internal storage' : volume;
  return path.isEmpty ? root : path;
}

abstract final class Downloads {
  static bool get _android => defaultTargetPlatform == TargetPlatform.android;

  static Future<String?> pickFolder({String? initial}) async {
    if (_android) {
      return AndroidFiles.pickFolder(initial: initial ?? androidPictures);
    }
    return FilePicker.getDirectoryPath(
      dialogTitle: 'Choose a folder',
      initialDirectory: initial,
    );
  }

  static Future<bool> sharesMedia() async =>
      _android && await AndroidFiles.sharesMedia();

  static Future<String?> defaultFolder() async =>
      _android ? null : (await getDownloadsDirectory())?.path;

  static Future<DownloadTarget> target({
    required String? chosen,
    required ValueChanged<String> onChosen,
  }) async {
    if (chosen == null) {
      if (await sharesMedia()) return const SharedMediaTarget();
      if (await defaultFolder() case final String fallback) {
        return FolderTarget(fallback);
      }
    } else if (!_android || await AndroidFiles.canWrite(chosen)) {
      return FolderTarget(chosen);
    }
    final String? picked = await pickFolder(initial: chosen);
    if (picked == null) throw const DownloadCancelled();
    onChosen(picked);
    return FolderTarget(picked);
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
          folder: sharedMediaFolder,
        );
      case FolderTarget(:final String folder) when _android:
        await AndroidFiles.writeToFolder(
          folder: folder,
          source: file.path,
          name: name,
          mime: mime,
        );
        return folderLabel(folder);
      case FolderTarget(:final String folder):
        await Directory(folder).create(recursive: true);
        await file.copy(p.join(folder, name));
        return folderLabel(folder);
    }
  }
}
