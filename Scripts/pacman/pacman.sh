#!/bin/bash

PACKAGE_LIST="./packages.txt"  # Set the path to your text file.

if [ ! -f "$PACKAGE_LIST" ]; then
  touch "$PACKAGE_LIST"
fi

case $1 in
-S)
  # Install packages, and append only the top-level packages (no dependencies)
  shift  # Remove the -S flag from the argument list
  sudo pacman -S "$@"  # Run the actual pacman command

  # After installation, append the installed packages (ignoring dependencies) to the .txt file
  for pkg in "$@"; do
    # Check if the package is not already in the list
    if ! grep -qx "$pkg" "$PACKAGE_LIST"; then
      echo "$pkg" >> "$PACKAGE_LIST"
    fi
  done
  ;;
-Rns)
  # Remove packages, and also remove them from the text file
  shift  # Remove the -Rns flag from the argument list
  sudo pacman -Rns "$@"  # Run the actual pacman command

  # After removal, delete the removed packages from the .txt file
  for pkg in "$@"; do
    # Remove the package from the file
    sed -i "/^$pkg$/d" "$PACKAGE_LIST"
  done
  ;;
*)
  echo "Usage: pacman {-S|-Rns} <package_name>"
  exit 1
  ;;
esac
