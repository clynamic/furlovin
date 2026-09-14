import 'package:flutter/gestures.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

const Map<int, double> headingScales = {
  1: 1.6,
  2: 1.4,
  3: 1.25,
  4: 1.1,
  5: 1,
  6: 1,
};

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
  final Set<MarkupSpoiler> _revealed = {};
  int _used = 0;

  @override
  void dispose() {
    for (final TapGestureRecognizer tap in _taps) {
      tap.dispose();
    }
    _taps.clear();
    super.dispose();
  }

  TapGestureRecognizer _recognizer(VoidCallback onTap) {
    if (_used == _taps.length) _taps.add(TapGestureRecognizer());
    final TapGestureRecognizer tap = _taps[_used++];
    tap.onTap = onTap;
    return tap;
  }

  @override
  void didUpdateWidget(Markup old) {
    super.didUpdateWidget(old);
    if (old.blocks != widget.blocks) _revealed.clear();
  }

  TextStyle _styled(MarkupStyle markup, TextStyle base, Color ground) {
    final Color? colour = markup.color;
    final int? heading = markup.heading;
    return base.copyWith(
      fontSize: heading == null || base.fontSize == null
          ? null
          : base.fontSize! * (headingScales[heading] ?? 1),
      fontWeight: markup.bold || heading != null ? FontWeight.w700 : null,
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
    VoidCallback? onTap,
    Color? veil,
    bool announce = false,
  }) {
    switch (span) {
      case MarkupText(:final String text, :final MarkupStyle style):
        final TextStyle styled = _styled(style, base, ground);
        return TextSpan(
          text: text,
          style: veil == null
              ? styled
              : styled.copyWith(
                  color: Colors.transparent,
                  backgroundColor: veil,
                  decoration: TextDecoration.none,
                ),
          semanticsLabel: veil == null
              ? null
              : (announce ? 'Spoiler, tap to reveal' : ''),
          recognizer: tap,
        );
      case MarkupBreak():
        return const TextSpan(text: '\n');
      case MarkupMention(
        :final String name,
        :final String? display,
        :final String? avatar,
      ):
        return _widget(
          Mention(name: name, display: display, avatar: avatar),
          onTap: veil == null ? null : onTap,
          veil: veil,
        );
      case MarkupEmote(:final String name):
        return _widget(
          Emote(name: name, scale: widget.emoteScale),
          onTap: onTap,
          veil: veil,
        );
      case MarkupLink(:final String href, :final List<MarkupSpan> spans):
        final VoidCallback open = veil == null
            ? () => widget.onOpen?.call(href)
            : onTap!;
        final TapGestureRecognizer inner = _recognizer(open);
        final TextStyle linked = base.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );
        return TextSpan(
          children: [
            for (final (int at, MarkupSpan child) in spans.indexed)
              _span(
                child,
                linked,
                ground,
                tap: inner,
                onTap: open,
                veil: veil,
                announce: announce && at == 0,
              ),
          ],
        );
      case MarkupSpoiler(:final List<MarkupSpan> spans):
        final ColorScheme colors = Theme.of(context).colorScheme;
        final bool hidden = veil == null && !_revealed.contains(span);
        if (!hidden) {
          void hide() => setState(() => _revealed.remove(span));
          final TapGestureRecognizer? hiding = tap == null
              ? _recognizer(hide)
              : null;
          return TextSpan(
            style: base.copyWith(
              backgroundColor: colors.surfaceContainerHighest,
            ),
            children: [
              for (final MarkupSpan child in spans)
                _span(
                  child,
                  base,
                  ground,
                  tap: tap ?? hiding,
                  onTap: onTap ?? hide,
                  veil: veil,
                ),
            ],
          );
        }
        void reveal() => setState(() => _revealed.add(span));
        final TapGestureRecognizer revealing = _recognizer(reveal);
        return TextSpan(
          children: [
            for (final (int at, MarkupSpan child) in spans.indexed)
              _span(
                child,
                base,
                ground,
                tap: revealing,
                onTap: reveal,
                veil: colors.onSurfaceVariant,
                announce: at == 0,
              ),
          ],
        );
    }
  }

  InlineSpan _widget(Widget child, {VoidCallback? onTap, Color? veil}) =>
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          onTap: onTap,
          child: veil == null
              ? child
              : ColoredBox(
                  color: veil,
                  child: ExcludeSemantics(
                    child: Visibility(
                      visible: false,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: child,
                    ),
                  ),
                ),
        ),
      );

  Widget _blocks(
    List<MarkupBlock> blocks,
    ThemeData theme,
    TextStyle base,
    Color ground,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 12,
    children: [
      for (final MarkupBlock block in blocks)
        switch (block) {
          MarkupRule() => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
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
          MarkupQuote(:final String? name, :final List<MarkupBlock> blocks) =>
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                    width: 3,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: Space.snug),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: Space.tight,
                  children: [
                    if (name != null)
                      Text(
                        name,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    _blocks(
                      blocks,
                      theme,
                      base.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ground,
                    ),
                  ],
                ),
              ),
            ),
        },
    ],
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle base =
        widget.style ?? theme.textTheme.bodyMedium ?? const TextStyle();
    final Color ground = theme.colorScheme.surface;
    _used = 0;
    return _blocks(widget.blocks, theme, base, ground);
  }
}
