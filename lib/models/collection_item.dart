import 'package:json_annotation/json_annotation.dart';
export 'package:twake/utils/bool_int.dart';

// Intermediate class, used to store all items by their id in database
class CollectionItem extends JsonSerializable {
  String id;
  int isSelected;

  CollectionItem(this.id);
}
