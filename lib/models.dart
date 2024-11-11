// ignore_for_file: invalid_annotation_target, unused_element

import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

// dart run build_runner build

@unfreezed
class Item with _$Item {
  factory Item({
    required final String name,
    required int position,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
