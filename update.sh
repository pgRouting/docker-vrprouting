#!/bin/bash
# Derived from https://github.com/docker-library/postgres/blob/master/update.sh
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */Dockerfile )
fi
versions=( "${versions[@]%/Dockerfile}" )

# sort version numbers with highest last
IFS=$'\n'; versions=( $(echo "${versions[*]}" | sort -V) ); unset IFS

defaultDebianSuite='bullseye-slim'
declare -A debianSuite=(
  # https://github.com/docker-library/postgres/issues/582
  [9.6]='bullseye-slim'
  [10]='bullseye-slim'
  [11]='bullseye-slim'
  [12]='bullseye-slim'
  [13]='bullseye-slim'
  [14]='bullseye-slim'
  [15]='bullseye-slim'
)

defaultPostgisDebPkgNameVersionSuffix='3'
declare -A postgisDebPkgNameVersionSuffixes=(
  [2.5]='2.5'
  [3.0]='3'
  [3.1]='3'
  [3.2]='3'
  [3.3]='3'
)

for version in "${versions[@]}"; do
  IFS=- read postgresVersion postgisVersion pgroutingVersion vrproutingVersion <<< "$version"

  echo " "
  echo "---- generate Dockerfile for $version ----"
  echo "postgresVersion=$postgresVersion"
  echo "postgisVersion=$postgisVersion"
  echo "pgroutingVersion=$pgroutingVersion"
  echo "vrproutingVersion=$vrproutingVersion"

  if [ "2.5" == "$postgisVersion" ]; then
    # posgis 2.5 only in the stretch ; no bullseye version
    tag='stretch-slim'
  else
    tag="${debianSuite[$postgresVersion]:-$defaultDebianSuite}"
  fi
  suite="${tag%%-slim}"

  if [ "$suite" == "bullseye" ]; then
    boostVersion="1.74.0"
  elif [ "$suite" == "buster" ]; then
    boostVersion="1.67.0"
  elif [ "$suite" == "stretch" ]; then
    boostVersion="1.62.0"
  else
    echo "Unknown debian version; stop"
    exit 1
  fi

  if [ "$vrproutingVersion" == "0.2.0" ]; then
    vroomVersion="1.10.0"
  elif [ "$vrproutingVersion" == "0.3.0" ] || [ "$vrproutingVersion" == "main" ]; then
    vroomVersion="1.11.0"
  elif [ "$vrproutingVersion" == "0.4.0" ] || [ "$vrproutingVersion" == "develop" ]; then
    vroomVersion="1.12.0"
  fi

  srcVersion="${vrproutingVersion}"
  if [ "$vrproutingVersion" == "develop" ] || [ "$vrproutingVersion" == "main" ]; then
    srcSha256=""
    vrproutingGitHash="$(git ls-remote https://github.com/pgrouting/vrprouting.git heads/${vrproutingVersion} | awk '{ print $1}')"
  else
    srcSha256="$(curl -sSL "https://github.com/pgRouting/vrprouting/archive/v${srcVersion}.tar.gz" | sha256sum | awk '{ print $1 }')"
    vrproutingGitHash=""
  fi
  (
      set -x
      cp -p -r Dockerfile.template README.md.template docker-compose.yml.template "$version/"
      if [ "$vrproutingVersion" == "develop" ] || [ "$vrproutingVersion" == "main" ]; then
        cp -p Dockerfile.develop.template "$version/Dockerfile.template"
      fi
      mv "$version/Dockerfile.template" "$version/Dockerfile"
      sed -i 's/%%PG_MAJOR%%/'"$postgresVersion"'/g; s/%%POSTGIS_VERSION%%/'"$postgisVersion"'/g; s/%%PGROUTING_VERSION%%/'"$pgroutingVersion"'/g; s/%%VRPROUTING_VERSION%%/'"$vrproutingVersion"'/g; s/%%VRPROUTING_SHA256%%/'"$srcSha256"'/g; s/%%VRPROUTING_GIT_HASH%%/'"$vrproutingGitHash"'/g; s/%%BOOST_VERSION%%/'"$boostVersion"'/g; s/%%VROOM_VERSION%%/'"$vroomVersion"'/g; ' "$version/Dockerfile"
      mv "$version/README.md.template" "$version/README.md"
      sed -i 's/%%PG_MAJOR%%/'"$postgresVersion"'/g; s/%%POSTGIS_VERSION%%/'"$postgisVersion"'/g; s/%%PGROUTING_VERSION%%/'"$pgroutingVersion"'/g; s/%%VRPROUTING_VERSION%%/'"$vrproutingVersion"'/g;' "$version/README.md"
      mv "$version/docker-compose.yml.template" "$version/docker-compose.yml"
      sed -i 's/%%PG_MAJOR%%/'"$postgresVersion"'/g; s/%%POSTGIS_VERSION%%/'"$postgisVersion"'/g; s/%%PGROUTING_VERSION%%/'"$pgroutingVersion"'/g; s/%%VRPROUTING_VERSION%%/'"$vrproutingVersion"'/g;' "$version/docker-compose.yml"
  )
done

