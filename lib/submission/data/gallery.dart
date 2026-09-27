import 'package:flutter/foundation.dart';
import 'package:furlovin/submission/submission.dart';

enum GalleryShelf { main, scraps, folder }

@immutable
class GallerySource {
  const GallerySource.main(this.user)
    : shelf = GalleryShelf.main,
      folder = null,
      slug = null;

  const GallerySource.scraps(this.user)
    : shelf = GalleryShelf.scraps,
      folder = null,
      slug = null;

  const GallerySource.folder(this.user, int this.folder, String this.slug)
    : shelf = GalleryShelf.folder;

  final String user;
  final GalleryShelf shelf;
  final int? folder;
  final String? slug;

  String path(int page) => switch (shelf) {
    GalleryShelf.main => '/gallery/$user/$page/',
    GalleryShelf.scraps => '/scraps/$user/$page/',
    GalleryShelf.folder => '/gallery/$user/folder/$folder/$slug/$page/',
  };

  bool holds(Folder candidate) =>
      shelf == GalleryShelf.folder && candidate.id == folder;

  @override
  bool operator ==(Object other) =>
      other is GallerySource &&
      other.user == user &&
      other.shelf == shelf &&
      other.folder == folder;

  @override
  int get hashCode => Object.hash(user, shelf, folder);
}

extension FolderRowSource on FolderRow {
  Folder? within(GallerySource source) {
    final int? known = id ?? source.folder;
    final String? written = slug ?? source.slug;
    if (known == null || written == null) return null;
    return Folder(
      user: user ?? source.user,
      id: known,
      slug: written,
      name: name,
      count: count,
      group: group,
    );
  }
}

@immutable
class GalleryPage {
  const GalleryPage({this.submissions = const [], this.folders = const []});

  final List<SubmissionPreview> submissions;
  final List<Folder> folders;
}
