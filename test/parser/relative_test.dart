import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

void main() {
  final StepContext context = StepContext(
    base: Uri.parse('https://furaffinity.net/'),
  );
  final Document page = html.parse('''
    <div class="folders">
      <div class="top"><h4>comics</h4></div>
      <ul class="group"><li><a id="grouped">a</a></li></ul>
      <ul class="group loose"><li><a id="loose">b</a></li></ul>
    </div>
  ''');
  final Element grouped = page.querySelector('#grouped')!;
  final Element loose = page.querySelector('#loose')!;

  test('closest climbs to the nearest matching ancestor', () {
    expect(
      const ClosestStep('ul').apply(grouped, context),
      page.querySelectorAll('ul').first,
    );
    expect(
      const ClosestStep('div.folders').apply(grouped, context),
      page.querySelector('div.folders'),
    );
    expect(const ClosestStep('section').apply(grouped, context), isNull);
  });

  test('closest skips the element itself', () {
    expect(const ClosestStep('a').apply(grouped, context), isNull);
  });

  test('previous only looks at the sibling right before', () {
    final List<Element> lists = page.querySelectorAll('ul');
    expect(
      const PreviousStep('div.top').apply(lists.first, context),
      page.querySelector('div.top'),
    );
    expect(const PreviousStep('div.top').apply(lists.last, context), isNull);
    expect(const PreviousStep('div.top').apply(loose, context), isNull);
  });

  test('both answer nothing for nothing', () {
    expect(const ClosestStep('ul').apply(null, context), isNull);
    expect(const PreviousStep('ul').apply(null, context), isNull);
  });

  test('labeled reads the value in the row its label names', () {
    final Element stats = html
        .parse('''
      <div class="stats">
        <span class="highlight"><span>Category</span><span>Species</span></span>
        <span><span>Artwork</span><span>Dog</span></span>
      </div>
    ''')
        .querySelector('div.stats')!;
    const LabeledStep species = LabeledStep(
      labels: 'span.highlight > span',
      values: 'span:not(.highlight) > span',
      label: 'Species',
    );
    expect((species.apply(stats, context)! as Element).text, 'Dog');
    expect(
      const LabeledStep(
        labels: 'span.highlight > span',
        values: 'span:not(.highlight) > span',
        label: 'Resolution',
      ).apply(stats, context),
      isNull,
    );
  });
}
