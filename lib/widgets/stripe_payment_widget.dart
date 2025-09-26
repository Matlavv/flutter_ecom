import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/stripe_mock_service.dart';

/// Widget de paiement Stripe avec UI réaliste
class StripePaymentWidget extends StatefulWidget {
  final double amount;
  final Function(StripePaymentResult) onPaymentResult;
  final VoidCallback? onCancel;

  const StripePaymentWidget({
    super.key,
    required this.amount,
    required this.onPaymentResult,
    this.onCancel,
  });

  @override
  State<StripePaymentWidget> createState() => _StripePaymentWidgetState();
}

class _StripePaymentWidgetState extends State<StripePaymentWidget> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isProcessing = false;
  CardType? _detectedCardType;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildCardNumberField(),
              const SizedBox(height: 16),
              _buildExpiryAndCvvRow(),
              const SizedBox(height: 16),
              _buildNameField(),
              const SizedBox(height: 24),
              _buildTestCardsInfo(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF635BFF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'stripe',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const Spacer(),
        Text(
          '${widget.amount.toStringAsFixed(2)} €',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCardNumberField() {
    return TextFormField(
      controller: _cardNumberController,
      decoration: InputDecoration(
        labelText: 'Numéro de carte',
        hintText: '1234 5678 9012 3456',
        prefixIcon: _buildCardIcon(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF635BFF), width: 2),
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CardNumberInputFormatter(),
      ],
      onChanged: (value) {
        setState(() {
          _detectedCardType = _detectCardType(value);
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Numéro de carte requis';
        }
        final cleanValue = value.replaceAll(' ', '');
        if (cleanValue.length < 13) {
          return 'Numéro de carte invalide';
        }
        return null;
      },
    );
  }

  Widget _buildExpiryAndCvvRow() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _expiryController,
            decoration: InputDecoration(
              labelText: 'MM/AA',
              hintText: '12/25',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFF635BFF), width: 2),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              ExpiryDateInputFormatter(),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Date requise';
              }
              if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                return 'Format MM/AA';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _cvvController,
            decoration: InputDecoration(
              labelText: 'CVV',
              hintText: '123',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFF635BFF), width: 2),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
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
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Nom sur la carte',
        hintText: 'Jean Dupont',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF635BFF), width: 2),
        ),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nom requis';
        }
        return null;
      },
    );
  }

  Widget _buildTestCardsInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700, size: 16),
              const SizedBox(width: 8),
              Text(
                'Cartes de test disponibles',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...StripeMockService.getTestCards().take(2).map(
                (card) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: GestureDetector(
                    onTap: () => _fillTestCard(card),
                    child: Text(
                      '${card.number} - ${card.description}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (widget.onCancel != null)
          Expanded(
            child: OutlinedButton(
              onPressed: _isProcessing ? null : widget.onCancel,
              child: const Text('Annuler'),
            ),
          ),
        if (widget.onCancel != null) const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF635BFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text('Payer ${widget.amount.toStringAsFixed(2)} €'),
          ),
        ),
      ],
    );
  }

  Widget _buildCardIcon() {
    IconData icon;
    Color color;

    switch (_detectedCardType) {
      case CardType.visa:
        icon = Icons.credit_card;
        color = Colors.blue;
        break;
      case CardType.mastercard:
        icon = Icons.credit_card;
        color = Colors.red;
        break;
      case CardType.amex:
        icon = Icons.credit_card;
        color = Colors.green;
        break;
      default:
        icon = Icons.credit_card;
        color = Colors.grey;
    }

    return Icon(icon, color: color);
  }

  CardType? _detectCardType(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(' ', '');
    if (cleanNumber.startsWith('4')) return CardType.visa;
    if (cleanNumber.startsWith('5')) return CardType.mastercard;
    if (cleanNumber.startsWith('3')) return CardType.amex;
    return null;
  }

  void _fillTestCard(TestCard card) {
    _cardNumberController.text = card.number;
    _expiryController.text = card.expiry;
    _cvvController.text = card.cvv;
    _nameController.text = 'Test User';
    setState(() {
      _detectedCardType = card.type;
    });
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      final result = await StripeMockService.processPayment(
        cardNumber: _cardNumberController.text,
        expiryDate: _expiryController.text,
        cvv: _cvvController.text,
        amount: widget.amount,
        cardholderName: _nameController.text,
      );

      widget.onPaymentResult(result);
    } catch (e) {
      widget.onPaymentResult(StripePaymentResult(
        success: false,
        error: 'Erreur inattendue: $e',
      ));
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}

/// Formateur pour le numéro de carte (ajoute des espaces)
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formateur pour la date d'expiration (MM/AA)
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
