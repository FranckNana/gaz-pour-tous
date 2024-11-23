// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottleModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BottleModel _$BottleModelFromJson(Map<String, dynamic> json) => BottleModel(
      bottleId: (json['bottleId'] as num?)?.toInt(),
      capacity: (json['capacity'] as num?)?.toInt(),
      currentOwnerId: (json['currentOwnerId'] as num?)?.toInt(),
      last_update: json['last_update'] == null
          ? null
          : DateTime.parse(json['last_update'] as String),
      state: json['state'] as String?,
    );

Map<String, dynamic> _$BottleModelToJson(BottleModel instance) =>
    <String, dynamic>{
      'bottleId': instance.bottleId,
      'capacity': instance.capacity,
      'currentOwnerId': instance.currentOwnerId,
      'last_update': instance.last_update?.toIso8601String(),
      'state': instance.state,
    };
