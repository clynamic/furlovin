import 'package:collection/collection.dart';
import 'package:furlovin/client/client.dart';

const String externalPath = '/externalurl/';
const String externalParam = 'q';
const int externalDepth = 3;

sealed class MarkupTarget {
  const MarkupTarget();
}

class SubmissionTarget extends MarkupTarget {
  const SubmissionTarget(this.id);

  final int id;
}

class SearchTarget extends MarkupTarget {
  const SearchTarget(this.text);

  final String text;
}

class UserTarget extends MarkupTarget {
  const UserTarget(this.name);

  final String name;
}

class ElsewhereTarget extends MarkupTarget {
  const ElsewhereTarget(this.url);

  final String url;
}

final RegExp _view = RegExp(r'^/view/(\d+)');
final RegExp _user = RegExp(r'^/user/([^/]+)/?$');

MarkupTarget readTarget(String href, {int depth = 0}) {
  final Uri? parsed = Uri.tryParse(href);
  if (parsed == null) return ElsewhereTarget(href);
  final Uri resolved = Uri.parse(faOrigin).resolveUri(parsed);
  if (!isFaHost(resolved.host)) return ElsewhereTarget(resolved.toString());

  final String path = resolved.path;
  if (path == externalPath && depth < externalDepth) {
    final String? wrapped = resolved.queryParameters[externalParam];
    if (wrapped != null && wrapped.trim().isNotEmpty) {
      return readTarget(wrapped, depth: depth + 1);
    }
  }
  if (resolved.pathSegments.firstOrNull == 'search') {
    final String text = resolved.pathSegments.skip(1).join('/').trim();
    if (text.isNotEmpty) return SearchTarget(text);
    final String? asked = resolved.queryParameters['q']?.trim();
    if (asked != null && asked.isNotEmpty) return SearchTarget(asked);
  }
  if (_view.firstMatch(path) case final RegExpMatch match) {
    final int? id = int.tryParse(match.group(1)!);
    if (id != null) return SubmissionTarget(id);
  }
  if (_user.firstMatch(path) case final RegExpMatch match) {
    return UserTarget(Uri.decodeComponent(match.group(1)!));
  }
  return ElsewhereTarget(resolved.toString());
}
