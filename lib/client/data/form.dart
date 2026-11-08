import 'package:furlovin/client/client.dart';

typedef FormEntry = ({String name, String value});

const Set<String> _unsent = {'submit', 'button', 'reset', 'image', 'file'};

const Set<String> _checkable = {'checkbox', 'radio'};

final RegExp _newlines = RegExp(r'\r\n|\r|\n');

String _crlf(String text) => text.replaceAll(_newlines, '\r\n');

class FormRequest {
  FormRequest(this.action, this.controls);

  final String action;
  final List<FormControl> controls;
  final Map<String, String> _values = {};
  final Map<String, bool> _checked = {};
  FormControl? pressed;

  void set(FormControl control, String value) => _values[control.name] = value;

  void check(FormControl control, {bool checked = true}) {
    if (checked && _typeOf(control) == 'radio') {
      for (final FormControl other in controls) {
        if (other.name == control.name && _typeOf(other) == 'radio') {
          _checked[_keyOf(other)] = false;
        }
      }
    }
    _checked[_keyOf(control)] = checked;
  }

  List<FormEntry> get entries => [
    for (final FormControl control in controls)
      if (_valueOf(control) case final String value)
        (name: _crlf(control.name), value: _crlf(value)),
    if (pressed case final FormControl button)
      (name: _crlf(button.name), value: _crlf(button.value ?? '')),
  ];

  String get body => [
    for (final (:String name, :String value) in entries)
      [name, value].map(Uri.encodeQueryComponent).join('='),
  ].join('&');

  static String _typeOf(FormControl control) =>
      control.type?.toLowerCase() ?? '';

  static String _keyOf(FormControl control) =>
      '${control.name}=${control.value ?? 'on'}';

  String? _valueOf(FormControl control) {
    if (control.disabled ?? false) return null;
    final String type = _typeOf(control);
    if (_unsent.contains(type)) return null;
    if (_checkable.contains(type)) {
      final bool checked =
          _checked[_keyOf(control)] ?? control.checked ?? false;
      return checked ? control.value ?? 'on' : null;
    }
    if (_values[control.name] case final String value) return value;
    if (control.options.isNotEmpty) {
      final FormOption chosen = control.options.firstWhere(
        (e) => e.selected ?? false,
        orElse: () => control.options.first,
      );
      return chosen.value;
    }
    return control.value ?? '';
  }
}
