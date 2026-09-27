import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<double> bottomOf(
    WidgetTester tester,
    Widget Function(Widget probe) page,
  ) async {
    late double bottom;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(padding: EdgeInsets.only(bottom: 100)),
        child: BottomReserve(
          space: 80,
          child: page(
            Builder(
              builder: (context) {
                bottom = MediaQuery.paddingOf(context).bottom;
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
    return bottom;
  }

  testWidgets('a claiming page lays out without the reserved space', (
    tester,
  ) async {
    expect(await bottomOf(tester, (probe) => ClaimedBottom(child: probe)), 20);
  });

  testWidgets('other pages keep the reserved space', (tester) async {
    expect(await bottomOf(tester, (probe) => probe), 100);
  });

  testWidgets('a claiming page covers the bottom as far as it has arrived', (
    tester,
  ) async {
    final BottomClaim claim = BottomClaim();
    addTearDown(claim.dispose);
    await tester.pumpWidget(
      BottomClaimScope(
        claim: claim,
        child: const MaterialApp(home: Scaffold(body: Text('grid'))),
      ),
    );

    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(builder: (context) => const _Claimant()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(claim.coverage, inExclusiveRange(0, 1));

    await tester.pumpAndSettle();
    expect(claim.coverage, 1);

    navigator.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(claim.coverage, inExclusiveRange(0, 1));

    await tester.pumpAndSettle();
    expect(claim.coverage, 0);
  });

  testWidgets('a page pushed over a claiming page uncovers the bottom', (
    tester,
  ) async {
    final BottomClaim claim = BottomClaim();
    addTearDown(claim.dispose);
    await tester.pumpWidget(
      BottomClaimScope(
        claim: claim,
        child: const MaterialApp(home: _Claimant()),
      ),
    );
    expect(claim.coverage, 1);

    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(builder: (context) => const Text('profile')),
    );
    await tester.pumpAndSettle();
    expect(claim.coverage, 0);
  });
}

class _Claimant extends StatefulWidget {
  const _Claimant();

  @override
  State<_Claimant> createState() => _ClaimantState();
}

class _ClaimantState extends State<_Claimant> with BottomClaimant {
  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('detail'));
}
