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
export RUST_BACKTRACE=1
export RUST_MIN_STACK=$((8 * 1024 * 1024))

# We prevent regression using faster checks
RUST_LOG=off ./scripts/base.sh --features tracing/max_level_error

RUST_LOG=error TEST='' DO_NOT_PRINT_MATCHED=1 cargo test --test tsc  --features tracing/max_level_error --features no-threading \
  | tee /dev/stderr \
  | grep 'ts .\.\. ok$' \
  | sed -e 's!test conformance::!!' \
  | sed -e 's! ... ok!!' \
  | sed -e 's!::!/!g' \
  | sed -e 's!test !!' \
  >> tests/conformance.pass.txt

./scripts/sort.sh

./scripts/_/notify.sh 'Check done!'
