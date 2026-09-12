import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/parser/parser.dart';

final FutureProvider<RuleSet> rulesProvider = FutureProvider<RuleSet>(
  (ref) => RuleLoader().bundled(),
);
