import 'dart:convert';
import 'package:battle_it_out/persistence/wfrp_database.dart';
import 'package:flutter/services.dart';

import 'DTO/attribute.dart';
import 'DTO/trait.dart';
import 'DTO/profession.dart';

class Character {
  String name;
  int subrace;
  Profession profession;
  Map<int, Attribute> attributes;
  // List<Skill> skills;
  // List<Talent> talents;
  // List<Trait> traits;

  Character({required this.name, required this.subrace, required this.profession, required this.attributes});

  static Future<Character> create(String jsonPath, WFRPDatabase database) async {
    var json = await _loadJson(jsonPath);
    return Character(
        name: json['name'],
        subrace: json['subrace_id'],
        profession: await Profession.create(id: json["profession_id"], database: database),
        attributes: await _createAttributes(json, database));
  }

  static Future<Map<int, Attribute>> _createAttributes(json, WFRPDatabase database) async {
    final Map<int, Attribute> attributes = {};
    for (var attribute in json['attributes']) {
      attributes[attribute["id"]] = await Attribute.create(
          id: attribute["id"],
          database: database,
          base: attribute["base"],
          advances: attribute["advances"]);
    }
    return attributes;
  }
  static _loadJson(String jsonPath) async {
    String data = await rootBundle.loadString(jsonPath);
    return jsonDecode(data);
  }
}