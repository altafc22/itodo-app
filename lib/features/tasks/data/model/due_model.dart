import 'package:itodo/features/tasks/domain/entitiy/due_entity.dart';

class DueModel extends DueEntity {
  DueModel({
    required super.date,
    required super.isRecurring,
    required super.datetime,
    required super.string,
    required super.lang,
    required super.timezone,
  });

  factory DueModel.fromJson(Map<String, dynamic> json) {
    return DueModel(
      date: json['date'],
      string: json['string'],
      lang: json['lang'],
      isRecurring: json['is_recurring'],
      datetime: json['datetime'],
      timezone: json['timezone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'string': string,
      'lang': lang,
      'isRecurring': isRecurring,
      'datetime': datetime,
      'timezone': timezone,
    };
  }
}
