#!/usr/bin/env bash
#
# This scripts invokes all unignored tests, update pass list (append-only)
# and print the list of failing tests.
# 
#

set -eu

err_handler () {
   ./scripts/_/notify.sh 'Check failed!'
   exit 1
}

trap err_handler ERR

export CARGO_TERM_COLOR=always

# We prevent regression using faster checks
GOLDEN_ONLY=1 cargo test -q -p stc_ts_file_analyzer --test visualize

RUST_LOG=0 TEST='' cargo test --test tsc \
  | tee /dev/stderr \
  | grep 'ts .\.\. ok$' \
  | sed -e 's!test conformance::!!' \
  | sed -e 's! ... ok!!' \
  | sed -e 's!::!/!g' \
  | sed -e 's!test !!' \
  >> tests/conformance.pass.txt

./scripts/sort.sh

./scripts/_/notify.sh 'Check done!'