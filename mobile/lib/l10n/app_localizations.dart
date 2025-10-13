import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Gestão de Eventos'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In pt, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In pt, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get password;

  /// No description provided for @signup.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar'**
  String get signup;

  /// No description provided for @name.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get name;

  /// No description provided for @confirmPassword.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar Senha'**
  String get confirmPassword;

  /// No description provided for @profile.
  ///
  /// In pt, this message translates to:
  /// **'Meu Perfil'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settings;

  /// No description provided for @myEvents.
  ///
  /// In pt, this message translates to:
  /// **'Meus Eventos'**
  String get myEvents;

  /// No description provided for @dashboard.
  ///
  /// In pt, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @events.
  ///
  /// In pt, this message translates to:
  /// **'Eventos'**
  String get events;

  /// No description provided for @confirmed.
  ///
  /// In pt, this message translates to:
  /// **'Confirmados'**
  String get confirmed;

  /// No description provided for @evaluations.
  ///
  /// In pt, this message translates to:
  /// **'Avaliações'**
  String get evaluations;

  /// No description provided for @cancelled.
  ///
  /// In pt, this message translates to:
  /// **'Cancelados'**
  String get cancelled;

  /// No description provided for @notifications.
  ///
  /// In pt, this message translates to:
  /// **'Notificações'**
  String get notifications;

  /// No description provided for @privacy.
  ///
  /// In pt, this message translates to:
  /// **'Privacidade'**
  String get privacy;

  /// No description provided for @preferences.
  ///
  /// In pt, this message translates to:
  /// **'Preferências'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @personalData.
  ///
  /// In pt, this message translates to:
  /// **'Dados Pessoais'**
  String get personalData;

  /// No description provided for @storage.
  ///
  /// In pt, this message translates to:
  /// **'Armazenamento'**
  String get storage;

  /// No description provided for @permissions.
  ///
  /// In pt, this message translates to:
  /// **'Permissões'**
  String get permissions;

  /// No description provided for @about.
  ///
  /// In pt, this message translates to:
  /// **'Sobre'**
  String get about;

  /// No description provided for @camera.
  ///
  /// In pt, this message translates to:
  /// **'Câmera'**
  String get camera;

  /// No description provided for @location.
  ///
  /// In pt, this message translates to:
  /// **'Localização'**
  String get location;

  /// No description provided for @allowed.
  ///
  /// In pt, this message translates to:
  /// **'Permitido'**
  String get allowed;

  /// No description provided for @denied.
  ///
  /// In pt, this message translates to:
  /// **'Negado'**
  String get denied;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @confirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In pt, this message translates to:
  /// **'Sim'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In pt, this message translates to:
  /// **'Não'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In pt, this message translates to:
  /// **'Erro'**
  String get error;

  /// No description provided for @success.
  ///
  /// In pt, this message translates to:
  /// **'Sucesso'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando...'**
  String get loading;

  /// No description provided for @noEvents.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum evento encontrado'**
  String get noEvents;

  /// No description provided for @eventName.
  ///
  /// In pt, this message translates to:
  /// **'Nome do Evento'**
  String get eventName;

  /// No description provided for @eventDate.
  ///
  /// In pt, this message translates to:
  /// **'Data do Evento'**
  String get eventDate;

  /// No description provided for @eventLocation.
  ///
  /// In pt, this message translates to:
  /// **'Local do Evento'**
  String get eventLocation;

  /// No description provided for @eventDescription.
  ///
  /// In pt, this message translates to:
  /// **'Descrição do Evento'**
  String get eventDescription;

  /// No description provided for @price.
  ///
  /// In pt, this message translates to:
  /// **'Preço'**
  String get price;

  /// No description provided for @period.
  ///
  /// In pt, this message translates to:
  /// **'Período'**
  String get period;

  /// No description provided for @morning.
  ///
  /// In pt, this message translates to:
  /// **'Manhã'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In pt, this message translates to:
  /// **'Tarde'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In pt, this message translates to:
  /// **'Noite'**
  String get evening;

  /// No description provided for @fullName.
  ///
  /// In pt, this message translates to:
  /// **'Nome Completo'**
  String get fullName;

  /// No description provided for @newPassword.
  ///
  /// In pt, this message translates to:
  /// **'Nova Senha'**
  String get newPassword;

  /// No description provided for @changePassword.
  ///
  /// In pt, this message translates to:
  /// **'Alterar Senha'**
  String get changePassword;

  /// No description provided for @profileUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Perfil atualizado com sucesso!'**
  String get profileUpdated;

  /// No description provided for @passwordChanged.
  ///
  /// In pt, this message translates to:
  /// **'Senha alterada com sucesso!'**
  String get passwordChanged;

  /// No description provided for @logout.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In pt, this message translates to:
  /// **'Excluir Conta'**
  String get deleteAccount;

  /// No description provided for @exportData.
  ///
  /// In pt, this message translates to:
  /// **'Exportar Dados'**
  String get exportData;

  /// No description provided for @clearCache.
  ///
  /// In pt, this message translates to:
  /// **'Limpar Cache'**
  String get clearCache;

  /// No description provided for @version.
  ///
  /// In pt, this message translates to:
  /// **'Versão'**
  String get version;

  /// No description provided for @privacyPolicy.
  ///
  /// In pt, this message translates to:
  /// **'Política de Privacidade'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In pt, this message translates to:
  /// **'Termos de Uso'**
  String get termsOfUse;
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
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
