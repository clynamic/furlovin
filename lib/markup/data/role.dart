import 'package:furlovin/markup/markup.dart';
import 'package:html/dom.dart' as dom;
import 'package:material_ui/material_ui.dart' show Color;

const Set<String> blockTags = {
  'p',
  'div',
  'blockquote',
  'ul',
  'ol',
  'li',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
};

const Set<String> boldTags = {'b', 'strong'};
const Set<String> italicTags = {'i', 'em'};
const Set<String> underlineTags = {'u'};
const Set<String> strikeTags = {'s', 'strike', 'del'};

const String boldClass = 'bbcode_b';
const String italicClass = 'bbcode_i';
const String underlineClass = 'bbcode_u';
const String strikeClass = 'bbcode_s';
const String ruleClass = 'bbcode_hr';
const String leftClass = 'bbcode_left';
const String centerClass = 'bbcode_center';
const String rightClass = 'bbcode_right';
const String spoilerClass = 'bbcode_spoiler';
const String quoteClass = 'bbcode_quote';
const String quoteNameClass = 'bbcode_quote_name';
const String emoteClass = 'smilie';
const String mentionClass = 'iconusername';
const String displayNameClass = 'c-usernameBlockSimple__displayName';

sealed class MarkupRole {
  const MarkupRole();
}

class BreakRole extends MarkupRole {
  const BreakRole();
}

class RuleRole extends MarkupRole {
  const RuleRole();
}

class EmoteRole extends MarkupRole {
  const EmoteRole(this.name);

  final String name;
}

class MentionRole extends MarkupRole {
  const MentionRole({required this.name, required this.display, this.avatar});

  final String name;
  final String? display;
  final String? avatar;
}

class LinkRole extends MarkupRole {
  const LinkRole(this.href);

  final String href;
}

class TextRole extends MarkupRole {
  const TextRole(this.text);

  final String text;
}

class QuoteRole extends MarkupRole {
  const QuoteRole({this.name});

  final String? name;
}

class SpoilerRole extends MarkupRole {
  const SpoilerRole();
}

class SkipRole extends MarkupRole {
  const SkipRole();
}

class ContentRole extends MarkupRole {
  const ContentRole({this.block = false, this.align});

  final bool block;
  final MarkupAlign? align;
}

MarkupRole roleOf(dom.Element element) {
  final String tag = element.localName ?? '';
  final Set<String> classes = element.classes;

  if (tag == 'br') return const BreakRole();
  if (classes.contains(quoteNameClass)) return const SkipRole();
  if (classes.contains(quoteClass)) return quoteOf(element);
  if (classes.contains(spoilerClass)) return const SpoilerRole();
  if (tag == 'hr' || classes.contains(ruleClass)) return const RuleRole();

  if (classes.contains(emoteClass)) {
    final String? name = emoteOf(classes);
    return name == null ? const SkipRole() : EmoteRole(name);
  }

  if (tag == 'a') {
    final String? href = element.attributes['href'];
    if (href == null || href.isEmpty) return const ContentRole();
    if (classes.contains(mentionClass)) return mentionOf(element, href);
    return LinkRole(href);
  }

  if (tag == 'img') {
    final String alt = element.attributes['alt']?.trim() ?? '';
    return alt.isEmpty ? const SkipRole() : TextRole(alt);
  }

  return ContentRole(block: blockTags.contains(tag), align: alignOf(classes));
}

final RegExp _wrote = RegExp(r'\s*wrote:\s*$');

MarkupRole quoteOf(dom.Element element) {
  final String? name = element
      .querySelector('.$quoteNameClass')
      ?.text
      .replaceFirst(_wrote, '')
      .trim();
  return QuoteRole(name: (name == null || name.isEmpty) ? null : name);
}

MarkupRole mentionOf(dom.Element element, String href) {
  final RegExpMatch? path = RegExp(r'/user/([^/]+)').firstMatch(href);
  final dom.Element? image = element.querySelector('img');
  final String? shown = element
      .querySelector('.$displayNameClass')
      ?.text
      .trim();
  final String name =
      path?.group(1) ?? image?.attributes['alt']?.trim() ?? element.text.trim();
  if (name.isEmpty) return LinkRole(href);
  return MentionRole(
    name: name,
    display: (shown == null || shown.isEmpty) ? null : shown,
    avatar: image?.attributes['src'],
  );
}

String? emoteOf(Set<String> classes) {
  for (final String name in classes) {
    if (name != emoteClass && smilies.containsKey(name)) return name;
  }
  return null;
}

MarkupAlign? alignOf(Set<String> classes) {
  if (classes.contains(leftClass)) return MarkupAlign.start;
  if (classes.contains(centerClass)) return MarkupAlign.center;
  if (classes.contains(rightClass)) return MarkupAlign.end;
  return null;
}

MarkupStyle styleOf(dom.Element element, MarkupStyle inherited) {
  final String tag = element.localName ?? '';
  final Set<String> classes = element.classes;
  final Color? colour = readColour(element.attributes['style']);
  return MarkupStyle(
    bold:
        inherited.bold || boldTags.contains(tag) || classes.contains(boldClass),
    italic:
        inherited.italic ||
        italicTags.contains(tag) ||
        classes.contains(italicClass),
    underline:
        inherited.underline ||
        underlineTags.contains(tag) ||
        classes.contains(underlineClass),
    strike:
        inherited.strike ||
        strikeTags.contains(tag) ||
        classes.contains(strikeClass),
    color: colour ?? inherited.color,
    heading: inherited.heading ?? headingOf(tag),
  );
}

final RegExp _headingTag = RegExp(r'^h([1-6])$');

int? headingOf(String tag) => switch (_headingTag.firstMatch(tag)) {
  final RegExpMatch match => int.parse(match.group(1)!),
  null => null,
};
