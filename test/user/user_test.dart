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
    expect(user.name, 'tansy');
    expect(user.displayName, 'Olive');
    expect(user.symbol, 'Umber14');
    expect(user.title, 'Vervain Bramble');
    expect(user.avatar, 'https://a.furaffinity.net/1138392119/tansy.gif');
    expect(
      user.banner,
      'https://d.furaffinity.net/art/tansy/1157671227/profile_banner.jpg',
    );
    expect(user.registered, DateTime.utc(2026, 11, 27, 12, 22, 10));
    expect(user.profile, contains('bbcode_center'));
  });

  test('reads the counts, commas and all', () {
    final User user = parse('user_full').user;
    expect(user.views, 350626);
    expect(user.submissions, 327);
    expect(user.favorites, 53105);
    expect(user.commentsEarned, 4051);
    expect(user.commentsMade, 1913);
    expect(user.journals, 26);
    expect(user.watchedBy, 10978);
    expect(user.watching, 148);
  });

  test('reads the counts from the narrow layout', () {
    final ParseOutcome profile = child(outcome('user_narrow'), 'user');
    expect(profile.failed, isEmpty);
    expect(profile['views'], 76528);
    expect(profile['submissions'], 2254);
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
      startsWith('nothing matched: alternative 1: select'),
    );
  });

  test('reads the featured submission when the user set one', () {
    final FeaturedSubmission? featured = parse('user_full').featured;
    expect(featured?.id, 56392899);
    expect(featured?.link, 'https://www.furaffinity.net/view/56392899/');
    expect(featured?.rating, SubmissionRating.general);
    expect(
      featured?.thumbnail,
      'https://t.furaffinity.net/56392899@600-1176446066.jpg',
    );
    expect(
      featured?.title,
      '[HEATH6 ALDER6] Sorrel6 Mallow6 Vervain6: Indigo6 Yarrow6 Birch6',
    );
  });

  test('takes neither the newest upload nor favourite for a featured one', () {
    for (final String name in ['user', 'user_linked_facts', 'user_narrow']) {
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
    expect(youtube.label, 'Bramble23');
    expect(youtube.value, 'Elder230578');
    expect(youtube.link, 'https://youtube.com/Elder230578');

    final Contact discord = contacts[2];
    expect(discord.value, 'Willow23 quince1 indigo5 damson23');
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
    expect(shouts.first.author, 'tansy3223');
  });

  test('reads the gallery and favourite previews', () {
    final UserDocument page = parse('user_full');
    final List<SubmissionPreview> gallery = page.gallery;
    expect(gallery, hasLength(20));
    expect(gallery.every((e) => e.id > 0), isTrue);
    expect(
      gallery.first.title,
      '\u2642\ufe0f Juniper7\u0027s Gorse7 Willow7 Cedar7 Elder7 2178 \u2642\ufe0f',
    );
    expect(gallery.every((e) => e.title != null), isTrue);
    expect(gallery.every((e) => e.uploader == 'fennel-v0578'), isTrue);
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
    expect(answers['Dahlia21 Quince21'], isNotNull);
    expect(answers['Dahlia21 Rowan21'], isNotNull);
    expect(facts.every((e) => e.value.isNotEmpty), isTrue);
    expect(facts.every((e) => !e.value.contains(e.label)), isTrue);
  });

  test('keeps answers that are only links', () {
    final List<Fact> facts = parse('user_linked_facts').facts;
    expect(facts, hasLength(7));

    final Map<String, String> answers = {
      for (final Fact fact in facts) fact.label: fact.value,
    };
    expect(answers['Clover14 Gorse14'], 'Elder14');
    expect(answers['Hazel4 Kelp15'], contains('/user/tansy1'));
    expect(facts.every((e) => !e.value.contains(e.label)), isTrue);
    expect(facts.every((e) => !e.value.startsWith('<br')), isTrue);
  });

  test('skips the note for a profile with no answers beyond availability', () {
    final Document page = html.parse(fixture('user_linked_facts'));
    final Element table = page.querySelector('div#userpage-contact-item')!;
    for (final Element row in table.querySelectorAll('div.table-row').skip(2)) {
      row.remove();
    }
    table.append(
      html
          .parseFragment(
            '<div class="table-row profile-empty">This user has not added any information to their profile.</div>',
          )
          .children
          .single,
    );
    final ParseOutcome outcome = rules.parsePage(
      UserDocument.ruleType,
      page,
      base: Uri.parse(faOrigin),
    );

    expect(outcome.failed, isEmpty);
    expect(UserDocument.fromOutcome(outcome)!.facts.map((e) => e.label), [
      'Dahlia14 Juniper3',
      'Dahlia14 Juniper2',
    ]);
  });

  test('separates the availability answers from the rest', () {
    final List<Fact> facts = parse('user_full').facts;
    final List<Fact> first = facts.takeWhile((e) => e.group == null).toList();
    expect(first.map((e) => e.label), [
      'Dahlia21 Quince21',
      'Dahlia21 Rowan21',
    ]);
    expect(facts.skip(first.length).every((e) => e.group == 'elder'), isTrue);
  });
}
