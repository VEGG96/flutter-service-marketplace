import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('es')];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'Flutter Service Marketplace'**
  String get appName;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In es, this message translates to:
  /// **'Eliminar cuenta'**
  String get deleteAccount;

  /// No description provided for @changePassword.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get changePassword;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @login.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get login;

  /// No description provided for @loginSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Accede con tu correo y contraseña'**
  String get loginSubtitle;

  /// No description provided for @createAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Crea tu cuenta para comenzar'**
  String get createAccountSubtitle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'Ya tengo cuenta'**
  String get alreadyHaveAccount;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get email;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmPassword;

  /// No description provided for @myProfile.
  ///
  /// In es, this message translates to:
  /// **'Mi perfil'**
  String get myProfile;

  /// No description provided for @editProfile.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get editProfile;

  /// No description provided for @saveProfile.
  ///
  /// In es, this message translates to:
  /// **'Guardar perfil'**
  String get saveProfile;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveChanges;

  /// No description provided for @fullName.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get fullName;

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get phone;

  /// No description provided for @city.
  ///
  /// In es, this message translates to:
  /// **'Ciudad'**
  String get city;

  /// No description provided for @address.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get address;

  /// No description provided for @cityOfOperation.
  ///
  /// In es, this message translates to:
  /// **'Ciudad de operación'**
  String get cityOfOperation;

  /// No description provided for @businessName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del negocio'**
  String get businessName;

  /// No description provided for @providerLabel.
  ///
  /// In es, this message translates to:
  /// **'Proveedor'**
  String get providerLabel;

  /// No description provided for @bio.
  ///
  /// In es, this message translates to:
  /// **'Biografía'**
  String get bio;

  /// No description provided for @aboutMe.
  ///
  /// In es, this message translates to:
  /// **'Sobre mí'**
  String get aboutMe;

  /// No description provided for @serviceDescription.
  ///
  /// In es, this message translates to:
  /// **'Sobre mis servicios'**
  String get serviceDescription;

  /// No description provided for @completeYourProfile.
  ///
  /// In es, this message translates to:
  /// **'Completa tu perfil'**
  String get completeYourProfile;

  /// No description provided for @serviceAreaLabel.
  ///
  /// In es, this message translates to:
  /// **'Área de servicio'**
  String get serviceAreaLabel;

  /// No description provided for @specialties.
  ///
  /// In es, this message translates to:
  /// **'Especialidades'**
  String get specialties;

  /// No description provided for @hourlyRate.
  ///
  /// In es, this message translates to:
  /// **'Precio por hora'**
  String get hourlyRate;

  /// No description provided for @providerSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes del proveedor'**
  String get providerSettings;

  /// No description provided for @editProviderProfile.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil (Proveedor)'**
  String get editProviderProfile;

  /// No description provided for @providerAvailability.
  ///
  /// In es, this message translates to:
  /// **'Disponibilidad'**
  String get providerAvailability;

  /// No description provided for @availability.
  ///
  /// In es, this message translates to:
  /// **'Disponibilidad'**
  String get availability;

  /// No description provided for @responseTime.
  ///
  /// In es, this message translates to:
  /// **'Tiempo respuesta'**
  String get responseTime;

  /// No description provided for @averageRate.
  ///
  /// In es, this message translates to:
  /// **'Promedio tarifa'**
  String get averageRate;

  /// No description provided for @bookNow.
  ///
  /// In es, this message translates to:
  /// **'Agendar ahora'**
  String get bookNow;

  /// No description provided for @sendMessage.
  ///
  /// In es, this message translates to:
  /// **'Enviar mensaje'**
  String get sendMessage;

  /// No description provided for @configureAvailability.
  ///
  /// In es, this message translates to:
  /// **'Configurar disponibilidad'**
  String get configureAvailability;

  /// No description provided for @selectDays.
  ///
  /// In es, this message translates to:
  /// **'Selecciona los días en los que trabajas'**
  String get selectDays;

  /// No description provided for @workingHours.
  ///
  /// In es, this message translates to:
  /// **'Horario de atención'**
  String get workingHours;

  /// No description provided for @start.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get start;

  /// No description provided for @end.
  ///
  /// In es, this message translates to:
  /// **'Fin'**
  String get end;

  /// No description provided for @saveAvailability.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get saveAvailability;

  /// No description provided for @availabilitySaved.
  ///
  /// In es, this message translates to:
  /// **'Disponibilidad guardada'**
  String get availabilitySaved;

  /// No description provided for @notifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notifications;

  /// No description provided for @receiveNotifications.
  ///
  /// In es, this message translates to:
  /// **'Recibir notificaciones'**
  String get receiveNotifications;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Avisos de mensajes y solicitudes nuevas'**
  String get notificationsSubtitle;

  /// No description provided for @profileLoadError.
  ///
  /// In es, this message translates to:
  /// **'No fue posible cargar el perfil'**
  String get profileLoadError;

  /// No description provided for @loadingProfile.
  ///
  /// In es, this message translates to:
  /// **'Cargando perfil...'**
  String get loadingProfile;

  /// No description provided for @appBrand.
  ///
  /// In es, this message translates to:
  /// **'QuickFix'**
  String get appBrand;

  /// No description provided for @noServicesAvailable.
  ///
  /// In es, this message translates to:
  /// **'No hay servicios disponibles'**
  String get noServicesAvailable;

  /// No description provided for @adjustSearchOrReload.
  ///
  /// In es, this message translates to:
  /// **'Intenta ajustar la búsqueda o recargar la pantalla.'**
  String get adjustSearchOrReload;

  /// No description provided for @reload.
  ///
  /// In es, this message translates to:
  /// **'Recargar'**
  String get reload;

  /// No description provided for @viewProfile.
  ///
  /// In es, this message translates to:
  /// **'Ver perfil'**
  String get viewProfile;

  /// No description provided for @jobs.
  ///
  /// In es, this message translates to:
  /// **'trabajos'**
  String get jobs;

  /// No description provided for @responds.
  ///
  /// In es, this message translates to:
  /// **'Responde'**
  String get responds;

  /// No description provided for @verifiedProfessional.
  ///
  /// In es, this message translates to:
  /// **'Profesional verificado'**
  String get verifiedProfessional;

  /// No description provided for @chat.
  ///
  /// In es, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @chatScreen.
  ///
  /// In es, this message translates to:
  /// **'Pantalla de chat'**
  String get chatScreen;

  /// No description provided for @goToMyProfile.
  ///
  /// In es, this message translates to:
  /// **'Ir a mi perfil'**
  String get goToMyProfile;

  /// No description provided for @backToServices.
  ///
  /// In es, this message translates to:
  /// **'Volver a servicios'**
  String get backToServices;

  /// No description provided for @bookings.
  ///
  /// In es, this message translates to:
  /// **'Reservas'**
  String get bookings;

  /// No description provided for @bookingsScreen.
  ///
  /// In es, this message translates to:
  /// **'Pantalla de reservas'**
  String get bookingsScreen;

  /// No description provided for @contactByChat.
  ///
  /// In es, this message translates to:
  /// **'Contactar por chat'**
  String get contactByChat;

  /// No description provided for @greetingHello.
  ///
  /// In es, this message translates to:
  /// **'Hola'**
  String get greetingHello;

  /// No description provided for @statusActive.
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get statusActive;

  /// No description provided for @earningsWeekly.
  ///
  /// In es, this message translates to:
  /// **'Ganancias (Semana)'**
  String get earningsWeekly;

  /// No description provided for @rating.
  ///
  /// In es, this message translates to:
  /// **'Calificación'**
  String get rating;

  /// No description provided for @reviews.
  ///
  /// In es, this message translates to:
  /// **'reseñas'**
  String get reviews;

  /// No description provided for @completed.
  ///
  /// In es, this message translates to:
  /// **'Completados'**
  String get completed;

  /// No description provided for @viewHowCustomersSeeMe.
  ///
  /// In es, this message translates to:
  /// **'Ver cómo me ven los clientes'**
  String get viewHowCustomersSeeMe;

  /// No description provided for @newRequests.
  ///
  /// In es, this message translates to:
  /// **'Nuevas Solicitudes'**
  String get newRequests;

  /// No description provided for @clientLabel.
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get clientLabel;

  /// No description provided for @scheduleLabel.
  ///
  /// In es, this message translates to:
  /// **'Horario'**
  String get scheduleLabel;

  /// No description provided for @addressLabel.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get addressLabel;

  /// No description provided for @reject.
  ///
  /// In es, this message translates to:
  /// **'Rechazar'**
  String get reject;

  /// No description provided for @accept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get accept;

  /// No description provided for @todayAgenda.
  ///
  /// In es, this message translates to:
  /// **'Agenda de Hoy'**
  String get todayAgenda;

  /// No description provided for @confirmed.
  ///
  /// In es, this message translates to:
  /// **'Confirmado'**
  String get confirmed;

  /// No description provided for @viewDetails.
  ///
  /// In es, this message translates to:
  /// **'Ver Detalles'**
  String get viewDetails;

  /// No description provided for @summary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get summary;

  /// No description provided for @includes.
  ///
  /// In es, this message translates to:
  /// **'Que incluye'**
  String get includes;

  /// No description provided for @aboutProfessional.
  ///
  /// In es, this message translates to:
  /// **'Sobre el profesional'**
  String get aboutProfessional;

  /// No description provided for @recentReviews.
  ///
  /// In es, this message translates to:
  /// **'Reseñas recientes'**
  String get recentReviews;

  /// No description provided for @responseLabel.
  ///
  /// In es, this message translates to:
  /// **'Respuesta'**
  String get responseLabel;

  /// No description provided for @guarantee.
  ///
  /// In es, this message translates to:
  /// **'Garantía 30 días'**
  String get guarantee;

  /// No description provided for @protectedPay.
  ///
  /// In es, this message translates to:
  /// **'Pago protegido'**
  String get protectedPay;

  /// No description provided for @securePay.
  ///
  /// In es, this message translates to:
  /// **'Pago seguro'**
  String get securePay;

  /// No description provided for @estimatedPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio estimado'**
  String get estimatedPrice;

  /// No description provided for @baseService.
  ///
  /// In es, this message translates to:
  /// **'Servicio base'**
  String get baseService;

  /// No description provided for @platformFee.
  ///
  /// In es, this message translates to:
  /// **'Tarifa plataforma'**
  String get platformFee;

  /// No description provided for @total.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @cancellationPolicy.
  ///
  /// In es, this message translates to:
  /// **'Cancelación gratis hasta 2 horas antes.'**
  String get cancellationPolicy;

  /// No description provided for @view.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get view;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
