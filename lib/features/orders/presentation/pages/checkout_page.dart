import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../providers/order_providers.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _addressController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItemsAsync = ref.watch(cartItemsProvider);
    final cartTotalAsync = ref.watch(cartTotalProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finaliser la commande'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: cartItemsAsync.when(
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Votre panier est vide',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ajoutez des produits avant de passer commande',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Résumé de la commande
                  _buildOrderSummary(cartItems, cartTotalAsync),
                  const SizedBox(height: 24),

                  // Adresse de livraison
                  _buildAddressSection(),
                  const SizedBox(height: 24),

                  // Informations de paiement
                  _buildPaymentSection(),
                  const SizedBox(height: 24),

                  // Bouton de commande
                  _buildOrderButton(cartItems, cartTotalAsync, currentUser),
                ],
              ),
            ),
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
      ),
    );
  }

  Widget _buildOrderSummary(
    List<CartItemEntity> cartItems,
    AsyncValue<double> cartTotalAsync,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Résumé de la commande',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...cartItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('${item.product.title} x${item.quantity}'),
                    ),
                    Text('${item.totalPrice.toStringAsFixed(2)} €'),
                  ],
                ),
              ),
            ),
            const Divider(),
            cartTotalAsync.when(
              data: (total) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${total.toStringAsFixed(2)} €',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Erreur de calcul'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adresse de livraison',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Adresse complète',
                border: OutlineInputBorder(),
                hintText: '123 Rue de la Paix, 75001 Paris',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre adresse';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations de paiement',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Numéro de carte',
                border: OutlineInputBorder(),
                hintText: '1234 5678 9012 3456',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le numéro de carte';
                }
                if (value.replaceAll(' ', '').length < 16) {
                  return 'Numéro de carte invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    decoration: const InputDecoration(
                      labelText: 'Date d\'expiration',
                      border: OutlineInputBorder(),
                      hintText: 'MM/AA',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date requise';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                      hintText: '123',
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CVV requis';
                      }
                      if (value.length < 3) {
                        return 'CVV invalide';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderButton(
    List<CartItemEntity> cartItems,
    AsyncValue<double> cartTotalAsync,
    user,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isProcessing
            ? null
            : () => _processOrder(cartItems, cartTotalAsync, user),
        child: _isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Confirmer la commande',
                style: TextStyle(fontSize: 18),
              ),
      ),
    );
  }

  Future<void> _processOrder(
    List<CartItemEntity> cartItems,
    AsyncValue<double> cartTotalAsync,
    user,
  ) async {
    if (!_formKey.currentState!.validate()) return;
    if (user == null) return;

    setState(() => _isProcessing = true);

    try {
      // Simuler le paiement
      final total = cartTotalAsync.when(
        data: (value) => value,
        loading: () => 0.0,
        error: (_, __) => 0.0,
      );

      final paymentSuccess =
          await ref.read(orderRepositoryProvider).simulatePayment(
                cardNumber: _cardNumberController.text,
                expiryDate: _expiryController.text,
                cvv: _cvvController.text,
                amount: total,
              );

      if (!paymentSuccess) {
        throw Exception('Paiement refusé. Veuillez vérifier vos informations.');
      }

      // Créer la commande
      final orderId = await ref.read(createOrderUseCaseProvider).call(
            userId: user.id,
            items: cartItems,
            shippingAddress: _addressController.text,
            paymentMethod: 'Carte bancaire',
          );

      // Vider le panier
      await ref.read(cartRepositoryProvider).clearCart();
      ref.invalidate(cartItemsProvider);
      ref.invalidate(cartTotalProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Commande #$orderId créée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/orders');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}
