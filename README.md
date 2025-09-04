# 🛒 Flutter E-Commerce App

Une application e-commerce complète développée avec Flutter, Firebase et une architecture MVVM/Clean.

## 🚀 Fonctionnalités

### ✅ Authentification

-   **Connexion/Inscription** avec email et mot de passe
-   **Gestion des sessions** avec Firebase Auth
-   **Protection des routes** - accès restreint aux utilisateurs connectés
-   **Déconnexion sécurisée** avec confirmation

### 🛍️ Catalogue & Produits

-   **Parcours du catalogue** avec liste de produits
-   **Recherche de produits** en temps réel
-   **Filtrage par catégorie**
-   **Détails produit** avec images, prix et description
-   **Création de produits** (pour les utilisateurs connectés)

### 🛒 Panier & Commandes

-   **Ajout au panier** avec gestion des quantités
-   **Modification des quantités** directement dans le panier
-   **Suppression d'articles** du panier
-   **Calcul automatique** du total
-   **Checkout simplifié** avec simulation de paiement
-   **Création de commandes** persistées dans Firestore
-   **Historique des commandes** avec statuts

### 👤 Profil Utilisateur

-   **Page de profil** avec informations utilisateur
-   **Avatar personnalisé** avec initiales
-   **Date d'inscription** affichée
-   **Gestion du compte** et déconnexion

### 🧭 Navigation

-   **Drawer de navigation** avec menu complet
-   **Bottom navigation** pour les sections principales
-   **Navigation fluide** entre toutes les pages
-   **Badge de notification** pour le nombre d'articles dans le panier

## 🏗️ Architecture

### Structure MVVM/Clean

```
lib/
├── core/                    # Configuration de base
│   ├── router/             # Navigation avec go_router
│   └── pages/              # Pages de base (splash)
├── features/               # Fonctionnalités métier
│   ├── auth/              # Authentification
│   ├── catalog/           # Catalogue de produits
│   ├── cart/              # Panier d'achat
│   ├── orders/            # Gestion des commandes
│   └── profile/           # Profil utilisateur
└── shared/                # Composants partagés
    ├── models/            # Modèles de données
    ├── services/          # Services métier
    ├── providers/         # Gestion d'état (Riverpod)
    └── widgets/           # Widgets réutilisables
```

### Technologies Utilisées

#### Frontend

-   **Flutter** - Framework de développement mobile
-   **Riverpod** - Gestion d'état réactive
-   **go_router** - Navigation déclarative
-   **Material Design 3** - Design system moderne

#### Backend & Services

-   **Firebase Auth** - Authentification utilisateur
-   **Cloud Firestore** - Base de données NoSQL
-   **Firebase Storage** - Stockage d'images
-   **SharedPreferences** - Stockage local du panier

#### Firestore rules

```bash
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // Règles pour les utilisateurs
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Règles pour les produits - lecture pour tous, écriture pour les utilisateurs connectés
    match /products/{productId} {
      allow read: if true; // Tout le monde peut lire les produits
      allow write: if request.auth != null; // Seuls les utilisateurs connectés peuvent créer/modifier
    }

    // Règles pour les commandes
    match /orders/{orderId} {
      allow read, write: if request.auth != null &&
        (resource.data.userId == request.auth.uid ||
         request.auth.uid == resource.data.userId);
    }

    // Règles pour les paniers
    match /carts/{cartId} {
      allow read, write: if request.auth != null &&
        (resource.data.userId == request.auth.uid ||
         request.auth.uid == resource.data.userId);
    }
  }
}
```

#### Architecture Patterns

-   **MVVM (Model-View-ViewModel)** - Séparation des responsabilités
-   **Repository Pattern** - Abstraction de la couche données
-   **Provider Pattern** - Injection de dépendances
-   **Clean Architecture** - Structure modulaire et testable

## 🔧 Configuration

### Prérequis

-   Flutter SDK (3.0+)
-   Dart SDK (3.0+)
-   Firebase CLI
-   FlutterFire CLI

