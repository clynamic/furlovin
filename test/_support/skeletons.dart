import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';

Finder skeletons(Finder matching) => find.descendant(
  of: find.byWidgetPredicate(
    (widget) => widget is Skeletonizer && widget.enabled,
  ),
  matching: matching,
);
