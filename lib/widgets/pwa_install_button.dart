import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PWAInstallButton extends StatefulWidget {
  const PWAInstallButton({super.key});

  @override
  State<PWAInstallButton> createState() => _PWAInstallButtonState();
}

class _PWAInstallButtonState extends State<PWAInstallButton> {
  bool _isInstallable = false;
  bool _isInstalled = false;

  @override
  void initState() {
    super.initState();
    _checkInstallability();
  }

  void _checkInstallability() {
    if (kIsWeb) {
      setState(() {
        _isInstallable = true;
      });
    }
  }

  void _installPWA() {
    if (kIsWeb) {
      // Logique d'installation PWA
      setState(() {
        _isInstalled = true;
        _isInstallable = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('EcoShop installé avec succès !'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || _isInstalled) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: _isInstallable ? _installPWA : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.download,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Installer EcoShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Accès rapide depuis votre écran d\'accueil',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
