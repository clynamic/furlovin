import 'package:flutter/services.dart' show rootBundle;
import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/parser/parser.dart';

class RuleLoader {
  RuleLoader();

  final Logger logger = Logger('RuleLoader');

  Future<RuleSet> bundled() async {
    final RuleSet rules = RuleSet.fromJson(
      decodeRules(await rootBundle.loadString(rulesAsset)),
    );
    logger.info('Loaded bundled rules, schema {schema} revision {revision}', {
      'schema': rules.schema,
      'revision': rules.revision,
      'asset': rulesAsset,
    });
    return rules;
  }

  RuleSet? accept(RuleSet current, RuleSet candidate) {
    final Logger scope = logger.child({
      'schema': candidate.schema,
      'revision': candidate.revision,
    });
    if (!candidate.isSupported) {
      scope.warn('Rejected rules, schema is not {expected}', {
        'expected': RuleSet.currentSchema,
      });
      return null;
    }
    if (candidate.revision <= current.revision) {
      scope.debug('Ignored rules, not newer than {current}', {
        'current': current.revision,
      });
      return null;
    }
    final List<String> problems = candidate.validateAgainst(ruleManifest);
    if (problems.isNotEmpty) {
      scope.warn('Rejected rules, {count} problems', {
        'count': problems.length,
        'problems': problems,
      });
      return null;
    }
    scope.info('Accepted rules');
    return candidate;
  }
}
