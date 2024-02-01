import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:practices_api/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'practice.g.dart';

@immutable
@JsonSerializable()
class Practice extends Equatable {
  const Practice(this.id, this.practice);

  final String id;
  final String practice;

  @override
  List<Object?> get props => [id, practice];

  static Practice fromJson(JsonMap json) => _$PracticeFromJson(json);

  JsonMap toJson() => _$PracticeToJson(this);

  Practice copyWith({
    String? id,
    String? practice,
  }) {
    return Practice(
      id ?? this.id,
      practice ?? this.practice,
    );
  }
}
