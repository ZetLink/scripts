#!/bin/bash

CLANG_DIR="./clang"
TAR_URL="https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/main/clang-r536225.tar.gz"  # AOSP Clang19
TAR_NAME="clang-r536225.tar.gz"

# Verificar si existe la carpeta clang
if [ -d "$CLANG_DIR" ]; then
    echo "✅ La carpeta 'clang' ya existe. No se requiere descarga."
else
    echo "📁 La carpeta 'clang' no existe. Creando y descargando archivo..."

    # Crear carpeta clang
    mkdir -p "$CLANG_DIR"

    # Descargar el archivo tar.gz
    wget -O "$TAR_NAME" "$TAR_URL"

    # Verificar si la descarga fue exitosa
    if [ $? -eq 0 ]; then
        echo "📦 Descarga completada. Descomprimiendo..."

        # Descomprimir en la carpeta clang
        tar -xzf "$TAR_NAME" -C "$CLANG_DIR"

        echo "✅ Archivo descomprimido correctamente en ./clang."

        # Opcional: eliminar el archivo descargado
        rm "$TAR_NAME"
    else
        echo "❌ Error al descargar el archivo."
    fi
fi
