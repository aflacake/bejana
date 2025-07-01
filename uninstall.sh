#!/bin/bash

echo "Menghapus instalasi Bejana..."

TARGET_DIR="$HOME/.bejana"
BIN_PATH="/usr/local/bin/bejana"

if [ -L "$BIN_PATH" ]; then
  sudo rm "$BIN_PATH"
  echo "Symlink $BIN_PATH dihapus"
fi

if [ -d "$TARGET_DIR" ]; then
  rm -rf "$TARGET_DIR"
  echo "Direktori $TARGET_DIR dihapus"
fi

echo "Bejana berhasil dihapus dari sistem"
