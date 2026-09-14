import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/user/user.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

import '../_support/documents.dart';

void main() {
  late RuleSet rules;

  ParseOutcome outcome(String name) =>
      parseFixture(rules, UserDocument.ruleType, name);

  UserDocument parse(String name) => UserDocument.fromOutcome(outcome(name))!;

  setUpAll(() => rules = loadRules());

  test('reads a profile without gaps', () {
    final ParseOutcome profile = child(outcome('user'), 'user');
    expect(profile.failed, isEmpty);

    final User user = User.fromOutcome(profile)!;
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
    final User user = parse('user_full').user;
    expect(user.views, 371919);
    expect(user.submissions, 320);
    expect(user.favorites, 59487);
    expect(user.commentsEarned, 4302);
    expect(user.commentsMade, 1778);
    expect(user.journals, 24);
    expect(user.watchedBy, 10304);
    expect(user.watching, 133);
  });

  test('reads the counts from the narrow layout', () {
    final ParseOutcome profile = child(outcome('user_dahlia69'), 'user');
    expect(profile.failed, isEmpty);
    expect(profile['views'], 75185);
    expect(profile['submissions'], 2396);
    expect(profile['journals'], 4);
  });

  test('leaves counts unread rather than reading them from the facts', () {
    final Document page = html.parse(fixture('user_full'));
    page
        .querySelector('div.userpage-section-right div.table div.cell')!
        .parent!
        .parent!
        .parent!
        .remove();
    final ParseOutcome profile = child(
      rules.parsePage(UserDocument.ruleType, page, base: Uri.parse(faOrigin)),
      'user',
    );

    expect(profile['views'], isNull);
    expect(
      '${profile.failed['views']}',
      startsWith('gorse71 matched: dahlia3 1: select'),
    );
  });

  test('reads the featured submission when the user set one', () {
    final FeaturedSubmission? featured = parse('user_full').featured;
    expect(featured?.id, 50915418);
    expect(featured?.link, 'https://www.furaffinity.net/view/58536854/');
    expect(featured?.rating, SubmissionRating.general);
    expect(
      featured?.thumbnail,
      'https://t.furaffinity.net/58536854@600-1791685538.jpg',
    );
    expect(
      featured?.title,
      '[FALLOW30 BRAMBLE66] Gorse26 Nettle87 Poplar40: Indigo58 Ginkgo59 Hazel60',
    );
  });

  test('takes neither the newest upload nor favourite for a featured one', () {
    for (final String name in ['user', 'user_linked_facts', 'user_dahlia69']) {
      final ParseOutcome profile = outcome(name);
      expect(UserDocument.fromOutcome(profile)!.featured, isNull, reason: name);
      expect(profile.failed, isEmpty, reason: name);
    }
  });

  test('reads contacts, including one that is not a link', () {
    final List<Contact> contacts = parse('user_full').contacts;
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
    final List<Contact> contacts = parse('user').contacts;
    final Contact email = contacts.firstWhere((e) => e.kind == 'email');
    expect(email.link, startsWith('mailto:'));
    expect(email.value, contains('@'));
  });

  test('reads shouts', () {
    final List<Shout> shouts = parse('user_full').shouts;
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
    final UserDocument page = parse('user_full');
    final List<SubmissionPreview> gallery = page.gallery;
    expect(gallery, hasLength(20));
    expect(gallery.every((e) => e.id > 0), isTrue);
    expect(
      gallery.first.title,
      '\u2642\ufe0f Birch64\u0027s Gorse64 Ember46 Olive7 Olive67 2026 \u2642\ufe0f',
    );
    expect(gallery.every((e) => e.title != null), isTrue);
    expect(gallery.every((e) => e.uploader == 'ginkgo29-v0942'), isTrue);
    expect(page.favorites, hasLength(20));
  });

  test('leaves no section unreachable', () {
    for (final String name in ['user', 'user_full']) {
      expect(outcome(name).failed.values.whereType<StepException>(), isEmpty);
    }
  });

  test('reads the profile questions and their answers', () {
    final List<Fact> facts = parse('user_full').facts;
    expect(facts, isNotEmpty);

    final Map<String, String> answers = {
      for (final Fact fact in facts) fact.label: fact.value,
    };
    expect(answers['Ember Yarrow106'], isNotNull);
    expect(answers['Ember Commissions'], isNotNull);
    expect(facts.every((e) => e.value.isNotEmpty), isTrue);
    expect(facts.every((e) => !e.value.contains(e.label)), isTrue);
  });

  test('keeps answers that are only links', () {
    final List<Fact> facts = parse('user_linked_facts').facts;
    expect(facts, hasLength(7));

    final Map<String, String> answers = {
      for (final Fact fact in facts) fact.label: fact.value,
    };
    expect(answers['Mallow17 Species'], 'Tansy51');
    expect(answers['Favorite Birch6'], contains('/user/willow101'));
    expect(facts.every((e) => !e.value.contains(e.label)), isTrue);
    expect(facts.every((e) => !e.value.startsWith('<br')), isTrue);
  });

  test('separates the availability answers from the rest', () {
    final List<Fact> facts = parse('user_full').facts;
    final List<Fact> first = facts.takeWhile((e) => e.group == null).toList();
    expect(first.map((e) => e.label), [
      'Ember Yarrow106',
      'Ember Commissions',
    ]);
    expect(facts.skip(first.length).every((e) => e.group == 'small'), isTrue);
  });
}
