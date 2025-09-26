import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/cart_item_entity.dart';
import '../services/stripe_mock_service.dart';
import '../viewmodels/auth_providers.dart';
import '../viewmodels/cart_providers.dart';
import '../viewmodels/order_providers.dart';
import '../widgets/stripe_payment_widget.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  bool _isProcessing = false;
  bool _showStripeWidget = false;

  @override
  void dispose() {
    _addressController.dispose();
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
        elevation: 0,
      ),
      body: Stack(
        children: [
          cartItemsAsync.when(
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
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
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

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWideScreen = constraints.maxWidth > 800;

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(isWideScreen ? 32 : 16),
                    child: Form(
                      key: _formKey,
                      child: isWideScreen
                          ? _buildWideLayout(
                              cartItems, cartTotalAsync, currentUser)
                          : _buildNarrowLayout(
                              cartItems, cartTotalAsync, currentUser),
                    ),
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
          ),
          // Overlay Stripe
          if (_showStripeWidget)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  margin: const EdgeInsets.all(16),
                  child: cartTotalAsync.when(
                    data: (total) => StripePaymentWidget(
                      amount: total,
                      onPaymentResult: _handleStripePayment,
                      onCancel: () => setState(() => _showStripeWidget = false),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) => const Text('Erreur de calcul'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(
    List<CartItemEntity> cartItems,
    AsyncValue<double> cartTotalAsync,
    user,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Colonne gauche - Formulaire
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAddressSection(),
              const SizedBox(height: 24),
              _buildPaymentMethodSelection(),
            ],
          ),
        ),
        const SizedBox(width: 32),
        // Colonne droite - Résumé
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildOrderSummary(cartItems, cartTotalAsync),
              const SizedBox(height: 24),
              _buildOrderButton(cartItems, cartTotalAsync, user),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(
    List<CartItemEntity> cartItems,
    AsyncValue<double> cartTotalAsync,
    user,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOrderSummary(cartItems, cartTotalAsync),
        const SizedBox(height: 24),
        _buildAddressSection(),
        const SizedBox(height: 24),
        _buildPaymentMethodSelection(),
        const SizedBox(height: 24),
        _buildOrderButton(cartItems, cartTotalAsync, user),
      ],
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

  Widget _buildPaymentMethodSelection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Méthode de paiement',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF635BFF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.credit_card,
                    color: Color(0xFF635BFF),
                  ),
                ),
                title: const Text(
                  'Paiement sécurisé avec Stripe',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Visa, Mastercard, American Express'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => setState(() => _showStripeWidget = true),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.security, color: Colors.green.shade600, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Paiement 100% sécurisé et crypté',
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
      height: 56,
      child: ElevatedButton(
        onPressed: _isProcessing
            ? null
            : () => setState(() => _showStripeWidget = true),
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.payment, size: 20),
                  const SizedBox(width: 8),
                  cartTotalAsync.when(
                    data: (total) => Text(
                      'Payer ${total.toStringAsFixed(2)} €',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    loading: () => const Text('Calcul...'),
                    error: (_, __) => const Text('Erreur'),
                  ),
                ],
              ),
      ),
    );
  }

  void _handleStripePayment(StripePaymentResult result) async {
    setState(() => _showStripeWidget = false);

    if (!result.success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paiement échoué: ${result.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Procéder à la création de la commande
    await _createOrder(result.transactionId!);
  }

  Future<void> _createOrder(String transactionId) async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = ref.read(currentUserProvider);
    final cartItemsAsync = ref.read(cartItemsProvider);

    if (currentUser == null) return;

    setState(() => _isProcessing = true);

    try {
      final cartItems = cartItemsAsync.when(
        data: (items) => items,
        loading: () => <CartItemEntity>[],
        error: (_, __) => <CartItemEntity>[],
      );

      // Créer la commande avec l'ID de transaction Stripe
      final orderId = await ref.read(createOrderUseCaseProvider).call(
            userId: currentUser.id,
            items: cartItems,
            shippingAddress: _addressController.text,
            paymentMethod: 'Stripe - $transactionId',
          );

      // Vider le panier
      await ref.read(cartRepositoryProvider).clearCart();
      ref.invalidate(cartItemsProvider);
      ref.invalidate(cartTotalProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Commande #$orderId créée avec succès !'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
        context.go('/orders');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la création de la commande: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}
