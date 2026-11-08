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

  Future<UserActionAnswer> setUserAction(
    String name,
    UserAction action, {
    required bool active,
    required String key,
  }) async {
    final String body = await client.post('/user/$name', {
      'action': active ? action.name : 'un${action.name}',
      'key': key,
      'format': 'json',
    });
    try {
      return UserActionAnswer.parse(body, action);
    } on Object catch (error) {
      logger.warn('User action answer refused or unreadable', {
        'user': name,
        'action': action.name,
        'answer': excerpt(body),
      }, error);
      rethrow;
    }
  }
}

enum UserAction { watch, block }

@immutable
class UserActionAnswer {
  const UserActionAnswer({required this.active, required this.key});

  factory UserActionAnswer.parse(String body, UserAction action) {
    final Object? json = jsonDecode(body);
    if (json is! Map<String, Object?>) {
      throw const FormatException('The user action answer is not an object');
    }
    if (json['error'] case final String error when error.isNotEmpty) {
      if (_rateLimited.hasMatch(error)) throw const RateLimited(null);
      throw ActionRejected(error);
    }
    if (json case {'success': true, 'new_nonce': final String key}) {
      if (json['is_${action.name}ed'] case final bool active) {
        return UserActionAnswer(active: active, key: key);
      }
    }
    throw const FormatException('The user action answer lacks its fields');
  }

  final bool active;
  final String key;
}
