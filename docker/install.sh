#!/bin/sh -eu

# No version is named here, so a rebuild installs whatever ocaml alpine is
# shipping by then rather than the release that was current when this file was
# last edited. Alpine carries one ocaml package rather than one per release, so
# asking for it by name is already asking for its newest stable.
#
# findlib comes too, because it is what resolves a library name such as
# alcotest to the archive the compiler links, and images built on this one
# install their framework through it.
apk update
apk add ocaml ocaml-findlib

# Read by check_version.sh, and by the install.sh of images built on this one,
# so both state the version this image actually holds rather than one written
# down when someone last edited them. The compiler is asked rather than the
# package index, so a version recorded here is one the image can run.
readonly OCAML_VERSION=$(ocaml -version | sed --quiet 's/.*version \([0-9][0-9.]*\).*/\1/p')

if [ -z "${OCAML_VERSION}" ]; then
  echo 'Could not read a version out of "ocaml -version"' >&2
  exit 1
fi

echo "{\"ocaml\":\"${OCAML_VERSION}\"}" > /versions.json

rm -rf /var/cache/apk/*
