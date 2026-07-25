#!/bin/sh
set -eu

if [ "$#" -ne 1 ] || [ ! -f "$1" ]; then
  echo "Usage: $0 /path/to/profile.ovpn" >&2
  exit 1
fi

endpoint=$(getent ahostsv4 vpn2.iiit.ac.in | { read -r address _; printf '%s' "$address"; })
case "$endpoint" in
  *.*.*.*) ;;
  *) echo "Could not resolve vpn2.iiit.ac.in to an IPv4 address" >&2; exit 1 ;;
esac

tmp=iiith.ovpn.tmp
trap 'rm -f "$tmp"' EXIT
sed \
  -e '/^script-security /d' \
  -e '/^up /d' \
  -e '/^down /d' \
  -e "s/^remote [^ ]*/remote $endpoint/" \
  "$1" > "$tmp"
mv "$tmp" iiith.ovpn
chmod 600 iiith.ovpn
trap - EXIT

echo "Prepared iiith.ovpn with endpoint $endpoint"
