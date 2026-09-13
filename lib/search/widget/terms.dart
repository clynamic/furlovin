import 'package:furlovin/search/search.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

const String termAnchor = '\u200B';

bool _awaitsWord(String typed) {
  final String last = typed
      .trim()
      .split(' ')
      .last
      .replaceFirst(RegExp('^[-!]'), '');
  if (TermScope.ofField(last) != null) return true;
  return last.endsWith(':') &&
      TermScope.ofKey(last.substring(0, last.length - 1)) != null;
}

bool termsComplete(String typed) {
  final String trimmed = typed.trim();
  if (!typed.endsWith(' ') || trimmed.isEmpty) return false;
  if ('"'.allMatches(typed).length.isOdd) return false;
  if ('('.allMatches(typed).length != ')'.allMatches(typed).length) {
    return false;
  }
  if (trimmed.endsWith('|') || trimmed.endsWith('&')) return false;
  if (_awaitsWord(typed)) return false;
  return parseTerms(typed).isNotEmpty;
}

List<SearchTerm> termSuggestions(String typed) {
  if (typed.trim().isEmpty || _awaitsWord(typed)) return const [];
  final List<SearchTerm> pending = parseTerms(typed);
  if (pending case [final SearchTerm term]) {
    if (term.verbatim || term.scope != TermScope.anything) return [term];
    return [
      for (final TermScope scope in TermScope.values)
        if (scope != TermScope.uploader ||
            !term.words.any((e) => e.contains(' ')))
          term.copyWith(scope: scope),
    ];
  }
  return const [];
}

class TermField extends StatefulWidget {
  const TermField({
    super.key,
    required this.terms,
    required this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.hint = 'Search',
  });

  final List<SearchTerm> terms;
  final ValueChanged<List<SearchTerm>> onChanged;
  final VoidCallback? onSubmitted;
  final bool autofocus;
  final String hint;

  @override
  State<TermField> createState() => TermFieldState();
}

class TermFieldState extends State<TermField> {
  final TextEditingController text = TextEditingController(text: termAnchor);
  final FocusNode focus = FocusNode();
  bool _settling = false;

  String get typed => text.text.replaceAll(termAnchor, '');

  @override
  void initState() {
    super.initState();
    text.addListener(_onText);
    focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    text.dispose();
    focus.dispose();
    super.dispose();
  }

  void _write(String rest) {
    _settling = true;
    text.value = TextEditingValue(
      text: '$termAnchor$rest',
      selection: TextSelection.collapsed(offset: 1 + rest.length),
    );
    _settling = false;
    setState(() {});
  }

  void _onText() {
    if (_settling) return;
    final String value = text.text;
    if (!value.startsWith(termAnchor)) {
      if (value.isEmpty && widget.terms.isNotEmpty) {
        widget.onChanged([...widget.terms]..removeLast());
      }
      _write(value.replaceAll(termAnchor, ''));
      return;
    }
    if (termsComplete(typed)) {
      commit();
      return;
    }
    if (text.selection.baseOffset == 0) {
      _write(typed);
      return;
    }
    setState(() {});
  }

  void commit() {
    final List<SearchTerm> kept = [...widget.terms];
    String pending = typed;
    if (pending.trimLeft().startsWith('|') && kept.isNotEmpty) {
      pending = '${composeTerms([kept.removeLast()])} $pending';
    }
    final List<SearchTerm> added = parseTerms(pending);
    _write('');
    if (added.isEmpty) return;
    widget.onChanged([...kept, ...added]);
  }

  void _take(SearchTerm term) {
    _write('');
    widget.onChanged([...widget.terms, term]);
    focus.requestFocus();
  }

  void _submit() {
    commit();
    widget.onSubmitted?.call();
  }

  void _replace(int index, SearchTerm? next) {
    final List<SearchTerm> terms = [...widget.terms];
    if (next == null) {
      terms.removeAt(index);
    } else {
      terms[index] = next;
    }
    widget.onChanged(terms);
  }

