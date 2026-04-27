#!/bin/bash

sanitize() {
  shopt -s extglob

  filename=${1##*/}
  directory=${1%/*}

  name_clean=$(
  printf '%s' "$filename" |
  awk '
  BEGIN {
    IGNORECASE = 1

    reserved["nul"]; reserved["prn"]; reserved["con"]; reserved["aux"]
    for (i=0;i<=9;i++) { reserved["com" i]; reserved["lpt" i] }
    reserved["com¹"]; reserved["com²"]; reserved["com³"]
    reserved["lpt¹"]; reserved["lpt²"]; reserved["lpt³"]
  }
  {
    # trim
    gsub(/^[[:space:]]+|[[:space:]]+$/, "")

    # espaces autour /
    gsub(/[[:space:]]*\/[[:space:]]*/, "/")

    # espaces multiples
    gsub(/[[:space:]]+/, " ")

    # caractères interdits + contrôle
    gsub(/['"'"'\\/:\*\?\"<>\|\001-\037\177]/, "_")

    # suppression points finaux
    sub(/\.+$/, "")

    # nettoyage dernier point
    if (match($0, /[[:space:]]*\.[[:space:]]*([^.]+)$/)) {
      ext = substr($0, RSTART, RLENGTH)
      sub(/^[[:space:]]*\.[[:space:]]*/, ".", ext)
      $0 = substr($0, 1, RSTART-1) ext
    }

    # uniquement des points → vide
    if ($0 ~ /^\.*$/) $0=""

    # basename sans extension
    base = $0
    sub(/\..*$/, "", base)

    if (tolower(base) in reserved) {
      $0 = base "_" substr($0, length(base)+1)
    }

    # vide → NONAME
    if ($0 ~ /^[[:space:]]*$/) $0="NONAME"

    print
  }'
)

  if test "$filename" != "$name_clean"; then
    suffix=0
    final_name="$directory/$name_clean"

    name="${name_clean##*/}"
    base="$name"
    ext=""

    if [[ "$name" == .* ]]; then
      base="${name:1}"
      if [[ "$base" == *.* ]]; then
        ext="${base##*.}"
        base="${base%.*}"
      fi
    else
      if [[ "$name" == *.* ]]; then
        ext="${name##*.}"
        base="${name%.*}"
      fi
    fi

    while test -e "$final_name"; do
      final_name="${directory}/${base}_${suffix}${ext}"
      ((suffix++))
    done

    echo " => '$1' serait renommé en '$final_name'"
    #mv -v "$1" "$final_name" >> /tmp/sanitize.log
  fi
}
export -f sanitize

sanitize_dir() {
  Debut=$(date +%s);
  find "$1" -depth -exec bash -c 'sanitize "$0"' {} \;
  echo "le tout en $(($(date +%s)-Debut)) secondes."
}

sanitize_dir "$PWD"#!/bin/bash

sanitize() {
  shopt -s extglob

  filename=${1##*/}
  directory=${1%/*}

  name_clean=$(
  printf '%s' "$filename" |
  awk '
  BEGIN {
    IGNORECASE = 1

    reserved["nul"]; reserved["prn"]; reserved["con"]; reserved["aux"]
    for (i=0;i<=9;i++) { reserved["com" i]; reserved["lpt" i] }
    reserved["com¹"]; reserved["com²"]; reserved["com³"]
    reserved["lpt¹"]; reserved["lpt²"]; reserved["lpt³"]
  }
  {
    # trim
    gsub(/^[[:space:]]+|[[:space:]]+$/, "")

    # espaces autour /
    gsub(/[[:space:]]*\/[[:space:]]*/, "/")

    # espaces multiples
    gsub(/[[:space:]]+/, " ")

    # caractères interdits + contrôle
    gsub(/['\''\\/:\*\?\"<>\|\001-\037\177]/, "_")

    # suppression points finaux
    sub(/\.+$/, "")

    # nettoyage dernier point (backreference awk OK)
    if (match($0, /[[:space:]]*\.[[:space:]]*([^.]+)$/)) {
      ext = substr($0, RSTART, RLENGTH)
      sub(/^[[:space:]]*\.[[:space:]]*/, ".", ext)
      $0 = substr($0, 1, RSTART-1) ext
    }

    # uniquement des points → vide
    if ($0 ~ /^\.*$/) $0=""

    # basename sans extension
    base = $0
    sub(/\..*$/, "", base)

    if (tolower(base) in reserved) {
      $0 = base "_" substr($0, length(base)+1)
    }

    # vide → NONAME
    if ($0 ~ /^[[:space:]]*$/) $0="NONAME"

    print
  }'
)

  if test "$filename" != "$name_clean"; then
    suffix=0
    final_name="$directory/$name_clean"

    name="${name_clean##*/}"
    base="$name"
    ext=""

    if [[ "$name" == .* ]]; then
      base="${name:1}"
      if [[ "$base" == *.* ]]; then
        ext="${base##*.}"
        base="${base%.*}"
      fi
    else
      if [[ "$name" == *.* ]]; then
        ext="${name##*.}"
        base="${name%.*}"
      fi
    fi

    while test -e "$final_name"; do
      final_name="${directory}/${base}_${suffix}${ext}"
      ((suffix++))
    done

    echo " => '$1' serait renommé en '$final_name'"
    #mv -v "$1" "$final_name" >> /tmp/sanitize.log
  fi
}
export -f sanitize

sanitize_dir() {
  Debut=$(date +%s);
  find "$1" -depth -exec bash -c 'sanitize "$0"' {} \;
  echo "le tout en $(($(date +%s)-Debut)) secondes."
}

sanitize_dir "$PWD"
