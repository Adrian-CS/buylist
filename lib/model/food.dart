import 'package:food/db/database_provider.dart';

class Food {
  int id;
  String name;
  String quantity;
  String supermarket;

  Food({this.id, this.name, this.quantity, this.supermarket});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NAME: name,
      DatabaseProvider.COLUMN_QUANTITY: quantity,
      DatabaseProvider.COLUMN_SUPER: supermarket,
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Food.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    name = map[DatabaseProvider.COLUMN_NAME];
    quantity = map[DatabaseProvider.COLUMN_QUANTITY];
    supermarket = map[DatabaseProvider.COLUMN_SUPER];
  }
}
