import 'package:flutter/gestures.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

const double markupBlockGap = 12;
const double markupRuleInset = 40;

class Markup extends StatefulWidget {
  const Markup({
    super.key,
    required this.blocks,
    this.style,
    this.onOpen,
    this.emoteScale = 1,
  });

  final List<MarkupBlock> blocks;
  final TextStyle? style;
  final void Function(String href)? onOpen;
  final double emoteScale;

  @override
  State<Markup> createState() => _MarkupState();
}

class _MarkupState extends State<Markup> {
  final List<TapGestureRecognizer> _taps = [];
  int _used = 0;

  @override
  void dispose() {
    for (final TapGestureRecognizer tap in _taps) {
      tap.dispose();
    }
    _taps.clear();
    super.dispose();
  }

  TapGestureRecognizer _recognizer(String href) {
    if (_used == _taps.length) _taps.add(TapGestureRecognizer());
    final TapGestureRecognizer tap = _taps[_used++];
    tap.onTap = () => widget.onOpen?.call(href);
    return tap;
  }

  TextStyle _styled(MarkupStyle markup, TextStyle base, Color ground) {
    final Color? colour = markup.color;
    return base.copyWith(
      fontWeight: markup.bold ? FontWeight.w700 : null,
      fontStyle: markup.italic ? FontStyle.italic : null,
      decoration: TextDecoration.combine([
        if (markup.underline) TextDecoration.underline,
        if (markup.strike) TextDecoration.lineThrough,
      ]),
      color: colour == null ? null : readableOn(colour, ground),
    );
  }

  InlineSpan _span(
    MarkupSpan span,
    TextStyle base,
    Color ground, {
    TapGestureRecognizer? tap,
    String? href,
  }) {
    switch (span) {
      case MarkupText(:final String text, :final MarkupStyle style):
        return TextSpan(
          text: text,
          style: _styled(style, base, ground),
          recognizer: tap,
        );
      case MarkupBreak():
        return const TextSpan(text: '\n');
      case MarkupMention(
        :final String name,
        :final String? display,
        :final String? avatar,
      ):
        return WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Mention(name: name, display: display, avatar: avatar),
        );
      case MarkupEmote(:final String name):
        final Widget emote = Emote(name: name, scale: widget.emoteScale);
        return WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: href == null
              ? emote
              : GestureDetector(
                  onTap: () => widget.onOpen?.call(href),
                  child: emote,
                ),
        );
      case MarkupLink(:final String href, :final List<MarkupSpan> spans):
        final TapGestureRecognizer inner = _recognizer(href);
        final TextStyle linked = base.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );
        return TextSpan(
          children: [
            for (final MarkupSpan child in spans)
              _span(child, linked, ground, tap: inner, href: href),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle base =
        widget.style ?? theme.textTheme.bodyMedium ?? const TextStyle();
    final Color ground = theme.colorScheme.surface;
    _used = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: markupBlockGap,
      children: [
        for (final MarkupBlock block in widget.blocks)
          switch (block) {
            MarkupRule() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: markupRuleInset),
              child: ColoredBox(
                color: theme.colorScheme.outlineVariant,
                child: const SizedBox(height: 1, width: double.infinity),
              ),
            ),
            MarkupParagraph(
              :final List<MarkupSpan> spans,
              :final MarkupAlign align,
            ) =>
              Text.rich(
                TextSpan(
                  children: [
                    for (final MarkupSpan span in spans)
                      _span(span, base, ground),
                  ],
                ),
                textAlign: switch (align) {
                  MarkupAlign.start => TextAlign.start,
                  MarkupAlign.center => TextAlign.center,
                  MarkupAlign.end => TextAlign.end,
                },
              ),
          },
      ],
    );
  }
}
