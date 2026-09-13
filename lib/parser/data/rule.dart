import 'package:furlovin/parser/parser.dart';

class FieldRule {
  const FieldRule(
    this.alternatives, {
    this.repeated = false,
    this.type = FieldType.string,
  });

  static List<Step> expandStep(
    Map<String, Object?> json,
    Map<String, List<Step>> refs,
  ) {
    final Object? reference = json[r'$ref'];
    if (reference == null) return [Step.fromJson(json)];
    final List<Step>? resolved = refs[reference];
    if (resolved == null) {
      throw StepException(r'$ref', 'unknown ref "$reference"');
    }
    return resolved;
  }

  final List<List<Step>> alternatives;
  final bool repeated;
  final FieldType type;
}
