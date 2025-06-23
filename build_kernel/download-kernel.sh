#!/bin/bash

REPO_URL="https://github.com/SM6225-Motorola/DanceKernel.git"
REPO_DIR="DanceKernel"
BUILD_SCRIPT_NAME="build_sm6225.sh"

# Verificar si la carpeta ya existe
if [ -d "$REPO_DIR" ]; then
    echo "✅ El directorio '$REPO_DIR' ya existe. No se clona nuevamente."
else
    echo "📁 Clonando repositorio desde: $REPO_URL"
    git clone "$REPO_URL" "$REPO_DIR" || {
        echo "❌ Error al clonar el repositorio."
        exit 1
    }
fi

# Verificar que el script de compilación existe en el mismo lugar que este
if [ ! -f "./$BUILD_SCRIPT_NAME" ]; then
    echo "❌ Script de compilación '$BUILD_SCRIPT_NAME' no encontrado en el directorio actual."
    exit 1
fi

# Copiar el script de compilación dentro del repositorio
echo "📦 Copiando script de compilación dentro de '$REPO_DIR'..."
cp "./$BUILD_SCRIPT_NAME" "$REPO_DIR/"

# Cambiar al directorio y ejecutar el script de compilación
cd "$REPO_DIR" || exit 1
echo "🚀 Ejecutando compilación..."
bash "./$BUILD_SCRIPT_NAME"

# Verificar y eliminar el archivo "Image" y cualquier archivo .zip en DanceKernel/AnyKernel3/
ANYKERNEL_DIR="$REPO_DIR/AnyKernel3"

if [ -d "$ANYKERNEL_DIR" ]; then
    echo "🔍 Verificando archivos en '$ANYKERNEL_DIR'..."
    if [ -f "$ANYKERNEL_DIR/Image" ]; then
        echo "🗑️ Eliminando archivo 'Image'..."
        rm "$ANYKERNEL_DIR/Image"
    fi

    if ls "$ANYKERNEL_DIR"/*.zip 1> /dev/null 2>&1; then
        echo "🗑️ Eliminando archivos .zip..."
        rm "$ANYKERNEL_DIR"/*.zip
    fi
else
    echo "❌ El directorio '$ANYKERNEL_DIR' no existe."
fi

# Ejecutar el script anykernel.sh
ANYKERNEL_SCRIPT="./anykernel.sh"
if [ -f "$ANYKERNEL_SCRIPT" ]; then
    echo "🚀 Ejecutando '$ANYKERNEL_SCRIPT'..."
    bash "$ANYKERNEL_SCRIPT"
else
    echo "❌ Script '$ANYKERNEL_SCRIPT' no encontrado."
    exit 1
fi