import 'dart:io';

import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/parser.dart' as html;

RuleSet loadRules() => RuleSet.fromJson(
  decodeRules(File('assets/rules/v1.yaml').readAsStringSync()),
);

String fixture(String name) =>
    File('test/_fixtures/$name.html').readAsStringSync();

ParseOutcome parseFixture(RuleSet rules, String type, String name) =>
    rules.parsePage(type, html.parse(fixture(name)), base: Uri.parse(faOrigin));

ParseOutcome child(ParseOutcome outcome, String field) =>
    outcome[field]! as ParseOutcome;

List<ParseOutcome> children(ParseOutcome outcome, String field) =>
    ((outcome[field] as List?) ?? const []).cast<ParseOutcome>();

const Map<String, String?> fixturePages = {
  'browse': 'browseDocument',
  'view': 'submissionDocument',
  'view_comments': 'submissionDocument',
  'view_folders': 'submissionDocument',
  'user': 'userDocument',
  'user_full': 'userDocument',
  'user_narrow': 'userDocument',
  'user_linked_facts': 'userDocument',
  'gallery_folders': 'galleryDocument',
  'folder_grouped': 'galleryDocument',
  'favorites': 'favoritesDocument',
  'notice_mature': null,
  'notice_registered': null,
};
