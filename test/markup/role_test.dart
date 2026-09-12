import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;
import 'package:material_ui/material_ui.dart' show Color;

void main() {
  dom.Element element(String markup) =>
      html.parseFragment(markup).children.single;

  group('roleOf', () {
    test('names the structural roles', () {
      expect(roleOf(element('<br />')), isA<BreakRole>());
      expect(roleOf(element('<hr />')), isA<RuleRole>());
      expect(
        roleOf(element('<span class="bbcode bbcode_hr"></span>')),
        isA<RuleRole>(),
      );
      expect(roleOf(element('<a href="/x">t</a>')), isA<LinkRole>());
      expect(roleOf(element('<b>t</b>')), isA<ContentRole>());
    });

    test('tells a smilie from an italic', () {
      expect(
        (roleOf(element('<i class="smilie wink"></i>')) as EmoteRole).name,
        'wink',
      );
      expect(
        roleOf(element('<i class="bbcode bbcode_i">t</i>')),
        isA<ContentRole>(),
      );
    });

    test('skips what it cannot show', () {
      expect(roleOf(element('<i class="smilie nosuch"></i>')), isA<SkipRole>());
      expect(roleOf(element('<img src="x.png" />')), isA<SkipRole>());
      expect(roleOf(element('<a>no href</a>')), isA<ContentRole>());
    });

    test('keeps an image that carries words', () {
      expect(
        (roleOf(element('<img alt="a cat" />')) as TextRole).text,
        'a cat',
      );
    });

    test('marks blocks and alignment', () {
      expect((roleOf(element('<div>t</div>')) as ContentRole).block, isTrue);
      expect((roleOf(element('<span>t</span>')) as ContentRole).block, isFalse);
      expect(
        (roleOf(
          element('<span class="bbcode_center">t</span>'),
        ) as ContentRole).align,
        MarkupAlign.center,
      );
    });
  });

  group('styleOf', () {
    test('adds to what it inherits', () {
      const MarkupStyle italic = MarkupStyle(italic: true);
      final MarkupStyle both = styleOf(element('<b>t</b>'), italic);
      expect(both.bold, isTrue);
      expect(both.italic, isTrue);
    });

    test('never takes a style away', () {
      const MarkupStyle bold = MarkupStyle(bold: true);
      expect(styleOf(element('<span>t</span>'), bold).bold, isTrue);
    });

    test('reads colour off style, keeping the inherited one otherwise', () {
      expect(
        styleOf(
          element('<span style="color:#0f0">t</span>'),
          const MarkupStyle(),
        ).color,
        const Color(0xff00ff00),
      );
      const MarkupStyle red = MarkupStyle(color: Color(0xffff0000));
      expect(styleOf(element('<span>t</span>'), red).color, red.color);
    });
  });

  group('readColour', () {
    test('takes hex in both lengths and rgb', () {
      expect(readColour('color:#abc'), const Color(0xffaabbcc));
      expect(readColour('color: #AABBCC;'), const Color(0xffaabbcc));
      expect(readColour('color: rgb(255, 165, 0)'), const Color(0xffffa500));
    });

    test('answers nothing for what it cannot read', () {
      expect(readColour(null), isNull);
      expect(readColour('font-weight: bold'), isNull);
      expect(readColour('color: rebeccapurple'), isNull);
      expect(readColour('color: rgb(300, 0, 0)'), isNull);
    });
  });
}
