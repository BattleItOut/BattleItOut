import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

abstract class DBObject with EquatableMixin {
  final Logger log = Logger("Logger");
  int? id;

  DBObject({this.id});

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
