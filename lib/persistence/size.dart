import 'package:battle_it_out/utils/db_object.dart';

class Size extends DBObject {
  String name;
  String source;

  Size({super.id, required this.name, this.source = "Custom"});

  @override
  List<Object?> get props => super.props..addAll([name, source]);
}
