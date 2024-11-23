// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottleModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BottleModel _$BottleModelFromJson(Map<String, dynamic> json) => BottleModel(
      bottleId: (json['bottleId'] as num?)?.toInt(),
      capacity: (json['capacity'] as num?)?.toInt(),
      currentOwnerId: (json['currentOwnerId'] as num?)?.toInt(),
      lastUpdate: json['lastUpdate'] == null
          ? null
          : DateTime.parse(json['lastUpdate'] as String),
      state: json['state'] as String?,
    );

Map<String, dynamic> _$BottleModelToJson(BottleModel instance) =>
    <String, dynamic>{
      'bottleId': instance.bottleId,
      'capacity': instance.capacity,
      'currentOwnerId': instance.currentOwnerId,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
      'state': instance.state,
    };
