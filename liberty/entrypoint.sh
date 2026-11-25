#!/bin/sh
set -e

if [ -z "${JAVA_HOME:-}" ]; then
    JAVA_BIN="$(readlink -f "$(command -v java)")"
    export JAVA_HOME="${JAVA_BIN%/bin/java}"
fi

export PG_PORT="${PG_PORT:-5432}"

exec /home/usuario/wlp/bin/server run galeno "$@"
