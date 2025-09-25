#!/bin/bash

# Script pour générer une clé de signature Android
# Usage: ./scripts/generate_keystore.sh

set -e

echo "🔐 Génération de la clé de signature Android..."

# Vérifier que keytool est disponible
if ! command -v keytool &> /dev/null; then
    echo "❌ keytool n'est pas installé. Installez Java JDK."
    exit 1
fi

# Paramètres de la clé
KEYSTORE_FILE="android/app/upload-keystore.jks"
KEY_ALIAS="upload"

echo "📝 Informations requises pour la clé de signature :"
echo "Vous allez être invité à saisir :"
echo "- Mot de passe du keystore (gardez-le précieusement !)"
echo "- Mot de passe de la clé (peut être le même)"
echo "- Vos informations personnelles/entreprise"

# Générer la clé
keytool -genkey -v -keystore $KEYSTORE_FILE -alias $KEY_ALIAS \
    -keyalg RSA -keysize 2048 -validity 10000

if [ $? -eq 0 ]; then
    echo "✅ Clé de signature générée avec succès !"
    echo "📁 Fichier : $KEYSTORE_FILE"
    echo ""
    echo "🔧 Maintenant, configurez android/key.properties avec :"
    echo "storePassword=VOTRE_MOT_DE_PASSE_KEYSTORE"
    echo "keyPassword=VOTRE_MOT_DE_PASSE_CLE"
    echo "keyAlias=$KEY_ALIAS"
    echo "storeFile=upload-keystore.jks"
    echo ""
    echo "⚠️  IMPORTANT : Sauvegardez ces informations en sécurité !"
    echo "   Sans elles, vous ne pourrez plus mettre à jour votre app sur le Play Store."
else
    echo "❌ Échec de la génération de la clé"
    exit 1
fi
