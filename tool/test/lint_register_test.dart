import 'package:decisions/decisions.dart';
import 'package:test/test.dart';

import '../lint_register.dart';

void main() {
  test('partitions only marked unmatched surfaces as exempt', () {
    const marked = DecisionLintDiagnostic(
      ruleId: DecisionLintRules.surfaceUnmatched,
      file: 'marked.md',
      message: 'surface "roster:CLAUDE.md" does not match any file',
    );
    const local = DecisionLintDiagnostic(
      ruleId: DecisionLintRules.surfaceUnmatched,
      file: 'local.md',
      message: 'surface "CLAUDE.md" does not match any file',
    );

    final partition = partitionLintDiagnostics([marked, local]);

    expect(partition.exempt, [same(marked)]);
    expect(partition.fatal, [same(local)]);
    expect(() => partition.exempt.add(local), throwsUnsupportedError);
    expect(() => partition.fatal.add(marked), throwsUnsupportedError);
  });

  test('keeps a different rule for a marked surface fatal', () {
    const wrongRule = DecisionLintDiagnostic(
      ruleId: DecisionLintRules.entrySchema,
      file: 'entry.md',
      message: 'surface "roster:CLAUDE.md" does not match any file',
    );

    final partition = partitionLintDiagnostics([wrongRule]);

    expect(partition.exempt, isEmpty);
    expect(partition.fatal, [same(wrongRule)]);
  });
}
