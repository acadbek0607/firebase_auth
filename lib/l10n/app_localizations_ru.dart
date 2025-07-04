// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get choose_language => 'Выберите язык';

  @override
  String get cancel => 'Отмена';

  @override
  String get done => 'Готово';

  @override
  String get sign_in => 'Войти';

  @override
  String get sign_up => 'Регистрация';

  @override
  String get email => 'Электронная почта';

  @override
  String get password => 'Пароль';

  @override
  String get contracts => 'Контракты';

  @override
  String get invoices => 'Счета';

  @override
  String get new_contract => 'Новый контракт';

  @override
  String get new_invoice => 'Новый счет';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get search => 'Поиск';

  @override
  String get filter => 'Фильтр';

  @override
  String get history => 'История';

  @override
  String get saved => 'Сохраненные';

  @override
  String get confirm_delete_contract => 'Вы уверены, что хотите удалить этот контракт?';

  @override
  String get fish => 'Ф.И.О.';

  @override
  String get amount => 'Сумма';

  @override
  String get last_contract => 'Последний контракт';

  @override
  String get number_contracts => 'Количество контрактов';

  @override
  String get status_paid => 'Оплачено';

  @override
  String get status_in_process => 'В процессе';

  @override
  String get status_rejected_by_payme => 'Отклонено Payme';

  @override
  String get status_rejected_by_iq => 'Отклонено IQ';

  @override
  String get from => 'От';

  @override
  String get to => 'До';

  @override
  String get what_create => 'Что вы хотите создать?';

  @override
  String get search_contracts => 'Поиск контрактов...';

  @override
  String get apply_filters => 'Применить фильтры';

  @override
  String get phone => 'Телефон';

  @override
  String get date_of_birth => 'Дата рождения';

  @override
  String get dont_have_account => 'Нет аккаунта?';

  @override
  String get have_account => 'Уже есть аккаунт?';

  @override
  String get profile => 'Профил';

  @override
  String get is_required => 'обязательно';

  @override
  String get profession => 'Профессия';

  @override
  String get organization => 'Организация';

  @override
  String get date => 'Дата';

  @override
  String get no_history => 'История за этот период отсутствует';

  @override
  String get load_failed => 'Не удалось загрузить контракты';

  @override
  String get from_date_error => 'Дата \'От\' должна быть раньше даты \'До\'';

  @override
  String get to_date_error => 'Дата \'До\' должна быть позже даты \'От\'';

  @override
  String get unknown => 'неизвестно';

  @override
  String get no_profile_data => 'Данные профиля недоступны';
}
