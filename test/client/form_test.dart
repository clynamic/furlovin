import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';

FormControl _input(String name, {String? type, String? value}) =>
    FormControl(name: name, type: type, value: value);

void main() {
  test('sends every control as the page filled it', () {
    final FormRequest form = FormRequest('https://www.furaffinity.net/a/', [
      _input('action', type: 'hidden', value: 'reply'),
      _input('replyto', type: 'hidden', value: ''),
      const FormControl(name: 'reply', value: 'first draft'),
    ]);
    expect(form.entries, [
      (name: 'action', value: 'reply'),
      (name: 'replyto', value: ''),
      (name: 'reply', value: 'first draft'),
    ]);
  });

  test('a set value replaces the one the page filled', () {
    const FormControl reply = FormControl(name: 'reply', value: 'draft');
    final FormRequest form = FormRequest('/a/', [
      _input('action', type: 'hidden', value: 'reply'),
      reply,
    ])..set(reply, 'kind words');
    expect(form.entries.last, (name: 'reply', value: 'kind words'));
  });

  test('leaves out disabled controls and buttons nobody pressed', () {
    final FormRequest form = FormRequest('/a/', [
      const FormControl(name: 'locked', value: 'x', disabled: true),
      _input('go', type: 'submit', value: 'Send'),
      _input('kept', type: 'text', value: 'y'),
    ]);
    expect(form.entries, [(name: 'kept', value: 'y')]);
  });

  test('sends the pressed button after the controls', () {
    const FormControl trash = FormControl(name: 'move_to', value: 'trash');
    final FormRequest form = FormRequest('/a/', [
      _input('manage_notes', type: 'hidden', value: '1'),
    ])..pressed = trash;
    expect(form.entries, [
      (name: 'manage_notes', value: '1'),
      (name: 'move_to', value: 'trash'),
    ]);
  });

  test('sends a checkbox only while checked, as on without a value', () {
    final FormControl shared = _input('sharenotes', type: 'checkbox');
    final FormControl kept = _input('items[]', type: 'checkbox', value: '7');
    const FormControl dropped = FormControl(
      name: 'items[]',
      type: 'checkbox',
      value: '8',
      checked: true,
    );
    final FormRequest form = FormRequest('/a/', [shared, kept, dropped])
      ..check(shared)
      ..check(kept)
      ..check(dropped, checked: false);
    expect(form.entries, [
      (name: 'sharenotes', value: 'on'),
      (name: 'items[]', value: '7'),
    ]);
  });

  test('checking a radio unchecks the others of its name', () {
    const FormControl low = FormControl(
      name: 'prio',
      type: 'radio',
      value: 'low',
      checked: true,
    );
    final FormControl high = _input('prio', type: 'radio', value: 'high');
    final FormRequest form = FormRequest('/a/', [low, high])..check(high);
    expect(form.entries, [(name: 'prio', value: 'high')]);
  });

  test('a select sends its selected option, or its first one', () {
    const List<FormOption> issues = [
      FormOption(value: '-1'),
      FormOption(value: '18'),
    ];
    final FormRequest form = FormRequest('/a/', [
      const FormControl(name: 'fresh', options: issues),
      const FormControl(
        name: 'chosen',
        options: [
          FormOption(value: '-1'),
          FormOption(value: '18', selected: true),
        ],
      ),
    ]);
    expect(form.entries, [
      (name: 'fresh', value: '-1'),
      (name: 'chosen', value: '18'),
    ]);
  });

  test('turns every line break into CRLF and encodes the body', () {
    const FormControl message = FormControl(name: 'message');
    final FormRequest form = FormRequest('/a/', [message])
      ..set(message, 'one\ntwo\rthree & four');
    expect(form.entries.single.value, 'one\r\ntwo\r\nthree & four');
    expect(form.body, 'message=one%0D%0Atwo%0D%0Athree+%26+four');
  });
}
