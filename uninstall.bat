@echo off
echo Menghapus instalasi Bejana...

set TARGET_DIR=%USERPROFILE%\.bejana

if exist %TARGET_DIR% (
    rmdir /S /Q %TARGET_DIR%
    echo Folder %TARGET_DIR% dihapus
) else (
    echo Folder %TARGET_DIR% tidak ditemukan
)

echo Jika PATH sistem diubah secara manual, hapus entry tersebut dari Environment Variables.
echo Bejana berhasil dihapus
