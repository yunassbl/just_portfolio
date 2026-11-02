#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
resolver="$script_dir/base_href.sh"
checks=0

assert_path() {
  actual=$(sh "$resolver" "$1")
  if [ "$actual" != "$2" ]; then
    printf '경로 검사 실패: %s → %s (기대: %s)\n' "$1" "$actual" "$2" >&2
    exit 1
  fi
  checks=$((checks + 1))
}

assert_path 'example/portfolio' '/portfolio/'
assert_path 'example/example.github.io' '/'
assert_path 'Example/EXAMPLE.GITHUB.IO' '/'
assert_path 'example/another.github.io' '/another.github.io/'
assert_path 'example/Portfolio_Web-2' '/Portfolio_Web-2/'
assert_path 'sample-org/sample-org.github.io' '/'

for invalid in '' 'example' '/portfolio' 'example/' 'example/repo/extra' 'example/..' 'example/repo name' 'example/repo%2Fname'; do
  if sh "$resolver" "$invalid" >/dev/null 2>&1; then
    printf '잘못된 저장소 이름을 허용했습니다: %s\n' "$invalid" >&2
    exit 1
  fi
  checks=$((checks + 1))
done

if sh "$resolver" >/dev/null 2>&1 || sh "$resolver" 'example/repo' 'extra' >/dev/null 2>&1; then
  printf '잘못된 인자 개수를 허용했습니다.\n' >&2
  exit 1
fi
checks=$((checks + 2))
printf 'Pages 경로 검사 %s개 통과\n' "$checks"
