import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/parser.dart' as html;

import '../_support/documents.dart';

class _Desk implements HttpClientAdapter {
  final List<RequestOptions> posted = [];
  final List<String> bodies = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.method == 'POST') {
      posted.add(options);
      bodies.add(
        options.data is String
            ? options.data! as String
            : utf8.decode(
                await (requestStream ?? const Stream<Uint8List>.empty())
                    .expand((e) => e)
                    .toList(),
              ),
      );
      return ResponseBody.fromString(
        '',
        302,
        headers: {
          'location': ['/controls/troubletickets/'],
        },
      );
    }
    return ResponseBody.fromString(fixture('ticket'), 200);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late RuleSet rules;

  setUpAll(() => rules = loadRules());

  TicketForm read() => TicketDocument.fromOutcome(
    parseFixture(rules, TicketDocument.ruleType, 'ticket'),
  )!.ticket;

  test('reads the issue groups, the limits and the pre-filled details', () {
    final TicketForm ticket = read();
    expect(ticket.action, 'https://www.furaffinity.net/controls/quince/');

    final FormOption first = ticket.issue.options.first;
    expect(first.placeholder, isTrue);
    expect(first.selected, isTrue);
    expect(first.group, isNull);
    expect(ticket.issue.options[1].group, 'General');
    expect(ticket.issue.options[1].value, '2');
    expect(ticket.issue.options.last.group, 'Discord');

    expect(ticket.details.value, contains('\n'));
    expect(ticket.details.value, contains('60015717'));
    expect(ticket.details.maxLength, 1170);
    expect(ticket.details.minLength, 1);
    expect(ticket.details.required, isTrue);
    expect(ticket.subject?.maxLength, 73);

    expect(ticket.shareNotes?.type, 'checkbox');
    expect(ticket.shareNotes?.checked, isNull);
    expect(ticket.shareNotes?.label, startsWith('Heath3'));
  });

  test('a control reads the selected option and an empty textarea', () {
    const String page = '''
<html><body><form id="new-ticket" action="/controls/newticket/">
  <select name="issuetype">
    <option class="default-value" value="-1">--Pick--</option>
    <optgroup label="Code of Conduct"><option value="18" selected>Spam</option></optgroup>
  </select>
  <textarea name="message"></textarea>
</form></body></html>''';
    final TicketForm ticket = TicketDocument.fromOutcome(
      rules.parsePage(
        TicketDocument.ruleType,
        html.parse(page),
        base: Uri.parse(faOrigin),
      ),
    )!.ticket;
    expect(ticket.issue.value, '18');
    expect(ticket.issue.options.last.label, 'Spam');
    expect(ticket.issue.options.last.placeholder, isNull);
    expect(ticket.details.value, '');
  });

  test('files the ticket as the site form sends it', () async {
    final _Desk desk = _Desk();
    final ViewerClient client = ViewerClient(
      client: FaClient()..dio.httpClientAdapter = desk,
      rules: rules,
    );
    final TicketForm ticket = (await client.ticket('/controls/troubletickets/'))
        .ticket;

    await client.fileTicket(
      FormRequest(ticket.action, ticket.controls)
        ..set(ticket.issue, '18')
        ..set(ticket.details, 'Spam in the comments')
        ..check(ticket.shareNotes!),
    );

    expect(desk.posted.single.uri.path, '/controls/quince/');
    expect(Uri.splitQueryString(desk.bodies.single), {
      'issuetype': '18',
      'other': '',
      'message': 'Spam in the comments',
      'sharenotes': '1',
    });
  });
}
