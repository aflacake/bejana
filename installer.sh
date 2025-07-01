#!/bin/bash

echo "Menginstal Bejana..."

TARGET_DIR="$HOME/.bejana"
BIN_PATH="/usr/local/bin/bejana"

mkdir -p "$TARGET_DIR"

cp -r . "$TARGET_DIR"

echo "#!/bin/bash" > "$TARGET_DIR/bejana"
echo "ruby $TARGET_DIR/bejana.rb \"\$@\"" >> "$TARGET_DIR/bejana"
chmod +x "$TARGET_DIR/bejana"

if [ -L "$BIN_PATH" ]; then
  sudo rm "$BIN_PATH"
fi

sudo ln -s "$TARGET_DIR/bejana" "$BIN_PATH"

echo "Bejana berhasil terinstal!"
echo "Jalankan dengan perintah: bejana bantuan"
