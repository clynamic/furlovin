import 'package:material_ui/material_ui.dart';

enum MarkupAlign { start, center, end }

@immutable
class MarkupStyle {
  const MarkupStyle({
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.strike = false,
    this.color,
  });

  final bool bold;
  final bool italic;
  final bool underline;
  final bool strike;
  final Color? color;

  MarkupStyle copyWith({
    bool? bold,
    bool? italic,
    bool? underline,
    bool? strike,
    Color? color,
  }) => MarkupStyle(
    bold: bold ?? this.bold,
    italic: italic ?? this.italic,
    underline: underline ?? this.underline,
    strike: strike ?? this.strike,
    color: color ?? this.color,
  );
}

@immutable
sealed class MarkupSpan {
  const MarkupSpan();
}

class MarkupText extends MarkupSpan {
  const MarkupText(this.text, {this.style = const MarkupStyle()});

  final String text;
  final MarkupStyle style;
}

class MarkupLink extends MarkupSpan {
  const MarkupLink({required this.href, required this.spans});

  final String href;
  final List<MarkupSpan> spans;
}

class MarkupMention extends MarkupSpan {
  const MarkupMention({required this.name, required this.display, this.avatar});

  final String name;
  final String? display;
  final String? avatar;
}

class MarkupEmote extends MarkupSpan {
  const MarkupEmote(this.name);

  final String name;
}

class MarkupBreak extends MarkupSpan {
  const MarkupBreak();
}

@immutable
sealed class MarkupBlock {
  const MarkupBlock();
}

class MarkupParagraph extends MarkupBlock {
  const MarkupParagraph(this.spans, {this.align = MarkupAlign.start});

  final List<MarkupSpan> spans;
  final MarkupAlign align;
}

class MarkupRule extends MarkupBlock {
  const MarkupRule();
}
