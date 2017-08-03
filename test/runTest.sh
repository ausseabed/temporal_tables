#!/bin/bash

createdb temporal_tables_test
psql temporal_tables_test -q -f versioning_function.sql

mkdir -p test/result

# TESTS="no_history_table no_system_period no_history_system_period"

TESTS="versioning no_history_table no_history_system_period no_system_period structure combinations"

for name in $TESTS; do
  echo ""
  echo $name
  echo ""
  psql temporal_tables_test -X -a -q < test/sql/$name.sql > test/result/$name.out 2>&1
  diff -b test/expected/$name.out test/result/$name.out
done


psql -q -c "drop database temporal_tables_test;"