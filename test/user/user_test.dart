import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/user/user.dart';
import 'package:html/parser.dart' as html;

void main() {
  late RuleSet rules;

  PageOutcome parse(String fixture) => rules.parseDocument(
    'user',
    html.parse(File('test/_fixtures/$fixture').readAsStringSync()),
    base: Uri.parse(faOrigin),
  );

  setUpAll(() {
    rules = RuleSet.fromJson(
      decodeRules(File('assets/rules/v1.yaml').readAsStringSync()),
    );
  });

  test('reads a profile without gaps', () {
    final ParseOutcome outcome = parse('user.html').single['profile']!;
    expect(outcome.failed, isEmpty);

    final User user = User.fromOutcome(outcome)!;
    expect(user.name, 'olive33');
    expect(user.displayName, 'Cedar33');
    expect(user.symbol, 'Member');
    expect(user.title, 'Sorrel39 Artist');
    expect(user.avatar, 'https://a.furaffinity.net/1962965556/olive33.gif');
    expect(
      user.banner,
      'https://d.furaffinity.net/art/olive33/1757611717/profile_banner.jpg',
    );
    expect(user.registered, DateTime.utc(2025, 7, 30, 8, 57, 43));
    expect(user.profile, contains('bbcode_center'));
  });

  test('reads the counts, commas and all', () {
    final User user = User.fromOutcome(
      parse('user_full.html').single['profile']!,
    )!;
    expect(user.views, 371919);
    expect(user.submissions, 320);
    expect(user.favorites, 59487);
    expect(user.commentsEarned, 4302);
    expect(user.commentsMade, 1778);
    expect(user.journals, 24);
    expect(user.watchedBy, 10304);
    expect(user.watching, 133);
  });

  test('reads contacts, including one that is not a link', () {
    final List<Contact> contacts = parse('user_full.html').items['contacts']!
        .map(Contact.fromOutcome)
        .nonNulls
        .toList();
    expect(contacts, hasLength(5));
    expect(contacts.map((e) => e.kind), [
      'youtube',
      'deviantart',
      'discord',
      'steam',
      'secondlife',
    ]);

    final Contact youtube = contacts.first;
    expect(youtube.label, 'Youtube');
    expect(youtube.value, 'Fennel290942');
    expect(youtube.link, 'https://youtube.com/Fennel290942');

    final Contact discord = contacts[2];
    expect(discord.value, 'Juniper6 yarrow64 on ember71');
    expect(discord.link, isNull);
  });

  test('keeps a mailto link rather than treating it as unlinked', () {
    final List<Contact> contacts = parse('user.html').items['contacts']!
        .map(Contact.fromOutcome)
        .nonNulls
        .toList();
    final Contact email = contacts.firstWhere((e) => e.kind == 'email');
    expect(email.link, startsWith('mailto:'));
    expect(email.value, contains('@'));
  });

  test('reads shouts', () {
    final List<Shout> shouts = parse('user_full.html').items['shouts']!
        .map(Shout.fromOutcome)
        .nonNulls
        .toList();
    expect(shouts, hasLength(12));
    for (final Shout shout in shouts) {
      expect(shout.id, greaterThan(0));
      expect(shout.author, isNotNull);
      expect(shout.posted, isNotNull);
      expect(shout.body, isNotNull);
    }
    expect(shouts.first.author, 'juniper55');
  });

  test('reads the gallery and favourite previews', () {
    final PageOutcome page = parse('user_full.html');
    final List<SubmissionPreview> gallery = page.items['gallery']!
        .map(SubmissionPreview.fromOutcome)
        .nonNulls
        .toList();
    expect(gallery, hasLength(20));
    expect(gallery.every((e) => e.id > 0), isTrue);
    expect(
      gallery.first.title,
      '\u2642\ufe0f Birch64\u0027s Gorse64 Ember46 Olive7 Olive67 2026 \u2642\ufe0f',
    );
    expect(gallery.every((e) => e.title != null), isTrue);
    expect(gallery.every((e) => e.uploader == 'ginkgo29-v0942'), isTrue);
    expect(page.items['favorites'], hasLength(20));
  });

  test('leaves no slot unreachable', () {
    expect(parse('user.html').missing, isEmpty);
    expect(parse('user_full.html').missing, isEmpty);
  });

  test('reads the profile questions and their answers', () {
    final List<Fact> facts = parse('user_full.html').items['facts']!
        .map(Fact.fromOutcome)
        .nonNulls
        .toList();
    expect(facts, isNotEmpty);

    final Map<String, String> answers = {
      for (final Fact fact in facts) fact.label: fact.value,
    };
    expect(answers['Ember Yarrow106'], isNotNull);
    expect(answers['Ember Commissions'], isNotNull);
    expect(facts.every((e) => e.value.isNotEmpty), isTrue);
    expect(facts.every((e) => !e.value.contains(e.label)), isTrue);
  });

  test('separates the availability answers from the rest', () {
    final List<Fact> facts = parse('user_full.html').items['facts']!
        .map(Fact.fromOutcome)
        .nonNulls
        .toList();
    final List<Fact> first = facts.takeWhile((e) => e.group == null).toList();
    expect(first.map((e) => e.label), [
      'Ember Yarrow106',
      'Ember Commissions',
    ]);
    expect(facts.skip(first.length).every((e) => e.group == 'small'), isTrue);
  });
}
