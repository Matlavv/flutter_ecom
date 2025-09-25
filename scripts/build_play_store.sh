#!/bin/bash

# Script pour construire l'AAB pour le Google Play Store
# Usage: ./scripts/build_play_store.sh

set -e

echo "🚀 Construction AAB pour Google Play Store avec Firebase..."

# Vérifier que Flutter est installé
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé ou pas dans le PATH"
    exit 1
fi

# Nettoyer le projet
echo "🧹 Nettoyage du projet..."
flutter clean
flutter pub get

# Vérifier la configuration Firebase
echo "🔥 Vérification de la configuration Firebase..."
if [ ! -f "android/app/google-services.json" ]; then
    echo "❌ Fichier google-services.json manquant dans android/app/"
    exit 1
fi

# Vérifier le package name dans google-services.json
PACKAGE_NAME=$(grep -o '"package_name": "[^"]*"' android/app/google-services.json | head -1 | cut -d'"' -f4)
echo "📱 Package name détecté : $PACKAGE_NAME"

if [ "$PACKAGE_NAME" != "com.matlav.flutter_ecom" ]; then
    echo "⚠️  ATTENTION: Le package name dans google-services.json ($PACKAGE_NAME)"
    echo "   ne correspond pas à celui dans build.gradle.kts (com.matlav.flutter_ecom)"
    echo "   Voulez-vous continuer ? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "❌ Build annulé. Mettez à jour votre configuration Firebase."
        exit 1
    fi
fi

echo "🔨 Construction de l'AAB (Android App Bundle)..."
flutter build appbundle --release --target-platform android-arm,android-arm64,android-x64

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ AAB construit avec succès !"
    echo "📱 Fichier AAB : build/app/outputs/bundle/release/app-release.aab"
    echo ""
    echo "📊 Informations du fichier :"
    ls -lh build/app/outputs/bundle/release/app-release.aab
    echo ""
    echo "🎯 Prochaines étapes pour Google Play Store :"
    echo "1. Allez sur https://play.google.com/console"
    echo "2. Créez une nouvelle application"
    echo "3. Uploadez le fichier app-release.aab"
    echo "4. Configurez votre fiche store (nom, description, captures d'écran)"
    echo "5. Définissez le prix et la distribution"
    echo "6. Soumettez pour révision"
    echo ""
    echo "💡 Conseil : Testez d'abord avec une version interne avant la publication"
else
    echo "❌ Échec de la construction de l'AAB"
    exit 1
fi
