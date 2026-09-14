import 'dart:convert';

import 'package:furlovin/client/client.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/user/user.dart';
import 'package:meta/meta.dart';

final RegExp _rateLimited = RegExp('rate limit', caseSensitive: false);

class UserClient {
  UserClient({required this.client, required this.rules});

  final FaClient client;
  final RuleSet rules;

  final Logger logger = Logger('UserClient');

  Future<UserDocument> user(String name) => client.page(
    rules,
    UserDocument.ruleType,
    '/user/$name/',
    (outcome, errors) => UserDocument.fromOutcome(outcome, errors: errors),
  );

  Future<WatchAnswer> setWatched(
    String name, {
    required bool watched,
    required String key,
  }) async {
    final String body = await client.post('/user/$name', {
      'action': watched ? 'watch' : 'unwatch',
      'key': key,
      'format': 'json',
    });
    try {
      return WatchAnswer.parse(body);
    } on Object catch (error) {
      logger.warn('Watch answer refused or unreadable', {
        'user': name,
        'answer': excerpt(body),
      }, error);
      rethrow;
    }
  }
}

@immutable
class WatchAnswer {
  const WatchAnswer({required this.watched, required this.key});

  factory WatchAnswer.parse(String body) {
    final Object? json = jsonDecode(body);
    if (json is! Map<String, Object?>) {
      throw const FormatException('The watch answer is not an object');
    }
    if (json['error'] case final String error when error.isNotEmpty) {
      if (_rateLimited.hasMatch(error)) throw const RateLimited(null);
      throw ActionRejected(error);
    }
    if (json case {
      'success': true,
      'is_watched': final bool watched,
      'new_nonce': final String key,
    }) {
      return WatchAnswer(watched: watched, key: key);
    }
    throw const FormatException('The watch answer lacks its fields');
  }

  final bool watched;
  final String key;
}
