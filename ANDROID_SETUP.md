# 🤖 Configuration Android SDK pour Flutter

## 🚀 Installation Android Studio (Recommandée)

### 1. Télécharger Android Studio
1. Allez sur [Android Studio](https://developer.android.com/studio)
2. Téléchargez la version pour macOS
3. Installez Android Studio

### 2. Configuration Initiale
1. Lancez Android Studio
2. Suivez l'assistant de configuration
3. Acceptez les licences Android SDK
4. Laissez installer les composants par défaut

### 3. Configurer les Variables d'Environnement
Ajoutez ces lignes à votre `~/.zshrc` (ou `~/.bash_profile`) :

```bash
# Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
```

### 4. Recharger le Terminal
```bash
source ~/.zshrc
```

### 5. Vérifier l'Installation
```bash
flutter doctor
```

## ⚡ Installation Rapide (Command Line Tools)

### 1. Installer Command Line Tools
```bash
# Créer le dossier Android SDK
mkdir -p $HOME/Library/Android/sdk

# Télécharger les command line tools
cd $HOME/Library/Android/sdk
wget https://dl.google.com/android/repository/commandlinetools-mac-11076708_latest.zip
unzip commandlinetools-mac-11076708_latest.zip
mv cmdline-tools latest
mkdir cmdline-tools
mv latest cmdline-tools/
```

### 2. Configurer les Variables d'Environnement
```bash
echo 'export ANDROID_HOME=$HOME/Library/Android/sdk' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.zshrc
source ~/.zshrc
```

### 3. Installer les Composants Nécessaires
```bash
# Accepter les licences
yes | sdkmanager --licenses

# Installer les composants essentiels
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

## 🏗️ Alternative : Build via CI/CD

Si vous ne voulez pas installer Android Studio localement, utilisez votre CI :

### 1. Push votre Code
```bash
git add .
git commit -m "feat: configuration Firebase pour Play Store"
git push origin main
```

### 2. Télécharger l'AAB depuis GitHub Actions
1. Allez sur votre repo GitHub
2. Actions → Dernier workflow
3. Téléchargez l'artifact "aab-build"

## 🔍 Vérification

### Commandes de Test
```bash
# Vérifier Flutter
flutter doctor

# Vérifier Android SDK
flutter doctor --android-licenses

# Tester le build
flutter build appbundle --release
```

### Résultat Attendu de `flutter doctor`
```
✓ Flutter (Channel stable, 3.27.0)
✓ Android toolchain - develop for Android devices (Android SDK version 34.0.0)
✓ Xcode - develop for iOS and macOS
✓ Chrome - develop for the web
✓ Android Studio (version 2024.1)
✓ VS Code (version 1.95.0)
✓ Connected device (1 available)
✓ Network resources
```

## 🚨 Résolution de Problèmes

### Erreur "No Android SDK found"
```bash
# Vérifier les variables d'environnement
echo $ANDROID_HOME
echo $PATH | grep android

# Si vides, reconfigurer :
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

### Erreur "License not accepted"
```bash
flutter doctor --android-licenses
# Tapez 'y' pour accepter toutes les licences
```

### Erreur "Build tools not found"
```bash
# Via Android Studio : Tools → SDK Manager → SDK Tools
# Ou via command line :
sdkmanager "build-tools;34.0.0"
```

## 💡 Conseils

### Pour le Développement
- **Android Studio** : Interface graphique, émulateurs, debugging
- **Command Line Tools** : Plus léger, juste pour les builds

### Pour la Production
- **CI/CD** : Builds automatiques, pas de configuration locale nécessaire
- **Local** : Tests rapides, debugging

---

🎯 **Recommandation** : Installez Android Studio pour une expérience complète, ou utilisez votre CI pour les builds de production.
