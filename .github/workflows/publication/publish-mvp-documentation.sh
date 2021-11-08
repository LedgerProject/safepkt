#!/bin/bash

function publish() {
  local documentation
  documentation="${1}"

  echo "=> About to publish ""${documentation}"

  if [ ! -e "${documentation}" ];
  then
      echo 'Invalid documentation ('"${documentation}"')'
      return 1
  fi

  local base_url
  base_url='https://api.github.com/repos/'"${GITHUB_REPOSITORY}"

  local upload_url
  upload_url="$(curl \
    -H 'Content-Type: application/octet-stream' \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "${base_url}"/releases 2>> /dev/null | \
    jq -r '.[] | .upload_url' | \
    head -n1)"

  upload_url=${upload_url/\{?name,label\}/}

  local release_name
  release_name="$(curl \
    -H 'Content-Type: application/octet-stream' \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "${base_url}"/releases 2>> /dev/null | \
    jq -r '.[] | .tag_name' | \
    head -n1)"

  echo '=> Release name is '"${release_name}"

  curl \
    -X POST \
    --data-binary @"${documentation}" \
    -H 'Content-Type: application/octet-stream' \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "${upload_url}?name=$(date -I)-${release_name}-mvp-documentation.pdf"
}

publish "${GITHUB_WORKSPACE}"'/'"${RELEASE_NAME}".pdf
