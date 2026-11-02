#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
  printf '사용법: sh base_href.sh OWNER/REPOSITORY\n' >&2
  exit 2
fi

repository=$1
case "$repository" in
  ''|/*|*/|*/*/*)
    printf 'OWNER/REPOSITORY 형식이 필요합니다.\n' >&2
    exit 2
    ;;
  */*) ;;
  *)
    printf 'OWNER/REPOSITORY 형식이 필요합니다.\n' >&2
    exit 2
    ;;
esac

owner=${repository%%/*}
name=${repository#*/}
case "$owner" in
  *[!a-zA-Z0-9-]*) exit 2 ;;
esac
case "$name" in
  '.'|'..'|*[!a-zA-Z0-9._-]*) exit 2 ;;
esac

lower_owner=$(printf '%s' "$owner" | tr '[:upper:]' '[:lower:]')
lower_name=$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]')
if [ "$lower_name" = "$lower_owner.github.io" ]; then
  printf '/\n'
else
  printf '/%s/\n' "$name"
fi
