#!/bin/bash

# Script d'exécution des tests de charge JMeter
# Usage: ./run-load-test.sh [environment] [users] [duration]

set -e

# Configuration par défaut
DEFAULT_ENV="production"
DEFAULT_USERS=10
DEFAULT_DURATION=300
DEFAULT_RAMP_UP=30

# Paramètres
ENV=${1:-$DEFAULT_ENV}
USERS=${2:-$DEFAULT_USERS}
DURATION=${3:-$DEFAULT_DURATION}
RAMP_UP=${4:-$DEFAULT_RAMP_UP}

# URLs selon l'environnement
case $ENV in
  "production"|"prod")
    BASE_URL="https://flutter-app-ecom.web.app"
    ;;
  "blue")
    BASE_URL="https://flutter-app-ecom--blue-loai3kdo.web.app"
    ;;
  "green")
    BASE_URL="https://flutter-app-ecom--green-hexbm263.web.app"
    ;;
  "local")
    BASE_URL="http://localhost:8000"
    ;;
  *)
    echo "❌ Environnement non reconnu: $ENV"
    echo "Environnements disponibles: production, blue, green, local"
    exit 1
    ;;
esac

# Vérification de JMeter
if ! command -v jmeter &> /dev/null; then
    echo "❌ JMeter n'est pas installé ou n'est pas dans le PATH"
    echo "Installation:"
    echo "  - macOS: brew install jmeter"
    echo "  - Ubuntu: sudo apt-get install jmeter"
    echo "  - Windows: Télécharger depuis https://jmeter.apache.org/"
    exit 1
fi

# Création du dossier de résultats
RESULTS_DIR="load-tests/results"
mkdir -p "$RESULTS_DIR"

# Timestamp pour les fichiers de résultats
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULTS_FILE="$RESULTS_DIR/load-test-$ENV-$TIMESTAMP.jtl"
REPORT_DIR="$RESULTS_DIR/html-report-$ENV-$TIMESTAMP"

echo "🚀 Démarrage des tests de charge"
echo "=================================="
echo "📊 Environnement: $ENV"
echo "🌐 URL de base: $BASE_URL"
echo "👥 Utilisateurs: $USERS"
echo "⏱️  Durée: ${DURATION}s"
echo "📈 Montée en charge: ${RAMP_UP}s"
echo "📁 Résultats: $RESULTS_FILE"
echo "📊 Rapport HTML: $REPORT_DIR"
echo ""

# Exécution du test
echo "🔄 Exécution en cours..."
jmeter -n -t load-tests/flutter-ecom-load-test.jmx \
  -JBASE_URL="$BASE_URL" \
  -JUSERS="$USERS" \
  -JDURATION="$DURATION" \
  -JRAMP_UP="$RAMP_UP" \
  -l "$RESULTS_FILE" \
  -e -o "$REPORT_DIR"

# Vérification du succès
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Tests de charge terminés avec succès!"
    echo ""
    echo "📊 Résultats disponibles:"
    echo "  - Fichier JTL: $RESULTS_FILE"
    echo "  - Rapport HTML: $REPORT_DIR/index.html"
    echo ""
    echo "🌐 Pour voir le rapport HTML:"
    echo "  open $REPORT_DIR/index.html"
    echo ""
    
    # Affichage d'un résumé rapide
    if [ -f "$RESULTS_FILE" ]; then
        echo "📈 Résumé rapide:"
        echo "=================="
        TOTAL_SAMPLES=$(tail -n +2 "$RESULTS_FILE" | wc -l)
        SUCCESS_SAMPLES=$(tail -n +2 "$RESULTS_FILE" | awk -F',' '$8=="true"' | wc -l)
        ERROR_SAMPLES=$(tail -n +2 "$RESULTS_FILE" | awk -F',' '$8=="false"' | wc -l)
        
        if [ "$TOTAL_SAMPLES" -gt 0 ]; then
            SUCCESS_RATE=$(echo "scale=2; $SUCCESS_SAMPLES * 100 / $TOTAL_SAMPLES" | bc -l)
            echo "📊 Total des requêtes: $TOTAL_SAMPLES"
            echo "✅ Succès: $SUCCESS_SAMPLES ($SUCCESS_RATE%)"
            echo "❌ Erreurs: $ERROR_SAMPLES"
            
            # Temps de réponse moyen
            AVG_RESPONSE_TIME=$(tail -n +2 "$RESULTS_FILE" | awk -F',' '{sum+=$2; count++} END {if(count>0) print int(sum/count); else print 0}')
            echo "⏱️  Temps de réponse moyen: ${AVG_RESPONSE_TIME}ms"
        fi
    fi
else
    echo ""
    echo "❌ Erreur lors de l'exécution des tests de charge"
    exit 1
fi
