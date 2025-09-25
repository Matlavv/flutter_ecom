#!/bin/bash

# Script pour construire l'APK Android pour le Play Store
# Usage: ./scripts/build_android.sh

set -e

echo "🚀 Construction de l'APK Android pour le Play Store..."

# Vérifier que Flutter est installé
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé ou pas dans le PATH"
    exit 1
fi

# Nettoyer le projet
echo "🧹 Nettoyage du projet..."
flutter clean
flutter pub get

# Vérifier la configuration Android
echo "🔍 Vérification de la configuration Android..."
if [ ! -f "android/key.properties" ]; then
    echo "⚠️  Fichier key.properties manquant. Création d'un exemple..."
    echo "Vous devez configurer vos clés de signature dans android/key.properties"
    echo "Voir le fichier android/key.properties pour un exemple"
fi

# Construire l'APK
echo "🔨 Construction de l'APK de release..."
flutter build apk --release --target-platform android-arm,android-arm64,android-x64

if [ $? -eq 0 ]; then
    echo "✅ APK construit avec succès !"
    echo "📱 Fichier APK : build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "📋 Prochaines étapes pour le Play Store :"
    echo "1. Testez l'APK sur un appareil Android"
    echo "2. Créez un compte développeur Google Play (25$ unique)"
    echo "3. Uploadez l'APK sur la Google Play Console"
    echo "4. Configurez la fiche du store (description, captures d'écran, etc.)"
    echo "5. Soumettez pour révision"
else
    echo "❌ Échec de la construction de l'APK"
    exit 1
fi