  Future<void> _edit(int index) async {
    final SearchTerm? next = await showDialog<SearchTerm>(
      context: context,
      builder: (context) => TermEditor(
        term: widget.terms[index],
        onRemove: () => _replace(index, null),
      ),
    );
    if (next == null || !mounted) return;
    _replace(index, next);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<SearchTerm> suggestions = termSuggestions(typed);
    return TextFieldTapRegion(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: focus.requestFocus,
            child: InputDecorator(
              isFocused: focus.hasFocus,
              isEmpty: widget.terms.isEmpty && typed.isEmpty,
              decoration: InputDecoration(
                hintText: widget.hint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(borderRadius: Corner.panels),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Space.small,
                  vertical: Space.small,
                ),
              ),
              child: Wrap(
                spacing: Space.tight,
                runSpacing: Space.tight,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final (int at, SearchTerm term) in widget.terms.indexed)
                    TermChip(
                      term: term,
                      onTap: () => _edit(at),
                      onRemove: () => _replace(at, null),
                    ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 96),
                    child: IntrinsicWidth(
                      child: TextField(
                        controller: text,
                        focusNode: focus,
                        autofocus: widget.autofocus,
                        autocorrect: false,
                        enableSuggestions: false,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) => _submit(),
                        style: theme.textTheme.bodyLarge,
                        decoration: const InputDecoration.collapsed(
                          hintText: null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 56,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: Space.small),
              child: Row(
                spacing: Space.small,
                children: [
                  for (final SearchTerm term in suggestions)
                    ActionChip(
                      label: TermSuggestion(term: term),
                      onPressed: () => _take(term),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TermWords extends StatelessWidget {
  const TermWords({super.key, required this.term, this.style});

  final SearchTerm term;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? muted = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    if (term.verbatim) {
      return Text(
        term.words.single,
        style: style?.copyWith(fontFamily: 'monospace'),
      );
    }
    return Text.rich(
      TextSpan(
        children: [
          for (final (int at, String word) in term.words.indexed) ...[
            if (at > 0) TextSpan(text: ' or ', style: muted),
            TextSpan(text: word, style: style),
          ],
        ],
      ),
    );
  }
}

class TermSuggestion extends StatelessWidget {
  const TermSuggestion({super.key, required this.term});

  final SearchTerm term;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? muted = theme.textTheme.labelLarge?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (term.excluded) Text('not ', style: muted),
        if (term.scope == TermScope.uploader) Text('by ', style: muted),
        TermWords(term: term, style: theme.textTheme.labelLarge),
        if (term.scope
            case TermScope.tags || TermScope.title || TermScope.description)
          Text(' in ${term.scope.label.toLowerCase()}', style: muted),
      ],
    );
  }
}

class TermChip extends StatelessWidget {
  const TermChip({
    super.key,
    required this.term,
    required this.onTap,
    required this.onRemove,
  });

  final SearchTerm term;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final Color tint = term.excluded ? colors.error : colors.primary;
    return Material(
      color: tint.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: Corner.cards,
        side: BorderSide(color: tint.withValues(alpha: 0.4)),
      ),
      child: InkWell(
        borderRadius: Corner.cards,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(left: Space.small),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (term.excluded) ...[
                Icon(Icons.remove, size: 14, color: tint),
                const SizedBox(width: Space.hair),
              ],
              if (term.scope.key case final String key)
                Text(
                  '$key ',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              TermWords(
                term: term,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: tint,
                  decoration: term.excluded ? TextDecoration.lineThrough : null,
                ),
              ),
              IconButton(
                tooltip: 'Remove',
                onPressed: onRemove,
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 28,
                  height: 28,
                ),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(Icons.close, color: tint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef SentencePart = ({String text, bool word});

List<SentencePart> termSentence(SearchTerm term) {
  List<SentencePart> said(String text) => [(text: text, word: false)];
  final List<SentencePart> words = [
    for (final (int at, String word) in term.words.indexed) ...[
      if (at > 0) ...said(at == term.words.length - 1 ? ' or ' : ', '),
      (text: word, word: true),
    ],
  ];
  final bool not = term.excluded;
  if (term.verbatim) {
    return [...said(not ? 'posts not matching ' : 'posts matching '), ...words];
  }
  return switch (term.scope) {
    TermScope.anything => [
      ...said(not ? 'posts not mentioning ' : 'posts mentioning '),
      ...words,
    ],
    TermScope.uploader => [
      ...said(not ? 'posts not by uploader ' : 'posts by uploader '),
      ...words,
    ],
    TermScope.tags || TermScope.title || TermScope.description => [
      ...said(not ? 'posts without ' : 'posts with '),
      ...words,
      ...said(' in their ${term.scope.label.toLowerCase()}'),
    ],
  };
}

class TermSentence extends StatelessWidget {
  const TermSentence({super.key, required this.term});

  final SearchTerm term;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color tint = term.excluded
        ? theme.colorScheme.error
        : theme.colorScheme.primary;
    return Text.rich(
      TextSpan(
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        children: [
          for (final SentencePart part in termSentence(term))
            TextSpan(
              text: part.text,
              style: part.word
                  ? TextStyle(color: tint, fontWeight: FontWeight.w600)
                  : null,
            ),
        ],
      ),
    );
  }
}

class TermEditor extends StatefulWidget {
  const TermEditor({super.key, required this.term, required this.onRemove});

  final SearchTerm term;
  final VoidCallback onRemove;

  @override
  State<TermEditor> createState() => _TermEditorState();
}

class _TermEditorState extends State<TermEditor> {
  late SearchTerm _term = widget.term;
  final TextEditingController _adding = TextEditingController();

  @override
  void dispose() {
    _adding.dispose();
    super.dispose();
  }

  void _add() {
    final String word = _adding.text.trim().replaceAll('"', '');
    _adding.clear();
    if (word.isEmpty || _term.words.contains(word)) return;
    setState(() => _term = _term.copyWith(words: [..._term.words, word]));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Edit term'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Space.medium,
          children: [
            TermSentence(term: _term),
            SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: false,
                  label: Text('Include'),
                  icon: Icon(Icons.add),
                ),
                ButtonSegment(
                  value: true,
                  label: Text('Exclude'),
                  icon: Icon(Icons.block),
                ),
              ],
              selected: {_term.excluded},
              onSelectionChanged: (value) => setState(
                () => _term = _term.copyWith(excluded: value.single),
              ),
            ),
            FilterRow(
              label: 'Look in',
              children: [
                for (final TermScope scope in TermScope.values)
                  ChoiceChip(
                    showCheckmark: false,
                    avatar: Icon(scope.icon),
                    label: Text(scope.label),
                    selected: _term.scope == scope,
                    onSelected: (value) =>
                        setState(() => _term = _term.copyWith(scope: scope)),
                  ),
              ],
            ),
            if (_term.verbatim)
              Text(
                _term.words.single,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                ),
              )
            else
              FilterRow(
                label: 'Any of',
                children: [
                  if (_term.words case [final String word])
                    Chip(label: Text(word))
                  else
                    for (final String word in _term.words)
                      InputChip(
                        label: Text(word),
                        onDeleted: () => setState(
                          () => _term = _term.copyWith(
                            words: [..._term.words]..remove(word),
                          ),
                        ),
                      ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 160),
                    child: IntrinsicWidth(
                      child: TextField(
                        controller: _adding,
                        autocorrect: false,
                        enableSuggestions: false,
                        onSubmitted: (value) => _add(),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Add alternative',
                          suffixIconConstraints: const BoxConstraints.tightFor(
                            width: 32,
                            height: 32,
                          ),
                          suffixIcon: IconButton(
                            tooltip: 'Add',
                            onPressed: _add,
                            padding: EdgeInsets.zero,
                            iconSize: 20,
                            style: const ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(Icons.add),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        IconButton(
          tooltip: 'Remove term',
          onPressed: () {
            Navigator.of(context).pop();
            widget.onRemove();
          },
          icon: const Icon(Icons.delete_outline),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Space.small,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                _add();
                Navigator.of(context).pop(_term);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ],
    );
  }
}

extension TermScopeLabel on TermScope {
  String get label => switch (this) {
    TermScope.anything => 'Anywhere',
    TermScope.tags => 'Tags',
    TermScope.title => 'Title',
    TermScope.description => 'Description',
    TermScope.uploader => 'Uploader',
  };

  IconData get icon => switch (this) {
    TermScope.anything => Icons.all_inclusive,
    TermScope.tags => Icons.sell_outlined,
    TermScope.title => Icons.title,
    TermScope.description => Icons.notes,
    TermScope.uploader => Icons.person_outline,
  };
}
