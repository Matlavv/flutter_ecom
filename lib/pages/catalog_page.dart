import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/product_entity.dart';
import '../viewmodels/app_providers.dart';
import '../widgets/product_card.dart';

class CatalogPage extends ConsumerStatefulWidget {
  const CatalogPage({super.key});

  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'Toutes';

  final List<String> _categories = [
    'Toutes',
    'Électronique',
    'Vêtements',
    'Maison',
    'Sport',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: scheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'EcoShop',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
            ),
          ],
        ),
        actions: [
          // Sélecteur de thème
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Thème',
            initialValue: themeMode,
            onSelected: (mode) =>
                ref.read(themeModeProvider.notifier).setThemeMode(mode),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: ThemeMode.system,
                child: Row(
                  children: [
                    const Icon(Icons.settings_suggest, size: 18),
                    const SizedBox(width: 8),
                    const Text('Système'),
                    const Spacer(),
                    if (themeMode == ThemeMode.system)
                      const Icon(Icons.check, size: 18),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ThemeMode.light,
                child: Row(
                  children: [
                    const Icon(Icons.light_mode, size: 18),
                    const SizedBox(width: 8),
                    const Text('Clair'),
                    const Spacer(),
                    if (themeMode == ThemeMode.light)
                      const Icon(Icons.check, size: 18),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ThemeMode.dark,
                child: Row(
                  children: [
                    const Icon(Icons.dark_mode, size: 18),
                    const SizedBox(width: 8),
                    const Text('Sombre'),
                    const Spacer(),
                    if (themeMode == ThemeMode.dark)
                      const Icon(Icons.check, size: 18),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProductDialog(),
            tooltip: 'Ajouter un produit',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(signOutUseCaseProvider).call();
              if (context.mounted) context.go('/login');
            },
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        tooltip: 'Effacer',
                      )
                    : null,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Filtres par catégorie
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.12),
                    showCheckmark: false,
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).dividerColor,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Liste des produits
          Expanded(child: _buildProductsList()),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    final productsAsync = ref.watch(
      productsByCategoryProvider(_selectedCategory),
    );

    return productsAsync.when(
      data: (products) {
        // Filtrer par recherche
        final filteredProducts = products.where((product) {
          final matchesSearch = _searchController.text.isEmpty ||
              product.title.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  );
          return matchesSearch;
        }).toList();

        if (filteredProducts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Aucun produit trouvé',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            // Grille adaptative: 2 colonnes en mobile, 3 tablette, 4 desktop
            final width = constraints.maxWidth;
            int crossAxisCount = 2;
            if (width >= 1200) {
              crossAxisCount = 4;
            } else if (width >= 800) {
              crossAxisCount = 3;
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(product: product);
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Erreur: $error'),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog() {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();
    final thumbnailController = TextEditingController();
    String selectedCategory = 'Électronique';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Ajouter un produit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Prix',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: thumbnailController,
                  decoration: const InputDecoration(
                    labelText: 'URL de l\'image',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Catégorie',
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      items: _categories
                          .where((cat) => cat != 'Toutes')
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
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
                if (titleController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  try {
                    final product = ProductEntity(
                      id: '', // généré par Firestore
                      title: titleController.text,
                      price: double.parse(priceController.text),
                      thumbnail: thumbnailController.text,
                      images: thumbnailController.text.isNotEmpty
                          ? [thumbnailController.text]
                          : [],
                      description: descriptionController.text,
                      category: selectedCategory,
                      stock: 10,
                    );

                    await ref.read(createProductUseCaseProvider).call(product);

                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Produit créé avec succès')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur: $e')),
                      );
                    }
                  }
                }
              },
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }
}
