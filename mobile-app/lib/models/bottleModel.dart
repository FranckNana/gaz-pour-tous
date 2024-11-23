import 'package:json_annotation/json_annotation.dart';

part 'bottleModel.g.dart';

@JsonSerializable()
class BottleModel {
  int? bottleId;
  int? capacity;
  int? currentOwnerId;
  DateTime? lastUpdate;
  String? state;

  BottleModel(
      {this.bottleId,
      this.capacity,
      this.currentOwnerId,
      this.lastUpdate,
      this.state});

  factory BottleModel.fromJson(Map<String, dynamic> json) =>
      _$BottleModelFromJson(json);

  Map<String, dynamic> toJson() => _$BottleModelToJson(this);
}
