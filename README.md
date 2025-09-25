# 🛒 Flutter E-Commerce App

Une application e-commerce complète développée avec Flutter, Firebase et une architecture MVVM/Clean.

Disponible sur :

```bash
https://web-six-flax.vercel.app
```

Lancer le projet localement :

```bash
flutter run -d chrome --hot
```

## 🚀 Fonctionnalités

### ✅ Authentification

-   **Connexion/Inscription** avec email et mot de passe ou Google
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
-   **Avatar personnalisé** changement de photo de profil
-   **Date d'inscription** affichée
-   **Gestion du compte** et déconnexion

### 🧭 Navigation

-   **Drawer de navigation** avec menu complet
-   **Bottom navigation** pour les sections principales
-   **Navigation fluide** entre toutes les pages
-   **Badge de notification** pour le nombre d'articles dans le panier

## 🏗️ Architecture

### Structure MVVM/Clean Architecture

L'application suit une architecture **Clean Architecture** avec **MVVM** pour une séparation claire des responsabilités :

```
lib/
├── core/                           # Configuration de base
│   ├── providers/                  # Providers centraux (exports)
│   ├── router/                     # Navigation avec go_router
│   ├── theme/                      # Thème et design system
│   └── pages/                      # Pages de base (splash)
├── features/                       # Fonctionnalités métier
│   ├── auth/                       # Authentification
│   │   ├── domain/                 # Couche métier
│   │   │   ├── entities/           # Entités métier (UserEntity)
│   │   │   ├── repositories/       # Interfaces de repositories
│   │   │   └── usecases/           # Cas d'usage métier
│   │   ├── data/                   # Couche données
│   │   │   ├── models/             # Modèles de sérialisation
│   │   │   ├── datasources/        # Sources de données (Firebase)
│   │   │   └── repositories/       # Implémentations des repositories
│   │   └── presentation/           # Couche présentation
│   │       ├── pages/              # Pages UI
│   │       └── providers/          # ViewModels (Riverpod)
│   ├── catalog/                    # Catalogue de produits
│   │   ├── domain/                 # ProductEntity, ProductRepository, UseCases
│   │   ├── data/                   # ProductModel, Firestore, RepositoryImpl
│   │   └── presentation/           # CatalogPage, ProductProviders
│   ├── cart/                       # Panier d'achat
│   │   ├── domain/                 # CartItemEntity, CartRepository, UseCases
│   │   ├── data/                   # CartItemModel, SharedPreferences, RepositoryImpl
│   │   └── presentation/           # CartPage, CartProviders
│   ├── orders/                     # Gestion des commandes
│   │   ├── domain/                 # OrderEntity, OrderRepository, UseCases
│   │   ├── data/                   # OrderModel, Firestore, RepositoryImpl
│   │   └── presentation/           # OrdersPage, OrderProviders
│   └── profile/                    # Profil utilisateur
│       └── presentation/           # ProfilePage
└── shared/                         # Composants partagés
    └── widgets/                    # Widgets réutilisables
        ├── app_drawer.dart         # Drawer de navigation
        ├── product_card.dart       # Carte produit
        └── pwa_install_button.dart # Bouton d'installation PWA
```

### Couches de l'Architecture

#### 🎯 **Domain Layer** (Logique Métier)

-   **Entities** : Objets métier purs (UserEntity, ProductEntity, CartItemEntity, OrderEntity)
-   **Repository Interfaces** : Contrats pour l'accès aux données
-   **Use Cases** : Logique métier spécifique (SignInUseCase, GetProductsUseCase, AddToCartUseCase)

#### 💾 **Data Layer** (Accès aux Données)

-   **Models** : Objets de sérialisation/désérialisation (UserModel, ProductModel)
-   **Data Sources** : Interfaces avec les sources externes (Firebase, SharedPreferences)
-   **Repository Implementations** : Implémentations concrètes des repositories

#### 🎨 **Presentation Layer** (Interface Utilisateur)

-   **Pages** : Écrans de l'application (LoginPage, CatalogPage, CartPage)
-   **Providers** : ViewModels avec Riverpod pour la gestion d'état
-   **Widgets** : Composants UI réutilisables

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

#### Architecture Patterns

-   **Clean Architecture** - Séparation en couches (Domain, Data, Presentation)
-   **MVVM (Model-View-ViewModel)** - Séparation des responsabilités UI
-   **Repository Pattern** - Abstraction de l'accès aux données
-   **Use Case Pattern** - Encapsulation de la logique métier
-   **Dependency Injection** - Avec Riverpod pour l'injection de dépendances
-   **Single Responsibility Principle** - Chaque classe a une responsabilité unique

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

#### **Domain Layer**

-   **Entities** : Tests des objets métier (UserEntity, ProductEntity, CartItemEntity, OrderEntity)
-   **Use Cases** : Tests de la logique métier (SignInUseCase, GetProductsUseCase, AddToCartUseCase)
-   **Repository Interfaces** : Tests des contrats

#### **Data Layer**

-   **Models** : Tests de sérialisation/désérialisation (UserModel, ProductModel)
-   **Data Sources** : Tests des interactions avec Firebase et SharedPreferences
-   **Repository Implementations** : Tests des implémentations concrètes

### Tests Widget

-   **Pages** : Tests des écrans principaux (LoginPage, CatalogPage, CartPage)
-   **Widgets** : Tests des composants réutilisables (ProductCard, AppDrawer)
-   **Navigation** : Tests du routing avec go_router
-   **Providers** : Tests de la gestion d'état avec Riverpod

### Couverture

-   **Objectif** : ≥ 50% de couverture de code
-   **Outils** : Flutter Test + Coverage
-   **Structure** : Tests organisés par couche (domain, data, presentation)

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

-   **Riverpod** pour la réactivité et l'injection de dépendances
-   **StreamProvider** pour les données temps réel (Firestore)
-   **FutureProvider** pour les opérations asynchrones (Use Cases)
-   **Provider** pour l'injection de dépendances (Repositories, Data Sources)
-   **StateNotifier** pour la logique complexe (si nécessaire)
-   **Architecture réactive** : Les ViewModels (Providers) écoutent les Use Cases

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
