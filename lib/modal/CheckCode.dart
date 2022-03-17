

import 'package:flutter/foundation.dart';
import "package:json_annotation/json_annotation.dart";

part "CheckCode.g.dart";

@JsonSerializable()
class Checkcode {
  String tokenValue;
  String tokenName;
  Checkcode({
    required this.tokenName,
    required this.tokenValue,
  });
  factory Checkcode.fromJson(Map<String, dynamic> json) =>
      _$CheckcodeFromJson(json);

  Map<String, dynamic> toJson(Checkcode interface) =>
        _$CheckcodeToJson(interface);

}