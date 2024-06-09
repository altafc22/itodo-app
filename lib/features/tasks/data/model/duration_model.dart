import 'package:itodo/features/tasks/domain/entitiy/duration_entity.dart';

class DurationModel extends DurationEntity {
  DurationModel({
    required super.amount,
    required super.unit,
  });

  factory DurationModel.fromJson(Map<String, dynamic> json) {
    return DurationModel(
      amount: json['amount'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unit,
    };
  }
}
