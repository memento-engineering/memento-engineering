// The org register's CI check.
//
// Runs the same `DecisionLintService` the station composes behind
// `lunar decisions lint`, then drops EXACTLY ONE documented diagnostic class
// before deciding the exit code.
//
// THE EXEMPTION. An entry here may govern other repos on the roster, and it
// says so with a surface like `roster:CLAUDE.md`. The suffix is resolved at
// tier 2 against the composing station's coded roster, so standalone lint
// reports `surface.unmatched`. That gap is recorded in
// `memento-engineering#org-decisions-live-in-the-org-register`: roster-wide
// surfaces resolve at tier 2, where a station enumerates its coded mounted
// substations at runtime. Until that path exists, this check exempts unmatched
// surfaces marked `roster:` and treats every other diagnostic — schema,
// identity, edges, cached force, spec, and any repo-local unmatched surface —
// as fatal.
//
// Do not widen the exemption, and do not silence a red run by narrowing a
// surface to something repo-local: the reach is real, and flattening it
// records something false.
//
// Usage: dart run lint_register.dart [repoRoot]   (default: the parent of cwd)
import 'dart:io';

import 'package:decisions/decisions.dart';
import 'package:path/path.dart' as p;

/// Partitions [diagnostics] into immutable exemption and fatality lists.
({List<DecisionLintDiagnostic> exempt, List<DecisionLintDiagnostic> fatal})
partitionLintDiagnostics(Iterable<DecisionLintDiagnostic> diagnostics) {
  final exempt = <DecisionLintDiagnostic>[];
  final fatal = <DecisionLintDiagnostic>[];

  for (final diagnostic in diagnostics) {
    (isRosterWideSurfaceUnmatched(diagnostic) ? exempt : fatal).add(diagnostic);
  }

  return (
    exempt: List<DecisionLintDiagnostic>.unmodifiable(exempt),
    fatal: List<DecisionLintDiagnostic>.unmodifiable(fatal),
  );
}

void main(List<String> arguments) {
  final repoRoot = p.normalize(
    p.absolute(arguments.isEmpty ? '..' : arguments.single),
  );
  final registerPath = p.join(repoRoot, 'docs', 'decisions');

  if (!Directory(registerPath).existsSync()) {
    stderr.writeln('no register at $registerPath');
    exitCode = 2;
    return;
  }

  final result = const DecisionLintService().lint(
    registerPath: registerPath,
    repoRoot: repoRoot,
  );

  final (:exempt, :fatal) = partitionLintDiagnostics(result.diagnostics);

  for (final diagnostic in exempt) {
    stdout.writeln(
      'exempt  ${diagnostic.file}: ${diagnostic.ruleId}: ${diagnostic.message}',
    );
  }
  for (final diagnostic in fatal) {
    stderr.writeln(
      'FAIL    ${diagnostic.file}: ${diagnostic.ruleId}: ${diagnostic.message}',
    );
  }

  if (fatal.isEmpty) {
    stdout.writeln(
      'docs/decisions: clean '
      '(${exempt.length} roster-wide surface(s) exempted)',
    );
    return;
  }
  stderr.writeln('docs/decisions: ${fatal.length} fatal diagnostic(s)');
  exitCode = 1;
}
