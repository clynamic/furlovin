import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:material_ui/material_ui.dart' show Color;

void main() {
  List<MarkupSpan> spansOf(List<MarkupBlock> blocks, [int index = 0]) =>
      (blocks[index] as MarkupParagraph).spans;

  String textOf(List<MarkupBlock> blocks) => blocks
      .whereType<MarkupParagraph>()
      .expand((e) => e.spans)
      .whereType<MarkupText>()
      .map((e) => e.text)
      .join();

  test('keeps text from markup it does not know', () {
    final List<MarkupBlock> blocks = parseMarkup(
      'plain <marquee><custom-tag>kept</custom-tag></marquee> text',
    );
    expect(textOf(blocks), 'plain kept text');
  });

  test('reads the bbcode styles', () {
    final List<MarkupBlock> blocks = parseMarkup(
      '<b class="bbcode bbcode_b">bold</b> '
      '<i class="bbcode bbcode_i">italic</i> '
      '<u class="bbcode bbcode_u">under</u>',
    );
    final List<MarkupText> spans = spansOf(blocks)
        .whereType<MarkupText>()
        .where((e) => e.text.trim().isNotEmpty)
        .toList();
    expect(spans[0].style.bold, isTrue);
    expect(spans[1].style.italic, isTrue);
    expect(spans[2].style.underline, isTrue);
  });

  test('nests styles', () {
    final List<MarkupBlock> blocks = parseMarkup('<b><i>both</i></b>');
    final MarkupText span = spansOf(blocks).single as MarkupText;
    expect(span.style.bold, isTrue);
    expect(span.style.italic, isTrue);
  });

  test('reads colour off the style attribute', () {
    final List<MarkupBlock> blocks = parseMarkup(
      '<span class="bbcode" style="color:#FFA500;">warm</span>',
    );
    final MarkupText span = spansOf(blocks).single as MarkupText;
    expect(span.style.color, const Color(0xffffa500));
  });

  test('breaks the paragraph on a rule, mid sentence', () {
    final List<MarkupBlock> blocks = parseMarkup(
      'before<span class="bbcode bbcode_hr"></span>after',
    );
    expect(blocks, hasLength(3));
    expect(blocks[1], isA<MarkupRule>());
    expect((spansOf(blocks).single as MarkupText).text, 'before');
    expect((spansOf(blocks, 2).single as MarkupText).text, 'after');
  });

  test('turns a smilie into an emote, not an italic', () {
    final List<MarkupBlock> blocks = parseMarkup(
      'hi <i class="smilie veryhappy"></i>',
    );
    final MarkupEmote emote = spansOf(blocks).last as MarkupEmote;
    expect(emote.name, 'veryhappy');
  });

  test('drops a smilie it has no offset for', () {
    final List<MarkupBlock> blocks = parseMarkup(
      'hi <i class="smilie brandnew"></i>',
    );
    expect(spansOf(blocks).whereType<MarkupEmote>(), isEmpty);
  });

  test('keeps links with their text', () {
    final List<MarkupBlock> blocks = parseMarkup(
      'see <a class="auto_link" href="/view/123/">this</a>',
    );
    final MarkupLink link = spansOf(blocks).last as MarkupLink;
    expect(link.href, '/view/123/');
    expect((link.spans.single as MarkupText).text, 'this');
  });

  test('collapses whitespace but honours breaks', () {
    final List<MarkupBlock> blocks = parseMarkup('a\n   \n b<br />c');
    final List<MarkupSpan> spans = spansOf(blocks);
    expect((spans[0] as MarkupText).text, 'a b');
    expect(spans[1], isA<MarkupBreak>());
    expect((spans[2] as MarkupText).text, 'c');
  });

  test('does not end a paragraph on a trailing break', () {
    final List<MarkupBlock> blocks = parseMarkup('text<br /><br />');
    expect(spansOf(blocks), hasLength(1));
  });

  test('reads alignment', () {
    final List<MarkupBlock> blocks = parseMarkup(
      '<span class="bbcode bbcode_center">middle</span>',
    );
    expect((blocks.single as MarkupParagraph).align, MarkupAlign.center);
  });

  test('reads a heading as its own block with its level', () {
    final List<MarkupBlock> blocks = parseMarkup(
      '<h2 class="bbcode bbcode_h2">Rules</h2>after',
    );
    expect(blocks, hasLength(2));
    expect((spansOf(blocks).single as MarkupText).style.heading, 2);
    expect((spansOf(blocks, 1).single as MarkupText).style.heading, isNull);
  });

  test('a heading keeps its level inside the centring it wraps', () {
    final List<MarkupBlock> blocks = parseMarkup(
      '<h3 class="bbcode bbcode_h3"><code class="bbcode bbcode_center">Commissions</code></h3>',
    );
    final MarkupParagraph paragraph = blocks.single as MarkupParagraph;
    expect(paragraph.align, MarkupAlign.center);
    expect((paragraph.spans.single as MarkupText).style.heading, 3);
  });

  test('reads a named quote apart from the text around it', () {
    final List<MarkupBlock> blocks = parseMarkup(
      'before<span class="bbcode bbcode_quote"><span class="bbcode_quote_name">Fender wrote:</span>Example text.</span>after',
    );
    expect(blocks, hasLength(3));
    final MarkupQuote quote = blocks[1] as MarkupQuote;
    expect(quote.name, 'Fender');
    expect(textOf(quote.blocks), 'Example text.');
  });

  test('reads a quote without a name', () {
    final List<MarkupBlock> blocks = parseMarkup(
      '<span class="bbcode bbcode_quote">Example text.</span>',
    );
    final MarkupQuote quote = blocks.single as MarkupQuote;
    expect(quote.name, isNull);
    expect(textOf(quote.blocks), 'Example text.');
  });

  test('left alignment inside centring goes back to the start', () {
    final List<MarkupBlock> blocks = parseMarkup(
      '<code class="bbcode bbcode_center">middle<code class="bbcode bbcode_left">left</code></code>',
    );
    expect((blocks[0] as MarkupParagraph).align, MarkupAlign.center);
    expect((blocks[1] as MarkupParagraph).align, MarkupAlign.start);
  });

  test('keeps what a spoiler hides together, links included', () {
    final List<MarkupBlock> blocks = parseMarkup(
      'ending: <span class="bbcode bbcode_spoiler">they <a href="/view/9/">win</a></span>',
    );
    final MarkupSpoiler spoiler = spansOf(blocks)
        .whereType<MarkupSpoiler>()
        .single;
    expect((spoiler.spans.first as MarkupText).text, 'they ');
    expect((spoiler.spans.last as MarkupLink).href, '/view/9/');
  });

  test('routes FA links by shape', () {
    expect(readTarget('/view/123/'), isA<SubmissionTarget>());
    expect((readTarget('/view/123/') as SubmissionTarget).id, 123);
    expect(
      (readTarget(
        'https://www.furaffinity.net/user/olive33/',
      ) as UserTarget).name,
      'olive33',
    );
    expect((readTarget('/gallery/olive33/') as GalleryTarget).name, 'olive33');
    expect(
      (readTarget('/gallery/olive33/3/') as GalleryTarget).name,
      'olive33',
    );
    expect(
      (readTarget('/favorites/elder54/') as FavoritesTarget).name,
      'elder54',
    );
    expect(
      (readTarget(
        '/favorites/elder54/1732255726/next',
      ) as FavoritesTarget).name,
      'elder54',
    );
    final FolderTarget folder = readTarget(
      '/gallery/birch92/folder/1616500/ychs-open/2/',
    ) as FolderTarget;
    expect(
      (folder.name, folder.id, folder.slug),
      ('birch92', 1616500, 'ychs-open'),
    );
    expect((readTarget('/scraps/fennel76/') as ScrapsTarget).name, 'fennel76');
    expect(readTarget('https://example.com/x'), isA<ElsewhereTarget>());
    expect(readTarget('/browse/2/'), isA<ElsewhereTarget>());
  });

  test('unwraps the external link interstitial', () {
    const String wrapped =
        'https://www.furaffinity.net/externalurl/'
        '?q=https%3A%2F%2Fbsky.app%2Fprofile%2Fbirch92.bsky.social';
    final MarkupTarget target = readTarget(wrapped);
    expect(target, isA<ElsewhereTarget>());
    expect(
      (target as ElsewhereTarget).url,
      'https://bsky.app/profile/birch92.bsky.social',
    );
  });

  test('unwraps to an in-app route when FA wraps its own link', () {
    expect(
      readTarget(
        '/externalurl/?q=https%3A%2F%2Fwww.furaffinity.net%2Fview%2F7%2F',
      ),
      isA<SubmissionTarget>(),
    );
  });

  test('gives up on a wrapper with nothing inside', () {
    final MarkupTarget target = readTarget('/externalurl/?q=');
    expect((target as ElsewhereTarget).url, contains('/externalurl/'));
  });

  test('reads a mention with an avatar and a display name', () {
    final List<MarkupBlock> blocks = parseMarkup(
      'see <a href="/user/yarrow53" class="iconusername"> '
      '<img src="//a.furaffinity.net/1.gif" title="yarrow53" alt="yarrow53"> '
      '<span class="c-usernameBlockSimple__displayName">Yarrow53</span> '
      '</a>',
    );
    final MarkupMention mention = spansOf(blocks)
        .whereType<MarkupMention>()
        .single;
    expect(mention.name, 'yarrow53');
    expect(mention.display, 'Yarrow53');
    expect(mention.avatar, 'https://a.furaffinity.net/1.gif');
    expect(textOf(blocks), 'see ');
  });

  test('leaves the name off a mention the site renders without one', () {
    final List<MarkupBlock> blocks = parseMarkup(
      '<a href="/user/willow74" class="iconusername"> '
      '<img src="//a.furaffinity.net/2.gif" alt="willow74"></a>',
    );
    final MarkupMention mention = spansOf(blocks)
        .whereType<MarkupMention>()
        .single;
    expect(mention.name, 'willow74');
    expect(mention.display, isNull);
  });

  test('leaves an ordinary user link alone', () {
    final List<MarkupBlock> blocks = parseMarkup(
      '<a href="/user/someone">someone</a>',
    );
    expect(spansOf(blocks).whereType<MarkupMention>(), isEmpty);
    expect(spansOf(blocks).whereType<MarkupLink>(), hasLength(1));
  });

  test('routes FA tag links into a search', () {
    final MarkupTarget target = readTarget('/search/@keywords female');
    expect((target as SearchTarget).text, '@keywords female');
    expect(
      (readTarget(
        'https://www.furaffinity.net/search/?q=ginkgo29',
      ) as SearchTarget).text,
      'ginkgo29',
    );
    expect(readTarget('/search/'), isA<ElsewhereTarget>());
  });

  test('alignment reaches the children of an aligned block', () {
    final List<MarkupBlock> blocks = parseMarkup(
      '<div class="bbcode_center"><p>one</p><p>two</p></div>',
    );
    expect(blocks, hasLength(2));
    for (final MarkupBlock block in blocks) {
      expect((block as MarkupParagraph).align, MarkupAlign.center);
    }
  });

  test('alignment does not reach backwards over its neighbours', () {
    final List<MarkupBlock> blocks = parseMarkup(
      'before <span class="bbcode_center">mid</span> after',
    );
    final List<MarkupAlign> aligns = [
      for (final MarkupBlock block in blocks) (block as MarkupParagraph).align,
    ];
    expect(aligns.first, MarkupAlign.start);
    expect(aligns, contains(MarkupAlign.center));
  });

  test('a link wrapping a block keeps its href and its text', () {
    final List<MarkupBlock> blocks = parseMarkup(
      '<a href="/view/1/"><div>Title</div></a>',
    );
    final MarkupLink link =
        (blocks.single as MarkupParagraph).spans.single as MarkupLink;
    expect(link.href, '/view/1/');
    expect(link.spans, isNotEmpty);
  });

  test('a background colour is not read as a text colour', () {
    expect(readColour('background-color:#ffffff'), isNull);
    expect(readColour('color:#ffffff'), isNotNull);
    expect(readColour('background-color:#fff;color:#ff0000'), isNotNull);
  });

  test('an rgba colour keeps its channels', () {
    expect(readColour('color:rgba(255,0,0,0.5)'), isNotNull);
    expect(readColour('color:rgb(255,0,0)'), isNotNull);
  });

  test('an oversized submission id does not throw', () {
    expect(readTarget('/view/99999999999999999999/'), isA<ElsewhereTarget>());
  });
}
