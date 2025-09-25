import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/user_entity.dart';
import '../viewmodels/auth_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête du profil
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          _buildProfileAvatar(context, user),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.displayName ?? 'Utilisateur',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                                if (user.createdAt != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Membre depuis ${_formatDate(user.createdAt!)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey[500]),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Actions du profil
                  Text(
                    'Actions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Bouton de modification du profil
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Modifier le profil'),
                      subtitle: const Text('Changer votre nom d\'affichage'),
                      onTap: () => _showEditProfileDialog(context, ref, user),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Bouton de déconnexion
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Déconnexion'),
                      subtitle: const Text('Se déconnecter de votre compte'),
                      onTap: () => _showLogoutDialog(context, ref),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context, UserEntity user) {
    if (user.photoUrl?.isNotEmpty == true) {
      return CircleAvatar(
        radius: 40,
        backgroundColor: Theme.of(context).primaryColor,
        child: ClipOval(
          child: Image.network(
            user.photoUrl!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultAvatar(context, user);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              );
            },
          ),
        ),
      );
    }
    return _buildDefaultAvatar(context, user);
  }

  Widget _buildDefaultAvatar(BuildContext context, UserEntity user) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        user.displayName?.isNotEmpty == true
            ? user.displayName![0].toUpperCase()
            : user.email[0].toUpperCase(),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showEditProfileDialog(
      BuildContext context, WidgetRef ref, UserEntity user) {
    final displayNameController =
        TextEditingController(text: user.displayName ?? '');
    final photoUrlController = TextEditingController(text: user.photoUrl ?? '');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Modifier le profil'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Aperçu de la photo de profil
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: photoUrlController.text.trim().isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  photoUrlController.text.trim(),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: displayNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom d\'affichage',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: photoUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL de la photo de profil',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image),
                    helperText:
                        'Collez l\'URL d\'une image pour voir l\'aperçu',
                  ),
                  onChanged: (value) {
                    setState(() {}); // Actualiser l'aperçu
                  },
                ),
                const SizedBox(height: 8),
                // Bouton d'exemple
                TextButton.icon(
                  onPressed: () {
                    photoUrlController.text =
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSH-iy4HEaLVBaJ9fv5PQ-7nXMKaHjcLNXd0A&s';
                    setState(() {});
                  },
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('Utiliser une image d\'exemple'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(updateProfileUseCaseProvider).call(
                        displayName: displayNameController.text.trim().isEmpty
                            ? null
                            : displayNameController.text.trim(),
                        photoUrl: photoUrlController.text.trim().isEmpty
                            ? null
                            : photoUrlController.text.trim(),
                      );

                  // Forcer l'actualisation du provider d'authentification
                  ref.invalidate(authStateProvider);

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profil mis à jour avec succès'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erreur: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(signOutUseCaseProvider).call();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}
