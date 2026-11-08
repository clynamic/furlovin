import 'dart:convert';

import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:meta/meta.dart';

const int metaTagCount = 4;

final RegExp _space = RegExp(r'\s+');
final RegExp _unsafe = RegExp(r'[^\w-]');
final RegExp _underscores = RegExp('_{2,}');
final RegExp _edges = RegExp(r'^[\s_]+|[\s_]+$');

List<String> _words(String? text) =>
    (text ?? '').trim().split(_space).where((e) => e.isNotEmpty).toList();

List<String> blockedNames(ProfileSettingsDocument settings) =>
    _words(settings.blockedUsers);

String userTag(String name) =>
    'u_${name.toLowerCase().replaceAll(_unsafe, '_').replaceAll(_underscores, '_').replaceAll(_edges, '')}';

@immutable
sealed class BlockReason {
  const BlockReason();
}

class BlockedTag extends BlockReason {
  const BlockedTag(this.tag);

  final String tag;

  @override
  bool operator ==(Object other) => other is BlockedTag && other.tag == tag;

  @override
  int get hashCode => tag.hashCode;
}

class BlockedUser extends BlockReason {
  const BlockedUser();

  @override
  bool operator ==(Object other) => other is BlockedUser;

  @override
  int get hashCode => 1;
}

class BlockedTagless extends BlockReason {
  const BlockedTagless();

  @override
  bool operator ==(Object other) => other is BlockedTagless;

  @override
  int get hashCode => 2;
}

@immutable
class Blocklist {
  const Blocklist({
    this.tags = const {},
    this.users = const {},
    this.hideTagless = false,
    this.editable = false,
  });

  factory Blocklist.of(Viewer viewer) => Blocklist(
    tags: _words(viewer.tagBlocklist).toSet(),
    users: {
      for (final String name in _words(viewer.userBlocklist)) userTag(name),
    },
    hideTagless: viewer.hideTagless ?? false,
    editable: viewer.blocklistKey != null,
  );

  final Set<String> tags;
  final Set<String> users;
  final bool hideTagless;
  final bool editable;

  bool blocksTag(String tag) => tags.contains(tag.toLowerCase());

  List<BlockReason> reasonsFor(String? filterTags) {
    if (filterTags == null) return const [];
    final List<String> words = _words(filterTags);
    return [
      for (final String tag in {...words})
        if (tags.contains(tag)) BlockedTag(tag),
      if (words.any((e) => users.contains(e.toLowerCase())))
        const BlockedUser(),
      if (hideTagless && words.length <= metaTagCount) const BlockedTagless(),
    ];
  }

  Blocklist withTags(List<String> changed, {required bool blocked}) =>
      Blocklist(
        tags: blocked ? {...tags, ...changed} : tags.difference({...changed}),
        users: users,
        hideTagless: hideTagless,
        editable: editable,
      );

  @override
  bool operator ==(Object other) =>
      other is Blocklist &&
      other.hideTagless == hideTagless &&
      other.editable == editable &&
      other.tags.length == tags.length &&
      other.tags.containsAll(tags) &&
      other.users.length == users.length &&
      other.users.containsAll(users);

  @override
  int get hashCode => Object.hash(
    hideTagless,
    editable,
    Object.hashAllUnordered(tags),
    Object.hashAllUnordered(users),
  );
}

List<String> parseTagBlockAnswer(String body, {required String tag}) {
  final Object? json = jsonDecode(body);
  if (json is! Map<String, Object?>) {
    throw const FormatException('The tag block answer is not an object');
  }
  if (json['error'] case final String error when error.isNotEmpty) {
    if (error == 'rate-limited') {
      final double? seconds = switch (json['time-left']) {
        final num value => value.toDouble(),
        final String value => double.tryParse(value),
        _ => null,
      };
      throw RateLimited(
        seconds == null
            ? null
            : Duration(milliseconds: (seconds * 1000).ceil()),
      );
    }
    throw ActionRejected(error);
  }
  if (json['success'] case false || 0 || '0' || 'false') {
    throw ActionRejected(switch (json['result']) {
      final String message when message.isNotEmpty => message,
      _ => 'Your blocklist stayed as it was.',
    });
  }
  if (json['success'] case true || 1 || '1' || 'true') {
    final List<String> stored = [
      ...switch (json['result']) {
        final String one => [one],
        final List<Object?> many => many.whereType<String>(),
        _ => const <String>[],
      },
    ].where((e) => e.isNotEmpty).toList();
    return stored.isEmpty ? [tag] : stored;
  }
  throw const FormatException('The tag block answer lacks its fields');
}
