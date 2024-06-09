import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itodo/common/models/language_model.dart';

extension StringExtension on String {
  String get toCapital {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension IntegetExtension on int? {
  bool get success {
    if (this == 200 || this == 201 || this == 204) {
      return true;
    }
    return false;
  }
}

extension GeneralExtension<T> on T {
  bool get isEnum {
    final split = toString().split('.');
    return split.length > 1 && split[0] == runtimeType.toString();
  }

  String get getEnumString => toString().split('.').last.toCapital;
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<E> mapWithIndex<E>(E Function(int index, T value) f) {
    return Iterable.generate(length).map((i) => f(i, elementAt(i)));
  }
}

extension MapExtension on Map {
  String get format {
    if (isEmpty) {
      return "";
    } else {
      var firstKey = entries.first.key;
      var mapValues = entries.first.value;
      return "?$firstKey=$mapValues";
    }
  }
}

//Helper functions
void pop(BuildContext context, int returnedLevel) {
  for (var i = 0; i < returnedLevel; ++i) {
    Navigator.pop(context, true);
  }
}

bool isEmailValid(String? email) {
  if (email != null) {
    return RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(email);
  } else {
    return false;
  }
}

extension NumberExtension on num {
  String formatAmount(String currency) {
    NumberFormat formatter = NumberFormat.currency(
      locale: 'en_AE',
      symbol: currency,
      decimalDigits: 2,
    );
    return formatter.format(this);
  }
}

extension DateTimeExtension on DateTime {
  String formatDate() {
    String day = this.day.toString().padLeft(2, '0');
    String month = this.month.toString().padLeft(2, '0');
    String year = this.year.toString();
    String hour = hourOfPeriod().toString().padLeft(2, '0');
    String minute = this.minute.toString().padLeft(2, '0');
    String period = this.hour >= 12 ? 'PM' : 'AM';

    return '$day/$month/$year $hour:$minute $period';
  }

  int hourOfPeriod() {
    return hour > 12 ? hour - 12 : hour;
  }

  String toDateString({String format = 'yyyy-MM-ddTHH:mm:ssZ'}) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(this);
  }

  String toFormatedDate() {
    return DateFormat('dd-MM-yyyy hh:mm aa').format(this);
  }
}

extension StringToDateTimeExtension on String {
  DateTime toDate() {
    return DateTime.parse(this);
  }

  DateTime toDateTime({String format = 'yyyy-MM-ddTHH:mm:ssZ'}) {
    final DateFormat formatter = DateFormat(format);
    return formatter.parse(this);
  }
}

extension LocaleExtension on Locale {
  String fullName() {
    switch (languageCode) {
      case 'en':
        return Language.english.text;
      case 'de':
        return Language.german.text;
    }
    return Language.english.text;
  }
}
