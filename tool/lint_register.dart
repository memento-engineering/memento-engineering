// The org register's CI check.
//
// Runs the same `DecisionLintService` the station composes behind
// `lunar decisions lint`, then drops EXACTLY ONE documented diagnostic class
// before deciding the exit code.
//
// THE EXEMPTION. An entry here may govern other repos on the roster, and it
// says so with a surface like `engineering.memento/*/CLAUDE.md`. Those globs
// resolve only on a machine where this checkout sits inside the umbrella
// directory, so in a clean clone — CI included — every one of them reports
// `surface.unmatched`. That gap is recorded in
// `memento-engineering#org-decisions-live-in-the-org-register`: roster-wide
// surfaces resolve at tier 2, where a station enumerates its mounted
// substations at runtime. Until that path exists, this check exempts
// unmatched surfaces under `engineering.memento/` and treats every other
// diagnostic — schema, identity, edges, cached force, spec, and any
// repo-local unmatched surface — as fatal.
//
// Do not widen the exemption, and do not silence a red run by narrowing a
// surface to something repo-local: the reach is real, and flattening it
// records something false.
//
// Usage: dart run lint_register.dart [repoRoot]   (default: the parent of cwd)
import 'dart:io';

import 'package:decisions/decisions.dart';
import 'package:path/path.dart' as p;

/// Surfaces beginning with this prefix are roster-wide and unresolvable from a
/// standalone checkout.
const String _rosterWidePrefix = 'engineering.memento/';

/// The exact shape `DecisionLintService` emits for an unmatched surface.
bool _isRosterWideSurface(DecisionLintDiagnostic diagnostic) =>
    diagnostic.ruleId == DecisionLintRules.surfaceUnmatched &&
    diagnostic.message.startsWith('surface "$_rosterWidePrefix');

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

  final exempt = result.diagnostics.where(_isRosterWideSurface).toList();
  final fatal = result.diagnostics
      .where((diagnostic) => !_isRosterWideSurface(diagnostic))
      .toList();

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
