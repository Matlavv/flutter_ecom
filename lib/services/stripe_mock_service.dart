import 'dart:async';
import 'dart:math';

class StripeMockService {
  static const Duration _processingDelay = Duration(seconds: 2);
  static final Random _random = Random();

  /// Simule le traitement d'un paiement Stripe
  /// Retourne true si le paiement est accepté, false sinon
  static Future<StripePaymentResult> processPayment({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required double amount,
    String? cardholderName,
  }) async {
    // Simulation du délai de traitement réseau
    await Future.delayed(_processingDelay);

    // Validation des données de carte
    final validationResult = _validateCard(cardNumber, expiryDate, cvv);
    if (!validationResult.isValid) {
      return StripePaymentResult(
        success: false,
        error: validationResult.error,
        transactionId: null,
      );
    }

    // Simulation de différents scénarios de paiement
    final scenario = _getPaymentScenario(cardNumber);

    switch (scenario) {
      case PaymentScenario.success:
        return StripePaymentResult(
          success: true,
          transactionId: _generateTransactionId(),
          amount: amount,
        );

      case PaymentScenario.insufficientFunds:
        return StripePaymentResult(
          success: false,
          error: 'Fonds insuffisants sur la carte',
          transactionId: null,
        );

      case PaymentScenario.cardDeclined:
        return StripePaymentResult(
          success: false,
          error: 'Carte refusée par la banque',
          transactionId: null,
        );

      case PaymentScenario.networkError:
        return StripePaymentResult(
          success: false,
          error: 'Erreur réseau. Veuillez réessayer.',
          transactionId: null,
        );
    }
  }

  /// Valide les informations de carte
  static CardValidationResult _validateCard(
    String cardNumber,
    String expiryDate,
    String cvv,
  ) {
    // Nettoyage du numéro de carte
    final cleanCardNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

    // Validation du numéro de carte (algorithme de Luhn simplifié)
    if (cleanCardNumber.length < 13 || cleanCardNumber.length > 19) {
      return CardValidationResult(false, 'Numéro de carte invalide');
    }

    // Validation de la date d'expiration
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiryDate)) {
      return CardValidationResult(false, 'Format de date invalide (MM/AA)');
    }

    final parts = expiryDate.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null || month < 1 || month > 12) {
      return CardValidationResult(false, 'Date d\'expiration invalide');
    }

    // Vérification que la carte n'est pas expirée
    final now = DateTime.now();
    final expiryYear = 2000 + year;
    final expiryDateTime = DateTime(expiryYear, month + 1, 0);

    if (expiryDateTime.isBefore(now)) {
      return CardValidationResult(false, 'Carte expirée');
    }

    // Validation du CVV
    if (!RegExp(r'^\d{3,4}$').hasMatch(cvv)) {
      return CardValidationResult(false, 'CVV invalide');
    }

    return CardValidationResult(true, null);
  }

  /// Détermine le scénario de paiement basé sur le numéro de carte
  static PaymentScenario _getPaymentScenario(String cardNumber) {
    final cleanCardNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

    // Cartes de test spéciales
    switch (cleanCardNumber) {
      case '4000000000000002': // Carte refusée
        return PaymentScenario.cardDeclined;
      case '4000000000000069': // Fonds insuffisants
        return PaymentScenario.insufficientFunds;
      case '4000000000000119': // Erreur réseau
        return PaymentScenario.networkError;
      default:
        // 90% de succès pour les autres cartes
        return _random.nextDouble() < 0.9
            ? PaymentScenario.success
            : PaymentScenario.cardDeclined;
    }
  }

  /// Génère un ID de transaction réaliste
  static String _generateTransactionId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return 'txn_${List.generate(16, (index) => chars[_random.nextInt(chars.length)]).join()}';
  }

  /// Retourne les cartes de test disponibles
  static List<TestCard> getTestCards() {
    return [
      TestCard(
        number: '4242424242424242',
        expiry: '12/25',
        cvv: '123',
        description: 'Visa - Paiement réussi',
        type: CardType.visa,
      ),
      TestCard(
        number: '5555555555554444',
        expiry: '12/25',
        cvv: '123',
        description: 'Mastercard - Paiement réussi',
        type: CardType.mastercard,
      ),
      TestCard(
        number: '4000000000000002',
        expiry: '12/25',
        cvv: '123',
        description: 'Visa - Carte refusée',
        type: CardType.visa,
      ),
      TestCard(
        number: '4000000000000069',
        expiry: '12/25',
        cvv: '123',
        description: 'Visa - Fonds insuffisants',
        type: CardType.visa,
      ),
    ];
  }
}

/// Résultat d'un paiement Stripe
class StripePaymentResult {
  final bool success;
  final String? error;
  final String? transactionId;
  final double? amount;

  StripePaymentResult({
    required this.success,
    this.error,
    this.transactionId,
    this.amount,
  });
}

/// Résultat de validation de carte
class CardValidationResult {
  final bool isValid;
  final String? error;

  CardValidationResult(this.isValid, this.error);
}

/// Scénarios de paiement possibles
enum PaymentScenario {
  success,
  insufficientFunds,
  cardDeclined,
  networkError,
}

/// Types de cartes supportées
enum CardType {
  visa,
  mastercard,
  amex,
  discover,
}

/// Carte de test
class TestCard {
  final String number;
  final String expiry;
  final String cvv;
  final String description;
  final CardType type;

  TestCard({
    required this.number,
    required this.expiry,
    required this.cvv,
    required this.description,
    required this.type,
  });
}
