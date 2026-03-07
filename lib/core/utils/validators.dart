import '../constants/app_constants.dart';

class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _containsLetterRegex = RegExp(r'[A-Za-z]');
  static final RegExp _containsNumberRegex = RegExp(r'[0-9]');

  static String? requiredField(
    String? value, {
    String fieldName = 'Este campo',
  }) {
    if (_isEmpty(value)) {
      return ErrorMessages.requiredFieldByName(fieldName);
    }
    return null;
  }

  static String? email(String? value, {bool required = true}) {
    if (_isEmpty(value)) {
      return required ? ErrorMessages.emailRequired : null;
    }

    final String normalized = value!.trim();
    if (!_emailRegex.hasMatch(normalized)) {
      return ErrorMessages.invalidEmail;
    }
    return null;
  }

  static String? password(String? value, {bool required = true}) {
    if (_isEmpty(value)) {
      return required ? ErrorMessages.passwordRequired : null;
    }

    final String normalized = value!.trim();
    if (normalized.length < AppLimits.minPasswordLength) {
      return ErrorMessages.minLength(AppLimits.minPasswordLength);
    }

    if (!_containsLetterRegex.hasMatch(normalized) ||
        !_containsNumberRegex.hasMatch(normalized)) {
      return ErrorMessages.weakPassword;
    }

    return null;
  }

  static String? confirmPassword(String? value, {required String password}) {
    if (_isEmpty(value)) {
      return ErrorMessages.confirmPasswordRequired;
    }

    if (value!.trim() != password.trim()) {
      return ErrorMessages.passwordsDoNotMatch;
    }
    return null;
  }

  static String? name(String? value, {bool required = true}) {
    if (_isEmpty(value)) {
      return required ? ErrorMessages.nameRequired : null;
    }

    final String normalized = value!.trim();
    if (normalized.length > AppLimits.maxNameLength) {
      return ErrorMessages.maxLength(AppLimits.maxNameLength);
    }
    return null;
  }

  static String? serviceTitle(String? value, {bool required = true}) {
    if (_isEmpty(value)) {
      return required ? ErrorMessages.serviceTitleRequired : null;
    }

    final String normalized = value!.trim();
    if (normalized.length > AppLimits.maxServiceTitleLength) {
      return ErrorMessages.maxLength(AppLimits.maxServiceTitleLength);
    }
    return null;
  }

  static String? serviceDescription(String? value, {bool required = true}) {
    if (_isEmpty(value)) {
      return required ? ErrorMessages.serviceDescriptionRequired : null;
    }

    final String normalized = value!.trim();
    if (normalized.length > AppLimits.maxServiceDescriptionLength) {
      return ErrorMessages.maxLength(AppLimits.maxServiceDescriptionLength);
    }
    return null;
  }

  static String? chatMessage(String? value, {bool required = true}) {
    if (_isEmpty(value)) {
      return required ? ErrorMessages.chatMessageRequired : null;
    }

    final String normalized = value!.trim();
    if (normalized.length > AppLimits.maxChatMessageLength) {
      return ErrorMessages.maxLength(AppLimits.maxChatMessageLength);
    }
    return null;
  }

  static String? price(
    String? value, {
    bool required = true,
    double min = 0,
    double? max,
  }) {
    if (_isEmpty(value)) {
      return required ? ErrorMessages.priceRequired : null;
    }

    final String normalized = value!.trim().replaceAll(',', '.');
    final double? parsed = double.tryParse(normalized);
    if (parsed == null) {
      return ErrorMessages.invalidPrice;
    }

    if (parsed < min) {
      return ErrorMessages.minPrice(min);
    }

    if (max != null && parsed > max) {
      return ErrorMessages.maxPrice(max);
    }

    return null;
  }

  static bool isValidEmail(String value) => email(value) == null;

  static bool isValidPassword(String value) => password(value) == null;

  static bool _isEmpty(String? value) => value == null || value.trim().isEmpty;
}
