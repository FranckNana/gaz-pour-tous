import 'package:json_annotation/json_annotation.dart';

part 'bottleModel.g.dart';

@JsonSerializable()
class BottleModel {
  int? bottleId;
  int? capacity;
  int? currentOwnerId;
  DateTime? last_update;
  String? state;

  BottleModel(
      {this.bottleId,
      this.capacity,
      this.currentOwnerId,
      this.last_update,
      this.state});

  factory BottleModel.fromJson(Map<String, dynamic> json) =>
      _$BottleModelFromJson(json);

  Map<String, dynamic> toJson() => _$BottleModelToJson(this);
}
