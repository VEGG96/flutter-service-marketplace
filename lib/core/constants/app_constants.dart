class AppConstants {
  const AppConstants._();

  static const String appName = 'Flutter Service Marketplace';
  static const String defaultLocale = 'es_MX';
  static const String currencyCode = 'USD';
  static const int defaultPageSize = 20;
}

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String services = '/services';
  static const String providerDashboard = '/provider-dashboard';
  static const String serviceDetail = '/services/detail';
  static const String providerProfile = '/providers/profile';
  static const String providerAvailability = '/provider/availability';
  static const String booking = '/booking';
  static const String chat = '/chat';
  static const String profile = '/profile';
}

class FirestoreCollections {
  const FirestoreCollections._();

  static const String users = 'users';
  static const String services = 'services';
  static const String bookings = 'bookings';
  static const String chats = 'chats';
  static const String messages = 'messages';
}

class FirestoreFields {
  const FirestoreFields._();

  static const String id = 'id';
  static const String email = 'email';
  static const String role = 'role';
  static const String fullName = 'fullName';
  static const String businessName = 'businessName';
  static const String phone = 'phone';
  static const String city = 'city';
  static const String address = 'address';
  static const String bio = 'bio';
  static const String profileImageUrl = 'profileImageUrl';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String userId = 'userId';
  static const String serviceId = 'serviceId';
  static const String bookingId = 'bookingId';
  static const String status = 'status';
}

class AppLimits {
  const AppLimits._();

  static const int minPasswordLength = 6;
  static const int maxNameLength = 60;
  static const int maxServiceTitleLength = 80;
  static const int maxServiceDescriptionLength = 1000;
  static const int maxChatMessageLength = 1200;
}

class AppDurations {
  const AppDurations._();

  static const Duration splash = Duration(milliseconds: 1200);
  static const Duration searchDebounce = Duration(milliseconds: 400);
  static const Duration requestTimeout = Duration(seconds: 30);
}

class DateFormats {
  const DateFormats._();

  static const String date = 'dd/MM/yyyy';
  static const String dateTime = 'dd/MM/yyyy HH:mm';
  static const String time = 'HH:mm';
}

class ErrorMessages {
  const ErrorMessages._();

  static const String requiredField = 'Este campo es obligatorio';
  static const String emailRequired = 'El correo es obligatorio';
  static const String invalidEmail = 'Ingresa un correo valido';
  static const String passwordRequired = 'La contrasena es obligatoria';
  static const String weakPassword = 'Debe incluir letras y numeros';
  static const String confirmPasswordRequired = 'Confirma tu contrasena';
  static const String passwordsDoNotMatch = 'Las contrasenas no coinciden';
  static const String nameRequired = 'El nombre es obligatorio';
  static const String serviceTitleRequired = 'El titulo es obligatorio';
  static const String serviceDescriptionRequired =
      'La descripcion es obligatoria';
  static const String chatMessageRequired = 'Escribe un mensaje';
  static const String priceRequired = 'El precio es obligatorio';
  static const String invalidPrice = 'Ingresa un precio valido';

  static String requiredFieldByName(String fieldName) =>
      '$fieldName es obligatorio';

  static String minLength(int value) => 'Minimo $value caracteres';

  static String maxLength(int value) => 'Maximo $value caracteres';

  static String minPrice(double value) =>
      'El precio minimo es ${value.toStringAsFixed(2)}';

  static String maxPrice(double value) =>
      'El precio maximo es ${value.toStringAsFixed(2)}';
}

class ApiErrorMessages {
  const ApiErrorMessages._();

  static const String noInternetConnection = 'Sin conexion a internet';
  static const String connectionTimeout = 'Tiempo de espera agotado';
  static const String receiveTimeout = 'No se recibio respuesta a tiempo';
  static const String sendTimeout = 'No se pudo enviar la solicitud a tiempo';
  static const String requestCancelled = 'La solicitud fue cancelada';
  static const String badRequest = 'Solicitud invalida';
  static const String unauthorized = 'No autorizado. Inicia sesion de nuevo';
  static const String forbidden = 'No tienes permisos para esta accion';
  static const String notFound = 'Recurso no encontrado';
  static const String conflict = 'Conflicto en la solicitud';
  static const String tooManyRequests = 'Demasiadas solicitudes. Intenta luego';
  static const String internalServerError = 'Error interno del servidor';
  static const String serviceUnavailable =
      'Servicio temporalmente no disponible';
  static const String gatewayTimeout =
      'El servidor tardo demasiado en responder';
  static const String unknown = 'Ocurrio un error inesperado';

  static String fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return badRequest;
      case 401:
        return unauthorized;
      case 403:
        return forbidden;
      case 404:
        return notFound;
      case 409:
        return conflict;
      case 429:
        return tooManyRequests;
      case 500:
        return internalServerError;
      case 503:
        return serviceUnavailable;
      case 504:
        return gatewayTimeout;
      default:
        return unknown;
    }
  }
}

class FirebaseAuthErrorMessages {
  const FirebaseAuthErrorMessages._();

  static const String invalidCredential = 'Credenciales invalidas';
  static const String invalidEmail = 'El correo no es valido';
  static const String userDisabled = 'Esta cuenta fue deshabilitada';
  static const String userNotFound = 'No existe una cuenta con ese correo';
  static const String wrongPassword = 'Contrasena incorrecta';
  static const String emailAlreadyInUse = 'Este correo ya esta registrado';
  static const String weakPassword = 'La contrasena es demasiado debil';
  static const String operationNotAllowed = 'Operacion no permitida';
  static const String tooManyRequests = 'Demasiados intentos. Intenta luego';
  static const String networkRequestFailed =
      ApiErrorMessages.noInternetConnection;
  static const String requiresRecentLogin =
      'Vuelve a iniciar sesion para eliminar la cuenta';
  static const String unknown = 'Error de autenticacion';

  static String fromCode(String code) {
    switch (code) {
      case 'invalid-credential':
        return invalidCredential;
      case 'invalid-email':
        return invalidEmail;
      case 'user-disabled':
        return userDisabled;
      case 'user-not-found':
        return userNotFound;
      case 'wrong-password':
        return wrongPassword;
      case 'email-already-in-use':
        return emailAlreadyInUse;
      case 'weak-password':
        return weakPassword;
      case 'operation-not-allowed':
        return operationNotAllowed;
      case 'too-many-requests':
        return tooManyRequests;
      case 'network-request-failed':
        return networkRequestFailed;
      case 'requires-recent-login':
        return requiresRecentLogin;
      default:
        return unknown;
    }
  }
}
