# 🚀 Tests de Charge JMeter - Flutter E-Commerce

Ce dossier contient la configuration complète des tests de charge pour l'application Flutter E-Commerce utilisant Apache JMeter.

## 📋 Prérequis

### Installation de JMeter

**macOS (Homebrew)**

```bash
brew install jmeter
```

**Ubuntu/Debian**

```bash
sudo apt-get update
sudo apt-get install jmeter
```

**Windows**

1. Télécharger depuis [Apache JMeter](https://jmeter.apache.org/download_jmeter.cgi)
2. Extraire l'archive
3. Ajouter `bin/` au PATH système

### Vérification de l'installation

```bash
jmeter --version
```

## 🎯 Scénarios de Test

Le plan de test couvre les parcours utilisateur principaux :

1. **Page d'accueil** (`/`) - Point d'entrée de l'application
2. **Catalogue de produits** (`/catalog`) - Navigation dans les produits
3. **Détail produit** (`/product/:id`) - Consultation d'un produit spécifique
4. **Panier** (`/cart`) - Gestion du panier d'achat
5. **Page de connexion** (`/login`) - Authentification utilisateur

## 🚀 Exécution des Tests

### Exécution Simple

```bash
# Test par défaut (10 utilisateurs, 5 minutes, production)
./load-tests/run-load-test.sh

# Test personnalisé
./load-tests/run-load-test.sh production 20 600
```

### Paramètres Disponibles

```bash
./run-load-test.sh [environnement] [utilisateurs] [durée] [montée_en_charge]
```

-   **environnement** : `production`, `blue`, `green`, `local`
-   **utilisateurs** : Nombre d'utilisateurs simultanés (défaut: 10)
-   **durée** : Durée du test en secondes (défaut: 300)
-   **montée_en_charge** : Temps de montée en charge en secondes (défaut: 30)

### Environnements de Test

| Environnement | URL                                              | Usage                        |
| ------------- | ------------------------------------------------ | ---------------------------- |
| `production`  | https://flutter-app-ecom.web.app                 | Tests sur la production      |
| `blue`        | https://flutter-app-ecom--blue-loai3kdo.web.app  | Tests sur le channel Blue    |
| `green`       | https://flutter-app-ecom--green-hexbm263.web.app | Tests sur le channel Green   |
| `local`       | http://localhost:8000                            | Tests en développement local |

## 📊 Résultats et Rapports

### Structure des Résultats

```
load-tests/results/
├── load-test-production-20241226_143022.jtl    # Données brutes
├── html-report-production-20241226_143022/     # Rapport HTML
│   ├── index.html                              # Page principale
│   ├── content/                                # Graphiques et données
│   └── sbadmin2-1.0.7/                        # Assets du rapport
└── summary-report.jtl                          # Résumé global
```

### Consultation des Rapports

```bash
# Ouvrir le rapport HTML (macOS)
open load-tests/results/html-report-*/index.html

# Ouvrir le rapport HTML (Linux)
xdg-open load-tests/results/html-report-*/index.html
```

## 📈 Métriques Surveillées

### Métriques de Performance

-   **Temps de réponse** (moyen, médian, 90e percentile, 95e percentile)
-   **Débit** (requêtes/seconde)
-   **Taux d'erreur** (pourcentage d'échecs)
-   **Temps de connexion** et **latence**

### Métriques de Charge

-   **Utilisateurs actifs** simultanés
-   **Montée en charge** progressive
-   **Stabilité** sous charge constante
-   **Dégradation** des performances

## 🎛️ Configuration Avancée

### Personnalisation du Plan de Test

Modifier `flutter-ecom-load-test.jmx` pour :

-   Ajouter de nouveaux scénarios
-   Modifier les temps de pause (Think Time)
-   Ajuster les assertions de validation
-   Configurer des données de test dynamiques

### Optimisation JMeter

Le fichier `jmeter.properties` contient :

-   Configuration HTTP optimisée
-   Gestion des timeouts
-   Paramètres de mémoire
-   Configuration des rapports

### Variables d'Environnement

```bash
# Personnaliser via variables d'environnement
export JMETER_OPTS="-Xms2g -Xmx4g"
export BASE_URL="https://mon-environnement.com"
```

## 🔧 Exemples d'Utilisation

### Test de Montée en Charge

```bash
# 50 utilisateurs sur 10 minutes avec montée progressive
./run-load-test.sh production 50 600 120
```

### Test de Stress

```bash
# 100 utilisateurs sur 5 minutes avec montée rapide
./run-load-test.sh production 100 300 30
```

### Test de Stabilité

```bash
# 20 utilisateurs sur 30 minutes
./run-load-test.sh production 20 1800 60
```

### Test sur Environnement de Staging

```bash
# Test sur le channel Blue avant promotion
./run-load-test.sh blue 25 450 45
```

## 🚨 Bonnes Pratiques

### Avant les Tests

1. **Vérifier la disponibilité** de l'environnement cible
2. **Informer l'équipe** des tests de charge planifiés
3. **Surveiller les ressources** serveur pendant les tests
4. **Commencer petit** puis augmenter progressivement

### Pendant les Tests

1. **Surveiller les métriques** en temps réel
2. **Vérifier les logs** d'erreur
3. **Arrêter immédiatement** si problème critique
4. **Documenter** les observations

### Après les Tests

1. **Analyser les rapports** HTML générés
2. **Identifier les goulots** d'étranglement
3. **Comparer** avec les tests précédents
4. **Archiver les résultats** pour référence future

## 🎯 Objectifs de Performance

### Cibles Recommandées

-   **Temps de réponse moyen** : < 2 secondes
-   **95e percentile** : < 5 secondes
-   **Taux d'erreur** : < 1%
-   **Débit minimum** : 10 req/sec pour 10 utilisateurs

### Seuils d'Alerte

-   **Temps de réponse** > 5 secondes
-   **Taux d'erreur** > 5%
-   **Timeouts** fréquents
-   **Erreurs 5xx** du serveur

## 🔍 Dépannage

### Problèmes Courants

**JMeter ne démarre pas**

```bash
# Vérifier l'installation
which jmeter
jmeter --version

# Vérifier JAVA_HOME
echo $JAVA_HOME
```

**Erreurs de connexion**

-   Vérifier l'URL de base
-   Contrôler la connectivité réseau
-   Vérifier les certificats SSL

**Performances dégradées**

-   Augmenter la mémoire JMeter
-   Réduire le nombre d'utilisateurs
-   Vérifier les ressources système

**Rapports non générés**

-   Vérifier les permissions d'écriture
-   Contrôler l'espace disque disponible
-   Valider le format des fichiers JTL

## 📚 Ressources Utiles

-   [Documentation JMeter](https://jmeter.apache.org/usermanual/index.html)
-   [Best Practices JMeter](https://jmeter.apache.org/usermanual/best-practices.html)
-   [JMeter Performance Testing](https://jmeter.apache.org/usermanual/jmeter_distributed_testing_step_by_step.html)
