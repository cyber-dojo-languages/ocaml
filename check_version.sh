#!/usr/bin/env bash
set -Eeu

readonly MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly REGEX="image_name\": \"(.*)\""
readonly JSON=`cat ${MY_DIR}/docker/image_name.json`
[[ ${JSON} =~ ${REGEX} ]]
readonly IMAGE_NAME="${BASH_REMATCH[1]}"

# Written down here so the gate fails when the floating base image moves to a
# different ocaml. Reading it from the image instead would compare the image
# against itself and pass whatever the move brought in. The exact version the
# image holds is recorded in its /versions.json.
readonly EXPECTED=4.14

# Asks the installed compiler, so the gate fails when the ocaml the image can
# run is not the one named above. Matching on the leading major.minor lets a
# patch release through and stops only a minor or major move.
readonly ACTUAL=$(docker run --rm ${IMAGE_NAME} sh -c 'ocaml -version')

if echo "${ACTUAL}" | grep -q "version ${EXPECTED}"; then
  echo "VERSION CONFIRMED as ${EXPECTED}"
else
  echo "VERSION EXPECTED: ${EXPECTED}"
  echo "VERSION   ACTUAL: ${ACTUAL}"
  exit 42
fi
