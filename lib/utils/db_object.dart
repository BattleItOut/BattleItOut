import 'package:equatable/equatable.dart';

abstract class DBObject with EquatableMixin {
  int? id;

  DBObject({this.id});

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}
