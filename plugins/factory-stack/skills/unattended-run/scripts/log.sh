#!/usr/bin/env bash
# Usage: log.sh <logfile> <phase> <decision> <why> <evidence> <result>
# Appends one row to a TSV decision log, writing the header on first use.
# Cells are flattened to one line, and a leading = + - @ is quoted so a
# spreadsheet never evaluates a cell as a formula.
set -euo pipefail

if [ "$#" -ne 6 ]; then
	echo "usage: log.sh <logfile> <phase> <decision> <why> <evidence> <result>" >&2
	exit 64
fi

log=$1
shift
mkdir -p "$(dirname "$log")"
[ -s "$log" ] || printf 'ts\tphase\tdecision\twhy\tevidence\tresult\n' >>"$log"

cell() {
	local value
	value=$(printf '%s' "$1" | tr '\t\r\n' '   ')
	case "$value" in
		[=+@-]*) printf "'%s" "$value" ;;
		*) printf '%s' "$value" ;;
	esac
}

row=$(date -u +%Y-%m-%dT%H:%M:%SZ)
for value in "$@"; do
	row="$row"$'\t'"$(cell "$value")"
done
printf '%s\n' "$row" >>"$log"
