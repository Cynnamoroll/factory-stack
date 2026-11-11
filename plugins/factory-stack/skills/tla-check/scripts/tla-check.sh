#!/usr/bin/env bash
# Usage: tla-check.sh SPEC.tla [CONFIG.cfg] [OUT_DIR]
# Runs SANY and TLC on SPEC, writes sany.out, tlc.out, states.dot, chart.mmd,
# and summary.txt to OUT_DIR, and prints the summary.
# Exit codes: 0 pass, 1 violation or deadlock, 2 parse or checker error, 64 usage.
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 3 ]; then
	echo "usage: tla-check.sh SPEC.tla [CONFIG.cfg] [OUT_DIR]" >&2
	exit 64
fi

spec=$(realpath "$1")
spec_dir=$(dirname "$spec")
module=$(basename "$spec" .tla)
config=$(realpath "${2:-$spec_dir/$module.cfg}")
out=$(realpath -m "${3:-$(mktemp -d "/tmp/tla-check-$module-XXXX")}")
chart_limit=${TLA_CHART_LIMIT:-200}
tla_version=${TLA_VERSION:-1.8.0}
jar=${TLA2TOOLS_JAR:-$HOME/.cache/factory-stack/tla2tools-$tla_version.jar}
here=$(cd "$(dirname "$0")" && pwd)

[ -f "$spec" ] || { echo "spec not found: $spec" >&2; exit 64; }
[ -f "$config" ] || { echo "config not found: $config" >&2; exit 64; }
command -v java >/dev/null || { echo "java not found; install a JRE 11 or later" >&2; exit 2; }

if [ ! -f "$jar" ]; then
	mkdir -p "$(dirname "$jar")"
	echo "downloading tla2tools $tla_version to $jar" >&2
	curl -fsSL -o "$jar.part" "https://github.com/tlaplus/tlaplus/releases/download/v$tla_version/tla2tools.jar"
	mv "$jar.part" "$jar"
fi

mkdir -p "$out"
cd "$spec_dir"

sany_status=0
java -cp "$jar" tla2sany.SANY "$spec" >"$out/sany.out" 2>&1 || sany_status=$?
if [ "$sany_status" -ne 0 ] || grep -q -E '\*\*\* ?Errors|Parse Error|Lexical error|Fatal errors|Semantic errors' "$out/sany.out"; then
	{ echo "result: parse-error"; echo "see: $out/sany.out"; } | tee "$out/summary.txt"
	exit 2
fi

tlc_status=0
java -XX:+UseParallelGC -cp "$jar" tlc2.TLC \
	-workers 1 -cleanup -metadir "$out/meta" \
	-config "$config" -dump dot,actionlabels "$out/states" \
	"$module" >"$out/tlc.out" 2>&1 || tlc_status=$?

states=$(grep -oE '[0-9,]+ distinct states found' "$out/tlc.out" | tail -1 | tr -d ',' | cut -d' ' -f1 || true)
violations=$(grep -oE 'Invariant [A-Za-z0-9_]+ is violated' "$out/tlc.out" | awk '{print $2}' | sort -u | paste -sd, - || true)
temporal=$(grep -oE 'Temporal properties were violated' "$out/tlc.out" | head -1 || true)
deadlock=$(grep -q 'Deadlock reached' "$out/tlc.out" && echo yes || true)

if [ -n "$violations" ] || [ -n "$temporal" ] || [ -n "$deadlock" ]; then
	result=violation
elif grep -q 'No error has been found' "$out/tlc.out"; then
	result=pass
else
	result=error
fi

chart=none
if [ -f "$out/states.dot" ] && [ -n "$states" ] && [ "$states" -le "$chart_limit" ]; then
	python3 "$here/dot2mermaid.py" "$out/states.dot" >"$out/chart.mmd"
	chart="$out/chart.mmd"
fi

{
	echo "result: $result"
	echo "distinct_states: ${states:-unknown}"
	echo "violated_invariants: ${violations:-none}"
	echo "temporal_violation: ${temporal:+yes}"
	echo "deadlock: ${deadlock:-no}"
	echo "tlc_exit: $tlc_status"
	echo "tlc_output: $out/tlc.out"
	echo "chart: $chart"
} | tee "$out/summary.txt"

case "$result" in
	pass) exit 0 ;;
	violation) exit 1 ;;
	*) exit 2 ;;
esac