### Installation

```bash
# Cloner le projet
git clone <repository-url>
cd flutter_ecom

# Installer les dépendances
flutter pub get

# Configurer Firebase
flutterfire configure

# Lancer l'application
flutter run -d chrome
```

## 🧪 Tests

### Test PWA (Progressive Web App)

1. **Build web** : `flutter build web --release`
2. **Serveur local** : `cd build/web && python3 -m http.server 8000`
3. **Ouvrir** : `http://localhost:8000` dans Chrome/Edge
4. **Vérifier PWA** : DevTools > Application > Manifest (score 90-100%)
5. **Installer** : Icône "Installer" dans la barre d'adresse ou menu "Ajouter à l'écran d'accueil"

### Test Android

1. **Émulateur** : `flutter emulators` puis `flutter emulators --launch <emulator_id>`
2. **Appareil physique** : Activer le mode développeur et débogage USB
3. **Lancer** : `flutter run -d android` ou `flutter run -d <device_id>`
4. **Build APK** : `flutter build apk --release` (fichier dans `build/app/outputs/flutter-apk/`)

### Variables d'environnement

Le projet utilise des variables d'environnement sécurisées via `.env` :

```bash
# Copier le fichier template
cp .env.example .env

# Éditer avec vos vraies valeurs Firebase
nano .env
```

**⚠️ Important** : Le fichier `.env` contient vos clés secrètes et ne doit JAMAIS être commité !

## 📱 Plateformes Supportées

-   ✅ **Web** - PWA ready
-   ✅ **Android** - APK/AAB
-   ✅ **iOS** - App Store ready
-   ✅ **macOS** - Desktop app

## 🔐 Sécurité

### Règles Firestore

```javascript
// Utilisateurs - accès personnel uniquement
match /users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}

// Produits - lecture publique, écriture authentifiée
match /products/{productId} {
  allow read: if true;
  allow write: if request.auth != null;
}

// Commandes - accès personnel uniquement
match /orders/{orderId} {
  allow read, write: if request.auth != null &&
    resource.data.userId == request.auth.uid;
}
```

## 🧪 Tests

### Tests Unitaires

-   Services métier (Auth, Cart, Order, Product)
-   Modèles de données
-   Logique de calcul (totaux, quantités)

### Tests Widget

-   Composants UI principaux
-   Navigation et routing
-   Gestion d'état

### Couverture

-   **Objectif** : ≥ 50% de couverture de code
-   **Outils** : Flutter Test + Coverage

## 🚀 Déploiement

### Web (Firebase Hosting)

```bash
# Build pour production
flutter build web

# Déployer
firebase deploy --only hosting
```

### Android (Play Store)

```bash
# Build AAB
flutter build appbundle --release

# Build APK
flutter build apk --release
```

## 📊 Fonctionnalités Techniques

### Gestion d'État

-   **Riverpod** pour la réactivité
-   **StreamProvider** pour les données temps réel
-   **FutureProvider** pour les opérations asynchrones
-   **StateNotifier** pour la logique complexe

### Persistance

-   **Firestore** pour les données utilisateur et commandes
-   **SharedPreferences** pour le panier local
-   **Cache intelligent** pour les performances

### Navigation

-   **go_router** avec guards d'authentification
-   **Routes protégées** automatiquement
-   **Navigation contextuelle** selon l'état utilisateur

## 🎨 Design System

### Thème

-   **Material Design 3** par défaut
-   **Couleurs cohérentes** avec le branding
-   **Typography** responsive
-   **Dark mode** ready

### Composants

-   **Cards** pour les produits et informations
-   **ListTiles** pour les menus et actions
-   **Dialogs** pour les confirmations
-   **SnackBars** pour les notifications

### CI/CD

-   **GitHub Actions** pour l'automatisation
-   **Tests automatiques** à chaque push
-   **Build automatique** pour le déploiement
-   **Linting** et formatage automatique
