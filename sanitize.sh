#!/bin/bash

sanitize() {
  shopt -s extglob;

  filename=$(basename "$1")
  directory=$(dirname "$1")

  name_clean=$(sed -E '
  s/^[[:space:]]*//                           # Suppression des espaces en début de ligne
  s/[[:space:]]*$//                           # Suppression des espaces en fin de ligne
  s/[[:space:]]*\/[[:space:]]*/\//g           # Remplace toute séquence d espaces autour d une barre oblique (/) par une seule barre oblique
  s/[[:space:]]+/ /g                          # Remplacement des espaces multiples par un seul espace
  s/['\''\\/:\*\?\"<>\|\x01-\x1F\x7F]/_/g     # Remplacement des apostrophes et des caractères interdits par des underscores
  s/\.+$//                                    # Suppression des points en fin de nom
  s/[[:space:]]*\.[[:space:]]*([^.]+)$/.\1/   # Suppression des espaces juste avant et / ou apres le dernier point
  s/^\.*$//                                   # Suppression des noms ne contenant que des points
  s/^(nul|prn|con|lpt[0-9]|com[0-9]|aux|COM¹|COM²|COM³|LPT¹|LPT²|LPT³)(\.|$)/\1_\2/I  # si nom exclu on ajoute le suffixe _
  s/^[[:space:]]*$/NONAME/' <<< "$filename")  # si espace ou vide => NONAME
  
  if test "$filename" != "$name_clean"; then
    suffix=0
    final_name="$directory/$name_clean"
    
    # eviter les doublons et renommer correctement quand meme :
    while test -e "$final_name"; do # Tant que le fichier cible existe déjà
      name="${name_clean##*/}"   # enlève le chemin
      base="$name"
      ext=""

      if [[ "$name" == .* ]]; then
        base="${name:1}"   # enlève le point initial
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
      # Permet de renommer le tout ( les 4 possibilités ) , car $ext et $base sont definies au départ
      final_name="${directory}/${base}_${suffix}${ext}"

      ((suffix++))
    done
    
    echo " => '$1' serait renommé en '$final_name'"
    #mv -v "$1"  "$final_name"
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
  shopt -s extglob;

  filename=$(basename "$1")
  directory=$(dirname "$1")

  name_clean=$(sed -E '
  s/^[[:space:]]*//                           # Suppression des espaces en début de ligne
  s/[[:space:]]*$//                           # Suppression des espaces en fin de ligne
  s/[[:space:]]*\/[[:space:]]*/\//g           # Remplace toute séquence d espaces autour d une barre oblique (/) par une seule barre oblique
  s/[[:space:]]+/ /g                          # Remplacement des espaces multiples par un seul espace
  s/['\''\\/:\*\?\"<>\|\x01-\x1F\x7F]/_/g     # Remplacement des apostrophes et des caractères interdits par des underscores
  s/\.+$//                                    # Suppression des points en fin de nom
  s/[[:space:]]*\.[[:space:]]*([^.]+)$/.\1/   # Suppression des espaces juste avant et / ou apres le dernier point
  s/^\.*$//                                   # Suppression des noms ne contenant que des points
  s/^(nul|prn|con|lpt[0-9]|com[0-9]|aux|COM¹|COM²|COM³|LPT¹|LPT²|LPT³)(\.|$)/\1_\2/I  # si nom exclu on ajoute le suffixe _
  s/^[[:space:]]*$/NONAME/' <<< "$filename")  # si espace ou vide => NONAME
  
  if test "$filename" != "$name_clean"; then
    suffix=0
    final_name="$directory/$name_clean"
    
    # eviter les doublons et renommer correctement quand meme :
    while test -e "$final_name"; do # Tant que le fichier cible existe déjà
      name="${name_clean##*/}"   # enlève le chemin
      base="$name"
      ext=""

      if [[ "$name" == .* ]]; then
        base="${name:1}"   # enlève le point initial
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
      # Permet de renommer le tout ( les 4 possibilités ) , car $ext est definie a vide au départ
      final_name="${directory}/${base}_${suffix}${ext}"

      ((suffix++))
    done
    
    echo " => '$1' serait renommé en '$final_name'"
    #mv -v "$1"  "$final_name"
  fi
}

export -f sanitize

sanitize_dir() {
  Debut=$(date +%s);
  find "$1" -depth -exec bash -c 'sanitize "$0"' {} \;
  echo "le tout en $(($(date +%s)-Debut)) secondes."
}

sanitize_dir "$PWD"
